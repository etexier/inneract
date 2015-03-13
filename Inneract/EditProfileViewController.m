//
//  EditProfileViewController.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/5/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <Parse/PFFile.h>
#import <Parse/PFUser.h>


#import "ComboBox.h"
#import "EditProfileViewController.h"
#import "ProfileDetailsViewController.h"

@interface EditProfileViewController () <UIImagePickerControllerDelegate,
										UINavigationControllerDelegate>
										//UIPickerViewDelegate,
										//UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *profileLinkEditText;

@property (weak, nonatomic) IBOutlet UIPickerView *profileTypePicker;


@property (weak, nonatomic) IBOutlet UITextView *professionTextView;
@property (strong, nonatomic) NSArray *profileNames;
@property (weak, nonatomic) IBOutlet UITextField *firstNameEdit;
@property (weak, nonatomic) IBOutlet UITextField *lastNameEdit;
@property (weak, nonatomic) IBOutlet UITextField *firstLastNameEdit;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressEdit;
@property (weak, nonatomic) IBOutlet UIButton *finishedButton;

@end

ComboBox* combo1;

@implementation EditProfileViewController

- (instancetype)initWithUser:(PFObject *)user {
    self = [super init];
    if (self) {
        _user = user;
    }

    return self;
}

+ (instancetype)controllerWithUser:(PFObject *)user {
    return [[EditProfileViewController alloc] initWithUser:user];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
	
	//self.profileTypePicker.delegate = self;
	//self.profileTypePicker.dataSource = self;

    if(self.user) {
        PFFile *profileFile = [self.user objectForKey:@"profileImage"];
        if(profileFile) {
            [profileFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    self.profileImageView.image = [UIImage imageWithData:data];
                }
            }];
        }
        self.firstName = [self.user valueForKey:@"firstName"];
        self.lastName = [self.user valueForKey:@"lastName"];
        self.email = [self.user valueForKey:@"email"];
        self.profileLinkEditText.text = [self.user valueForKey:@"profileLink"];
        self.professionTextView.text = [self.user valueForKey:@"profession"];
<<<<<<< HEAD


		
//		[self showEditMode:YES];
		// rounded corners
		CALayer *layer = [self.profileImageView layer];
		[layer setMasksToBounds:YES];
		[layer setCornerRadius:32.0];
		
		self.finishedButton.hidden = YES;
	} else {
		self.finishedButton.hidden = NO;
	}
=======
    }
>>>>>>> origin/master
	
	self.firstNameEdit.text = self.firstName;
	self.lastNameEdit.text = self.lastName;
	self.emailAddressEdit.text = self.email;
	

	
	self.profileNames = @[@"IP Teacher/TA", @"Parent/Guardian",
						  @"Follower"];
	[self showEditMode:YES];
	
//	NSMutableArray* profileTypeArray = [[NSMutableArray alloc] init];
//	[profileTypeArray addObject:@"IP Teacher/TA"];
//	[profileTypeArray addObject:@"Parent/Guardian"];
//	[profileTypeArray addObject:@"Follower"];
//	
//	combo1 = [[ComboBox alloc] init];
//	[combo1 setComboData:profileTypeArray];  //Assign the array to ComboBox
//	combo1.view.frame = CGRectMake(self.profileType.frame.origin.x, self.profileType.frame.origin.y, self.profileType.frame.size.width, /*self.profileType.frame.size.height*/ 30);  //ComboBox location and size (x,y,width,height)
//
//	
//	[self.view addSubview:combo1.view];
//	
//	NSLog(@"height: %f", combo1.view.frame.size.height);
//	self.profileType.hidden = YES;
	
	
//	self.firstLastNameEdit.borderStyle = UITextBorderStyleNone;
//	[self.firstLastNameEdit setBackgroundColor:[UIColor clearColor]];
//	self.firstLastNameEdit.enabled = NO;
//	NSString *name = self.firstNameEdit.text;
//	name = [name stringByAppendingString:@" "];
//	self.firstLastNameEdit.text = [name stringByAppendingString:self.lastNameEdit.text];
//	
//	self.emailAddressEdit.borderStyle = UITextBorderStyleNone;
//	[self.emailAddressEdit setBackgroundColor:[UIColor clearColor]];
//	self.emailAddressEdit.enabled = NO;
//	
//	self.professionTextView.layer.borderWidth = 1.0f;
//	self.professionTextView.layer.borderColor = [[UIColor grayColor] CGColor];
//	
//	UIFont* boldFont = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
//	[self.firstLastNameEdit setFont:boldFont];
//	[self.emailAddressEdit setFont:boldFont];
}

#pragma mark PickerView DataSource

//- (NSInteger)numberOfComponentsInPickerView:
//(UIPickerView *)pickerView
//{
//	return 1;
//}
//
//- (NSInteger)pickerView:(UIPickerView *)pickerView
//numberOfRowsInComponent:(NSInteger)component
//{
//	return self.profileNames.count;
//}
//
//- (NSString *)pickerView:(UIPickerView *)pickerView
//			 titleForRow:(NSInteger)row
//			forComponent:(NSInteger)component
//{
//	return self.profileNames[row];
//}

-(void) showAlert:(NSString *)title withMessage:(NSString *) message{
	[[[UIAlertView alloc] initWithTitle:title
								message:message
							   delegate:nil
					  cancelButtonTitle:@"OK"
					  otherButtonTitles:nil] show];
}

-(BOOL) validateInput{
	
//	if(self.profileType.text.length < 1) {
//		[self showAlert:@"profileType is empty" withMessage:@"Please select your profileType"];
//		return NO;
//	}
	
	return YES;
}



-(void) onCancelButton {
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void) onApplySearch {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker
		didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo
{
	//show the image view with the picked image
	[picker dismissModalViewControllerAnimated:YES];
	self.profileImageView.image = image;
	
	// rounded corners
	CALayer *layer = [self.profileImageView layer];
	[layer setMasksToBounds:YES];
	[layer setCornerRadius:32.0];

	PFUser *parseUser = [PFUser currentUser];

	// Convert to JPEG with 50% quality
	NSData* data = UIImageJPEGRepresentation(self.profileImageView.image, 0.5f);
	PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:data];

	// Save the image to Parse
	//http://stackoverflow.com/questions/18839834/how-to-upload-an-image-to-parse-com-from-uiimageview
	[imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (!error) {
			[parseUser setObject:imageFile forKey:@"profileImage"];
			
			[parseUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
				if (!error) {
					NSLog(@"Saved");
				}
				else{
					// Error
					NSLog(@"Error: %@ %@", error, [error userInfo]);
				}
			}];
		}
	}];
}

-(void) showEditMode:(BOOL) mode{
	self.firstLastNameEdit.hidden = mode;
	self.firstNameEdit.hidden = !mode;
	self.lastNameEdit.hidden = !mode;
	
	if(mode == YES){
		self.emailAddressEdit.borderStyle = UITextBorderStyleRoundedRect;
	}
	else {
		self.emailAddressEdit.borderStyle = UITextBorderStyleNone;
		[self.emailAddressEdit setBackgroundColor:[UIColor clearColor]];
	}
	
	self.emailAddressEdit.enabled = mode;
	self.firstNameEdit.enabled = mode;
	self.lastNameEdit.enabled = mode;
	
	self.professionTextView.layer.borderWidth = 1.0f;
	self.professionTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];

}

- (IBAction)onEdit:(UIButton *)sender {
	UIButton *button = (UIButton *)sender;
	NSString *buttonTitle = button.currentTitle;
	
	if([buttonTitle isEqualToString:@"Edit"]){
		button.enabled = FALSE;
		[button setTitle:@"Save" forState:UIControlStateNormal];
		button.enabled = TRUE;
		[self showEditMode:YES];
//
//		self.firstLastNameEdit.hidden = YES;
//		self.firstNameEdit.hidden = NO;
//		self.lastNameEdit.hidden = NO;
//		
//		self.emailAddressEdit.borderStyle = UITextBorderStyleRoundedRect;
//		self.emailAddressEdit.enabled = YES;
//		self.firstNameEdit.enabled = YES;
//		self.lastNameEdit.enabled = YES;
	} else if([buttonTitle isEqualToString:@"Save"]){
		button.enabled = FALSE;
		[button setTitle:@"Edit" forState:UIControlStateNormal];
		button.enabled = TRUE;
		[self showEditMode:NO];
		
//		self.firstLastNameEdit.hidden = NO;
//		self.firstNameEdit.hidden = YES;
//		self.lastNameEdit.hidden = YES;
//		self.firstNameEdit.enabled = NO;
//		self.lastNameEdit.enabled = NO;
//		
//		self.emailAddressEdit.borderStyle = UITextBorderStyleNone;
//		[self.emailAddressEdit setBackgroundColor:[UIColor clearColor]];
//		self.emailAddressEdit.enabled = NO;
//		
//		self.firstLastNameEdit.borderStyle = UITextBorderStyleNone;
//		[self.firstLastNameEdit setBackgroundColor:[UIColor clearColor]];
//		self.firstLastNameEdit.enabled = NO;
//		
//		UIFont* boldFont = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
//		[self.firstLastNameEdit setFont:boldFont];
//		[self.emailAddressEdit setFont:boldFont];
//		
//		
//		CGRect frameRect = self.emailAddressEdit.frame;
//		frameRect.size.height = 25;
//		self.emailAddressEdit.frame = frameRect;
//		
//		NSString *name = self.firstNameEdit.text;
//		name = [name stringByAppendingString:@" "];
//		self.firstLastNameEdit.text = [name stringByAppendingString:self.lastNameEdit.text];

		// add a check, if data is changed then save it.
//		PFUser *parseUser = [PFUser currentUser];
//		[parseUser setObject:self.firstNameEdit.text forKey:@"firstName"];
//		[parseUser setObject:self.lastNameEdit.text forKey:@"lastName"];
//		[parseUser setObject:self.emailAddressEdit.text forKey:@"email"];
		
//		[parseUser saveInBackground];
	}
}

//http://stackoverflow.com/questions/7605845/how-to-load-photos-from-photo-gallery-and-store-it-into-application-project
- (IBAction)onAddImage:(UIButton *)sender {
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
	imagePickerController.delegate = self;
	imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
	
	[self presentViewController:imagePickerController animated:YES completion:nil];
}

- (IBAction)onFinished:(UIButton *)sender {
	if([self validateInput] == NO)
		return;

	PFUser *parseUser = [PFUser currentUser];
	[parseUser setObject:self.firstNameEdit.text forKey:@"firstName"];
	[parseUser setObject:self.lastNameEdit.text forKey:@"lastName"];
	[parseUser setObject:self.emailAddressEdit.text forKey:@"email"];
	[parseUser setObject:self.profileLinkEditText.text forKey:@"profileLink"];
	[parseUser setObject:self.professionTextView.text forKey:@"profession"];
	
	[parseUser saveInBackground];
	
	// finished button will be visible only when we will land here view account creation.
	ProfileDetailsViewController *profileVc = [[ProfileDetailsViewController alloc] initWithUser:parseUser fromAccountCreation:YES];
	UINavigationController *profileNvc = [[UINavigationController alloc] initWithRootViewController:profileVc];
	profileVc.title = @"My Profile";
	[self presentViewController:profileNvc animated:YES completion:nil];
}

@end
