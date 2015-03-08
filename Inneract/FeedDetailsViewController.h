//
//  FeedDetailsViewController.h
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Feed;

@interface FeedDetailsViewController : UIViewController
@property (weak, nonatomic) Feed *feed;
- (id)initWithFeed:(Feed *)feed;
@end
