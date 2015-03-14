//
//  EditProfileViewController.h
//  Inneract
//
//  Created by Emmanuel Texier on 3/5/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditProfileViewController : UIViewController

@property (strong, nonatomic)  NSString *firstName;
@property (strong, nonatomic)  NSString *lastName;

@property (strong, nonatomic)  NSString *email;

@property (nonatomic, strong) PFObject *user;



- (instancetype)initWithUser:(PFObject *)user;

+ (instancetype)controllerWithUser:(PFObject *)user;


@end
