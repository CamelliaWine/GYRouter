//
//  ThirdViewController.m
//  GYRouter
//
//  Created by BlueSea on 2018/2/24.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

+ (void)load {
    [GYRouter routerRegisterURL:[NSString stringWithFormat:@"gy://home/%@", NSStringFromClass([self class])] handler:^(GYRouterResponse *response) {
        ThirdViewController *vc = [[ThirdViewController alloc] init];
        [response.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.title = NSStringFromClass([self class]);
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
