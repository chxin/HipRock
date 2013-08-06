//
//  REMCommodityModel.h
//  Blues
//
//  Created by 张 锋 on 8/1/13.
//
//

#import <Foundation/Foundation.h>
#import "REMCommonHeaders.h"

@interface REMCommodityModel : REMJSONObject

@property (nonatomic,strong) NSNumber *commodityId;
@property (nonatomic,strong) NSString *name,*code,*comment;

@end
