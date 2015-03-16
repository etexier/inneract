//
//  NSMutableString+HTML.h
//  Inneract
//
//  Created by Emmanuel Texier on 3/14/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (HTML)

- (NSMutableString *)xmlSimpleUnescape;

- (NSMutableString *)xmlSimpleEscape;
@end
