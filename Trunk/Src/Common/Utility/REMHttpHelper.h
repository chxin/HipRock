/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMNetworkHelper.h
 * Created      : zhangfeng on 7/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
//#import "Reachability.h"

@interface REMHttpHelper : NSObject

//+ (NetworkStatus) checkCurrentNetworkStatus;
//
//+ (BOOL) checkIsWifi;
//
//+ (BOOL) checkIs3G;
//
//+ (BOOL) checkIsNoConnect;

+ (NSString *)parameterStringByObject:(id)object;

@end
