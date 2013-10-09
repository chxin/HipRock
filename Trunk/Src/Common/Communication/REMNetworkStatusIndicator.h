//
//  REMNetworkStatusIndicator.h
//  Blues
//
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
