//
// Created by Emmanuel Texier on 3/7/15.
// Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "Helper.h"


@implementation Helper


static NSDateFormatter *_dateFormatter = nil;

+(NSDateFormatter *)postedDateFormatterInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"MM/dd/YYYY"];
        [_dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    });
    return _dateFormatter;
}
+ (NSString *)postedDate:(NSDate *)date {
    NSString *dateString = [self.postedDateFormatterInstance stringFromDate:date];
    return dateString;
}



@end