//
//  FeedDetailsViewController.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "UIImageView+IP.h"
#import "FeedDetailsHeaderView.h"
#import "FeedDetailsViewController.h"
#import "FeedDetailsCell.h"
#import "VimeoController.h"
#import "VimeoVideoConfigResult.h"
#import "Request.h"
#import "Files.h"
#import "H264.h"
#import "Sd.h"
#import "IPEventTracker.h"
#import "IPWebViewController.h"
#import "IPShareManager.h"
#import <MediaPlayer/MediaPlayer.h>

#import <PayPalMobile.h>
#import <PayPalPayment.h>

NSString *const kFeedDetailsCellNibId = @"FeedDetailsCell";

@interface FeedDetailsViewController () <UITableViewDataSource,
										UITableViewDelegate,
										FeedDetailsHeaderViewDelegate,
										IPFeedDelegate,
										UIWebViewDelegate,
										PayPalPaymentDelegate>

@property(weak, nonatomic) IBOutlet UITableView *tableView;

// PayPal integration stuff.
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property(nonatomic, strong, readwrite)  UIButton *payNowButton;
@property(nonatomic, strong, readwrite)  UIButton *payFutureButton;
@property(nonatomic, strong, readwrite)  UIView *successView;

@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;

@property (nonatomic, strong) IPWebViewController *webViewController;

@property (nonatomic, strong) PFObject *feedActivity;

@end

@implementation FeedDetailsViewController

- (instancetype) initWithFeed:(PFObject *) feed isBookmarked:(BOOL) isBookmarked isForBookmark:(BOOL) isForBookmark delegate:(id<IPFeedDelegate>) delegate {
    self = [super init];
    if(self) {
        _feed = feed;
        _isBookmarked = isBookmarked;
        _isForBookmark = isForBookmark;
        _delegate = delegate;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 400;
    
    [self fetchFeedActivity];

    // Do any additional setup after loading the view from its nib.
    [self.tableView registerNib:[UINib nibWithNibName:kFeedDetailsCellNibId bundle:nil] forCellReuseIdentifier:kFeedDetailsCellNibId];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"backArrowIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(didBack:)];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self setupHeaderView];
}

- (void) fetchFeedActivity {
    if(self.feed) {
        PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
        [query whereKey:@"userId" equalTo:[PFUser currentUser].objectId];
        [query whereKey:@"event" equalTo: self.feed];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(!error && objects.count == 1) {
                self.feedActivity = objects[0];
                [self.tableView reloadData];
            } else {
                
            }
        }];
    }
}

- (void)setupHeaderView {
    // header view: thumbnail image (mostly)
    CGRect headerFrame = CGRectMake(0, 0, self.tableView.bounds.size.width, 230.0);
    FeedDetailsHeaderView *headerView = [[FeedDetailsHeaderView alloc] initWithFrame:headerFrame];
    headerView.feed = self.feed;
    headerView.delegate = self;
    self.tableView.tableHeaderView = headerView;

}


- (void)didBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedDetailsCell *cell = (FeedDetailsCell *) [tableView dequeueReusableCellWithIdentifier:kFeedDetailsCellNibId forIndexPath:indexPath];
    [self configureBasicCell:cell];
    return cell;
}

#pragma recalculate height for details cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForFeedDetailsCell];
}

- (CGFloat)heightForFeedDetailsCell {
    static FeedDetailsCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:kFeedDetailsCellNibId];
    });
    
    [self configureBasicCell:sizingCell];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

- (void)configureBasicCell:(FeedDetailsCell *)cell {
    [cell setData:self.feed isBookmarked:self.isBookmarked isForBookmakr:self.isForBookmark feedActivity:self.feedActivity];
    cell.delegate = self;
}


#pragma FeedDetailsHeaderViewDelegate

- (void)didTapOnHeaderView:(FeedDetailsHeaderView *)headerView {
    if (!headerView.videoUrl) {
        return;
    }
    NSLog(@"Tap on top image : will play %@", headerView.videoUrl);
    VimeoController *controller = [[VimeoController alloc] init];
    NSString *videoId = [headerView.videoUrl lastPathComponent];
    [controller getVimeoVideoConfig:videoId success:^(VimeoVideoConfigResult *response) {
        //        NSString *movieUrlString = response.request.files.h264.hd.url; // hd may be slow to download
        NSString *movieUrlString = response.request.files.h264.sd.url;
        NSURL *movieURL = [NSURL URLWithString:movieUrlString];
        NSLog(@"Playing video at URL: %@", movieURL);
        MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:movieURL];
        [self presentMoviePlayerViewControllerAnimated:movieController];
        [movieController.moviePlayer play];

        // code
    }
    failure:^(NSError *error) {
        NSLog(@"Couldn't open video url");
    }];
}

#pragma FeedDetailsCellDelegate

- (void)didSelectReadFullStory:(PFObject *)feed {
    NSLog(@"Did select full story");

    [self openWebLink:[feed objectForKey:@"link"] title:[feed objectForKey:@"title"]];
    [[IPEventTracker sharedInstance] onReadFeed:self.feed];
}

- (void)didBookmarkFeed:(PFObject *)feed {
    [self.delegate didBookmarkFeed:feed];
}

- (void)didShareFeed:(PFObject *)feed {
    [[IPShareManager sharedInstance] shareFeed:feed fromViewController:self];
    //[self.delegate didShareFeed:feed];
}

- (void)didRsvp:(PFObject *)feed {
    NSLog(@"Did rsvp feed");

    //[self openWebLink:[feed objectForKey:@"rsvpUrl"] title:[feed objectForKey:@"title"]];
    //NSLog(@"opening web link: %@", urlStr);
    if(!self.webViewController) {
        self.webViewController = [[IPWebViewController alloc] initWithUrl:[feed objectForKey:@"rsvpUrl"] title:[feed objectForKey:@"title"] rightNavigationItem:@"Done" warningMessageBeforeBack:nil callback:^(NSError *error) {
            self.webViewController.didCompleteCallback = YES;
            
            [[IPEventTracker sharedInstance] onRsvpEvent:self.feed];
            
            //TODO : need confirmation of rsvp process
            [self createFeedActivity:@"rsvp"];
        }];
    }
    [self.navigationController pushViewController:self.webViewController animated:YES];
}

- (void)didPay:(PFObject *)feed {
    NSLog(@"Did pay for feed");
    [self pay];

}

- (void)didRegister:(PFObject *)feed {
    NSLog(@"Did register feed");

    if(!self.webViewController) {
        self.webViewController = [[IPWebViewController alloc] initWithUrl:[feed objectForKey:@"registerUrl"]
                                                                                title:[feed objectForKey:@"title"]
                                                                  rightNavigationItem:@"Pay"
                                                             warningMessageBeforeBack:@"Please continue with the payment after you finished the form."
                                                                             callback:^(NSError *error) {
                                                                                 NSLog(@"Did pay for feed");
                                                                                 [self pay];
                                                                                 self.webViewController.didCompleteCallback = YES;
                                                                                     [[IPEventTracker sharedInstance] onRegisterClass:self.feed];

                                                                             }];
    }
    [self.navigationController pushViewController:self.webViewController animated:YES];
}

- (void)didVolunteer:(PFObject *)feed {
    NSString *urlAddress = [feed objectForKey:@"volunteerUrl"];
    NSLog(@"Did volunteer feed");
    //[self openWebLink:urlAddress title:[feed objectForKey:@"title"]];
    
    if(!self.webViewController) {
        self.webViewController = [[IPWebViewController alloc] initWithUrl:urlAddress title:[feed objectForKey:@"title"] rightNavigationItem:@"Done" warningMessageBeforeBack:nil callback:^(NSError *error) {
            self.webViewController.didCompleteCallback = YES;
            
            [[IPEventTracker sharedInstance] onVolunteerEvent:self.feed];
            
            //TODO : need confirmation of rsvp process
            [self createFeedActivity:@"volunteered"];
        }];
    }
    [self.navigationController pushViewController:self.webViewController animated:YES];

}


- (void)openWebLink:(NSString *)urlStr title:(NSString *) title {
    NSLog(@"opening web link: %@", urlStr);
    if(!self.webViewController) {
        self.webViewController = [[IPWebViewController alloc] initWithUrl:urlStr title:title rightNavigationItem:@"Done" warningMessageBeforeBack:nil callback:^(NSError *error) {
            self.webViewController.didCompleteCallback = YES;
        }];
    }
    [self.navigationController pushViewController:self.webViewController animated:YES];
}

#pragma mark PayPal Payment integration stuff

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.payPalConfig = [[PayPalConfiguration alloc] init];
		
		// See PayPalConfiguration.h for details and default values.
		// Should you wish to change any of the values, you can do so here.
		// For example, if you wish to accept PayPal but not payment card payments, then add:
		self.payPalConfig.acceptCreditCards = YES;
		// Or if you wish to have the user choose a Shipping Address from those already
		// associated with the user's PayPal account, then add:
		self.payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
	}
	return self;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// Start out working with the test environment! When you are ready, switch to PayPalEnvironmentProduction.
	//[PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];
	[PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
}

- (void)pay {
	// Remove our last completed payment, just for demo purposes.
	self.resultText = nil;
	
	// Note: For purposes of illustration, this example shows a payment that includes
	//       both payment details (subtotal, shipping, tax) and multiple items.
	//       You would only specify these if appropriate to your situation.
	//       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
	//       and simply set payment.amount to your total charge.
	
	// Optional: include multiple items
	PayPalItem *item1 = [PayPalItem itemWithName:@"Course"
									withQuantity:1
									   withPrice:[NSDecimalNumber decimalNumberWithString:@"0.99"]
									withCurrency:@"USD"
										 withSku:@"Inneract-01"];
	
	NSArray *items = @[item1];
	NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
	
	// Optional: include payment details
	NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.00"];
	NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@".09"];
	PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
																			   withShipping:shipping
																					withTax:tax];
	
	NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
	
	PayPalPayment *payment = [[PayPalPayment alloc] init];
	payment.amount = total;
	payment.currencyCode = @"USD";
	payment.shortDescription = @"Final Cost";
	payment.items = items;  // if not including multiple items, then leave payment.items as nil
	payment.paymentDetails = paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
	
	if (!payment.processable) {
		// This particular payment will always be processable. If, for
		// example, the amount was negative or the shortDescription was
		// empty, this payment wouldn't be processable, and you'd want
		// to handle that here.
	}
	
	// Update payPalConfig re accepting credit cards.
	self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
	
	PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
										configuration:self.payPalConfig
										delegate:self];
	[self presentViewController:paymentViewController animated:YES completion:nil];
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
	NSLog(@"PayPal Payment Success!");
	self.resultText = [completedPayment description];
	[self showSuccess];
	
	[self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [[[UIAlertView alloc] initWithTitle:@"Transaction complete" message:@"Complete" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
	//[self dismissViewControllerAnimated:YES completion:nil];
    
    self.webViewController.didCompleteCallback = YES;
    [self createFeedActivity:@"registered"];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
	NSLog(@"PayPal Payment Canceled");
	self.resultText = nil;
	self.successView.hidden = YES;
	[self dismissViewControllerAnimated:YES completion:nil];
    
    self.webViewController.didCompleteCallback = NO;
}

#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
	// TODO: Send completedPayment.confirmation to server
	NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
}

#pragma mark - Helpers

- (void)showSuccess {
	self.successView.hidden = NO;
	self.successView.alpha = 1.0f;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelay:2.0];
	self.successView.alpha = 0.0f;
	[UIView commitAnimations];
}

#pragma mark - private methods

- (void) createFeedActivity:(NSString *) action {
    PFObject *activity = [PFObject objectWithClassName:@"Activity"];
    activity[@"userId"] = [PFUser currentUser].objectId;
    activity[@"event"] = self.feed;
    activity[@"action"] = action;
    
    [activity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            self.feedActivity = activity;
            
            [self.tableView reloadData];
        }
    }];
}

@end
