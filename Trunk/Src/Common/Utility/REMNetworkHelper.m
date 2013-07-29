//
//  REMNetworkHelper.m
//  Blues
//
//  Created by zhangfeng on 7/4/13.
//
//

#import "REMNetworkHelper.h"
#import "Reachability.h"

@implementation REMNetworkHelper


+ (NetworkStatus) checkCurrentNetworkStatus
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    return [reachability currentReachabilityStatus];
}

+ (BOOL) checkIsWifi
{
    return [REMNetworkHelper checkCurrentNetworkStatus] == ReachableViaWiFi;
}

+ (BOOL) checkIs3G
{
    return [REMNetworkHelper checkCurrentNetworkStatus] == ReachableViaWWAN3G;
}

+ (BOOL) checkIs2G
{
    return [REMNetworkHelper checkCurrentNetworkStatus] == ReachableViaWWAN2G;
}

+ (BOOL) checkIsNoConnect
{
    return [REMNetworkHelper checkCurrentNetworkStatus] == NotReachable;
}

@end
