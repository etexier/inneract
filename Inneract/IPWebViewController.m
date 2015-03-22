//
//  IPWebViewController.m
//  Inneract
//
//  Created by Jim Liu on 3/20/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "IPWebViewController.h"

#define CocoaJSHandler  @"mpAjaxHandler"

static NSString *JSHandler;

@interface FormURLProtocol : NSURLProtocol

@end

@implementation FormURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    //return [request.URL.host isEqualToString:@"localhost"];
    NSLog(@"canInitWithRequest : %@", [request URL]);
    return YES;
}

+ (NSURLRequest *) canonicalRequestForRequest:(NSURLRequest *)request {
    NSLog(@"canonicalRequestForRequest : %@", [request URL]);
    return request;
}

- (void) startLoading {
    NSLog(@"startLoading");
}

- (void)stopLoading {
    NSLog(@"stopLoading");
}

@end

@interface IPWebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation IPWebViewController

- (instancetype) initWithUrl:(NSString *) url title:(NSString *) title {
   return [self initWithUrl:url title:title callback:nil];
}

- (instancetype) initWithUrl:(NSString *) url title:(NSString *) title callback:(IPWebviewCallback) block {
    self = [super init];
    if(self) {
        _urlStr = url;
        self.title = title;
        _callback = block;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if(self.callback) {
        //FIXME
        //[NSURLProtocol registerClass:[FormURLProtocol class]];
    }

    JSHandler = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"ajax_handler" withExtension:@"js"] encoding:NSUTF8StringEncoding error:nil];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"backArrowIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(didBack:)];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.webView.scalesPageToFit = YES;

    if(self.callback) {
        self.webView.delegate = self;
    }

    [self.webView loadRequest:urlRequest];
}

- (void)viewDidUnload {
    if(self.callback) {
        [NSURLProtocol unregisterClass:[FormURLProtocol class]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebView delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"webView shouldStartLoadWithRequest %@, navigationType : %lu", request, navigationType);

    if ([[[request URL] scheme] isEqual:CocoaJSHandler]) {
        NSString *requestedURLString = [[[request URL] absoluteString] substringFromIndex:[CocoaJSHandler length] + 3];

        NSLog(@"ajax request: %@", requestedURLString);
        return YES;
    }
    
    if([[[request URL] absoluteString] isEqualToString:self.urlStr]) {
        if(self.callback) {
            [webView stringByEvaluatingJavaScriptFromString:JSHandler];
        }
    }

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"didFailLoadWithError : %@", error);
}


#pragma mark - private methods

- (void) didBack:(id) sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end