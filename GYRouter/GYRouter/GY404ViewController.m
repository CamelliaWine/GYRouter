//
//  GY404ViewController.m
//  GYRouter
//
//  Created by BlueSea on 2018/2/23.
//  Copyright © 2018年 杭州卫健科技. All rights reserved.
//

#import "GY404ViewController.h"
#import <WebKit/WebKit.h>

@interface GY404ViewController ()
@property (strong, nonatomic) UILabel *errorLabel;
@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) NSDictionary *parameters;
@end

@implementation GY404ViewController

+ (void)load {
//    [GYRouter sharedInstance].tableType = GYRouterTileTableType;
    [GYRouter routerRegister404URLWithHandler:^(GYRouterResponse *response) {
        GY404ViewController *vc = [[GY404ViewController alloc] init];
        vc.parameters = response.parameters;
        [response.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"404页面";
    self.view.backgroundColor = [UIColor whiteColor];
#ifdef DEBUG
    self.errorLabel.text = [NSString stringWithFormat:@"%@", self.parameters];
    [self.errorLabel sizeToFit];
#else
    
#endif
}

- (UILabel *)errorLabel {
    if (!_errorLabel) {
        CGFloat y = [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.bounds.size.height;
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y, self.view.bounds.size.width-20, 0)];
        _errorLabel.textColor = [UIColor blackColor];
        _errorLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _errorLabel.textAlignment = NSTextAlignmentLeft;
        _errorLabel.numberOfLines = 0;
        [self.view addSubview:_errorLabel];
    }
    return _errorLabel;
}

@end
