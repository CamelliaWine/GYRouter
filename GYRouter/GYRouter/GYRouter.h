//
//  GYRouter.h
//  GYRouter
//
//  Created by BlueSea on 2018/2/11.
//  Copyright © 2018年 杭州卫健科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GYRouterResponse : NSObject

@property (strong, nonatomic) NSDictionary *parameters;

@property (strong, nonatomic) UIViewController *viewController;

@property (strong, nonatomic) UINavigationController *navigationController;

@end

typedef NS_ENUM(NSInteger, GYRouterTableType) {
    GYRouterFoldTableType = 0,
    GYRouterTileTableType = 1
};

typedef void(^GYRouterHandler)(GYRouterResponse *response);

@interface GYRouter : NSObject

/**
 路由内部映射表结构，默认折叠表
 */
@property (assign, nonatomic) GYRouterTableType tableType;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;


/**
 获取GYRouter全局唯一单例

 @return GYRouter单例
 */
+ (instancetype)sharedInstance;


/**
 注册url

 @param url 需要注册的url
 @param handler 打开url时触发的block
 */
+ (void)routerRegisterURL:(NSString *)url handler:(GYRouterHandler)handler;


/**
 注册404url 做降级处理

 @param handler 打开url时触发的block
 */
+ (void)routerRegister404URLWithHandler:(GYRouterHandler)handler;


/**
 判断url是否可被打开

 @param url 需要判断的url
 @return 是否可被打开
 */
+ (BOOL)routerCanOpenURL:(NSString *)url;


/**
 打开url 被废弃，请使用 - routerOpenURL:userInfo:viewController 方法

 @param url 需要打开的url
 @param userInfo 额外的参数字典，参数也可以在url中拼接的形式传递，故此参数可为nil
 */
+ (void)routerOpenURL:(NSString *)url userInfo:(NSDictionary *)userInfo DEPRECATED_ATTRIBUTE;


/**
 打开url

 @param url 需要打开的url
 @param userInfo 额外的参数字典，参数也可以在url中拼接的形式传递，故此参数可为nil
 @param viewController 当前控制器，如果当前控制器有导航控制器进行管理，可直接传入self（或weakSelf）。
 */
+ (void)routerOpenURL:(NSString *)url userInfo:(NSDictionary *)userInfo viewController:(UIViewController *)viewController;


@end
