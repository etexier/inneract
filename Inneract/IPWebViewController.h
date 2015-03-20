//
//  IPWebViewController.h
//  Inneract
//
//  Created by Jim Liu on 3/20/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPWebViewController : UIViewController

@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) NSString *title;

- (instancetype) initWithUrl:(NSString *) url title:(NSString *) title;

@end
