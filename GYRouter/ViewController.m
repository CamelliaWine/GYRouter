//
//  ViewController.m
//  GYRouter
//
//  Created by BlueSea on 2018/2/24.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.center = self.view.center;
    button.bounds = CGRectMake(0, 0, 150, 150);
    [button setTitle:@"click" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:0.36 green:0.79 blue:0.96 alpha:1.00];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClicked:(UIButton *)sender {
    [GYRouter routerOpenURL:@"gy://home/SecondViewController?username=zhengzheng" userInfo:@{@"age":@26} viewController:self];
//    [GYRouter routerOpenURL:@"tb://home/SecondViewController?" userInfo:@{@"age":@26} viewController:self];
//    [GYRouter routerOpenURL:@"tb://home/SecondViewController?" userInfo:@{} viewController:self];
//    [GYRouter routerOpenURL:@"tb://home/SecondViewController?" userInfo:nil viewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
