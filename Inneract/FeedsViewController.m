//
//  FeedsViewController.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "FeedsViewController.h"
#import "FeedCell.h"
#import "FeedDetailsViewController.h"
#import <Parse/PFQuery.h>
#import "IPShareManager.h"
#import "IPColors.h"

NSString *const kFeedCellNibId = @"FeedCell";
NSString *const kFeedBookmarkRelationshipName = @"feedsBookmarkedBy";

typedef void (^FeedQueryCompletion)(NSArray *objects, NSError *error);

@interface FeedsViewController () <UITableViewDataSource, UITableViewDelegate,UISearchDisplayDelegate, UISearchBarDelegate, FeedCellProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIRefreshControl *refreshController;
@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic, strong) UISearchDisplayController *searchController;
@property(nonatomic, strong) NSMutableArray *feeds;
@property(nonatomic, strong) NSMutableArray *feedsOfCurrentCategory;
@property(nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic, assign) BOOL isForBookmark;
@property(nonatomic, strong) NSString *parseClassName;

- (void)filterResults:(NSString *)text;

@end

@implementation FeedsViewController

- (id)init {
    NSLog(@"Initializing new FeedsViewController");
    self = [super init];
    
    if (self) {
        //[self setupTableView];
    }
    
    return self;
}

- (id)initForBookmark {
    NSLog(@"Initializing new FeedsViewController for bookmark");
    self = [super init];
    
    if (self) {
        _isForBookmark = YES;
        //[self setupTableView];
    }
    
    return self;
}

- (void) setupTableView {
    // This table displays items in the Todo class
    self.parseClassName = @"IPNews";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // cell auto dim.
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150;
    
    self.refreshController = [[UIRefreshControl alloc] init];
    [self.refreshController addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshController atIndex:0];
    
    // cell registration
    [self.tableView registerNib:[UINib nibWithNibName:kFeedCellNibId bundle:nil] forCellReuseIdentifier:kFeedCellNibId];

}


#pragma mark - Parse

- (void)queryForFeedsWithCompletion:(FeedQueryCompletion) block {
    PFQuery *query;
    if(self.isForBookmark) {
        query = [PFQuery queryWithClassName:self.parseClassName];
        [query whereKey:kFeedBookmarkRelationshipName equalTo:[PFUser currentUser]];
    } else {
        query = [PFQuery queryWithClassName:self.parseClassName];
    }

    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    //    if ([self.objects count] == 0) {
    //        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    //    }
    
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(objects) {
            [self.feeds removeAllObjects];
            self.feeds = [objects mutableCopy];
            [self filterFeedsByCategory];
            if(block) {
                block(objects, error);
            }
            
            [self.refreshController endRefreshing];
        }
    }];
}

- (void) filterFeedsByCategory {
    [self.feedsOfCurrentCategory removeAllObjects];
    if (self.feedCategory) {
        self.feedsOfCurrentCategory = [[self.feeds filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"feedCategory=%@", self.feedCategory]] mutableCopy];
    } else {
        self.feedsOfCurrentCategory = self.feeds;
    }
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Title (can be overridden)
    //self.title = kTitle;
    
    [self setupTableView];
    
    // search
    [self initSearchBar];
    
    // navigation bar
    if(!self.isForBookmark) {
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"IP News", @"Volunteer", @"Classes"]];
        //[statFilter setSegmentedControlStyle:UISegmentedControlStyleBar];
        segmentedControl.frame = CGRectMake(0, 22, [UIScreen mainScreen].bounds.size.width, 40);
        //[segmentedControl sizeToFit];
        [segmentedControl addTarget:self action:@selector(categoryDidSelected:) forControlEvents:UIControlEventValueChanged];
        
        NSDictionary *attributesNormalState = @{NSForegroundColorAttributeName : ipPrimaryMidnightBlue};
        [segmentedControl setTitleTextAttributes:attributesNormalState forState:UIControlStateNormal];
        
        NSDictionary *attributesHighlightedState = @{NSForegroundColorAttributeName : ipPrimaryMidnightBlue};
        [segmentedControl setTitleTextAttributes:attributesHighlightedState forState:UIControlStateHighlighted];
        
        segmentedControl.tintColor = ipPrimaryOrange;
        
        self.navigationItem.titleView = segmentedControl;
        
        segmentedControl.selectedSegmentIndex = 0;
        self.feedCategory = @"news";
    }
    
    [self queryForFeedsWithCompletion:^(NSArray *objects, NSError *error) {
        [self.tableView reloadData];
    }];
    
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
    
    self.searchController.searchResultsTableView.rowHeight = UITableViewAutomaticDimension;
    self.searchController.searchResultsTableView.estimatedRowHeight = 150;
    
    // cell registration
    [self.searchController.searchResultsTableView registerNib:[UINib nibWithNibName:kFeedCellNibId bundle:nil] forCellReuseIdentifier:kFeedCellNibId];
    
    //    self.searchBar = [[UISearchBar alloc] init];
    //    self.navigationItem.titleView = self.searchBar;
    //    self.searchBar.text = nil;
    //    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    //    self.searchBar.delegate = self;
    
    
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

    FeedDetailsViewController *detailsVc = [[FeedDetailsViewController alloc] initWithFeed:[self feedForTableView:tableView atIndexPath:indexPath]];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:detailsVc animated:YES];
    
}


#pragma mark - Table View Data source methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedCellNibId forIndexPath:indexPath];
    
    if(!cell) {
        cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kFeedCellNibId];
    }
    
    cell.feedCellHandler = self;
    cell.isForBookmark = self.isForBookmark;
    cell.feed = [self feedForTableView:tableView atIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.feedsOfCurrentCategory.count;
    } else {
        return self.searchResults.count;
    }
}

- (PFObject *) feedForTableView:(UITableView *) tableView atIndexPath:(NSIndexPath *) indexPath {
    PFObject *feed;
    if (tableView == self.tableView) {
        feed = self.feedsOfCurrentCategory[indexPath.row];
    } else {
        feed = self.searchResults[(NSUInteger) indexPath.row];
    }
    
    return feed;
}

#pragma mark - can be overridden

- (void)filterQuery:(PFQuery *)query {
    return;
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
    //Do a local filter first
    NSArray *localFilterResult = [self.feedsOfCurrentCategory filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchTerm]];
    if(localFilterResult.count) {
        [self.searchResults removeAllObjects];
        [self.searchResults addObjectsFromArray:localFilterResult];
        return;
    } else {
        // search in titles
        PFQuery *titleQuery = [PFQuery queryWithClassName:self.parseClassName];
        [self filterQuery:titleQuery];
        [titleQuery whereKey:@"title" containsString:searchTerm];

        //    // search in summary
        //    PFQuery *summaryQuery = [PFQuery queryWithClassName:self.parseClassName];
        //    [self filterQuery:summaryQuery];
        //    [titleQuery whereKey:@"summary" containsString:searchTerm];
        //
        //    // or' queries
        //    PFQuery *mainQuery = [PFQuery orQueryWithSubqueries:@[titleQuery, summaryQuery]];
        //
        //    NSArray *results = [mainQuery findObjects];
        [titleQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            //    NSLog(@"%@", results);
            NSLog(@"%lu", (unsigned long) objects.count);

            [self.searchResults removeAllObjects];
            [self.searchResults addObjectsFromArray:objects];
        }];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterResults:searchString];
    return YES;
}

- (void) categoryDidSelected:(UISegmentedControl *) sender {
    switch ([sender selectedSegmentIndex]) {
        case 0:
            self.feedCategory = @"news";
            break;
        case 1:
            self.feedCategory = @"volunteer";
            break;
        case 2:
            self.feedCategory = @"classes";
            break;
        default:
            break;
    }
    
    [self filterFeedsByCategory];
    [self.tableView reloadData];
}

#pragma mark - feed cell protocol
- (void) feedCell:(FeedCell *) tweetCell didShareFeed:(PFObject *) feed {
    [[IPShareManager sharedInstance] shareItemWithTitle:[feed objectForKey:@"title"] andUrl:[feed objectForKey:@"link"] fromViewController:self];
}

- (void) feedCell:(FeedCell *) tweetCell didBookmarkFeed:(PFObject *) feed {
    if(feed) {
        [feed addObject:[PFUser currentUser] forKey:kFeedBookmarkRelationshipName];
        [feed saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error) {
                NSLog(@"failed to save %@ for feed \n%@", kFeedBookmarkRelationshipName, feed);
            } else {
                //NSLog(@"User %@ bookmarked feed \n%@", [PFUser currentUser], feed);
            }
        }];
    }
}
#pragma mark - private methods 
-(void) onRefresh {
    [self queryForFeedsWithCompletion:^(NSArray *objects, NSError *error) {
        [self.tableView reloadData];
    }];
}

@end
