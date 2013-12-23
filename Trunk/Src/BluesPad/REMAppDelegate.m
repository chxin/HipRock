/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMAppDelegate.m
 * Created      : zhangfeng on 6/26/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMAppDelegate.h"
#import "REMLog.h"
#import "REMStorage.h"
#import "REMApplicationInfo.h"
#import "WeiboSDK.h"
#import <GoogleMaps/GoogleMaps.h>

//comment

#define kWeiboAppKey @"216981675"
#define kWeiboAppSecret @"6e25a0619b4431091ce0b663f4c479c8"
#define kGoogleMapsKey @"AIzaSyAQRlAzROZjk_Z_J50nDGeytcnDUp57czw"

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
    
    // App info init
    [REMApplicationInfo initApplicationInfo];
    
    //[REMStorage clearSessionStorage];
    
    // Weibo app key init
    Weibo *weibo = [[Weibo alloc] initWithAppKey:kWeiboAppKey withAppSecret:kWeiboAppSecret];
    [Weibo setWeibo:weibo];
    
    // Google key init
    [GMSServices provideAPIKey:kGoogleMapsKey];
    
//#ifndef DEBUG
//    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
//    
//    // Read from document directory
//    NSMutableDictionary *settingsItem = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
//    
//    BOOL shouldCleanCache=(BOOL)[settingsItem[@"shouldCleanCache"] boolValue];
//    
//    if (shouldCleanCache==YES) {
//        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        NSFileManager *fileManager=[NSFileManager defaultManager];
//        
//    }
//    
//#endif
    
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError * error;
    NSArray *imgArray= [fileManager contentsOfDirectoryAtPath:documents error:&error];
    for (NSString *path in imgArray) {
        if ([path.pathExtension isEqualToString:@"png"]==YES) {
            NSString *fullPath=[documents stringByAppendingPathComponent:path];
            [fileManager removeItemAtPath:fullPath error:&error];
        }
    }
    
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
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    REMLogWarn(@"REM memory warning..");
}

@end
