//
//  SingleHighlightedFeedView.h
//  Inneract
//
//  Created by Emmanuel Texier on 3/16/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SingleHighlightedFeedView : UIView

@property (nonatomic, strong) PFObject *feed;
@end
