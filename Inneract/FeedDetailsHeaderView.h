//
//  FeedDetailsHeaderView.h
//  Inneract
//
//  Created by Emmanuel Texier on 3/18/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class FeedDetailsHeaderView;

@protocol FeedDetailsHeaderViewDelegate<NSObject>

- (void) didTapOnHeaderView:(FeedDetailsHeaderView *) headerView;

@end

@interface FeedDetailsHeaderView : UIView


@property (nonatomic, strong) PFObject *feed;
@property(strong, nonatomic, readonly) NSURL *videoUrl;
@property (nonatomic, weak) id<FeedDetailsHeaderViewDelegate> delegate;


@end
