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
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * 2, self.bounds.size.height - 100);
    
    UIWebView *first  = [[UIWebView alloc] initWithFrame:[self frameByIndex:0]];
    [first sizeToFit];
    [Helper embedVimeoVideoId:@"109561086" inView:first];
    UIWebView *second = [[UIWebView alloc] initWithFrame:[self frameByIndex:1]];
    [second sizeToFit];
    [Helper embedVimeoVideoId:@"109933873" inView:second];
    
    _panels = [NSMutableArray arrayWithCapacity:2];
    [_panels addObject:first];
    [_panels addObject:second];
    
    [self.scrollView addSubview:first];
    [self.scrollView addSubview:second];
    
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
    CGRect rect = self.bounds;
    return CGRectMake(rect.size.width * index, 0, rect.size.width, rect.size.height);
}


@end
