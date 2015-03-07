//
//  IntroductionContainerView.m
//  Inneract
//
//  Created by Jim Liu on 3/5/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "IntroductionContainerView.h"
#import "FirstIntroductionView.h"
#import "SecondIntroductionView.h"
#import "ThirdIntroductionView.h"



@interface IntroductionContainerView()
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *panels; //UIView

@end

@implementation IntroductionContainerView {
    NSInteger _lastPanelIndex;
    NSInteger _currentPanelIndex;
}

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
    UINib *nib = [UINib nibWithNibName:@"IntroductionContainerView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    
    FirstIntroductionView *first = [[FirstIntroductionView alloc] initWithFrame:[self frameByIndex:0]];
    SecondIntroductionView *second = [[SecondIntroductionView alloc] initWithFrame:[self frameByIndex:1]];
    ThirdIntroductionView *third = [[ThirdIntroductionView alloc] initWithFrame:[self frameByIndex:2]];
    
    _panels = [NSMutableArray arrayWithCapacity:3];
    [_panels addObject:first];
    [_panels addObject:second];
    [_panels addObject:third];
    
    [self.scrollView addSubview:first];
    [self.scrollView addSubview:second];
    [self.scrollView addSubview:third];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    //self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 4, [UIScreen mainScreen].bounds.size.height);
    //self.scrollView.frame = self.bounds;
    
    //self.scrollView.contentSize = CGSizeMake(0, self.scrollView.frame.size.height);
    
    [self.contentView addSubview:self.scrollView];
    
    //self.PageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, (self.scrollView.frame.origin.y + self.scrollView.frame.size.height - 60), self.frame.size.width, 36)];
    //[self.pageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.pageControl addTarget:self action:@selector(showPanelAtPageControl) forControlEvents:UIControlEventValueChanged];
    self.pageControl.numberOfPages = self.panels.count;
    [self.contentView addSubview:self.pageControl];
    
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    
    [self makePanelVisibleAtIndex:0];
}

-(void)makePanelVisibleAtIndex:(NSInteger)panelIndex{
//    NSLog(@"Making %lu page visible", panelIndex);
//    [UIView animateWithDuration:0.3 animations:^{
//        for (int i = 0; i < self.panels.count; i++) {
//            UIView *page = self.panels[i];
//            if (i == panelIndex) {
//                page.alpha = 1;
//            } else {
//                page.alpha = 0;
//            }
//            NSLog(@"Page %d is %@", i, page);
//        }
//    }];
}

-(void)showPanelAtPageControl {
    //Format and show new content
    //[self setContentScrollViewHeightForPanelIndex:self.CurrentPanelIndex animated:YES];
    [self makePanelVisibleAtIndex:self.pageControl.currentPage];
    
    [self.scrollView setContentOffset:CGPointMake(self.pageControl.currentPage * [[UIScreen mainScreen] bounds].size.width, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if(page <= self.panels.count) {
        self.pageControl.currentPage = page;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //Update Page Control
    //Format and show new content
    [self makePanelVisibleAtIndex:self.pageControl.currentPage];
}

- (CGRect) frameByIndex:(NSInteger) index {
    CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];
    return CGRectMake(mainScreenBounds.size.width * index, 0, mainScreenBounds.size.width, mainScreenBounds.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
