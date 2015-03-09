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

// View Controllers
#import "JoinUsViewController.h"
#import "EditProfileViewController.h"


@interface JoinUsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;

@end

@implementation JoinUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showSpinnerWithText:(NSString *)text{
	[SVProgressHUD setForegroundColor:[UIColor whiteColor]];
	[SVProgressHUD showWithStatus:text maskType:SVProgressHUDMaskTypeNone];
	[SVProgressHUD setBackgroundColor:[UIColor blueColor]];
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
			EditProfileViewController *epvc = [[EditProfileViewController alloc]init];
			epvc.name =	self.firstName.text;
			epvc.email = self.emailAddress.text;
			[self presentViewController:epvc animated:YES completion:nil];
		} else {
			NSLog(@"FAIL");
		}
	}];
}

- (IBAction)onLogin:(UIButton *)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}
@end
