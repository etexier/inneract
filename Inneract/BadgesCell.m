//
//  BadgesCell.m
//  Inneract
//
//  Created by Jim Liu on 3/17/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "BadgesCell.h"
#import "IPColors.h"

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
}

- (void) setBadgeNumber:(NSInteger)badgeNumber {
    _badgeNumber = badgeNumber;
    self.badgeLabel.text = [NSString stringWithFormat:@"%lu", self.badgeNumber];
}

- (void) setIsSelfProfile:(BOOL)isSelfProfile {
    _isSelfProfile = isSelfProfile;
    
    if(isSelfProfile) {
        self.giveButton.hidden = YES;
    } else {
        self.giveButton.hidden = NO;
    }
}

- (IBAction)didGiveBadge:(id)sender {
    [self.profileDelegate onGiveBadge];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
