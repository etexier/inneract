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
@property (nonatomic, strong) IPWebviewCallback callback;

// For simple web view
- (instancetype) initWithUrl:(NSString *) url title:(NSString *) title;
// For form
- (instancetype) initWithUrl:(NSString *) url title:(NSString *) title callback:(IPWebviewCallback) block;

@end
