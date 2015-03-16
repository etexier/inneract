//
//  NSMutableString+HTML.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/14/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "NSMutableString+HTML.h"

@implementation NSMutableString (HTML)

- (NSMutableString *)xmlSimpleUnescape
{
    [self replaceOccurrencesOfString:@"&amp;"  withString:@"&"  options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&#x27;" withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&#x39;" withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&#x92;" withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&#x96;" withString:@"'"  options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&gt;"   withString:@">"  options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&lt;"   withString:@"<"  options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    
    return self;
}

- (NSMutableString *)xmlSimpleEscape
{
    [self replaceOccurrencesOfString:@"&"  withString:@"&amp;"  options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"\"" withString:@"&quot;" options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"'"  withString:@"&#x27;" options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@">"  withString:@"&gt;"   options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"<"  withString:@"&lt;"   options:NSLiteralSearch range:NSMakeRange(0, [self length])];
    
    return self;
}

@end
