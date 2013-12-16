/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMNetworkStatusIndicator.h
 * Created      : 张 锋 on 10/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>

@interface REMNetworkStatusIndicator : NSObject

+(REMNetworkStatusIndicator *)sharedManager;
-(void)increaseActivity;
-(void)decreaseActivity;
-(void)noActivity;

@end
