//
//  MainViewController.m
//  Inneract
//
//  Created by Jim Liu on 3/7/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "MainViewController.h"

#import "FeedsViewController.h"
#import "ProfilesViewController.h"
#import "ProfileDetailsViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //[self setupTabBar];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)setupTabBar {
    FeedsViewController *feedsVc = [[FeedsViewController alloc] init];
    FeedsViewController *bookmarkVc = [[FeedsViewController alloc] init];
    ProfilesViewController *peopleVc = [[ProfilesViewController alloc] init];
    ProfileDetailsViewController *profileVc = [[ProfileDetailsViewController alloc] init];
    
    UITabBarItem *barItem1 = [[UITabBarItem alloc] initWithTitle:@"Feed" image:[UIImage imageNamed:@"news"] tag:1];
    barItem1.selectedImage = [[UIImage imageNamed:@"news-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    feedsVc.tabBarItem = barItem1;
    
    UITabBarItem *barItem2 = [[UITabBarItem alloc] initWithTitle:@"Bookmark" image:[UIImage imageNamed:@"bookmark"] tag:2];
    barItem2.selectedImage = [[UIImage imageNamed:@"bookmark-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    bookmarkVc.tabBarItem = barItem2;
    
    UITabBarItem *barItem3 = [[UITabBarItem alloc] initWithTitle:@"People" image:[UIImage imageNamed:@"people"] tag:3];
    barItem1.selectedImage = [[UIImage imageNamed:@"people-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    peopleVc.tabBarItem = barItem3;
    
    UITabBarItem *barItem4 = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"profile"] tag:4];
    barItem2.selectedImage = [[UIImage imageNamed:@"profile-selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    profileVc.tabBarItem = barItem4;
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.view.frame = [[UIScreen mainScreen] bounds];
    //tabBarController.tabBar.items = [NSArray arrayWithObjects:barItem1, barItem2, barItem3, barItem4, nil];
    NSArray* controllers = [NSArray arrayWithObjects:feedsVc, bookmarkVc, peopleVc, profileVc, nil];
    tabBarController.viewControllers = controllers;
    
    [self.view addSubview:tabBarController.view];
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
