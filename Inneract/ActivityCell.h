//
//  ActivityCell.h
//  Inneract
//
//  Created by Jim Liu on 3/17/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ActivityCell : UITableViewCell

@property (nonatomic, strong) PFObject *activity;

@end
