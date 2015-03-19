//
//  IPEventTracker.h
//  Inneract
//
//  Created by Jim Liu on 3/19/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface IPEventTracker : NSObject

+ (IPEventTracker *)sharedInstance;

- (void) onShareFeed:(PFObject *) feed;

- (void) onReadFeed:(PFObject *) feed;

- (void) onRegisterClass:(PFObject *) feed;

- (void) onRsvpEvent:(PFObject *) feed;

- (void) onVolunteerEvent:(PFObject *) feed;

- (void) onGiveBadgeToUser:(PFUser *) user;

@end
