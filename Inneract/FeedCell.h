//
//  FeedCell.h
//  Inneract
//
//  Created by Emmanuel Texier on 3/6/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFTableViewCell.h>
#import <Parse/PFObject.h>

@class FeedCell;

@protocol FeedCellProtocol <NSObject>

- (void) feedCell:(FeedCell *) tweetCell didShareFeed:(PFObject*) feed;

- (void) feedCell:(FeedCell *) tweetCell didBookmarkFeed:(PFObject*) feed;

@end

@interface FeedCell : PFTableViewCell
@property (weak, nonatomic) PFObject *feed;
@property (nonatomic, weak) id<FeedCellProtocol> feedCellHandler;
@property (nonatomic, assign) BOOL isForBookmark;

@end
