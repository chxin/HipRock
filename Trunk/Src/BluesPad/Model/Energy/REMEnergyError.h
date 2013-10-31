//
//  REMEnergyError.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 谭 坦 on 7/16/13.
//
//

#import <Foundation/Foundation.h>
#import "REMJSONObject.h"

@interface REMEnergyError : REMJSONObject

@property (nonatomic,strong) NSString *errorCode;

@property (nonatomic,strong) NSArray *params;

@end
