//
//  ProfileDetailsViewController.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "ProfileDetailsViewController.h"
#import "EditProfileViewController.h"
#import "IPColors.h"
#import "UIImageView+AFNetworking.h"
#import "MainViewHelper.h"


@interface ProfileDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *designatoinLabel;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UILabel *profession;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;
@property (assign, nonatomic) BOOL fromAccountCreation;

@property (nonatomic, assign) BOOL isSelfProfile;

- (IBAction)onLogout:(id)sender;
- (IBAction)onProfileLink:(id)sender;


@end

@implementation ProfileDetailsViewController

- (instancetype)initWithUser:(PFObject *)user {
    return [self initWithUser:user fromAccountCreation:NO];
}

- (instancetype)initWithUser:(PFObject *)user fromAccountCreation:(BOOL) fromAccountCreation{
	self = [super init];
	if (self) {
		self.fromAccountCreation = fromAccountCreation;
		if(user) {
			_user = user;
		} else {
			_isSelfProfile = YES;
			PFQuery *query = [PFUser query];
			PFUser *parseUser = [PFUser currentUser];
			NSString *username = parseUser.username;
			[query whereKey:@"username" equalTo:username];
			[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
				if(!error && objects.count == 1) {
					_user = objects[0];
				}
			}];
		}
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
    // round image
    self.profileImage.layer.cornerRadius = 40; // self.thumbnail.frame.size.width / 2.0f;
    self.profileImage.clipsToBounds = YES;
    // for performance
    self.profileImage.layer.shouldRasterize = YES;
    self.profileImage.layer.rasterizationScale = [[UIScreen mainScreen] scale];
	
    if(!self.isSelfProfile) {
        self.editProfileButton.hidden = YES;
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"backArrowIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(didBack:)];

		if(self.fromAccountCreation){
			self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit Profile" style:UIBarButtonItemStylePlain target:self action:@selector(onEditProfile:)];
			
			//[self.confirmPopupView setHidden:NO];
            UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Thanks for joining the Inneract Project Family!"
                                                               message:@"You have successfully created your profile. An email confirmation has been sent to your email address. Please verify your account. Your email confirmation helps to maintain an honest IP community."
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [theAlert show];
            
		}
        //Share is removed from new design
//        else {
//			self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"shareYellowButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(didShared:)];
//		}
    } else {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout:)];
    }
    
    // thumbnail
    PFFile *profileFile = [self.user objectForKey:@"profileImage"];
    if(profileFile) {
        [self.profileImage setImageWithURL:[NSURL URLWithString:profileFile.url]];
//        [profileFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//            if (!error) {
//                self.profileImage.image = [UIImage imageWithData:data];
//            }
//        }];
    } else {
        self.profileImage.image = [UIImage imageNamed:@"user"];
    }
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", [self.user objectForKey:@"firstName"], [self.user objectForKey:@"lastName"]];
    self.designatoinLabel.text = [self.user objectForKey:@"designation"];
    self.profession.text = [self.user objectForKey:@"profession"];
    self.profession.sizeToFit;
    
    [self.aboutButton setTitle:[NSString stringWithFormat:@"About %@", self.nameLabel.text] forState:UIControlStateNormal];
    
    self.nameLabel.textColor = ipPrimaryMidnightBlue;
    self.designatoinLabel.textColor = ipPrimaryMidnightBlue;
    self.profession.textColor = ipPrimaryMidnightBlue;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUser:(PFObject *)user {
    _user = user;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)didShared:(id)sender {
//    [[IPShareManager sharedInstance] shareItemWithTitle:[NSString stringWithFormat:@"%@ %@", [self.user objectForKey:@"firstName"], [self.user objectForKey:@"lastName"]] andUrl:[self.user objectForKey:@"profileLink"] fromViewController:self];
//}

- (void)didBack:(id)sender {
    if(!self.fromAccountCreation) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSString *preselectedCategory;
        NSString *userDesignation = [self.user valueForKey:@"userType"];
        if([userDesignation hasPrefix:@"Teacher"]) {
            preselectedCategory = @"volunteer";
        } else if([userDesignation hasPrefix:@"Parent"]) {
            preselectedCategory = @"classes";
        } else {
            preselectedCategory = @"news";
        }
        [self presentViewController:[MainViewHelper setupMainViewTabBarWithSelectedFeedsCategory:preselectedCategory] animated:YES completion:nil];
    }
}

- (IBAction)onLogout:(id)sender {
    [PFUser logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLogoutNotification" object:nil];
}

- (IBAction)onProfileLink:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.user objectForKey:@"profileLink"]]];
}

- (IBAction)onEditProfile:(id)sender {
    [self.navigationController pushViewController:[[EditProfileViewController alloc] initWithUser:self.user] animated:YES];
}

@end
