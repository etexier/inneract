//
//  IPSocialActionView.m
//  Inneract
//
//  Created by Jim Liu on 3/22/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "IPSocialActionView.h"

NSString * const kNibName = @"IPSocialActionView";

@interface IPSocialActionView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *bookmarkButton;

- (IBAction)onShareButton:(id)sender;
- (IBAction)onBookmarkButton:(id)sender;

@end

@implementation IPSocialActionView

-(id) initWithCoder:(NSCoder *) coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

-(id) init {
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
    
}

-(void) initSubViews {
    UINib *nib = [UINib nibWithNibName:kNibName bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    
    [self.shareButton setImage: [[UIImage imageNamed:@"shareYellowButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.shareButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0 , 0)];
    [self.shareButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
    
    [self.bookmarkButton setImage: [[UIImage imageNamed:@"bookmarkGreenButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.bookmarkButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0 , 0)];
    [self.bookmarkButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.bookmarkButton setTitle:@"Bookmark" forState:UIControlStateNormal];
}

- (void) setBookmarkNeeded:(BOOL) isBookmarkNeeded isBookmarked:(BOOL) isBookmarked {
    _isBookmarked = isBookmarked;
    _isBookmarkNeeded = isBookmarkNeeded;
    
    if(!isBookmarkNeeded) {
        self.bookmarkButton.hidden = YES;
    } else {
        UIImage *image = [UIImage imageNamed:(isBookmarked ? @"bookmarkGrayButton" : @"bookmarkGreenButton")];
        self.bookmarkButton.enabled = !isBookmarked;
        [self.bookmarkButton setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)onShareButton:(id)sender {
    NSLog(@"onShareButton");
    [self.delegate onShareFeed];
}

- (IBAction)onBookmarkButton:(id)sender {
    NSLog(@"onBookmarkButton");
    [self.delegate onBookmarkFeed];
    [self.bookmarkButton setImage: [[UIImage imageNamed:@"bookmarkGrayButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.bookmarkButton.enabled = false;
}
@end
