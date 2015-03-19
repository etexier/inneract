//
//  FeedDetailsCell.h
//  Inneract
//
//  Created by Emmanuel Texier on 3/18/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class FeedDetailsCell;

@protocol FeedDetailsCellDelegate<NSObject>

-(void) didSelectReadFullStory:(FeedDetailsCell *) cell;
-(void) didBookmark:(FeedDetailsCell *) cell;
-(void) didShare:(FeedDetailsCell *) cell;

@end

@interface FeedDetailsCell : UITableViewCell

@property (weak, nonatomic) PFObject *feed;
@property (weak, nonatomic) id<FeedDetailsCellDelegate> delegate;

@end
