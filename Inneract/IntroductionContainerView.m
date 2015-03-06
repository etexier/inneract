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

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *panels; //UIView

@end

@implementation IntroductionContainerView

-(id) initWithCoder:(NSCoder *) coder {
    self = [super initWithCoder:coder];
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
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.scrollView.delegate = self;
    
    FirstIntroductionView *first = [[FirstIntroductionView alloc] init];
    SecondIntroductionView *second = [[SecondIntroductionView alloc] init];
    ThirdIntroductionView *third = [[ThirdIntroductionView alloc] init];
    
    _panels = [NSMutableArray arrayWithCapacity:3];
    [_panels addObject:first];
    [_panels addObject:second];
    [_panels addObject:third];
    
    [self.scrollView addSubview:first];
    [self.scrollView addSubview:second];
    [self.scrollView addSubview:third];
    
    self.scrollView.frame = self.bounds;
    
    [self makePanelVisibleAtIndex:0];
    //self.scrollView.contentSize = CGSizeMake(0, self.scrollView.frame.size.height);
    
    [self addSubview:self.scrollView];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
