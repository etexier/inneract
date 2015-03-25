//
//  BasicInfoCell.m
//  Inneract
//
//  Created by Jim Liu on 3/17/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "BasicInfoCell.h"
#import "IPColors.h"
#import "UIImageView+AFNetworking.h"
#import "IPColorManager.h"

@interface BasicInfoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *designatoinLabel;
@property (weak, nonatomic) IBOutlet UIButton *aboutButton;
@property (weak, nonatomic) IBOutlet UILabel *profession;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButton;

- (IBAction)onEditProfile:(id)sender;
- (IBAction)onViewProfileLink:(id)sender;

@property (assign, nonatomic) BOOL fromAccountCreation;

@end

@implementation BasicInfoCell

- (void)setUser:(PFObject *)user fromAccountCreation:(BOOL) fromAccountCreation isSelf:(BOOL) isSelf {
    _user = user;
    _fromAccountCreation = fromAccountCreation;
    _isSelfProfile = isSelf;
    
    [self updateUI];
}

- (void)awakeFromNib {
    // Initialization code
    
    // round image
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2.0f;
    self.profileImage.clipsToBounds = YES;
    // for performance
    self.profileImage.layer.shouldRasterize = YES;
    self.profileImage.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void) updateUI {
    if(!self.isSelfProfile) {
        self.editProfileButton.hidden = YES;
    } else {
        self.editProfileButton.hidden = NO;
    }
    
    // thumbnail
    PFFile *profileFile = [self.user objectForKey:@"profileImage"];
    if(profileFile) {
        [self.profileImage setImageWithURL:[NSURL URLWithString:profileFile.url]];
    } else {
        self.profileImage.image = [UIImage imageNamed:@"user"];
    }
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", [self.user objectForKey:@"firstName"], [self.user objectForKey:@"lastName"]];
    self.designatoinLabel.text = [self.user objectForKey:@"designation"];
    self.profession.text = [self.user objectForKey:@"profession"];
    //self.profession.sizeToFit;
    self.profession.preferredMaxLayoutWidth = self.bounds.size.width - 16;
    
    NSString *profileLink = [self.user objectForKey:@"profileLink"];
    if(profileLink) {
        [self.aboutButton setTitle:[NSString stringWithFormat:@"  About %@  ", self.nameLabel.text] forState:UIControlStateNormal];
    } else {
        self.aboutButton.hidden = YES;
    }
    
    self.nameLabel.textColor = ipPrimaryMidnightBlue;
    self.designatoinLabel.textColor = ipPrimaryMidnightBlue;
    self.profession.textColor = ipPrimaryMidnightBlue;
    self.aboutButton.tintColor = ipPrimaryOrange;
    self.aboutButton.backgroundColor = ipPrimaryLightGrey;

    NSInteger badges = [[self.user objectForKey:@"badges"] integerValue];
    self.profileImage.layer.borderColor = [[[IPColorManager sharedInstance] getUserBadgeColor:badges] CGColor];
    self.profileImage.layer.borderWidth = 3.0;

    self.designatoinLabel.textColor = [[IPColorManager sharedInstance] getUserBadgeColor:badges];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onEditProfile:(id)sender {
    [self.profileDelegate onEditProfile];
}

- (IBAction)onViewProfileLink:(id)sender {
    [self.profileDelegate onViewProfileLink];
}
@end
