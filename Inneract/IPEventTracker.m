//
//  IPEventTracker.m
//  Inneract
//
//  Created by Jim Liu on 3/19/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "IPEventTracker.h"

NSString * const kEventShareNews = @"ShareNews";
NSString * const kEventReadNews = @"ReadNews";
NSString * const kEventRegisterClass = @"RegisterClass";
NSString * const kEventRSVPEvent = @"RSVPEvent";
NSString * const kEventVolunteerEvent = @"VolunteerEvent";
NSString * const kEventGiveBadge = @"GiveBadge";

@implementation IPEventTracker


+ (IPEventTracker *)sharedInstance {
    static IPEventTracker *_instance = nil;
    
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    
    return _instance;
}

- (void) onShareFeed:(PFObject *) feed {
    [PFAnalytics trackEvent:kEventShareNews dimensions:[self getFeedDictionary:feed]];
}

- (void) onReadFeed:(PFObject *) feed {
    [PFAnalytics trackEvent:kEventReadNews dimensions:[self getFeedDictionary:feed]];
}

- (void) onRegisterClass:(PFObject *) feed {
    [PFAnalytics trackEvent:kEventRegisterClass dimensions:[self getFeedDictionary:feed]];
}

- (void) onRsvpEvent:(PFObject *) feed {
    [PFAnalytics trackEvent:kEventRSVPEvent dimensions:[self getFeedDictionary:feed]];
}

- (void) onVolunteerEvent:(PFObject *) feed {
    [PFAnalytics trackEvent:kEventVolunteerEvent dimensions:[self getFeedDictionary:feed]];
}

- (void) onGiveBadgeToUser:(PFUser *) user {
    NSDictionary *dimesions = @{
            @"toUser": [user valueForKey:@"username"],
            @"byUser" : [PFUser currentUser].username
    };
    [PFAnalytics trackEvent:kEventGiveBadge dimensions:dimesions];
}

- (NSDictionary *) getFeedDictionary:(PFObject *) feed {
    return @{
            @"feedTitle": [feed valueForKey:@"title"],
            @"feedId": [feed valueForKey:@"objectId"],
            @"byUser" : [PFUser currentUser].username
    };
}

@end
