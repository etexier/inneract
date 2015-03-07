//
//  LandingViewController.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "LandingViewController.h"
#import "IntroductionContainerView.h"
#import "LoginViewController.h"
#import "JoinUsViewController.h"

@interface LandingViewController ()

@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)onJoin:(id)sender;
- (IBAction)onLogin:(id)sender;

@end

@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.frame = self.view.bounds;
    IntroductionContainerView *instroductionView = [[IntroductionContainerView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 49)];
    [self.view addSubview:instroductionView];
    
    //NSArray *tabBarItems = self.tabBarController.tabBar.items;
//    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0, -12.0)];
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                [UIFont boldSystemFontOfSize:16], NSFontAttributeName,
//                                [UIColor whiteColor], NSForegroundColorAttributeName,
//                                nil];
//    [[UITabBarItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
//    
//    UITabBarItem *joinItem = [[UITabBarItem alloc] initWithTitle:@"Join us!" image:nil tag:1];
//    JoinUsViewController *joinVc = [[JoinUsViewController alloc] init];
//    joinVc.tabBarItem = joinItem;
//    
//    UITabBarItem *loginItem = [[UITabBarItem alloc] initWithTitle:@"Login" image:nil tag:2];
//    LoginViewController *loginVc = [[LoginViewController alloc] init];
//    loginVc.tabBarItem = loginItem;
//    
//    //self.tabBar.items = [NSArray arrayWithObjects:joinItem, loginItem, nil];
//    UITabBarController *tabBarController = [[UITabBarController alloc] init];
//    tabBarController.viewControllers = [NSArray arrayWithObjects:joinVc, loginVc, nil];
    //tabBarController.tabBar.items = [NSArray arrayWithObjects:joinItem, loginItem, nil];
}


- (IBAction)onJoin:(id)sender {
    [self presentViewController:[[JoinUsViewController alloc] init] animated:YES completion:nil];
}

- (IBAction)onLogin:(id)sender {
    [self presentViewController:[[LoginViewController alloc] init] animated:YES completion:nil];
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
