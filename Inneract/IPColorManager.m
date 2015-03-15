//
//  IPColorManager.m
//  Inneract
//
//  Created by Jim Liu on 3/14/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "IPColorManager.h"
#import "IPColors.h"

@implementation IPColorManager


+ (IPColorManager *)sharedInstance {
    static IPColorManager *_instance = nil;
    
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    
    return _instance;
}

- (UIColor *) getUserBadgeColor:(NSInteger) badgeScore {
    if(badgeScore > 10) {
        return ipPrimaryOrange;
    } else if(badgeScore > 5) {
        return ipSecondaryCyan;
    } else {
        return ipPrimaryMidnightBlue;
    }
}

@end
