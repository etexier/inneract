//
//  PeopleCell.h
//  Inneract
//
//  Created by Jim Liu on 3/8/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI.h>
#import <Parse/PFObject.h>

@interface PeopleCell : PFTableViewCell

@property (weak, nonatomic) PFObject *user;

@end
