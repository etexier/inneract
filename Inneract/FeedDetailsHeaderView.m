//
//  FeedDetailsHeaderView.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/18/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "FeedDetailsHeaderView.h"
#import "UIImageView+IP.h"


NSString *const kFeedDetailsHeaderViewNibId = @"FeedDetailsHeaderView";


@interface FeedDetailsHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (strong, nonatomic) IBOutlet UITableViewCell *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *bookmarkOnImg;
@property (weak, nonatomic) IBOutlet UIImageView *videoPlayButtonImageView;

@property(strong, nonatomic, readwrite) NSURL *videoUrl;


@end
@implementation FeedDetailsHeaderView

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
    UINib *nib = [UINib nibWithNibName:kFeedDetailsHeaderViewNibId bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    
}

- (void)setFeed:(PFObject *)feed {
    
    _feed = feed;
    
    self.bookmarkOnImg.hidden = YES;
    
    // thumbnail
    NSString *imageUrlString = [feed objectForKey:@"imageUrl"];
    NSURL *imageUrl = [NSURL URLWithString:imageUrlString];
    [self.thumbnailImageView ip_setImageWithURL:imageUrl];
    
    
    // play button image
    NSString *url = [_feed objectForKey:@"videoUrl"];
    if (nil != url) {
        self.videoUrl = [NSURL URLWithString:url];
        self.videoPlayButtonImageView.hidden = NO;
    } else {
        self.videoUrl = nil;
        self.videoPlayButtonImageView.hidden = YES;
    }
    
}

#pragma mark - tap gesture
- (IBAction)onTap:(id)sender {
    NSLog(@"on Tap");
    [self.delegate didTapOnHeaderView:self];
}




@end
