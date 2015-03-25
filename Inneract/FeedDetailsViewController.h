//
//  FeedDetailsViewController.h
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IPFeedDelegate.h"

@class PFObject;

@interface FeedDetailsViewController : UIViewController
@property (strong, nonatomic) PFObject *feed;
@property (assign, nonatomic) BOOL isBookmarked;
@property (assign, nonatomic) BOOL isForBookmark;
@property (nonatomic, weak) id<IPFeedDelegate> delegate;

- (instancetype) initWithFeed:(PFObject *) feed isBookmarked:(BOOL) isBookmarked isForBookmark:(BOOL) isForBookmark delegate:(id<IPFeedDelegate>) delegate;

@end
