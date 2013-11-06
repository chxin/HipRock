/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMNetworkHelper.m
 * Created      : zhangfeng on 7/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
