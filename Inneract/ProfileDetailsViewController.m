//
//  ProfileDetailsViewController.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "ProfileDetailsViewController.h"
#import "IPShareManager.h"

@interface ProfileDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *designatoinLabel;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UILabel *profession;


- (IBAction)onLogout:(id)sender;
- (IBAction)onProfileLink:(id)sender;


@end

@implementation ProfileDetailsViewController

- (instancetype)initWithUser:(PFObject *)user {
    self = [super init];
    if (self) {
        self.user = user;
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"label36"] style:UIBarButtonItemStylePlain target:self action:@selector(didShared:)];
    
    // thumbnail
    PFFile *profileFile = [self.user objectForKey:@"profileImage"];
    if(profileFile) {
        [profileFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                self.profileImage.image = [UIImage imageWithData:data];
            }
        }];
    }
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", [self.user objectForKey:@"firstName"], [self.user objectForKey:@"lastName"]];
    self.designatoinLabel.text = [self.user objectForKey:@"designation"];
    self.profession.text = [self.user objectForKey:@"profession"];
    self.profession.sizeToFit;
    
    self.aboutButton.titleLabel.text = self.nameLabel.text;
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

- (void)didShared:(id)sender {
    [[IPShareManager sharedInstance] shareItemWithTitle:[NSString stringWithFormat:@"%@ %@", [self.user objectForKey:@"firstName"], [self.user objectForKey:@"lastName"]] andUrl:[self.user objectForKey:@"profileLink"] fromViewController:self];
}

- (IBAction)onLogout:(id)sender {
    [PFUser logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLogoutNotification" object:nil];
}

- (IBAction)onProfileLink:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.user objectForKey:@"profileLink"]]];
}
@end
