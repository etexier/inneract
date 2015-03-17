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
    
}

- (void) setFeeds:(NSArray *)feeds {
    // init scrollView
    
    self.scrollView.delegate = self;
    CGRect main = [[UIScreen mainScreen] bounds];

    // tap gesture recognizer
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];

    _panels = [NSMutableArray arrayWithCapacity:feeds.count];
    self.scrollView.contentSize = CGSizeMake(main.size.width * feeds.count, self.bounds.size.height - 100);
    for (int i = 0; i < feeds.count; i++) {
        UIImageView *v = [[UIImageView alloc] initWithFrame:[self frameByIndex:i]];
        NSString *urlString = feeds[i][@"imageUrl"];
        [v ip_setImageWithURL:[NSURL URLWithString:urlString]];
        [_panels addObject:v];
        [self.scrollView addSubview:v];
        v.contentMode = UIViewContentModeScaleAspectFill;
        [v addGestureRecognizer:singleTap];
        v.userInteractionEnabled = YES;
        _feeds = feeds;
        
    }
    
    
    // scrollview setup
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

- (void)oneTap:(UIGestureRecognizer *)gesture {
    NSLog(@"Tapped on %ld", self.pageControl.currentPage);
    [self.delegate onHeaderTap:self.feeds[self.pageControl.currentPage ? 0: self.pageControl.currentPage]];
}

@end
