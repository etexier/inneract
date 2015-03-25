//
//  FeedDetailsCell.h
//  Inneract
//
//  Created by Emmanuel Texier on 3/18/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "IPFeedDelegate.h"

@class FeedDetailsCell;

@interface FeedDetailsCell : UITableViewCell

@property (weak, nonatomic) PFObject *feed;
@property (weak, nonatomic) PFObject *feedActivity;
@property (weak, nonatomic) id<IPFeedDelegate> delegate;
@property (nonatomic, assign) BOOL isBookmarked;
@property (nonatomic, assign) BOOL isForBookmark;

- (void)setData:(PFObject *)feed isBookmarked:(BOOL)isBookmarked isForBookmakr:(BOOL) isForBookmark feedActivity:(PFObject *)feedActivity;

@end
