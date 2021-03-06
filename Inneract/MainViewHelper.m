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

+ (UITabBarController *)setupMainViewTabBarWithSelectedTab:(NSInteger) tabIndex andSubSegmentName:(NSString *) subSegmentName {
    FeedsViewController *feedsVc = [[FeedsViewController alloc] initWithCategory:subSegmentName ? : @"news"];
    UINavigationController *feedsNvc = [[UINavigationController alloc] initWithRootViewController:feedsVc];
    feedsNvc.title = @"Feeds";
    feedsNvc.navigationBar.translucent = NO; // so it does not hide details views

    FeedsViewController *bookmarkVc = [[FeedsViewController alloc] initWithCategory:@"bookmark"];
    UINavigationController *bookmarkNvc = [[UINavigationController alloc] initWithRootViewController:bookmarkVc];
    bookmarkNvc.navigationBar.translucent = NO; // so it does not hide details views
    bookmarkNvc.title = @"Bookmarked";

    ProfilesViewController *peopleVc = [[ProfilesViewController alloc] init];
    UINavigationController *peopleNvc = [[UINavigationController alloc] initWithRootViewController:peopleVc];
    peopleNvc.title = @"People";

    ProfileDetailsViewController *profileVc = [[ProfileDetailsViewController alloc] initWithUser:nil];
    UINavigationController *profileNvc = [[UINavigationController alloc] initWithRootViewController:profileVc];
    profileVc.title = @"My Profile";

	
	
	
    //UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.magentaColor()], forState:.Normal)
    //UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.redColor()], forState:.Selected)

    UIImage *feedImage = [UIImage imageNamed:@"feedNavA"];
    UIImage *feedSelectedImage = [UIImage imageNamed:@"feedNavB"];
    UITabBarItem *barItem1 = [[UITabBarItem alloc] initWithTitle:@"Feed" image:[feedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[feedSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    feedsNvc.tabBarItem = barItem1;

    UIImage *bookmarkImage = [UIImage imageNamed:@"bookmarkNavA"];
    UIImage *bookmarkSelectedImage = [UIImage imageNamed:@"bookmarkNavB"];
    UITabBarItem *barItem2 = [[UITabBarItem alloc] initWithTitle:@"Bookmarks" image:[bookmarkImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[bookmarkSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    bookmarkNvc.tabBarItem = barItem2;

    UIImage *peopleImage = [UIImage imageNamed:@"peopleNavA"];
    UIImage *peopleSelectedImage = [UIImage imageNamed:@"peopleNavB"];
    UITabBarItem *barItem3 = [[UITabBarItem alloc] initWithTitle:@"People" image:[peopleImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[peopleSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    peopleNvc.tabBarItem = barItem3;

    UIImage *profileImage = [UIImage imageNamed:@"profileNavA"];
    UIImage *profileSelectedImage = [UIImage imageNamed:@"profileNavB"];
    UITabBarItem *barItem4 = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[profileImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[profileSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    profileNvc.tabBarItem = barItem4;

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.tabBar.translucent = NO;
    tabBarController.view.frame = [[UIScreen mainScreen] bounds];
    //tabBarController.tabBar.items = [NSArray arrayWithObjects:barItem1, barItem2, barItem3, barItem4, nil];
    NSArray* controllers = [NSArray arrayWithObjects:feedsNvc, bookmarkNvc, peopleNvc, profileNvc, nil];
    tabBarController.viewControllers = controllers;
    tabBarController.selectedIndex = tabIndex;

    return tabBarController;
}

+ (UITabBarController *)setupMainViewTabBar {
    return [MainViewHelper setupMainViewTabBarWithSelectedFeedsCategory:@"news"];
}

+ (UITabBarController *)setupMainViewTabBarWithSelectedFeedsCategory:(NSString *) category {
    return [MainViewHelper setupMainViewTabBarWithSelectedTab:0 andSubSegmentName:category];
}

@end
