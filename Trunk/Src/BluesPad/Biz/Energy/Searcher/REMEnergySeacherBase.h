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
#import "REMBusinessErrorInfo.h"
#import "REMEnergyViewData.h"
#import "REMWidgetObject.h"

@interface REMEnergySeacherBase : NSObject

@property (nonatomic,weak) REMWidgetObject *widgetInfo;

+ (REMEnergySeacherBase *)querySearcherByType:(REMDataStoreType) storeType withWidgetInfo:(REMWidgetObject *)widgetInfo;

- (void)queryEnergyDataByStoreType:(REMDataStoreType)storeType andParameters:(NSDictionary *)params withMaserContainer:(UIView *)maskerContainer andGroupName:(NSString *)groupName callback:(void(^)(id,REMBusinessErrorInfo *))callback;

- (REMEnergyViewData *)processEnergyData:(NSDictionary *)rawData;

@end
