//
//  FeedDetailsCell.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/18/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "FeedDetailsCell.h"
#import "Helper.h"
#import "IPSocialActionView.h"
#import "IPFeedDelegate.h"

@interface FeedDetailsCell()<IPSocialActionDelegate>


@property(weak, nonatomic) IBOutlet UILabel *postedLabel;

@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property(weak, nonatomic) IBOutlet UILabel *webLinkLabel;

@property (weak, nonatomic) IBOutlet UIView *socialActionView;

@property (weak, nonatomic) IBOutlet UIButton *onApplyButton;

@property (nonatomic, strong) IPSocialActionView *ipSocailActionView;
@property (weak, nonatomic) IBOutlet UIButton *onPayButton;


@end

@implementation FeedDetailsCell

- (void)awakeFromNib {
    // Initialization code

    [self setupGestureRecognizer];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userInteractionEnabled = YES;
    
    // set up social action view
    self.ipSocailActionView = [[IPSocialActionView alloc] initWithFrame:self.socialActionView.bounds];
    self.ipSocailActionView.delegate = self;
    [self.socialActionView addSubview:self.ipSocailActionView];

}

- (void)setupGestureRecognizer {
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

- (void)setData:(PFObject *)feed isBookmarked:(BOOL)isBookmarked isForBookmakr:(BOOL) isForBookmark {
    _feed = feed;
    _isBookmarked = isBookmarked;
    _isForBookmark = isForBookmark;
    
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

    if ([_feed objectForKey:@"paymentInfo"]) {
        self.onPayButton.hidden = NO;
    } else {
        self.onPayButton.hidden = YES;
    }
    
    [self.ipSocailActionView setBookmarkNeeded:!self.isForBookmark isBookmarked:isBookmarked];
}


#pragma mark - tap gesture

- (IBAction)onWebLinkTap:(UITapGestureRecognizer *)sender {
    [self.delegate didSelectReadFullStory:self.feed];
}

- (IBAction)onApply:(UIButton *)sender {
    NSLog(@"On Apply");
    if ([_feed objectForKey:@"rsvpUrl"]) {
        [self.delegate didRsvp:self.feed];

    } else if ([_feed objectForKey:@"registerUrl"]) {
        [self.delegate didRegister:self.feed];

    } else if ([_feed objectForKey:@"volunteerUrl"]) {
        [self.delegate didVolunteer:self.feed];
    }

}
- (IBAction)onPay:(UIButton *)sender {
    if ([_feed objectForKey:@"paymentInfo"]) {
        [self.delegate didPay:self.feed];
    }
}

#pragma mark - IPSocialActionDelegate

- (void) onShareFeed {
    [self.delegate didShareFeed:self.feed];
}

- (void) onBookmarkFeed {
    [self.delegate didBookmarkFeed:self.feed];
}


@end
