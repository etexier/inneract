//
//  JoinUsViewController.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

// Third party SDKs
#import "SVProgressHUD.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>	// Facebook
#import <FBGraphUser.h>

// View Controllers
#import "JoinUsViewController.h"
#import "EditProfileViewController.h"
#import "MainViewHelper.h"

#import "IPColors.h"

@interface JoinUsViewController () <FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet FBLoginView *loginViewFB;
@property (assign, nonatomic) BOOL facebookLoginProgress;
@end



@implementation JoinUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.loginViewFB.readPermissions = @[@"public_profile", @"email", @"user_friends"];
	
	self.facebookLoginProgress = NO;
    // login button borders:
    self.loginButton.layer.borderColor = ipPrimaryOrange.CGColor;
    
    self.loginButton.layer.borderWidth = 3.0;
    
    self.loginButton.layer.cornerRadius = 18;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showSpinnerWithText:(NSString *)text{
	[SVProgressHUD setForegroundColor:[UIColor whiteColor]];
	[SVProgressHUD showWithStatus:text maskType:SVProgressHUDMaskTypeNone];
	[SVProgressHUD setBackgroundColor:ipPrimaryOrange];
}

-(void) showAlert:(NSString *)title withMessage:(NSString *) message{
	[[[UIAlertView alloc] initWithTitle:title
								message:message
							   delegate:nil
					  cancelButtonTitle:@"OK"
					  otherButtonTitles:nil] show];
}

- (IBAction)onJoinUs:(UIButton *)sender {
	if(self.firstName.text.length < 1) {
		[self showAlert:@"First Name is empty" withMessage:@"Please input your first name"];
		return;
	}
	
	if(self.lastName.text.length < 1) {
		[self showAlert:@"Last Name is empty" withMessage:@"Please input your last name"];
		return;
	}
	
	if(self.emailAddress.text.length < 1) {
		[self showAlert:@"email is empty" withMessage:@"Please input your email"];
		return;
	}
	
	if(self.password.text.length < 1) {
		[self showAlert:@"Password is empty" withMessage:@"Please input your password"];
		return;
	}
	
	if(self.password.text.length < 1) {
		[self showAlert:@"Confirm password is empty" withMessage:@"Please input your confirm password"];
		return;
	}
	
	if(![self.password.text isEqualToString:self.confirmPassword.text]) {
		[self showAlert:@"Password doesn't match" withMessage:@"Please fix your password"];
		return;
	}
	
	[self showSpinnerWithText:@"SignUp in progress..."];
	
	PFUser *user = [PFUser user];
	user.username = self.emailAddress.text;
	user.password = self.password.text;
	user.email = self.emailAddress.text;
	
	[user signUpInBackgroundWithBlock: ^(BOOL succeeded, NSError *error) {
		[SVProgressHUD dismiss];
		if (succeeded) {
			NSLog(@"OK");
			[user setObject:self.firstName.text forKey:@"firstName"];
			[user setObject:self.lastName.text forKey:@"lastName"];
			[user saveInBackground];
			
			EditProfileViewController *epvc = [[EditProfileViewController alloc]init];
			UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:epvc];
			epvc.firstName = self.firstName.text;
			epvc.lastName =	self.lastName.text;
			epvc.email = self.emailAddress.text;
			[self presentViewController:nvc animated:YES completion:nil];
		} else {
			NSLog(@"FAIL");
		}
	}];
}

- (IBAction)onLogin:(UIButton *)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark FBLoginViewDelegate methods

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
	[self showSpinnerWithText:@"Login using Facebook..."];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
							user:(id<FBGraphUser>)user{
	
	if(self.facebookLoginProgress == YES)
		return;
	self.facebookLoginProgress = YES;
	
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
		} else if([error.userInfo[@"code"] intValue]== 202){
			NSLog(@"FAIL: %@", error.userInfo);
			//[self showSpinnerWithText:@"Login..."];
			
			//User is already signed up. We will try to login as using FB credentials.
			[PFUser logInWithUsernameInBackground:user[@"email"] password:user[@"id"]
				block:^(PFUser *user, NSError *error) {
					if (user) {
						// TODO save current user in UserDefaults
						[self presentViewController:[MainViewHelper setupMainViewTabBar] animated:YES completion:nil];
					} else {
						// The login failed. Check error to see why.
						UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Login Failed"
																		   message:@"Please check your username and password are correct"
																		  delegate:self
																 cancelButtonTitle:@"OK"
																 otherButtonTitles:nil];
						[theAlert show];
					}

					[SVProgressHUD dismiss];
				}];
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

@end
