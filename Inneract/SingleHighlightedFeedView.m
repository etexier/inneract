//
//  SingleHighlightedFeedView.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/16/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "SingleHighlightedFeedView.h"
#import "UIImageView+IP.h"
#import "Helper.h"

@interface SingleHighlightedFeedView()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postedLabel;

@end

NSString *const kSingleHighlightedFeedViewId = @"SingleHighlightedFeedView";

@implementation SingleHighlightedFeedView


- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initSubViews];
    }
    return self;
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
    
}

- (id)init {
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
    
}

- (void)initSubViews {
    UINib *nib = [UINib nibWithNibName:kSingleHighlightedFeedViewId bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    
}

- (void) setFeed:(PFObject *)feed {
    _feed = feed;
    
    [self.thumbnailView ip_setImageWithURL:[NSURL URLWithString:[feed objectForKey:@"imageUrl"]]];
    self.titleLabel.text = [feed objectForKey:@"title"];
        NSDate *createdAt = feed.createdAt;
    NSString *dateString = [Helper postedDate:createdAt];
    self.postedLabel.text = [NSString stringWithFormat:@"posted %@", dateString];
    
}




@end
