//
//  BadgesCell.m
//  Inneract
//
//  Created by Jim Liu on 3/17/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "BadgesCell.h"
#import "IPColors.h"
#import "PFQuery.h"
#import "Helper.h"

@interface BadgesCell ()

@property (weak, nonatomic) IBOutlet UILabel *appreciationLabel;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet UIButton *giveButton;
@property (weak, nonatomic) IBOutlet UILabel *alreadyBadgedLabel;


@end

@implementation BadgesCell

- (void)awakeFromNib {
    // Initialization code
    
    self.appreciationLabel.textColor = ipSecondaryGrey;
    self.alreadyBadgedLabel.textColor = ipSecondaryGrey;
    self.badgeLabel.textColor = ipPrimaryMidnightBlue;
    self.giveButton.tintColor = ipPrimaryOrange;
    self.giveButton.backgroundColor = ipPrimaryLightGrey;

    self.giveButton.hidden = YES;
    self.alreadyBadgedLabel.hidden = YES;
}

- (void)setUser:(PFObject *)user isSelfProfile:(BOOL) isSelfProfile {
    _user = user;
    _isSelfProfile = isSelfProfile;
    _badgeNumber = [[_user valueForKey:@"badges"] integerValue];
    self.badgeLabel.text = [NSString stringWithFormat:@"%lu", _badgeNumber];

    PFQuery *query = [PFQuery queryWithClassName:@"Badge"];
    [query whereKey:@"fromUserId" equalTo:[PFUser currentUser].objectId];
    [query whereKey:@"toUserId" equalTo: self.user.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error && objects.count == 0 && !self.isSelfProfile) {
            self.giveButton.hidden = NO;
        } else if(objects.count > 0) {
            self.alreadyBadgedLabel.text = [NSString stringWithFormat:@"You gave %@ %@ a badge on %@", [self.user valueForKey:@"firstName"], [self.user valueForKey:@"lastName"], [Helper postedDate:[objects[0] valueForKey:@"createdAt"]]];
            self.alreadyBadgedLabel.hidden = NO;
        }
    }];
}

- (IBAction)didGiveBadge:(id)sender {
    [self.profileDelegate onGiveBadge:(self.badgeNumber + 1) WithCompletion:^(NSError *error) {
        if(!error) {
            self.badgeNumber++;
            self.badgeLabel.text = [NSString stringWithFormat:@"%lu", self.badgeNumber];
            self.giveButton.hidden = YES;
        }
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
