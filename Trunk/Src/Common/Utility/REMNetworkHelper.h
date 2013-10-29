//
//  REMNetworkHelper.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by zhangfeng on 7/4/13.
//
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface REMNetworkHelper : NSObject

+ (NetworkStatus) checkCurrentNetworkStatus;

+ (BOOL) checkIsWifi;

+ (BOOL) checkIs3G;

+ (BOOL) checkIsNoConnect;

@end
