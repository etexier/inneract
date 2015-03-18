//
//  ProfilesViewController.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "ProfilesViewController.h"
#import <Parse/PFQuery.h>
#import "IPShareManager.h"
#import "IPColors.h"
#import "ProfileDetailsViewController.h"
#import "PeopleCell.h"
#import <SVProgressHUD.h>

NSString *const kPeopleCellNibId = @"PeopleCell";

@interface ProfilesViewController ()  <UISearchDisplayDelegate, UISearchBarDelegate>
@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic, strong) UISearchDisplayController *searchController;
@property(nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation ProfilesViewController

- (id)init {
    NSLog(@"Initializing new FeedsViewController");
    self = [super init];

    if (self) {
        [self setupTableView];
    }

    return self;
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

    // cell registration
    [self.tableView registerNib:[UINib nibWithNibName:kPeopleCellNibId bundle:nil] forCellReuseIdentifier:kPeopleCellNibId];

    // search
    [self initSearchBar];
    
    self.title = @"People";
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder]; // hide keyboard
}

#pragma mark - search method

- (void)filterResults:(NSString *)searchTerm {

    [self.searchResults removeAllObjects];

    // search in first name
    PFQuery *firstNameQuery = [PFUser query];
    [firstNameQuery whereKey:@"firstName" hasPrefix:searchTerm];

    // search in last name
    PFQuery *lastNameQuery = [PFUser query];
    [firstNameQuery whereKey:@"lastName" hasPrefix:searchTerm];

    // search in designation
    PFQuery *designationQuery = [PFQuery queryWithClassName:self.parseClassName];
    [designationQuery whereKey:@"designation" containsString:searchTerm];

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
    [SVProgressHUD show];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];

    [SVProgressHUD dismiss];
}

#pragma mark - feed cell protocol
- (void) peopleCell:(PeopleCell *) tweetCell didSharePeople:(PFObject *) user {
    [[IPShareManager sharedInstance] shareItemWithTitle:[NSString stringWithFormat:@"%@ %@", [user objectForKey:@"firstName"], [user objectForKey:@"lastName"]] andUrl:[user objectForKey:@"profileLink"] fromViewController:self];
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
