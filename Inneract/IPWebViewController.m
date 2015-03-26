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

//@interface FormURLProtocol : NSURLProtocol
//
//@end
//
//@implementation FormURLProtocol
//
//+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
//    //return [request.URL.host isEqualToString:@"localhost"];
//    NSLog(@"canInitWithRequest : %@", [request URL]);
//    return YES;
//}
//
//+ (NSURLRequest *) canonicalRequestForRequest:(NSURLRequest *)request {
//    NSLog(@"canonicalRequestForRequest : %@", [request URL]);
//    return request;
//}
//
//- (void) startLoading {
//    NSLog(@"startLoading");
//}
//
//- (void)stopLoading {
//    NSLog(@"stopLoading");
//}
//
//@end

@interface IPWebViewController () <UIWebViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation IPWebViewController

- (instancetype) initWithUrl:(NSString *) url title:(NSString *) title {
    return [self initWithUrl:url title:title rightNavigationItem:nil warningMessageBeforeBack:nil callback:nil];
}

- (instancetype) initWithUrl:(NSString *) url title:(NSString *) title callback:(IPWebviewCallback) block {
    return [self initWithUrl:url title:title rightNavigationItem:nil warningMessageBeforeBack:nil callback:block];
}

- (instancetype) initWithUrl:(NSString *) url title:(NSString *) title rightNavigationItem:(NSString *) rightItemTitle warningMessageBeforeBack:(NSString *) warningMessageBeforeBack callback:(IPWebviewCallback) block {
    self = [super init];
    if(self) {
        _urlStr = url;
        self.title = title;
        _callback = block;
        _rightItemTitle = rightItemTitle;
        _warningMessageBeforeBack = warningMessageBeforeBack;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if(self.rightItemTitle) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.rightItemTitle style:UIBarButtonItemStylePlain target:self action:@selector(onRightBarItem:)];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIImageRenderingModeAlwaysOriginal target:self action:@selector(didBack:)];
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"backArrowIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(didBack:)];
    }
    
    if(self.callback) {
        //FIXME
        //[NSURLProtocol registerClass:[FormURLProtocol class]];
    }

    //JSHandler = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"ajax_handler" withExtension:@"js"] encoding:NSUTF8StringEncoding error:nil];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.webView.scalesPageToFit = YES;

//    if(self.callback) {
//        self.webView.delegate = self;
//    }

    [self.webView loadRequest:urlRequest];
}

- (void)viewDidUnload {
//    if(self.callback) {
//        [NSURLProtocol unregisterClass:[FormURLProtocol class]];
//    }
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
//        if(self.callback) {
//            [webView stringByEvaluatingJavaScriptFromString:JSHandler];
//        }
    }

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad");
    if(self.callback) {
        [webView stringByEvaluatingJavaScriptFromString:JSHandler];
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"webViewDidFinishLoad");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"didFailLoadWithError : %@", error);
}


#pragma mark - private methods

- (void) didBack:(id) sender {
    if(self.warningMessageBeforeBack) {
            if(!self.didCompleteCallback) {
        [[[UIAlertView alloc] initWithTitle:@"Warning"
                                                           message:self.warningMessageBeforeBack
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"OK", nil] show];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) onRightBarItem:(id) sender {
    if(self.callback) {
        self.didStartCallback = YES;
        
        self.callback(nil);
        
        if(self.didCompleteCallback) {
           [self.navigationController popViewControllerAnimated:YES]; 
        }
    }
}

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"The %@ button was tapped.", [theAlert buttonTitleAtIndex:buttonIndex]);
    if(buttonIndex == 1) { // OK
        [self onRightBarItem:nil];
    } else { // cancel
        [self.navigationController popViewControllerAnimated:YES];
    }
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
