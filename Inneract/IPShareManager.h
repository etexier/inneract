//
//  IPShareManager.h
//  Inneract
//
//  Created by Jim Liu on 3/7/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IPShareManager : NSObject

+ (IPShareManager *)sharedInstance;

- (void) shareItemWith:(NSString *) title andUrl:(NSString *) url fromViewController:(UIViewController *) viewController

@end
