//
//  REMEnergySeacherBase.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 10/9/13.
//
//

#import <Foundation/Foundation.h>
#import "REMEnum.h"
#import "REMWidgetContentSyntax.h"

@interface REMEnergySeacherBase : NSObject

+ (REMEnergySeacherBase *)querySearcherByType:(REMDataStoreType) storeType;

- (void)queryEnergyDataByStoreType:(REMDataStoreType)storeType andParameters:(NSDictionary *)params withMaserContainer:(UIView *)maskerContainer andGroupName:(NSString *)groupName callback:(void(^)(id))callback;


@end
