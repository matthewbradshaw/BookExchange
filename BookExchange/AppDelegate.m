//
//  AppDelegate.m
//  BookExchange
//
//  Created by Fiaz Sami on 2/15/15.
//  Copyright (c) 2015 collecdev. All rights reserved.
//

#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"" clientKey:@""];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    //Customize TabBar Appearance
    [[UITabBar appearance] setBarTintColor: [UIColor colorWithRed:216/255.0
                                                            green:216/255.0
                                                             blue:216/255.0
                                                            alpha:1]];

    [[UITabBar appearance] setTintColor: [UIColor colorWithRed:8/255.0
                                                         green:18/255.0
                                                          blue:114/255.0
                                                         alpha: 1]];


    [[UINavigationBar appearance] setTintColor: [UIColor colorWithRed:168/255.0
                                                                green:181/255.0
                                                                 blue:197/255.0
                                                                alpha: 1]];


    return YES;
}

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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end