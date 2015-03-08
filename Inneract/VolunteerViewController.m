//
//  VolunteerViewController.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/7/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "VolunteerViewController.h"
#import <Parse/PFQuery.h>

@interface VolunteerViewController ()

@end

@implementation VolunteerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Volunteer";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Parse


- (void) filterQuery:(PFQuery *) query {
    [query whereKey:@"feedCategory"  equalTo:@"volunteer"];

}
@end
