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
#import "IPColors.h"

@interface FeedDetailsCell()<IPSocialActionDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applyButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payButtonHeightConstraint;

@property(weak, nonatomic) IBOutlet UILabel *postedLabel;

@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property(weak, nonatomic) IBOutlet UILabel *webLinkLabel;

@property (weak, nonatomic) IBOutlet UIView *socialActionView;

@property (weak, nonatomic) IBOutlet UIButton *onApplyButton;
@property (weak, nonatomic) IBOutlet UILabel *alreadyAppliedLabel;


@property (nonatomic, strong) IPSocialActionView *ipSocailActionView;

@end

@implementation FeedDetailsCell

- (void)awakeFromNib {
    // Initialization code

    self.onApplyButton.hidden = YES;
    self.alreadyAppliedLabel.hidden = YES;
    
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

- (void)setData:(PFObject *)feed isBookmarked:(BOOL)isBookmarked isForBookmakr:(BOOL) isForBookmark feedActivity:(PFObject *)feedActivity{
    _feed = feed;
    _isBookmarked = isBookmarked;
    _isForBookmark = isForBookmark;
    _feedActivity = feedActivity;
    
    // title
    self.titleLabel.text = [feed objectForKey:@"title"];
    [self.titleLabel sizeToFit];
    
    
    // posted date
    NSDate *createdAt = feed.createdAt;
    NSString *dateString = [Helper postedDate:createdAt];
    
    self.postedLabel.text = [NSString stringWithFormat:@"posted %@", dateString];
    
    // summary
    self.summaryLabel.text = [_feed objectForKey:@"summary"];
    [self.ipSocailActionView setBookmarkNeeded:!self.isForBookmark isBookmarked:isBookmarked];
    
    [self setupApplyButton];
}

- (void) setupApplyButton {
    self.alreadyAppliedLabel.backgroundColor = ipSecondaryLightGrey;
    
    if ([_feed objectForKey:@"rsvpUrl"]) {
        if(!self.feedActivity) {
            [self.onApplyButton setTitle:@"RSVP" forState:UIControlStateNormal];
            self.onApplyButton.hidden = NO;
            self.alreadyAppliedLabel.hidden = YES;
        } else {
            self.onApplyButton.hidden = YES;
            self.alreadyAppliedLabel.hidden = NO;
            self.alreadyAppliedLabel.text = [NSString stringWithFormat:@"You reserved on %@", [Helper postedDate:self.feedActivity.createdAt]];
        }
    } else if ([_feed objectForKey:@"registerUrl"]) {
        if(!self.feedActivity) {
            [self.onApplyButton setTitle:@"Register" forState:UIControlStateNormal];
            self.onApplyButton.hidden = NO;
            self.alreadyAppliedLabel.hidden = YES;
        } else {
            self.onApplyButton.hidden = YES;
            self.alreadyAppliedLabel.hidden = NO;
            self.alreadyAppliedLabel.text = [NSString stringWithFormat:@"You registered on %@", [Helper postedDate:self.feedActivity.createdAt]];
        }
    } else if ([_feed objectForKey:@"volunteerUrl"]) {
        if(!self.feedActivity) {
            [self.onApplyButton setTitle:@"Volunteer" forState:UIControlStateNormal];
            self.onApplyButton.hidden = NO;
            self.alreadyAppliedLabel.hidden = YES;
        } else {
            self.onApplyButton.hidden = YES;
            self.alreadyAppliedLabel.hidden = NO;
            self.alreadyAppliedLabel.text = [NSString stringWithFormat:@"You volunteered on %@", [Helper postedDate:self.feedActivity.createdAt]];
        }
    } else {
        self.onApplyButton.hidden = YES;
        self.applyButtonHeightConstraint.constant = 0;
        
        self.alreadyAppliedLabel.hidden = YES;
    }
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

#pragma mark - IPSocialActionDelegate

- (void) onShareFeed {
    [self.delegate didShareFeed:self.feed];
}

- (void) onBookmarkFeed {
    [self.delegate didBookmarkFeed:self.feed];
}


@end
