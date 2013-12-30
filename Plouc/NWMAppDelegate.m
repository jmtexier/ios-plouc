//
//  NWMAppDelegate.m
//  Plouc
//
//  Created by Jean-Michel TEXIER on 29/12/13.
//  Copyright (c) 2013 Jean-Michel TEXIER. All rights reserved.
//

#import "NWMAppDelegate.h"
#import "NWMMenuViewController.h"

@interface NWMAppDelegate ()

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) NWMMenuViewController *menuVC;

@end

@implementation NWMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"Application did finish launch");
    
    //  Build main window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    // Add navigation control and set-up first screen (menu)
    self.menuVC = [[NWMMenuViewController alloc] init];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.menuVC];
    self.window.rootViewController = self.navigationController;

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"Application will resign active");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Application did enter background");
    
    // Store state information for restoration

    // Save user data
    
    // Release resources
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"Application will enter foreground");

    // Re-create resources
    
    // Load user data

    // Restore state information
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"Application did become active");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"Application will terminate");
    self.navigationController = nil;
    self.menuVC = nil;
}

@end
