//
//  IPWebViewController.h
//  Inneract
//
//  Created by Jim Liu on 3/20/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^IPWebviewCallback)(NSError *error);

@interface IPWebViewController : UIViewController

@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *rightItemTitle;
@property (nonatomic, strong) IPWebviewCallback callback;
@property (nonatomic, assign) BOOL didStartCallback;
@property (nonatomic, assign) BOOL didCompleteCallback;
@property (nonatomic, strong) NSString *warningMessageBeforeBack;

// For simple web view
- (instancetype) initWithUrl:(NSString *) url title:(NSString *) title;
// For form
- (instancetype) initWithUrl:(NSString *) url title:(NSString *) title callback:(IPWebviewCallback) block;

- (instancetype) initWithUrl:(NSString *) url title:(NSString *) title rightNavigationItem:(NSString *) rightItemTitle warningMessageBeforeBack:(NSString *) warningMessageBeforeBack callback:(IPWebviewCallback) block;

@end
