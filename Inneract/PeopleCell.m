//
//  PeopleCell.m
//  Inneract
//
//  Created by Jim Liu on 3/8/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "PeopleCell.h"

@interface PeopleCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *designationLabel;
@property (weak, nonatomic) IBOutlet UILabel *professionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shareImage;


@end

@implementation PeopleCell

- (void)awakeFromNib {
    // Initialization code

    // round image
    self.profileImage.layer.cornerRadius = 5; // self.thumbnail.frame.size.width / 2.0f;
    self.profileImage.clipsToBounds = YES;
    // for performance
    self.profileImage.layer.shouldRasterize = YES;
    self.profileImage.layer.rasterizationScale = [[UIScreen mainScreen] scale];
}

- (void)setUser:(PFObject *)user {
    _user = user;

    // thumbnail
    PFFile *profileFile = [user objectForKey:@"profileImage"];
    if(profileFile) {
        [profileFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                self.profileImage.image = [UIImage imageWithData:data];
            }
        }];
    }

    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", [user objectForKey:@"firstName"], [user objectForKey:@"lastName"]];
    self.designationLabel.text = [user objectForKey:@"designation"];
    self.professionLabel.text = [user objectForKey:@"profession"];
    self.professionLabel.sizeToFit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
