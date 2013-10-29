//
//  REMNetworkStatusIndicator.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 10/9/13.
//
//

#import <Foundation/Foundation.h>

@interface REMNetworkStatusIndicator : NSObject

+(REMNetworkStatusIndicator *)sharedManager;
-(void)increaseActivity;
-(void)decreaseActivity;
-(void)noActivity;

@end
