//
//  ResetPasswordViewController.m
//  Inneract
//
//  Created by Syed Naqvi on 3/25/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import <Parse/Parse.h>				// parse

@interface ResetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
	self.navigationItem.leftBarButtonItem = leftButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetPassword:(id)sender {
	if([self isValidEmail:self.username.text] == NO) {
		[[[UIAlertView alloc] initWithTitle:@"Invalid email address."
									message:@"Please enter valid email address."
								   delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil] show];
		return;
	}

	//[PFUser requestPasswordResetForEmailInBackground:self.username.text];
	[PFUser requestPasswordResetForEmailInBackground: self.username.text
	  block:^(BOOL succeeded, NSError *error){
		 if (!succeeded)
		 {
			 [[[UIAlertView alloc] initWithTitle:@"Error"
										 message:[error userInfo][@"error"]
										delegate:nil
							   cancelButtonTitle:@"OK"
							   otherButtonTitles:nil] show];
			 return;
		 }
		 
		 [[[UIAlertView alloc] initWithTitle:@"Check your email."
									 message:@"Your password has been sent to your email address."
									delegate:nil
						   cancelButtonTitle:@"OK"
						   otherButtonTitles:nil] show];
		  
		  [self dismissViewControllerAnimated:YES completion:nil];
	}];
}

-(BOOL) isValidEmail:(NSString *)checkString
{
	BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
	NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
	NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
	NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	return [emailTest evaluateWithObject:checkString];
}

-(void)onCancel{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
