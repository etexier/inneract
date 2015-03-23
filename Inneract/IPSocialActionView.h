//
//  IPSocialActionView.h
//  Inneract
//
//  Created by Jim Liu on 3/22/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol IPSocialActionDelegate <NSObject>

- (void) onShareFeed;
- (void) onBookmarkFeed;

@end

@interface IPSocialActionView : UIView

@property (nonatomic, strong) PFObject * feed;
@property (nonatomic, assign) BOOL isBookmarked;
@property (nonatomic, assign) BOOL isBookmarkNeeded;
@property (nonatomic, weak) id<IPSocialActionDelegate> delegate;

- (void) setBookmarkNeeded:(BOOL) isBookmarkNeeded isBookmarked:(BOOL) isBookmarked;

@end
