//
//  AppDelegate.m
//  Inneract
//
//  Created by Emmanuel Texier on 3/4/15.
//  Copyright (c) 2015 Emmanuel Texier. All rights reserved.
//

#import "AppDelegate.h"
#import "LandingViewController.h"
#import "LoginViewController.h"
#import "JoinUsViewController.h"
#import "EditProfileViewController.h"
#import "FeedsViewController.h"
#import "MainViewHelper.h"

#import <Parse/Parse.h>
#import <ParseCrashReporting/ParseCrashReporting.h>
#import <FacebookSDK/FacebookSDK.h>
#import <PayPalMobile.h>

//Parse Keys
NSString *kParseApplicationId = @"fqoCAqnAX9dcjrJSpxENnHsOkt1WTuFv8aJhfPH6";
NSString *kParseClientKey = @"YQiC2C7HYWIz6rZOjYWDe0jDwGjvc3CD4FtplZsr";

//PayPal Keys
NSString *kPayPalClientId = @"AYIrAAhanrQ2f5I5oE1ks213YFi4Y5YVxXLZE8VwBN94idvUZ3NfIQeRv2z75ilRdLiRFXCK6V39z9XC";
NSString *kPayPalSecretId = @"EL5ZgD8cf34aiM3rQX4EH0g_xpAR-HaBr7B5W9nVl73zfMLVRJDT1wiX_RWzjJRxgjcUXLU4qEhiMslG";
NSString *kPayPalProductionClientId = @"AXd22k12t_s4V9k7K-07Dgdo60mdat9uib7Zi9id3tkoFoF2XzUwqUsZ7gIRv4OQHFYjdYicSiiMt__B";




@interface AppDelegate ()

@end



@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // init parse
    [self parseInit:launchOptions];
	// Override point for customization after application launch.
	[FBLoginView class];

	[PayPalMobile initializeWithClientIdsForEnvironments:@{
		PayPalEnvironmentSandbox : kPayPalClientId,
		PayPalEnvironmentProduction : kPayPalProductionClientId}];
	
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout) name:@"UserDidLogoutNotification" object:nil];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
	
    PFUser *currentUser = [PFUser currentUser];
    if(!currentUser) {
        self.window.rootViewController = [[LandingViewController alloc] init];
    } else {
        self.window.rootViewController = [MainViewHelper setupMainViewTabBar];
    }
	//self.window.rootViewController = [[JoinUsViewController alloc] init];
	//self.window.rootViewController = [[LoginViewController alloc] init];
	//self.window.rootViewController = [[EditProfileViewController alloc] init];

     //[[UINavigationBar appearance] setBackIndicatorImage:[[UIImage imageNamed:@"backArrowIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];


    [self.window makeKeyAndVisible];
    
    // For push notification
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    
    return YES;
}

# pragma mark - Parse
- (void)parseInit:(NSDictionary *)launchOptions {
    [ParseCrashReporting enable];
    [Parse setApplicationId:kParseApplicationId clientKey:kParseClientKey];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current Installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void) userDidLogout {
    self.window.rootViewController = [[LandingViewController alloc] init];
}

#pragma mark -

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	// Logs 'install' and 'app activate' App Events.
	[FBAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
			openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
		 annotation:(id)annotation {
	
	// attempt to extract a token from the url
	return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

@end
