/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergySeacherBase.h
 * Created      : tantan on 10/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMEnum.h"
#import "REMWidgetContentSyntax.h"

@interface REMEnergySeacherBase : NSObject

+ (REMEnergySeacherBase *)querySearcherByType:(REMDataStoreType) storeType;

- (void)queryEnergyDataByStoreType:(REMDataStoreType)storeType andParameters:(NSDictionary *)params withMaserContainer:(UIView *)maskerContainer andGroupName:(NSString *)groupName callback:(void(^)(id))callback;


@end
