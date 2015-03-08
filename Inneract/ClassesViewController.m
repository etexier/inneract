//
//  ClassesViewController.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/7/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import <Parse/PFQuery.h>
#import "ClassesViewController.h"

@interface ClassesViewController ()

@end

@implementation ClassesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Classes";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)filterQuery:(PFQuery *)query {
    [query whereKey:@"feedCategory"  equalTo:@"classes"];
}
@end
