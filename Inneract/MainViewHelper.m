//
//  MainViewHelper.m
//  Inneract
//
//  Created by Jim Liu on 3/7/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "MainViewHelper.h"
#import "FeedsViewController.h"
#import "ProfilesViewController.h"
#import "ProfileDetailsViewController.h"

@implementation MainViewHelper

+ (UITabBarController *)setupMainViewTabBar {
    FeedsViewController *feedsVc = [[FeedsViewController alloc] initWithFeedCategory:nil];
    FeedsViewController *bookmarkVc = [[FeedsViewController alloc] init];
    ProfilesViewController *peopleVc = [[ProfilesViewController alloc] init];
    ProfileDetailsViewController *profileVc = [[ProfileDetailsViewController alloc] init];

    //UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.magentaColor()], forState:.Normal)
    //UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.redColor()], forState:.Selected)

    UIImage *feedImage = [UIImage imageNamed:@"news"];
    UITabBarItem *barItem1 = [[UITabBarItem alloc] initWithTitle:@"Feed" image:[feedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[feedImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    feedsVc.tabBarItem = barItem1;

    UIImage *bookmarkImage = [UIImage imageNamed:@"bookmark"];
    UITabBarItem *barItem2 = [[UITabBarItem alloc] initWithTitle:@"Bookmark" image:[bookmarkImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[bookmarkImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    bookmarkVc.tabBarItem = barItem2;

    UIImage *peopleImage = [UIImage imageNamed:@"people"];
    UITabBarItem *barItem3 = [[UITabBarItem alloc] initWithTitle:@"People" image:[peopleImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[peopleImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    peopleVc.tabBarItem = barItem3;

    UIImage *profileImage = [UIImage imageNamed:@"profile"];
    UITabBarItem *barItem4 = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[profileImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[profileImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    profileVc.tabBarItem = barItem4;

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.view.frame = [[UIScreen mainScreen] bounds];
    //tabBarController.tabBar.items = [NSArray arrayWithObjects:barItem1, barItem2, barItem3, barItem4, nil];
    NSArray* controllers = [NSArray arrayWithObjects:feedsVc, bookmarkVc, peopleVc, profileVc, nil];
    tabBarController.viewControllers = controllers;

    return tabBarController;
}

@end
