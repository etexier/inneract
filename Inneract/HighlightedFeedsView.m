//
//  HighlightedFeedsView.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/15/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "HighlightedFeedsView.h"
#import "Helper.h"
#import "IPColors.h"
#import "UIImageView+IP.h"

NSString *const kHighlightedFeedsViewId = @"HighlightedFeedsView";

@interface HighlightedFeedsView() <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property(nonatomic, strong) NSMutableArray *panels;

@end

@implementation HighlightedFeedsView



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

    UINib *nib = [UINib nibWithNibName:kHighlightedFeedsViewId bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];


    // init scrollView

    self.scrollView.delegate = self;
    CGRect main = [[UIScreen mainScreen] bounds];
    self.scrollView.contentSize = CGSizeMake(main.size.width * 2, self.bounds.size.height - 100);

    UIImageView *first = [[UIImageView alloc] initWithFrame:[self frameByIndex:0]];
    [first ip_setImageWithURL:[NSURL URLWithString:@"https://i.vimeocdn.com/video/494016254_1280.webp"]];
//    UIWebView *first  = [[UIWebView alloc] initWithFrame:[self frameByIndex:0]];
//    [first sizeToFit];
//    [Helper embedVimeoVideoId:@"109561086" inView:first];
    UIImageView *second = [[UIImageView alloc] initWithFrame:[self frameByIndex:1]];
    [second ip_setImageWithURL:[NSURL URLWithString:@"https://i.vimeocdn.com/video/493531925_640.webp"]];

//    UIWebView *second = [[UIWebView alloc] initWithFrame:[self frameByIndex:1]];
//    [second sizeToFit];
//    [Helper embedVimeoVideoId:@"109933873" inView:second];
    
    _panels = [NSMutableArray arrayWithCapacity:2];
    [_panels addObject:first];
    [_panels addObject:second];
    
    [self.scrollView addSubview:first];
    first.contentMode = UIViewContentModeScaleAspectFill;
    [self.scrollView addSubview:second];
    second.contentMode = UIViewContentModeScaleAspectFill;
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    [self.contentView addSubview:self.scrollView];

    // page control

    self.pageControl.currentPageIndicatorTintColor = ipPrimaryOrange;
    self.pageControl.tintColor = ipSecondaryGrey;
    
    [self.pageControl addTarget:self action:@selector(showVideoPane) forControlEvents:UIControlEventValueChanged];
    self.pageControl.numberOfPages = self.panels.count;
    [self.contentView addSubview:self.pageControl];
    
}

- (void)showVideoPane {
    [self.scrollView setContentOffset:CGPointMake(self.pageControl.currentPage * self.frame.size.width, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = (int) (floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1);
    if (page <= self.panels.count) {
        self.pageControl.currentPage = page;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

- (CGRect) frameByIndex:(NSInteger) index {
    CGRect main = [[UIScreen mainScreen] bounds];
    CGRect rect = self.bounds;
    return CGRectMake(main.size.width * index, 0, main.size.width, rect.size.height);
}


@end
