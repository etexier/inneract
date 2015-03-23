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
@protocol IPFeedDelegate;

@interface FeedCell : PFTableViewCell
@property (weak, nonatomic) PFObject *feed;
@property (nonatomic, assign) BOOL isBookmarked;
@property (nonatomic, weak) id<IPFeedDelegate> feedCellHandler;
@property (nonatomic, assign) BOOL isForBookmark;

- (void)setData:(PFObject *)feed isBookmarked:(BOOL)isBookmarked isForBookmakr:(BOOL) isForBookmark;

@end
