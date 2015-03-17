//
//  SingleHighlightedFeedView.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/16/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "SingleHighlightedFeedView.h"
#import "UIImageView+IP.h"

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
    
    [self.thumbnailView ip_setImageWithURL:feed[@"imageUrl"]];
    self.titleLabel.text = feed[@"title"];
    self.postedLabel.text = feed[@"createdAt"];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
