//
//  IPShareManager.m
//  Inneract
//
//  Created by Jim Liu on 3/7/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "IPShareManager.h"

@implementation IPShareManager


+ (IPShareManager *)sharedInstance {
    static IPShareManager *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void) shareItemWith:(NSString *) title andUrl:(NSString *) url fromViewController:(UIViewController *) viewController {
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[title, [NSURL URLWithString:url]]
                                      applicationActivities:nil];
    [viewController presentViewController:activityViewController
                                       animated:YES
                                     completion:^{
                                         // ...
                                     }];
}



@end
