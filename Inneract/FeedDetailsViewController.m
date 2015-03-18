//
//  FeedDetailsViewController.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "UIImageView+IP.h"
#import "FeedDetailsViewController.h"
#import <Parse/PFObject.h>
#import "Helper.h"
#import "IPColors.h"
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface FeedDetailsViewController ()
@property(weak, nonatomic) IBOutlet UIView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;

@property(weak, nonatomic) IBOutlet UIImageView *nestedImageView;

@property(weak, nonatomic) IBOutlet UILabel *postedLabel;

@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property(weak, nonatomic) IBOutlet UILabel *webLinkLabel;

@property(weak, nonatomic) IBOutlet UIImageView *shareImage;

@property(weak, nonatomic) IBOutlet UIImageView *bookmarkImage;

@property(strong, nonatomic) NSURL *videoUrl;


@end

@implementation FeedDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initLayoutFromFeed:self.feed];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"backArrowIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(didBack:)];
    //[[UINavigationBar appearance] setBackIndicatorImage:[[UIImage imageNamed:@"backArrowIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //[[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[[UIImage imageNamed:@"backArrowIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}

- (id)initWithFeed:(PFObject *)feed {
    self = [super init];
    if (self) {
        _feed = feed;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initLayoutFromFeed:(PFObject *)feed {

    // thumbnail
    NSString *imageUrlString = [feed objectForKey:@"imageUrl"];
    NSURL *imageUrl = [NSURL URLWithString:imageUrlString];
    [self.nestedImageView ip_setImageWithURL:imageUrl];


    // title
    self.titleLabel.text = [feed objectForKey:@"title"];
//    self.titleLabel.textColor = ipPrimaryMidnightBlue;


    // posted date
    NSDate *createdAt = feed.createdAt;
    NSString *dateString = [Helper postedDate:createdAt];

    self.postedLabel.text = [NSString stringWithFormat:@"posted %@", dateString];
//    self.postedLabel.textColor = ipPrimaryMidnightBlue;

    // summary
    self.summaryLabel.text = [feed objectForKey:@"summary"];
    self.summaryLabel.textColor = ipSecondaryGrey;

    // bookmark
    self.bookmarkImage.image = [UIImage imageNamed:@"bookmarkGreenButton"];

    // share
    self.shareImage.image = [UIImage imageNamed:@"shareYellowButton"];

    // play image
    NSString *url = [self.feed objectForKey:@"videoUrl"];
    if (nil != url) {
        self.videoUrl = [NSURL URLWithString:url];
    } else {
//        self.videoUrl = nil;
        self.playImageView.hidden = YES;
    }
    
    // web link
//    self.webLinkLabel.textColor = ipPrimaryMidnightBlue;
    // tap registered in IB

}

#pragma mark - tap gesture
- (IBAction)onTopImageViewTap:(id)sender {
    NSLog(@"Tap on top image : if any media link, will display it (%@)", self.videoUrl);
//    UIWebView *v  = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    [v sizeToFit];
//    [Helper embedVimeoVideoId:@"109561086" inView:v];
//    [self.view addSubview:v];

    NSURL *movieURL = self.videoUrl;
    MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
    [self presentMoviePlayerViewControllerAnimated:movieController];
    [movieController.moviePlayer play];


}

- (IBAction)onWebLinkTap:(UITapGestureRecognizer *)sender {
    UIViewController *webViewController = [[UIViewController alloc] init];


    NSString *urlAddress = [self.feed objectForKey:@"link"];
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSLog(@"opening web link: %@", url);
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    UIWebView *uiWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    uiWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    uiWebView.scalesPageToFit = YES;

    [uiWebView loadRequest:urlRequest];

    [webViewController.view addSubview:uiWebView];

    [self.navigationController
            pushViewController:webViewController animated:YES];
}

- (void)didBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
