//
//  FeedDetailsViewController.h
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFObject;

@interface FeedDetailsViewController : UIViewController
@property (weak, nonatomic) PFObject *feed;
- (id)initWithFeed:(PFObject *)feed;
@end
