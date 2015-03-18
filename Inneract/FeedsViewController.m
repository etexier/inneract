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
#import "HighlightedFeedsView.h"

NSString *const kFeedCellNibId = @"FeedCell";
NSString *const kFeedBookmarkRelationshipName = @"feedsBookmarkedBy";
const CGFloat ksearchBarHeight = 44;
const CGFloat kHighlightedFeedsHeight = 200;
//    const CGFloat highlightedFeedsViewOffset = ksearchBarHeight;
const CGFloat highlightedFeedsViewOffset = 0;



typedef void (^FeedQueryCompletion)(NSArray *objects, NSError *error);

@interface FeedsViewController () <UITableViewDataSource, UITableViewDelegate,UISearchDisplayDelegate, UISearchBarDelegate, FeedCellProtocol, HighlightedFeedsViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIRefreshControl *refreshController;
@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic, strong) UISearchDisplayController *searchController;
@property(nonatomic, strong) NSMutableArray *feeds;
@property(nonatomic, strong) NSMutableArray *highlightedFeeds;
@property(nonatomic, strong) NSMutableArray *feedsOfCurrentCategory;
@property(nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic, assign) BOOL isForBookmark;
@property(nonatomic, strong) NSString *parseClassName;
@property (nonatomic, assign) NSInteger preselectedCategoryIndex;

- (void)filterResults:(NSString *)text;

@end

@implementation FeedsViewController

- (id)init {
    return [self initWithCategory:@"news"];
}

- (id)initWithCategory:(NSString *) category {
    NSLog(@"Initializing new FeedsViewController for category : %@", category);
    self = [super init];
    
    if (self) {
        if([category isEqualToString:@"bookmark"]) {
            _isForBookmark = YES;
        } else {
            self.feedCategory = category;

            if([category isEqualToString:@"news"]) {
                self.preselectedCategoryIndex = 0;
            } else if([category isEqualToString:@"volunteer"]) {
                self.preselectedCategoryIndex = 1;
            } else if([category isEqualToString:@"classes"]) {
                self.preselectedCategoryIndex = 2;
            }
        }
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

- (void) filterFeedsByCategory{
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

    [self setupTableView];
    

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
        
        segmentedControl.tintColor = ipPrimaryOrange; // done in XIB
        
        self.navigationItem.titleView = segmentedControl;
        
        segmentedControl.selectedSegmentIndex = self.preselectedCategoryIndex;
    }


    [self queryForFeedsWithCompletion:^(NSArray *objects, NSError *error) {
        [self reloadData];
    }];
    
}

- (void) reloadData {
    [self.tableView reloadData];
    [self setupHeaderView];
}

- (void)setupHeaderView {


    CGFloat height =  highlightedFeedsViewOffset +  kHighlightedFeedsHeight;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    [self.view addSubview:headerView];


    // search bar on top of header

    BOOL hasSearchBar = NO;
    //[self setupSearchBarForHeaderView:headerView];

    // highlighted feeds at bottom of headerview

    BOOL hasHeader = [self setupHighlightedFeedsForHeaderView:headerView];

    if (!hasHeader && !hasSearchBar) {
        self.tableView.tableHeaderView = nil;
        [headerView removeFromSuperview];
        return;
    }
    self.tableView.tableHeaderView = headerView;
}

- (BOOL)setupHighlightedFeedsForHeaderView:(UIView *)headerView {

    CGRect frame = CGRectMake(0, highlightedFeedsViewOffset, self.tableView.bounds.size.width, kHighlightedFeedsHeight);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"renderingStyle=%@", @"highlighted"];
    NSMutableArray *highlightedFeeds = [[self.feedsOfCurrentCategory filteredArrayUsingPredicate:predicate] mutableCopy];
    if (highlightedFeeds.count == 0) {
        return NO;
    }
    HighlightedFeedsView *highlightedFeedsView = [[HighlightedFeedsView alloc] initWithFrame:frame];
    [headerView addSubview:highlightedFeedsView];
    highlightedFeedsView.delegate = self;
    [self.highlightedFeeds removeAllObjects];
    self.highlightedFeeds = highlightedFeeds;
    highlightedFeedsView.feeds = self.highlightedFeeds;
    return YES;


}

- (void)setupSearchBarForHeaderView:(UIView *) headerView {
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ksearchBarHeight)];
    [headerView addSubview:self.searchBar];

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
        feed = self.feedsOfCurrentCategory[(NSUInteger) indexPath.row];
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
    [self reloadData];

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
#pragma - HighlightedFeedsViewDelegate
- (void) onHeaderTap:(PFObject *)object {
    FeedDetailsViewController *detailsVc = [[FeedDetailsViewController alloc] initWithFeed:object];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:detailsVc animated:YES];

    
}
#pragma mark - private methods 
-(void) onRefresh {
    [self queryForFeedsWithCompletion:^(NSArray *objects, NSError *error) {
        [self reloadData];
    }];
}

@end
