//
//  FeedCell.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/6/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "FeedCell.h"
#import "UIImageView+AFNetworking.h"
#import "Helper.h"
#import "IPColors.h"


@interface FeedCell()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *postedDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shareImage;
@property (weak, nonatomic) IBOutlet UIImageView *bookmarkImage;
@property (weak, nonatomic) IBOutlet UILabel *bookMarkLabel;

@property (weak, nonatomic) IBOutlet UIImageView *mediaImage;
@end
@implementation FeedCell



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)awakeFromNib {

    // round image
    self.thumbnail.layer.cornerRadius = 5; // self.thumbnail.frame.size.width / 2.0f;
    self.thumbnail.clipsToBounds = YES;
    // for performance
    self.thumbnail.layer.shouldRasterize = YES;
    self.thumbnail.layer.rasterizationScale = [[UIScreen mainScreen] scale];

//    [self prepareForReuse];

}

//- (void)prepareForReuse {
//    self.thumbnail.image = nil;
//    self.mediaImage.image = nil;
//
//    self.titleLabel.text = nil;
////    self.postedDateLabel = nil;
//    self.summaryLabel.text = nil;
//
//}




- (void)setFeed:(PFObject *)feed {
    _feed = feed;
    
    // thumbnail
    NSString *imageUrlString = [feed objectForKey:@"imageUrl"];
    NSURL *imageUrl = [NSURL URLWithString:imageUrlString];
    [self.thumbnail setImageWithURL:imageUrl];


    // title
    self.titleLabel.text = [feed objectForKey:@"title"];
    self.titleLabel.textColor = ipPrimaryMidnightBlue;

    // posted date
    NSDate *createdAt = feed.createdAt;
    NSString *dateString = [Helper postedDate:createdAt];
    self.postedDateLabel.text = [NSString stringWithFormat:@"posted %@", dateString];
    self.postedDateLabel.textColor = ipPrimaryMidnightBlue;

    // summary
    self.summaryLabel.text = [feed objectForKey:@"summary"];
    self.summaryLabel.textColor = ipSecondaryGrey;

    // bookmark
    if(!self.isForBookmark) {
        self.bookmarkImage.image = [UIImage imageNamed:@"label36"];
        UITapGestureRecognizer *bookmarkTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didBookmark:)];
        [self.bookmarkImage addGestureRecognizer:bookmarkTap];
    } else {
        self.bookmarkImage.hidden = YES;
        self.bookMarkLabel.hidden = YES;
    }

    self.bookmarkImage.tintColor = ipSecondaryCyan;

    // share
    self.shareImage.image = [UIImage imageNamed:@"share27"];
    self.shareImage.tintColor = ipPrimaryOrange;
    
    UITapGestureRecognizer *shareTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didShare:)];
    [self.shareImage addGestureRecognizer:shareTap];



}

- (IBAction)didShare:(id)sender {
    [self.feedCellHandler feedCell:self didShareFeed:self.feed];
}

- (IBAction)didBookmark:(id)sender {
    [self.feedCellHandler feedCell:self didBookmarkFeed:self.feed];
}


@end
