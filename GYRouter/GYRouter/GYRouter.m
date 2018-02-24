//
//  GYRouter.m
//  GYRouter
//
//  Created by BlueSea on 2018/2/11.
//  Copyright © 2018年 杭州卫健科技. All rights reserved.
//

#import "GYRouter.h"

@implementation GYRouterResponse

@end

NSString * const kGYRouterURL = @"url";
NSString * const kGYRouterUserInfo = @"userInfo";
NSString * const kGYRouterHandler = @"-";
NSString * const kGYRouterException = @"exception";
NSString * const kGYRouter404URL = @"gy://404";

@interface GYRouter ()

//折叠映射字典表
@property (strong, nonatomic) NSMutableDictionary *routes;
//平铺映射字典表
@property (strong, nonatomic) NSMutableDictionary *tileRoutes;

@end

@implementation GYRouter

+ (instancetype)sharedInstance {
    static GYRouter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - PublicMethod
+ (void)routerRegisterURL:(NSString *)url handler:(GYRouterHandler)handler {
    [[self sharedInstance] routerRegisterURLToRoutes:[NSURL URLWithString:url] handler:handler];
}

+ (void)routerRegister404URLWithHandler:(GYRouterHandler)handler {
    [[self sharedInstance] routerRegisterURLToRoutes:[NSURL URLWithString:kGYRouter404URL] handler:handler];
}

+ (void)routerOpenURL:(NSString *)url userInfo:(NSDictionary *)userInfo {
    [self routerOpenURL:url userInfo:userInfo viewController:nil];
}

+ (void)routerOpenURL:(NSString *)url userInfo:(NSDictionary *)userInfo viewController:(UIViewController *)viewController {
    [[self sharedInstance] routerOpenURLFromRoutes:[NSURL URLWithString:url] userInfo:userInfo viewController:viewController];
}

+ (BOOL)routerCanOpenURL:(NSString *)url {
    NSMutableDictionary *subRoutes = [[self sharedInstance] routerCanOpenURL:[NSURL URLWithString:url]];
    if (subRoutes) {
        return YES;
    } else {
        NSLog(@"[%@] 错误", url);
        return NO;
    }
}

#pragma mark - PrivateMethod
/** 注册url */
- (void)routerRegisterURLToRoutes:(NSURL *)url handler:(GYRouterHandler)handler {
    if (self.tableType==GYRouterFoldTableType) {
        NSMutableArray *components = [self routerDecodeURL:url];
        NSMutableDictionary *subRoutes = self.routes;
        for (NSString *component in components) {
            if (!subRoutes[component]) {
                subRoutes[component] = @{}.mutableCopy;
            }
            subRoutes = subRoutes[component];
        }
        if (handler) {
            subRoutes[kGYRouterHandler] = handler;
        }
    } else if (self.tableType==GYRouterTileTableType) {
        NSMutableString *key = [self routerDecodeURLTile:url];
        NSMutableDictionary *tileRoutes = self.tileRoutes;
        if (!tileRoutes[key] && handler) {
            tileRoutes[key] = handler;
        }
    }
//    NSLog(@"%@\n%@", self.routes, self.tileRoutes);
}

/** 打开url */
- (void)routerOpenURLFromRoutes:(NSURL *)url userInfo:(NSDictionary *)userInfo viewController:(UIViewController *)viewController {
    
    //判断能否打开url
    NSMutableDictionary *subRoutes = [self routerCanOpenURL:url];
    if (subRoutes==nil) {
        NSLog(@"[%@] 错误", url.absoluteString);
        return;
    }
    
    //参数字典拼接
    NSMutableDictionary *parameters = @{}.mutableCopy;
    NSArray<NSURLQueryItem *> *queryItems = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO].queryItems;
    if (queryItems.count!=0) {
        for (NSURLQueryItem *item in queryItems) {
            parameters[item.name] = item.value;
        }
    }
    
    //保证在404的情况下，生成的响应对象中的parameters格式和正常情况下的格式相同
    if ([url.absoluteString isEqualToString:kGYRouter404URL]) {
        parameters = userInfo.mutableCopy;
    } else {
        parameters[kGYRouterURL] = url.absoluteString;
        parameters[kGYRouterUserInfo] = userInfo;
    }
    
    //生成响应对象
    /**
     相应对象中的parameters格式：
     {
        url = @"",
        userInfo = {
                    key:value,
                    key:value
                    },
        key:value,
        key:value
     }
     */
    GYRouterResponse *response = [[GYRouterResponse alloc] init];
    response.parameters = parameters;
    response.viewController = viewController;
    response.navigationController = viewController.navigationController;
    
    //回调响应对象，并进行异常捕获，如捕获异常，则降级处理打开404url
    if (self.tableType==GYRouterFoldTableType) {
         GYRouterHandler handler = subRoutes[kGYRouterHandler];
        if (handler) {
            @try {
                handler(response);
            }
            @catch (NSException *exception) {
                NSMutableDictionary *userInfo404 = [NSMutableDictionary dictionaryWithDictionary:parameters];
                userInfo404[kGYRouterException] = exception;
                [self routerOpenURLFromRoutes:[NSURL URLWithString:kGYRouter404URL] userInfo:userInfo404 viewController:viewController];
            }
        }
    } else if (self.tableType==GYRouterTileTableType) {
        GYRouterHandler handler = subRoutes[[self routerDecodeURLTile:url]];
        if (handler) {
            @try {
                handler(response);
            }
            @catch (NSException *exception) {
                NSMutableDictionary *userInfo404 = [NSMutableDictionary dictionaryWithDictionary:parameters];
                userInfo404[kGYRouterException] = exception;
                [self routerOpenURLFromRoutes:[NSURL URLWithString:kGYRouter404URL] userInfo:userInfo404 viewController:viewController];
            }
        }
    }
}

/** 判断url能否打开 */
- (NSMutableDictionary *)routerCanOpenURL:(NSURL *)url {
    if (self.tableType==GYRouterFoldTableType) {
        NSMutableArray *components = [self routerDecodeURL:url];
        NSMutableDictionary *subRoutes = self.routes;
        for (NSString *component in components) {
            BOOL found = NO;
            NSArray *subRoutesKeys = subRoutes.allKeys;
            for (NSString *key in subRoutesKeys) {
                if ([key isEqualToString:component]) {
                    found = YES;
                    subRoutes = subRoutes[key];
                    break;
                }
            }
            if (!found) {return nil;}
        }
        return subRoutes;
    } else if (self.tableType==GYRouterTileTableType) {
        NSMutableString *key = [self routerDecodeURLTile:url];
        NSMutableDictionary *tileRoutes = self.tileRoutes;
        if (tileRoutes[key]) {return tileRoutes;}
        else {return nil;}
    } else {
        return nil;
    }
}

/** 解析折叠表url */
- (NSMutableArray *)routerDecodeURL:(NSURL *)url {
    NSMutableArray *components = @[].mutableCopy;
    if (url.scheme) {
        [components addObject:url.scheme];
    }
    if (url.host) {
        [components addObject:url.host];
    }
    if (url.pathComponents.count!=0) {
        for (NSString *pathComponent in url.pathComponents) {
            if ([pathComponent isEqualToString:@"/"]) {continue;}
            [components addObject:pathComponent];
        }
    }
    return components;
}

/** 解析平铺表url */
- (NSMutableString *)routerDecodeURLTile:(NSURL *)url {
    NSMutableString *key = @"".mutableCopy;
    if (url.scheme) {
        [key appendString:[NSString stringWithFormat:@"%@://", url.scheme]];
    }
    if (url.host) {
        [key appendString:url.host];
    }
    if (url.path) {
        [key appendString:url.path];
    }
    return key;
}

#pragma mark - LazyLoad
- (NSMutableDictionary *)routes {
    if (_routes==nil) {
        _routes = @{}.mutableCopy;
    }
    return _routes;
}
- (NSMutableDictionary *)tileRoutes {
    if (_tileRoutes==nil) {
        _tileRoutes = @{}.mutableCopy;
    }
    return _tileRoutes;
}



@end
