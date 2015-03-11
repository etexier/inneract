//
//  ProfileDetailsViewController.h
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProfileDetailsViewController : UIViewController

@property (nonatomic, strong) PFObject *user;

@end
