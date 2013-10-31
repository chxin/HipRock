//
//  REMCommodityModel.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 8/1/13.
//
//

#import <Foundation/Foundation.h>
#import "REMCommonHeaders.h"

@interface REMCommodityModel : REMJSONObject

@property (nonatomic,strong) NSNumber *commodityId;
@property (nonatomic,strong) NSString *name,*code,*comment;

+(NSDictionary *)systemCommodities;

@end
