//
//  PeopleCell.m
//  Inneract
//
//  Created by Jim Liu on 3/8/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "PeopleCell.h"
#import "IPShareManager.h"
#import "IPColors.h"
#import "UIImageView+AFNetworking.h"
#import "IPColorManager.h"

@interface PeopleCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *designationLabel;
@property (weak, nonatomic) IBOutlet UILabel *professionLabel;
@property (weak, nonatomic) IBOutlet UILabel *badgesLabel;

@property (weak, nonatomic) IBOutlet UIImageView *shareImage;


@end

@implementation PeopleCell

- (void)awakeFromNib {
    // Initialization code

    // round image
    self.profileImage.layer.cornerRadius = 40; // self.thumbnail.frame.size.width / 2.0f;
    self.profileImage.clipsToBounds = YES;
    // for performance
    self.profileImage.layer.shouldRasterize = YES;
    self.profileImage.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    UITapGestureRecognizer *shareTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didShare:)];
    [self.shareImage addGestureRecognizer:shareTap];
    
    self.nameLabel.textColor = ipPrimaryMidnightBlue;
    //self.designationLabel.textColor = ipPrimaryMidnightBlue;
    self.professionLabel.textColor = ipPrimaryMidnightBlue;
    self.badgesLabel.textColor = ipPrimaryMidnightBlue;
}

- (void)setUser:(PFObject *)user {
    _user = user;

    // thumbnail
    PFFile *profileFile = [user objectForKey:@"profileImage"];
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
    
    NSInteger badges = [[user objectForKey:@"badges"] integerValue];

    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", [user objectForKey:@"firstName"], [user objectForKey:@"lastName"]];
    
    self.designationLabel.text = [user objectForKey:@"designation"];
    self.designationLabel.textColor = [[IPColorManager sharedInstance] getUserBadgeColor:badges];
    
    self.professionLabel.text = [user objectForKey:@"profession"];
    self.professionLabel.sizeToFit;
    
    self.badgesLabel.text = [NSString stringWithFormat:@"Badges : %lu", badges];

    self.profileImage.layer.borderColor = [[[IPColorManager sharedInstance] getUserBadgeColor:badges] CGColor];
    self.profileImage.layer.borderWidth = 3.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didShare:(id)sender {
    [self.userCellHandler peopleCell:self didSharePeople:self.user];
}

@end
