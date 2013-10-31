//
//  REMNetworkHelper.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
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
    return [REMNetworkHelper checkCurrentNetworkStatus] == ReachableViaWWAN;
}

+ (BOOL) checkIsNoConnect
{
    return [REMNetworkHelper checkCurrentNetworkStatus] == NotReachable;
}

@end
