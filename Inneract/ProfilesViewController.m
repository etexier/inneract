//
//  ProfilesViewController.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "ProfilesViewController.h"
#import <Parse/PFQuery.h>
#import "IPColors.h"
#import "ProfileDetailsViewController.h"
#import "PeopleCell.h"
#import <SVProgressHUD.h>
#import "IPConstants.h"

NSString *const kPeopleCellNibId = @"PeopleCell";

@interface ProfilesViewController ()  <UISearchDisplayDelegate, UISearchBarDelegate>
@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic, strong) UISearchDisplayController *searchController;
@property(nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic, assign) BOOL isInSearchMode;

@end

static const CGFloat kTableViewSideOffset = 10.0;

@implementation ProfilesViewController

- (id)init {
    NSLog(@"Initializing new FeedsViewController");
    self = [super init];

    if (self) {
        [self setupTableView];
    }

    return self;
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDidReceiveNewFeedRemoteNotification object:nil];
    //[super dealloc];
}

- (void) setupTableView {
    // This table displays items in the Todo class
    self.parseClassName = @"User";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = NO;
    self.objectsPerPage = 10;

    // cell auto dim.
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120;

    self.searchController.searchResultsTableView.rowHeight = UITableViewAutomaticDimension;
    self.searchController.searchResultsTableView.estimatedRowHeight = 120;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0, 20, 0.0, 20.0);
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:insets];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:insets];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:insets];
    }
    
}

- (PFQuery *)queryForTable {
    //PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    PFQuery *query = [PFUser query];

    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }

    [query orderByDescending:@"createdAt"];

    return query;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Handle remote notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveUserBadgeRemoteNotification:) name:kDidReceiveUserBadgeRemoteNotification object:nil];

    // cell registration
    [self.tableView registerNib:[UINib nibWithNibName:kPeopleCellNibId bundle:nil] forCellReuseIdentifier:kPeopleCellNibId];

    // search
    [self initSearchBar];
    
    self.title = @"People";
    
    // Only show for first loading
    [SVProgressHUD show];
}

- (void)initSearchBar {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];

    self.tableView.tableHeaderView = self.searchBar;

    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];

    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;


    CGPoint offset = CGPointMake(0, self.searchBar.frame.size.height);
    self.tableView.contentOffset = offset;

    self.searchResults = [NSMutableArray array];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateUserBadgeds) name:kDidUpdateUserBadgesNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View delegate  methods

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *user = (tableView == self.tableView) ? self.objects[(NSUInteger) indexPath.row] : self.searchResults[(NSUInteger) indexPath.row];
    ProfileDetailsViewController *detailsVc = [[ProfileDetailsViewController alloc] initWithUser:user];

    [self.navigationController pushViewController:detailsVc animated:YES];

}

#pragma mark - Table View Data source methods

- (PFTableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {

    PeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:kPeopleCellNibId];

    if (!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:kPeopleCellNibId owner:nil options:nil];

        for (id currentObject in topLevelObjects) {
            if([currentObject isKindOfClass:[PeopleCell class]]) {
                cell = (PeopleCell *)currentObject;
                break;
            }
        }
    }

    if (tableView == self.tableView) {
        cell.user = object;
    } else {
        cell.user = self.searchResults[(NSUInteger) indexPath.row];
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView == self.tableView) {
        return self.objects.count;
    } else {
        return self.searchResults.count;
    }

}

#pragma mark - Search bar delegate methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder]; // hide keyboard
    // do search
    [self filterResults:self.searchBar.text];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.isInSearchMode = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder]; // hide keyboard
    self.isInSearchMode = NO;
}

#pragma mark - search method

- (void)filterResults:(NSString *)searchTerm {
    
    //Do a local filter first
    NSArray *localFilterResult = [self.objects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"firstName CONTAINS[cd] %@ OR lastName CONTAINS[cd] %@ OR userType CONTAINS[cd] %@ OR profession CONTAINS[cd] %@", searchTerm, searchTerm, searchTerm, searchTerm]];
    if(localFilterResult.count) {
        [self.searchResults removeAllObjects];
        [self.searchResults addObjectsFromArray:localFilterResult];
        [self.searchController.searchResultsTableView reloadData];
        return;
    } else {
        // search in first name
        PFQuery *firstNameQuery = [PFUser query];
        [firstNameQuery whereKey:@"firstName" hasPrefix:searchTerm];

        // search in last name
        PFQuery *lastNameQuery = [PFUser query];
        [firstNameQuery whereKey:@"lastName" hasPrefix:searchTerm];

        // search in designation
        PFQuery *designationQuery = [PFQuery queryWithClassName:self.parseClassName];
        [designationQuery whereKey:@"userType" containsString:searchTerm];

        // search in professionQuery
        PFQuery *professionQuery = [PFQuery queryWithClassName:self.parseClassName];
        [professionQuery whereKey:@"profession" containsString:searchTerm];

        // or' queries
        PFQuery *mainQuery = [PFQuery orQueryWithSubqueries:@[firstNameQuery, lastNameQuery/**, designationQuery, professionQuery*/]];
        //mainQuery.trace = YES;
        [mainQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(!error) {
                    NSLog(@"people search result for query: %@ \n%@", mainQuery, objects);
                    NSLog(@"%lu", (unsigned long)objects.count);

                    [self.searchResults removeAllObjects];
                    [self.searchResults addObjectsFromArray:objects];
                    [self.searchController.searchResultsTableView reloadData];
            }
        }];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterResults:searchString];
    return NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarTextDidEndEditing");
    //[self filterResults:searchBar.text];
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];

    [SVProgressHUD dismiss];
}

- (void) didUpdateUserBadgeds {
    if(self.isInSearchMode) {
        [self.searchController.searchResultsTableView reloadData];
    } else {
        [self.tableView reloadData];
    }
}

- (void) didReceiveUserBadgeRemoteNotification:(NSNotification *) notification {
    NSString *userId = [notification.userInfo valueForKey:@"userId"];
    if(userId) {
        PFQuery *query = [PFUser query];
        [query getObjectInBackgroundWithId:userId block:^(PFObject *object, NSError *error) {
            if(object) {
                ProfileDetailsViewController *detailsVc = [[ProfileDetailsViewController alloc] initWithUser:object];
                [self.navigationController pushViewController:detailsVc animated:YES];
            }
        }];
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
