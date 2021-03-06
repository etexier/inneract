//
//  ProfileDetailsViewController.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "ProfileDetailsViewController.h"
#import "EditProfileViewController.h"
#import "IPColors.h"
#import "UIImageView+AFNetworking.h"
#import "MainViewHelper.h"
#import "BasicInfoCell.h"
#import "BadgesCell.h"
#import "ProfileDelegate.h"
#import "ActivityCell.h"
#import "IPEventTracker.h"
#import "IPConstants.h"
#import "IPWebViewController.h"
#import <Parse/PFQuery.h>
#import <FBSession.h>

NSString * const kBasicInfoCell = @"BasicInfoCell";
NSString * const kBadgeCell = @"BadgesCell";
NSString * const kActivityCell = @"ActivityCell";

@interface ProfileDetailsViewController () <UITableViewDataSource, UITableViewDelegate, ProfileDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) BOOL fromAccountCreation;
@property (nonatomic, assign) BOOL isSelfProfile;

- (IBAction)onLogout:(id)sender;

@property (nonatomic, strong, readonly) NSArray *sectionCells;
//@property (nonatomic, strong) NSArray *activities;

@property (nonatomic, strong) UIRefreshControl *refreshController;

@end

@implementation ProfileDetailsViewController

- (instancetype)initWithUser:(PFObject *)user {
    return [self initWithUser:user fromAccountCreation:NO];
}

- (instancetype)initWithUser:(PFObject *)user fromAccountCreation:(BOOL) fromAccountCreation{
	self = [super init];
	if (self) {
		self.fromAccountCreation = fromAccountCreation;
		if(user) {
			_user = user;
            self.title = [self getUserName];
            _isSelfProfile = [[user valueForKey:@"username"] isEqualToString:[[PFUser currentUser] valueForKey:@"username"]];
		} else {
			_isSelfProfile = YES;
            _isMyProfileView = YES;
            [self fetchUser];
		}
	}
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
    _sectionCells = @[kBasicInfoCell, kBadgeCell, kActivityCell];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150;
    
    for(NSString *cellname in self.sectionCells) {
        [self.tableView registerNib:[UINib nibWithNibName:cellname bundle:nil] forCellReuseIdentifier:cellname];
    }
    
    if(!self.isMyProfileView) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"backArrowIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(didBack:)];
    }
	
    if(self.isSelfProfile) {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout:)];
    }
    
    if(self.fromAccountCreation){
        //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit Profile" style:UIBarButtonItemStylePlain target:self action:@selector(onEditProfile)];
        
        //[self.confirmPopupView setHidden:NO];
        UIAlertView *theAlert = [[UIAlertView alloc] initWithTitle:@"Thanks for joining the Inneract Project Family!"
                                                           message:@"You have successfully created your profile. An email confirmation has been sent to your email address. Please verify your account. Your email confirmation helps to maintain an honest IP community."
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [theAlert show];
    } else {
        //[self getUserActivities];
    }
    
    self.refreshController = [[UIRefreshControl alloc] init];
    [self.refreshController addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshController atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUser:(PFObject *)user {
    _user = user;
}

#pragma mark - table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
//        case 2:
//            return self.activities.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.sectionCells[indexPath.section]];
    switch (indexPath.section) {
        case 0: {
            BasicInfoCell *basicInfoCell = (BasicInfoCell *) cell;
            [basicInfoCell setUser:self.user fromAccountCreation:self.fromAccountCreation isSelf:self.isSelfProfile];
            basicInfoCell.profileDelegate = self;
            break;
        }
        case 1: {
            BadgesCell *badgeCell = (BadgesCell *) cell;
            [badgeCell setUser:self.user isSelfProfile:self.isSelfProfile];
            badgeCell.profileDelegate = self;
            break;
        }
//        case 2: {
//            ActivityCell *activityCell = (ActivityCell *) cell;
//            [activityCell setActivity:self.activities[indexPath.row]];
//            break;
//        }
        default:
            return nil;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //switch (section) {
        //case 0:
            //return @"Basic Information";
       // case 1:
           // return @"Badges";
       // case 2:
         //   return @"Activities";
       // default:
           // return nil;
   // }
//}

#pragma mark - table view delegate
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - profile delegate
- (void) onViewProfileLink {
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.user objectForKey:@"profileLink"]]];
    [self.navigationController pushViewController:[[IPWebViewController alloc] initWithUrl:[self.user objectForKey:@"profileLink"] title:[self getUserName]] animated:YES];
}

- (void) onGiveBadge:(NSInteger) newBadges WithCompletion:(ProfileDelegateCompletion) block {
//    [self.user setValue:@([[self.user valueForKey:@"badges"] integerValue] + 1) forKey:@"badges"];
//    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if(error) {
//            NSLog(@"----self.user saveInBackgroundWithBlock error : %@", error);
//        }
//    }];

    [PFCloud callFunctionInBackground:@"giveBadge"
                       withParameters:@{@"toUserId": [self.user valueForKey:@"objectId"]}
                                block:^(NSArray *results, NSError *error) {
                                    if (!error) {
                                        // update list view
                                        [self.user setValue:@(newBadges) forKey:@"badges"];
                                        [[NSNotificationCenter defaultCenter] postNotificationName:kDidUpdateUserBadgesNotification object:nil];

                                        [[IPEventTracker sharedInstance] onGiveBadgeToUser:self.user];
                                    }

                                    if(block) {
                                        block(error);
                                    }
                                }];
}

- (void) onEditProfile {
    [self.navigationController pushViewController:[[EditProfileViewController alloc] initWithUser:self.user] animated:YES];  
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)didShared:(id)sender {
//    [[IPShareManager sharedInstance] shareItemWithTitle:[NSString stringWithFormat:@"%@ %@", [self.user objectForKey:@"firstName"], [self.user objectForKey:@"lastName"]] andUrl:[self.user objectForKey:@"profileLink"] fromViewController:self];
//}

- (void)didBack:(id)sender {
    if(!self.fromAccountCreation) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSString *preselectedCategory;
        NSString *userDesignation = [self.user valueForKey:@"userType"];
        if([userDesignation hasPrefix:@"Teacher"]) {
            preselectedCategory = @"volunteer";
        } else if([userDesignation hasPrefix:@"Parent"]) {
            preselectedCategory = @"classes";
        } else {
            preselectedCategory = @"news";
        }
        [self presentViewController:[MainViewHelper setupMainViewTabBarWithSelectedFeedsCategory:preselectedCategory] animated:YES completion:nil];
    }
}

- (IBAction)onLogout:(id)sender {
    [PFUser logOut];

    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setValue:[NSNull null] forKey:@"userId"];
    [currentInstallation saveInBackground];

	// if we logged in via facbook, close and clear that information.
	if (FBSession.activeSession.isOpen)
	{
		[FBSession.activeSession closeAndClearTokenInformation];
	}
	
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLogoutNotification" object:nil];
}

- (NSString *) getUserName {
    return [NSString stringWithFormat:@"%@ %@", [self.user valueForKey:@"firstName"], [self.user valueForKey:@"lastName"]];
}

//- (void) getUserActivities {
//    PFQuery *activitiesQuery = [PFQuery queryWithClassName:@"Activity"];
//    [activitiesQuery whereKey:@"userId" equalTo:self.user.objectId];
//    [activitiesQuery includeKey:@"event"];
//    [activitiesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if(!error) {
//            self.activities = objects;
//            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:YES];
//        }
//
//        [self.refreshController endRefreshing];
//    }];
//}

- (void) fetchUser {
    PFQuery *query = [PFUser query];
    PFUser *parseUser = [PFUser currentUser];
    NSString *username = parseUser.username;
    [query whereKey:@"username" equalTo:username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error && objects.count == 1) {
            _user = objects[0];
            //self.title = [self getUserName];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)] withRowAnimation:YES];
        }
        
        [self.refreshController endRefreshing];
    }];
}

-(void) onRefresh {
//    if(self.fromAccountCreation){
//        [self getUserActivities];
//    }
    
    if(self.isMyProfileView) {
        [self fetchUser];
    }
}


@end
