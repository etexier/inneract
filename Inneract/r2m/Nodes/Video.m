//
//  Video.m
//
//  File generated by Magnet rest2mobile 1.1 - Mar 18, 2015 3:03:18 PM
//  @See Also: http://developer.magnet.com
//
#import "Video.h"


@implementation Video

+ (NSDictionary *)attributeMappings {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:@{
        @"magnetId" : @"id",
    }];
    [dictionary addEntriesFromDictionary:[super attributeMappings]];
    return [dictionary copy];
}

+ (NSDictionary *)listAttributeTypes {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:@{
    }];
    [dictionary addEntriesFromDictionary:[super listAttributeTypes]];
    return [dictionary copy];
}

@end