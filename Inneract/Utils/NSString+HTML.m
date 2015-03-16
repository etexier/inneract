//
//  NSString+HTML.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/14/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "NSString+HTML.h"
#import "NSMutableString+HTML.h"

@implementation NSString (HTML)

- (NSString *)xmlSimpleUnescapeString
{
    NSMutableString *unescapeStr = [NSMutableString stringWithString:self];
    
    return [unescapeStr xmlSimpleUnescape];
}


- (NSString *)xmlSimpleEscapeString
{
    NSMutableString *escapeStr = [NSMutableString stringWithString:self];
    
    return [escapeStr xmlSimpleEscape];
}

@end
