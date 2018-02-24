//
//  SecondViewController.m
//  TBRouter
//
//  Created by BlueSea on 2018/2/10.
//  Copyright © 2018年 杭州卫健科技. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
@property (strong, nonatomic) NSDictionary *parameters;
@property (strong, nonatomic) NSMutableArray *arr;
@end

@implementation SecondViewController

+ (void)load {
    [GYRouter routerRegisterURL:[NSString stringWithFormat:@"gy://home/%@", NSStringFromClass([self class])] handler:^(GYRouterResponse *response) {
        SecondViewController *vc = [[SecondViewController alloc] init];
        [vc.arr addObject:response.parameters[@"gender"]];//打开，可捕获异常
        [response.navigationController pushViewController:vc animated:YES];
        NSLog(@"%@", response.parameters);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor yellowColor];
    self.navigationItem.title = NSStringFromClass([self class]);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [GYRouter routerOpenURL:@"gy://homes/ThidrViewController" userInfo:@{@"color":[UIColor redColor]} viewController:self];
}

- (NSMutableArray *)arr {
    if (!_arr) {
        _arr = @[].mutableCopy;
    }
    return _arr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
