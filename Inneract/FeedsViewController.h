//
//  FeedsViewController.h
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFQueryTableViewController.h>

@interface FeedsViewController : UIViewController

@property (nonatomic, strong) NSString *feedCategory;

- (id)initForBookmark;

- (void) filterQuery:(PFQuery *) query;

@end
