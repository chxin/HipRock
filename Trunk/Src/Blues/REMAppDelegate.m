/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMAppDelegate.m
 * Created      : zhangfeng on 6/26/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMAppDelegate.h"
#import "REMLog.h"
#import "Weibo.h"
#import <GoogleMaps/GoogleMaps.h>
#import "REMCommonHeaders.h"
#import "UIKit+AFNetworking.h"
#import "REMVendorMacro.h"


@implementation REMAppDelegate

+ (REMAppDelegate *) app
{
    return [[UIApplication sharedApplication] delegate];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Log init
    [REMLog bind];
    
    // Recover login info
    [REMApplicationContext recover];
    
    // Weibo app key init
    Weibo *weibo = [[Weibo alloc] initWithAppKey:kWeiboAppKey withAppSecret:kWeiboAppSecret];
    [Weibo setWeibo:weibo];
    
    // Google key init
    [GMSServices provideAPIKey:kGoogleMapsKey];
    
    return YES;
}



							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //[REMStorage clearOnApplicationActive];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = REMAppContext.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    REMLogWarn(@"REM memory warning..");
}







@end
