//
//  FeedCell.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/6/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "FeedCell.h"
#import "Feed.h"

@interface FeedCell()

@property (weak, nonatomic) Feed *feed;
@end
@implementation FeedCell



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
