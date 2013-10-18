//
//  REMNetworkHelper.h
//  Blues
//
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
