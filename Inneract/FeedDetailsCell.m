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

@property (weak, nonatomic) IBOutlet UIButton *onApplyButton;


@end

@implementation FeedDetailsCell

- (void)awakeFromNib {
    // Initialization code

    [self setupGestureRecognizer];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userInteractionEnabled = YES;

}

- (void)setupGestureRecognizer {
    self.shareImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *shareTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onShareTap:)];
    [shareTap setNumberOfTapsRequired:1];
    [shareTap setNumberOfTouchesRequired:1];
    [self.shareImage addGestureRecognizer:shareTap];


    self.bookmarkImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *bookmarkTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBookmarkTap:)];
    [bookmarkTap setNumberOfTapsRequired:1];
    [bookmarkTap setNumberOfTouchesRequired:1];
    [self.bookmarkImage addGestureRecognizer:bookmarkTap];


    self.webLinkLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *webLinkTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onWebLinkTap:)];
    [webLinkTap setNumberOfTapsRequired:1];
    [webLinkTap setNumberOfTouchesRequired:1];
    [self.webLinkLabel addGestureRecognizer:webLinkTap];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFeed:(PFObject *)feed {
    
    _feed = feed;
    // title
    self.titleLabel.text = [feed objectForKey:@"title"];
    
    
    // posted date
    NSDate *createdAt = feed.createdAt;
    NSString *dateString = [Helper postedDate:createdAt];
    
    self.postedLabel.text = [NSString stringWithFormat:@"posted %@", dateString];
    
    // summary
    self.summaryLabel.text = [_feed objectForKey:@"summary"];

    if ([_feed objectForKey:@"rsvpUrl"]) {
        [self.onApplyButton setTitle:@"RSVP" forState:UIControlStateNormal];

    } else if ([_feed objectForKey:@"registerUrl"]) {
        [self.onApplyButton setTitle:@"Register" forState:UIControlStateNormal];

    } else if ([_feed objectForKey:@"volunteerUrl"]) {
        [self.onApplyButton setTitle:@"Volunteer" forState:UIControlStateNormal];
    } else {
        self.onApplyButton.hidden = YES;
    }



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

- (IBAction)onApply:(UIButton *)sender {
    NSLog(@"On Apply");
    if ([_feed objectForKey:@"rsvpUrl"]) {
        [self.delegate didRsvp:self];

    } else if ([_feed objectForKey:@"registerUrl"]) {
        [self.delegate didRegister:self];

    } else if ([_feed objectForKey:@"volunteerUrl"]) {
        [self.delegate didVolunteer:self];
    }

}


@end
