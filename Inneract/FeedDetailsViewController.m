//
//  FeedDetailsViewController.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "FeedDetailsViewController.h"
#import "Feed.h"

@interface FeedDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIView *topImageView;


@property (weak, nonatomic) IBOutlet UILabel *postedLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property (weak, nonatomic) IBOutlet UILabel *webLinkLabel;

@property (weak, nonatomic) IBOutlet UIImageView *shareImage;

@property (weak, nonatomic) IBOutlet UIImageView *bookmarkImage;



@end

@implementation FeedDetailsViewController

/*
feedCategory
imageUrl
link
renderingStyle
shareCount
bookmarkCount
title
createdAt
updatedAt
summary

*/


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (id)initWithFeed:(Feed *)feed {
    self = [super init];
    if (self) {
        self.feed = feed;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
