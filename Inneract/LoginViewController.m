//
//  LoginViewController.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "MainViewController.h"
#import "FeedsViewController.h"
#import "ProfilesViewController.h"
#import "ProfileDetailsViewController.h"

@interface LoginViewController () <FBLoginViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;


- (IBAction)onLogin:(id)sender;
- (IBAction)onSignUp:(id)sender;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Do any additional setup after loading the view from its nib.
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark FBLoginViewDelegate methods

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
	NSLog(@"loginViewShowingLoggedInUser");
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
							user:(id<FBGraphUser>)user{
	NSLog(@"loginViewFetchedUserInfo");
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
	NSLog(@"loginViewShowingLoggedOutUser");
}

/*!
 @abstract
 Tells the delegate that there is a communication or authorization error.
 
 @param loginView           The login view that transitioned its view mode
 @param error               An error object containing details of the error.
 @discussion See https://developers.facebook.com/docs/technical-guides/iossdk/errors/
 for error handling best practices.
 */
// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
	NSString *alertMessage, *alertTitle;
	
	// If the user performs an action outside of you app to recover,
	// the SDK provides a message, you just need to surface it.
	// This handles cases like Facebook password change or unverified Facebook accounts.
	if ([FBErrorUtility shouldNotifyUserForError:error]) {
		alertTitle = @"Facebook error";
		alertMessage = [FBErrorUtility userMessageForError:error];
		
  // This code will handle session closures that happen outside of the app
  // You can take a look at our error handling guide to know more about it
  // https://developers.facebook.com/docs/ios/errors
	} else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
		alertTitle = @"Session Error";
		alertMessage = @"Your current session is no longer valid. Please log in again.";
		
		// If the user has cancelled a login, we will do nothing.
		// You can also choose to show the user a message if cancelling login will result in
		// the user not being able to complete a task they had initiated in your app
		// (like accessing FB-stored information or posting to Facebook)
	} else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
		NSLog(@"user cancelled login");
		
		// For simplicity, this sample handles other errors with a generic message
		// You can checkout our error handling guide for more detailed information
		// https://developers.facebook.com/docs/ios/errors
	} else {
		alertTitle  = @"Something went wrong";
		alertMessage = @"Please try again later.";
		NSLog(@"Unexpected error:%@", error);
	}
	
	if (alertMessage) {
		[[[UIAlertView alloc] initWithTitle:alertTitle
									message:alertMessage
								   delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil] show];
	}
}

- (IBAction)onLogin:(id)sender {
    if(self.userNameText.text.length < 1) {
        [[[UIAlertView alloc] initWithTitle:@"UserName is empty"
                                    message:@"Please input your user name"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    if(self.passwordText.text.length < 1) {
        [[[UIAlertView alloc] initWithTitle:@"Password is empty"
                                    message:@"Please input your password"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return;
    }
    [PFUser logInWithUsernameInBackground:self.userNameText.text password:self.passwordText.text
        block:^(PFUser *user, NSError *error) {
            if (user) {
                // TODO save current user in UserDefaults
                [self presentViewController:[self setupTabBar] animated:YES completion:nil];
            } else {
                // The login failed. Check error to see why.
            }
        }];
}

- (IBAction)onSignUp:(id)sender {
}

- (UITabBarController *)setupTabBar {
    FeedsViewController *feedsVc = [[FeedsViewController alloc] init];
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
