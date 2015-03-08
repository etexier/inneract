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


NSString *const kTitle = @"Feeds";
NSString *const kFeedCellNibId = @"FeedCell";

@interface FeedsViewController ()
@property(strong, nonatomic) NSArray *feeds;

@end

@implementation FeedsViewController

- (id)init {
    NSLog(@"Initializing new FeedsViewController");
    self = [super init];

    if (self) {
        self.feeds = [NSMutableArray array];

        // This table displays items in the Todo class
        self.parseClassName = @"IPNews";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 10;

    }

    return self;
}


#pragma mark - Parse

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];

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
    // Do any additional setup after loading the view from its nib.

    // delegates
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;

    // cell registration
    [self.tableView registerNib:[UINib nibWithNibName:kFeedCellNibId bundle:nil] forCellReuseIdentifier:kFeedCellNibId];

    // cell auto dim.
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 150;
    self.title = kTitle; // not seen anyway

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View delegate  methods

//  could be a iOS bug: the cell were squished when going back and forth b/w views
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    FeedCell *cell = [tableView dequeueReusableCellWithIdentifier:kFeedCellNibId];
//    cell.feed = self.feeds[(NSUInteger) indexPath.row];
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
    cell.feed = object;

    return cell;
}
#pragma mark - 


@end
