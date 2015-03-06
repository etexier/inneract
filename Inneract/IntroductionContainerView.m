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
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    //self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.scrollView.delegate = self;
    
    FirstIntroductionView *first = [[FirstIntroductionView alloc] initWithFrame:self.frame];
    SecondIntroductionView *second = [[SecondIntroductionView alloc] init];
    ThirdIntroductionView *third = [[ThirdIntroductionView alloc] init];
    
    _panels = [NSMutableArray arrayWithCapacity:3];
    [_panels addObject:first];
    [_panels addObject:second];
    [_panels addObject:third];
    
    [self.scrollView addSubview:first];
    [self.scrollView addSubview:second];
    [self.scrollView addSubview:third];
    
    //self.scrollView.frame = self.bounds;
    
    [self makePanelVisibleAtIndex:0];
    //self.scrollView.contentSize = CGSizeMake(0, self.scrollView.frame.size.height);
    
    [self.contentView addSubview:self.scrollView];
    
    //self.PageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, (self.scrollView.frame.origin.y + self.scrollView.frame.size.height - 60), self.frame.size.width, 36)];
    //[self.pageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [self.pageControl addTarget:self action:@selector(showPanelAtPageControl) forControlEvents:UIControlEventValueChanged];
    
    self.pageControl.numberOfPages = self.panels.count;
    [self.contentView addSubview:self.pageControl];
    
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
}

-(void)makePanelVisibleAtIndex:(NSInteger)panelIndex{
    [UIView animateWithDuration:0.3 animations:^{
        for (int i = 0; i < self.panels.count; i++) {
            if (i == panelIndex) {
                [self.panels[i] setAlpha:1];
            }
            else {
                [self.panels[i] setAlpha:0];
            }
        }
    }];
}

-(void)showPanelAtPageControl {
    
    _lastPanelIndex = self.pageControl.currentPage;
    _currentPanelIndex = self.pageControl.currentPage;
    
    //Format and show new content
    //[self setContentScrollViewHeightForPanelIndex:self.CurrentPanelIndex animated:YES];
    [self makePanelVisibleAtIndex:_currentPanelIndex];
    
    [self.scrollView setContentOffset:CGPointMake(_currentPanelIndex * 320, 0) animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
