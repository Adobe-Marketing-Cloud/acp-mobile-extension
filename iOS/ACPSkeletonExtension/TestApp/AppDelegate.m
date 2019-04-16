/*
 ADOBE CONFIDENTIAL
 
 Copyright 2019 Adobe
 All Rights Reserved.
 
 NOTICE: Adobe permits you to use, modify, and distribute this file in
 accordance with the terms of the Adobe license agreement accompanying
 it. If you have received this file from a source other than Adobe,
 then your use, modification, or distribution of it requires the prior
 written permission of Adobe.
 */

#import "AppDelegate.h"
#import "ACPCore.h"
#import "ACPIdentity.h"
#import "ACPLifecycle.h"
#import "ACPSignal.h"
#import "SkeletonExtensionPublicApi.h"

// set the environment id associated with your Launch mobile property
static NSString *const LaunchEnvironmentId = @"";

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ACPCore setLogLevel:ACPMobileLogLevelDebug];
    [ACPCore configureWithAppId:LaunchEnvironmentId];

    
    // register Adobe core extensions
    [ACPIdentity registerExtension];
    [ACPLifecycle registerExtension];
    [ACPSignal registerExtension];
    
    // register the extension
    [SkeletonExtensionPublicApi registerExtension];
    
    // after registering all the extensions, call ACPCore start to start procesing events in the Event Hub
    [ACPCore start:^{
        NSLog(@"Mobile SDK as initialized");
        
        // Uncomment updateConfiguration call if LaunchEnvironmentId is not set to initialize Configuration extension
        [ACPCore updateConfiguration:@{@"global.privacy":@"optedin"}];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateBackground) {
                [ACPCore lifecycleStart:nil];
            }
        });
    }];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [ACPCore lifecyclePause];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [ACPCore lifecycleStart:nil];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
