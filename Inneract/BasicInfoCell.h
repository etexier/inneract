//
//  BasicInfoCell.h
//  Inneract
//
//  Created by Jim Liu on 3/17/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ProfileDelegate.h"

@interface BasicInfoCell : UITableViewCell

@property (nonatomic, strong) PFObject *user;
@property (nonatomic, assign) BOOL isSelfProfile;
@property (nonatomic, weak) id<ProfileDelegate> profileDelegate;

- (void)setUser:(PFObject *)user fromAccountCreation:(BOOL) fromAccountCreation isSelf:(BOOL) isSelf;

@end
