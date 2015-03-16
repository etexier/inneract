//
// Created by Emmanuel Texier on 3/7/15.
// Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Helper : NSObject
+ (NSString *)postedDate:(NSDate *)date;

+ (NSString *)embeddedVimeoIFrameForId:(NSString *)id1;

+ (void)embedVimeoVideoId:(NSString *)videoId inView:(UIWebView *)view;

@end