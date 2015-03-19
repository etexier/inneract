//
//  IPShareManager.m
//  Inneract
//
//  Created by Jim Liu on 3/7/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "IPShareManager.h"
#import "IPEventTracker.h"

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

- (void) shareFeed:(PFObject *) feed fromViewController:(UIViewController *) viewController {
    NSString *title = [feed objectForKey:@"title"];
    NSString *link = [feed objectForKey:@"link"];
    if(!link) {
        return;
    }
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[title, [NSURL URLWithString:link]]
                                      applicationActivities:nil];
    [viewController presentViewController:activityViewController
                                       animated:YES
                                     completion:^{
                                         // ...
                                     }];

    [[IPEventTracker sharedInstance] onShareFeed:feed];
}



@end
