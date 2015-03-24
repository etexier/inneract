//
// Created by Jim Liu on 3/22/15.
// Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@protocol IPFeedDelegate <NSObject>

-(void) didBookmarkFeed:(PFObject *) feed;
-(void) didShareFeed:(PFObject *) feed;

@optional
-(void) didSelectReadFullStory:(PFObject *) feed;
-(void) didRsvp:(PFObject *) feed;
-(void) didPay:(PFObject *) feed;
-(void) didRegister:(PFObject *) feed;
-(void) didVolunteer:(PFObject *) feed;

@end