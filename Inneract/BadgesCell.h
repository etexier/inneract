//
//  BadgesCell.h
//  Inneract
//
//  Created by Jim Liu on 3/17/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileDelegate.h"

@interface BadgesCell : UITableViewCell

@property (nonatomic, assign) NSInteger badgeNumber;
@property (nonatomic, assign) BOOL isSelfProfile;
@property (nonatomic, weak) id<ProfileDelegate> profileDelegate;

@end
