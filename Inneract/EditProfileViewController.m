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
#import "NIDropDown.h"


@interface EditProfileViewController () <UIImagePickerControllerDelegate,
										UINavigationControllerDelegate,
										NIDropDownDelegate>
										//UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *profileLinkEditText;
@property (weak, nonatomic) IBOutlet UIButton *profileSelectButton;

@property (weak, nonatomic) IBOutlet UIPickerView *profileTypePicker;


@property (weak, nonatomic) IBOutlet UITextView *professionTextView;
@property (strong, nonatomic) NSArray *profileNames;
@property (weak, nonatomic) IBOutlet UITextField *firstNameEdit;
@property (weak, nonatomic) IBOutlet UITextField *lastNameEdit;
@property (weak, nonatomic) IBOutlet UITextField *firstLastNameEdit;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressEdit;

@property (nonatomic, assign) BOOL isUserCreation;

@end

ComboBox* combo1;
NIDropDown *dropDown;

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

    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(onSave)];
    self.navigationItem.rightBarButtonItem = rightButton;

    // Do any additional setup after loading the view from its nib.
	self.profileSelectButton.layer.borderWidth = 1;
	self.profileSelectButton.layer.borderColor = [[UIColor blackColor] CGColor];
	self.profileSelectButton.layer.cornerRadius = 5;
	
	
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
		//self.profileSelectButton.titleLabel.text = [self.user objectForKey:@"userType"];
		[self.profileSelectButton setTitle: [self.user objectForKey:@"userType"] forState: UIControlStateNormal];
		
		NSLog(@"%@", [self.user objectForKey:@"userType"]);
//		[self showEditMode:YES];
		// rounded corners
		CALayer *layer = [self.profileImageView layer];
		[layer setMasksToBounds:YES];
		[layer setCornerRadius:32.0];
	} else {
        self.isUserCreation = YES;
		[self.profileSelectButton setTitle: @"Select a profile type *" forState: UIControlStateNormal];
	}
	
	self.firstNameEdit.text = self.firstName;
	self.lastNameEdit.text = self.lastName;
	self.emailAddressEdit.text = self.email;
		
	self.profileNames = @[@"IP Teacher/TA", @"Parent/Guardian",
						  @"Follower"];
	[self showEditMode:YES];
}

-(void) saveUserInfo{
	if([self validateInput] == NO)
		return;
	
	PFUser *parseUser = [PFUser currentUser];
	[parseUser setObject:self.firstNameEdit.text forKey:@"firstName"];
	[parseUser setObject:self.lastNameEdit.text forKey:@"lastName"];
	[parseUser setObject:self.emailAddressEdit.text forKey:@"email"];
	[parseUser setObject:self.profileLinkEditText.text forKey:@"profileLink"];
	[parseUser setObject:self.professionTextView.text forKey:@"profession"];
	[parseUser setObject:self.profileSelectButton.titleLabel.text forKey:@"userType"];
    [parseUser setObject:self.profileSelectButton.titleLabel.text forKey:@"designation"];
	
	[parseUser saveInBackground];
	
}
-(void) onSave{
	
	[self saveUserInfo];
    
    if(self.isUserCreation) {
        PFUser *parseUser = [PFUser currentUser];
        
        // finished button will be visible only when we will land here view account creation.
        ProfileDetailsViewController *profileVc = [[ProfileDetailsViewController alloc] initWithUser:parseUser fromAccountCreation:YES];
        UINavigationController *profileNvc = [[UINavigationController alloc] initWithRootViewController:profileVc];
        profileVc.title = @"My Profile";
        [self presentViewController:profileNvc animated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

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

//http://stackoverflow.com/questions/7605845/how-to-load-photos-from-photo-gallery-and-store-it-into-application-project
- (IBAction)onAddImage:(UIButton *)sender {
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
	imagePickerController.delegate = self;
	imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
	
	[self presentViewController:imagePickerController animated:YES completion:nil];
}


- (IBAction)selectedClicked:(UIButton *)sender {
	if(dropDown == nil) {
		CGFloat f = 120;
		dropDown = [[NIDropDown alloc]showDropDown:sender :&f :self.profileNames :nil :@"down"];
		dropDown.delegate = self;
	}
	else {
		[dropDown hideDropDown:sender];
		dropDown = nil;
	}
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
	dropDown = nil;
}


@end
