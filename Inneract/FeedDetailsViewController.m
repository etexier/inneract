//
//  FeedDetailsViewController.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "UIImageView+IP.h"
#import "FeedDetailsHeaderView.h"
#import "FeedDetailsViewController.h"
#import "FeedDetailsCell.h"
#import "VimeoController.h"
#import "VimeoVideoConfigResult.h"
#import "Request.h"
#import "Files.h"
#import "H264.h"
#import "Sd.h"
#import "IPEventTracker.h"

#import <MediaPlayer/MediaPlayer.h>


NSString *const kFeedDetailsCellNibId = @"FeedDetailsCell";

@interface FeedDetailsViewController () <UITableViewDataSource, UITableViewDelegate, FeedDetailsHeaderViewDelegate, FeedDetailsCellDelegate, UIWebViewDelegate>
@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FeedDetailsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 320;

    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:kFeedDetailsCellNibId bundle:nil] forCellReuseIdentifier:kFeedDetailsCellNibId];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"backArrowIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(didBack:)];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self setupHeaderView];

}

- (void)setupHeaderView {
    // header view: thumbnail image (mostly)
    CGRect headerFrame = CGRectMake(0, 0, self.tableView.bounds.size.width, 230.0);
    FeedDetailsHeaderView *headerView = [[FeedDetailsHeaderView alloc] initWithFrame:headerFrame];
    headerView.feed = self.feed;
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;

}


- (void)didBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedDetailsCell *cell = (FeedDetailsCell *) [tableView dequeueReusableCellWithIdentifier:kFeedDetailsCellNibId forIndexPath:indexPath];
    cell.feed = self.feed;
    cell.delegate = self;
    return cell;
}

#pragma FeedDetailsHeaderViewDelegate

- (void)didTapOnHeaderView:(FeedDetailsHeaderView *)headerView {
    if (!headerView.videoUrl) {
        return;
    }
    NSLog(@"Tap on top image : will play %@", headerView.videoUrl);
    VimeoController *controller = [[VimeoController alloc] init];
    NSString *videoId = [headerView.videoUrl lastPathComponent];
    [controller getVimeoVideoConfig:videoId success:^(VimeoVideoConfigResult *response) {
        //        NSString *movieUrlString = response.request.files.h264.hd.url; // hd may be slow to download
        NSString *movieUrlString = response.request.files.h264.sd.url;
        NSURL *movieURL = [NSURL URLWithString:movieUrlString];
        NSLog(@"Playing video at URL: %@", movieURL);
        MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
        [self presentMoviePlayerViewControllerAnimated:movieController];
        [movieController.moviePlayer play];

        // code
    }                       failure:^(NSError *error) {
        NSLog(@"Couldn't open video url");
    }];
}

#pragma FeedDetailsCellDelegate

- (void)didSelectReadFullStory:(FeedDetailsCell *)cell {
    NSLog(@"Did select full story");
    NSString *urlAddress = [cell.feed objectForKey:@"link"];
    NSURL *url = [NSURL URLWithString:urlAddress];

    [self openWebLink:url];

}

- (void)didBookmark:(FeedDetailsCell *)cell {
    NSLog(@"Did Bookmark feed"); // TODO
}

- (void)didShare:(FeedDetailsCell *)cell {
    NSLog(@"Did share feed"); // TODO

}

- (void)didRsvp:(FeedDetailsCell *)cell {
    NSLog(@"Did rsvp feed");
    NSString *urlAddress = [cell.feed objectForKey:@"rsvpUrl"];
    NSURL *url = [NSURL URLWithString:urlAddress];
    [self openWebLink:url];

    [[IPEventTracker sharedInstance] onRsvpEvent:self.feed];
}

- (void)didRegister:(FeedDetailsCell *)cell {
    NSLog(@"Did register feed");
    NSString *urlAddress = [cell.feed objectForKey:@"registerUrl"];
    NSURL *url = [NSURL URLWithString:urlAddress];
    [self openWebLink:url];

    [[IPEventTracker sharedInstance] onRegisterClass:self.feed];
}

- (void)didVolunteer:(FeedDetailsCell *)cell {
    NSString *urlAddress = [cell.feed objectForKey:@"volunteerUrl"];
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSLog(@"Did volunteer feed");
    [self openWebLink:url];

    [[IPEventTracker sharedInstance] onVolunteerEvent:self.feed];
}


- (void)openWebLink:(NSURL *)url {

    NSLog(@"opening web link: %@", url);
    UIViewController *webViewController = [[UIViewController alloc] init];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    UIWebView *uiWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    uiWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    uiWebView.scalesPageToFit = YES;
    uiWebView.delegate = self;

    [uiWebView loadRequest:urlRequest];

    [webViewController.view addSubview:uiWebView];

    [self.navigationController pushViewController:webViewController animated:YES];

    [[IPEventTracker sharedInstance] onReadFeed:self.feed];
}

#pragma mark - UIWebView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"webView shouldStartLoadWithRequest %@, navigationType : %lu", request, navigationType);
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"didFailLoadWithError");
}


@end
