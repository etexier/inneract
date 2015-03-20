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

@interface BadgesCell ()

@property (weak, nonatomic) IBOutlet UILabel *appreciationLabel;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet UIButton *giveButton;

@end

@implementation BadgesCell

- (void)awakeFromNib {
    // Initialization code
    
    self.appreciationLabel.textColor = ipSecondaryGrey;
    self.badgeLabel.textColor = ipPrimaryMidnightBlue;
    self.giveButton.tintColor = ipPrimaryOrange;
    self.giveButton.backgroundColor = ipPrimaryLightGrey;

    self.giveButton.hidden = YES;
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
