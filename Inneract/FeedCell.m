//
//  FeedCell.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/6/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "FeedCell.h"
#import "Helper.h"
#import "IPColors.h"
#import "UIImageView+IP.h"
#import "IPSocialActionView.h"
#import "IPFeedDelegate.h"


@interface FeedCell () <IPSocialActionDelegate>
@property(weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property(weak, nonatomic) IBOutlet UILabel *postedDateLabel;
@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property (weak, nonatomic) IBOutlet UIView *socialActionView;


@property(weak, nonatomic) IBOutlet UIImageView *mediaImage;
@property (weak, nonatomic) IBOutlet UIImageView *bookmarkOnImgView;

@property (nonatomic, strong) IPSocialActionView *ipSocailActionView;

@end

@implementation FeedCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)awakeFromNib {

    // round image
//    self.thumbnail.layer.cornerRadius = 5; // self.thumbnail.frame.size.width / 2.0f;
    self.thumbnail.clipsToBounds = YES;
    // for performance
    self.thumbnail.layer.shouldRasterize = YES;
    self.thumbnail.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    // set up social action view
    self.ipSocailActionView = [[IPSocialActionView alloc] initWithFrame:self.socialActionView.bounds];
    self.ipSocailActionView.delegate = self;
    [self.socialActionView addSubview:self.ipSocailActionView];
    
//    [self prepareForReuse];

}


- (void)setData:(PFObject *)feed isBookmarked:(BOOL)isBookmarked isForBookmakr:(BOOL) isForBookmark {
    _feed = feed;
    _isBookmarked = isBookmarked;
    _isForBookmark = isForBookmark;

    // thumbnail
    NSString *imageUrlString = [feed objectForKey:@"imageUrl"];
    NSURL *imageUrl = [NSURL URLWithString:imageUrlString];
    [self.thumbnail ip_setImageWithURL:imageUrl];

    // title
    self.titleLabel.text = [feed objectForKey:@"title"];
//    self.titleLabel.textColor = ipPrimaryMidnightBlue;

    // posted date
    NSDate *createdAt = feed.createdAt;
    NSString *dateString = [Helper postedDate:createdAt];
    self.postedDateLabel.text = [NSString stringWithFormat:@"posted %@", dateString];
//    self.postedDateLabel.textColor = ipPrimaryMidnightBlue;

    // summary
    self.summaryLabel.text = [feed objectForKey:@"summary"];
//    self.summaryLabel.textColor = ipSecondaryGrey;

    self.bookmarkOnImgView.hidden = !self.isForBookmark;
    
    [self.ipSocailActionView setBookmarkNeeded:!self.isForBookmark isBookmarked:isBookmarked];
}

#pragma mark - IPSocialActionDelegate

- (void) onShareFeed {
   [self.feedCellHandler didShareFeed:self.feed];
}

- (void) onBookmarkFeed {
    [self.feedCellHandler didBookmarkFeed:self.feed];
}

@end
