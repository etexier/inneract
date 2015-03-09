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
#import <SVProgressHUD.h>


NSString *const kTitle = @"Feeds";
NSString *const kFeedCellNibId = @"FeedCell";

NSString *const kFeedBookmarkRelationshipName = @"feedsBookmarkedBy";

@interface FeedsViewController () <UISearchDisplayDelegate, UISearchBarDelegate, FeedCellProtocol>
@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic, strong) UISearchDisplayController *searchController;
@property(nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic, assign) BOOL isForBookmark;

- (void)filterResults:(NSString *)text;
@end

@implementation FeedsViewController

- (id)init {
    NSLog(@"Initializing new FeedsViewController");
    self = [super init];

    if (self) {
        [self setupTableView];
    }

    return self;
}

- (id)initForBookmark {
    NSLog(@"Initializing new FeedsViewController for bookmark");
    self = [super init];

    if (self) {
        _isForBookmark = YES;
        [self setupTableView];
    }

    return self;
}

- (void) setupTableView {
    // This table displays items in the Todo class
    self.parseClassName = @"IPNews";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = NO;
    self.objectsPerPage = 10;
}


#pragma mark - Parse

- (PFQuery *)queryForTable {
    PFQuery *query;
    if(self.isForBookmark) {
        query = [PFQuery queryWithClassName:self.parseClassName];
        [query whereKey:kFeedBookmarkRelationshipName equalTo:[PFUser currentUser]];
    } else {
        if (self.feedCategory) {
            query = [PFQuery queryWithClassName:self.parseClassName predicate:[NSPredicate predicateWithFormat:@"feedCategory=%@", self.feedCategory]];
        } else {
            query = [PFQuery queryWithClassName:self.parseClassName];
        }
    }

    [self filterQuery:query];
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }

    [query orderByDescending:@"createdAt"];

    return query;
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    // cell registration
    [self.tableView registerNib:[UINib nibWithNibName:kFeedCellNibId bundle:nil] forCellReuseIdentifier:kFeedCellNibId];

    // cell auto dim.
    [self initTableView:self.tableView];

    // Title (can be overridden)
    //self.title = kTitle;

    // search
    [self initSearchBar];

    // navigation bar
    if(!self.isForBookmark) {
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"IP News", @"Volunteer", @"Classes"]];
        //[statFilter setSegmentedControlStyle:UISegmentedControlStyleBar];
        [segmentedControl sizeToFit];
        [segmentedControl addTarget:self action:@selector(categoryDidSelected:) forControlEvents:UIControlEventValueChanged];

        NSDictionary *attributesNormalState = @{NSForegroundColorAttributeName : ipPrimaryMidnightBlue};
        [segmentedControl setTitleTextAttributes:attributesNormalState forState:UIControlStateNormal];

        NSDictionary *attributesHighlightedState = @{NSForegroundColorAttributeName : ipPrimaryMidnightBlue};
        [segmentedControl setTitleTextAttributes:attributesHighlightedState forState:UIControlStateHighlighted];

        segmentedControl.tintColor = ipPrimaryOrange;
        
        self.navigationItem.titleView = segmentedControl;
        segmentedControl.selectedSegmentIndex = 0;
    }


}

- (void)initTableView:(UITableView *)view {
    view.rowHeight = UITableViewAutomaticDimension;
    view.estimatedRowHeight = 150;
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

//  could be a iOS bug: the cell were squished when going back and forth b/w views
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedCellNibId];
//    cell.feed = self.objects[(NSUInteger) indexPath.row];
//    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//    return size.height + 1;
//}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FeedDetailsViewController *detailsVc = [[FeedDetailsViewController alloc] initWithFeed:self.objects[(NSUInteger) indexPath.row]];

    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:detailsVc animated:YES];

}


#pragma mark - Table View Data source methods


- (PFTableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {

    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedCellNibId];

    if (!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:kFeedCellNibId owner:nil options:nil];

        for (id currentObject in topLevelObjects) {
            if([currentObject isKindOfClass:[FeedCell class]]) {
                cell = (FeedCell *)currentObject;
                break;
            }
        }
    }

    cell.feedCellHandler = self;
    cell.isForBookmark = self.isForBookmark;

    if (tableView == self.tableView) {
        cell.feed = object;
    } else {
       cell.feed = self.searchResults[(NSUInteger) indexPath.row];
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

    [self.searchResults removeAllObjects];

    // search in titles
    PFQuery *titleQuery = [PFQuery queryWithClassName:self.parseClassName];
    [self filterQuery:titleQuery];
    [titleQuery whereKey:@"title" containsString:searchTerm];

    // search in summary
    PFQuery *summaryQuery = [PFQuery queryWithClassName:self.parseClassName];
    [self filterQuery:summaryQuery];
    [titleQuery whereKey:@"summary" containsString:searchTerm];

    // or' queries
    PFQuery *mainQuery = [PFQuery orQueryWithSubqueries:@[titleQuery, summaryQuery]];

    NSArray *results = [mainQuery findObjects];
    NSLog(@"%@", results);
    NSLog(@"%u", results.count);

    [self.searchResults removeAllObjects];
    [self.searchResults addObjectsFromArray:results];
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

    [SVProgressHUD show];
    [self loadObjects];
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    //[SVProgressHUD show];
}

- (void)objectsDidLoad:(NSError *)error {
   [super objectsDidLoad:error];

    [SVProgressHUD dismiss];
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

@end
