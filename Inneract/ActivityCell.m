//
//  ActivityCell.m
//  Inneract
//
//  Created by Jim Liu on 3/17/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "ActivityCell.h"
#import "Helper.h"
#import "IPColors.h"

@interface ActivityCell ()

@property (weak, nonatomic) IBOutlet UILabel *activityDescriptionLabel;

@end

@implementation ActivityCell

- (void)awakeFromNib {
    // Initialization code
    
    self.activityDescriptionLabel.textColor = ipSecondaryBlue;
}

- (void) setActivity:(PFObject *)activity {
    _activity = activity;
    
    PFObject *feed = [activity valueForKey:@"event"];
    if(feed) {
        self.activityDescriptionLabel.text = [NSString stringWithFormat:@"%@ : %@ \"%@\"", [Helper postedDate:activity.createdAt], [activity valueForKey:@"action"], [feed valueForKey:@"title"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
