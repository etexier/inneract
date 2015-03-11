//
//  LoginViewController.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

// Third party SDKs
#import <Parse/Parse.h>				// parse
#import "SVProgressHUD.h"			// Spinner
#import <FacebookSDK/FacebookSDK.h>	// Facebook
#import <FBGraphUser.h>

// ViewControllers
#import "MainViewHelper.h"
#import "LoginViewController.h"
#import "JoinUsViewController.h"
#import "EditProfileViewController.h"

@interface LoginViewController () <FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet FBLoginView *loginViewFB;

@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (assign, nonatomic) BOOL inProgress;

- (IBAction)onLogin:(id)sender;
- (IBAction)onSignUp:(id)sender;
- (IBAction)onTap:(UITapGestureRecognizer *)sender;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // Do any additional setup after loading the view from its nib.
	
	// In your viewDidLoad method:
	self.loginViewFB.readPermissions = @[@"public_profile", @"email", @"user_friends"];
	
	self.inProgress = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark FBLoginViewDelegate methods

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
	NSLog(@"loginViewShowingLoggedInUser");
	[self showSpinnerWithText:@"Login using Facebook..."];
	//[self presentViewController:[MainViewHelper setupMainViewTabBar] animated:YES completion:nil];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
							user:(id<FBGraphUser>)user{
	
	if(self.inProgress == YES)
		return;
	self.inProgress = YES;
	
	PFUser *parseUser = [PFUser user];
	parseUser.username = user[@"email"];
	parseUser.password = user[@"id"];
	parseUser.email = user[@"email"];
	
	[parseUser signUpInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
		[SVProgressHUD dismiss];
		if (succeeded) {
			NSLog(@"OK");
			[parseUser setObject:user[@"first_name"] forKey:@"firstName"];
			[parseUser setObject:user[@"last_name"] forKey:@"lastName"];
			[parseUser saveInBackground];
			
			EditProfileViewController *epvc = [[EditProfileViewController alloc]init];
			UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:epvc];
			epvc.firstName =	user[@"first_name"];
			epvc.lastName =	user[@"last_name"];
			epvc.email = user[@"email"];
			[self presentViewController:nvc animated:YES completion:nil];
		} else {
			NSLog(@"FAIL");
		}
	}];
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

-(void) showSpinnerWithText:(NSString *)text{
	[SVProgressHUD setForegroundColor:[UIColor whiteColor]];
	[SVProgressHUD showWithStatus:text maskType:SVProgressHUDMaskTypeNone];
	[SVProgressHUD setBackgroundColor:[UIColor blueColor]];
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
	[self showSpinnerWithText:@"Login..."];
	
    [PFUser logInWithUsernameInBackground:self.userNameText.text password:self.passwordText.text
        block:^(PFUser *user, NSError *error) {
            if (user) {
                // TODO save current user in UserDefaults
                [self presentViewController:[MainViewHelper setupMainViewTabBar] animated:YES completion:nil];
            } else {
                // The login failed. Check error to see why.
            }
        }];
}

- (IBAction)onSignUp:(id)sender {
	[self presentViewController:[[JoinUsViewController alloc]init] animated:YES completion:nil];
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    [self.userNameText endEditing:YES];
    [self.passwordText endEditing:YES];
}


@end
