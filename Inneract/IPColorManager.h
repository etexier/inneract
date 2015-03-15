//
//  IPColorManager.h
//  Inneract
//
//  Created by Jim Liu on 3/14/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IPColorManager : NSObject

+ (IPColorManager *)sharedInstance;

- (UIColor *) getUserBadgeColor:(NSInteger) badgeScore;

@end
