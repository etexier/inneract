//
//  HighlightedFeedsView.h
//  Inneract
//
//  Created by Emmanuel Texier on 3/15/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol HighlightedFeedsViewDelegate<NSObject>
- (void) onHeaderTap:(PFObject *)object;
@end

@interface HighlightedFeedsView : UIView
@property (nonatomic, weak) id<HighlightedFeedsViewDelegate> delegate;
@property (strong, nonatomic) NSArray *feeds;
@end
