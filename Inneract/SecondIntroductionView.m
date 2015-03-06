//
//  SecondIntroductionView.m
//  Inneract
//
//  Created by Jim Liu on 3/5/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "SecondIntroductionView.h"

@interface SecondIntroductionView()

@property (strong, nonatomic) IBOutlet SecondIntroductionView *contentView;


@end

@implementation SecondIntroductionView

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
    UINib *nib = [UINib nibWithNibName:@"FirstIntroductionView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
