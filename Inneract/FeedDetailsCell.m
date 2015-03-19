//
//  FeedDetailsCell.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/18/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "FeedDetailsCell.h"
#import "Helper.h"

@interface FeedDetailsCell()


@property(weak, nonatomic) IBOutlet UILabel *postedLabel;

@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property(weak, nonatomic) IBOutlet UILabel *webLinkLabel;

@property(weak, nonatomic) IBOutlet UIImageView *shareImage;

@property(weak, nonatomic) IBOutlet UIImageView *bookmarkImage;



@end

@implementation FeedDetailsCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFeed:(PFObject *)feed {
    
    
    // title
    self.titleLabel.text = [feed objectForKey:@"title"];
    
    
    // posted date
    NSDate *createdAt = feed.createdAt;
    NSString *dateString = [Helper postedDate:createdAt];
    
    self.postedLabel.text = [NSString stringWithFormat:@"posted %@", dateString];
    
    // summary
    self.summaryLabel.text = [feed objectForKey:@"summary"];
    
    
}


#pragma mark - tap gesture
- (IBAction)onShareTap:(UITapGestureRecognizer *)sender {
    [self.delegate didShare:self];
}

- (IBAction)onBookmarkTap:(UITapGestureRecognizer *)sender {
    [self.delegate didBookmark:self];
}

- (IBAction)onWebLinkTap:(UITapGestureRecognizer *)sender {
    [self.delegate didSelectReadFullStory:self];
}



@end
