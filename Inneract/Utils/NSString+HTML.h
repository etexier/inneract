//
//  NSString+HTML.h
//  Inneract
//
//  Created by Emmanuel Texier on 3/14/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HTML)

- (NSString *)xmlSimpleUnescapeString;

- (NSString *)xmlSimpleEscapeString;
@end
