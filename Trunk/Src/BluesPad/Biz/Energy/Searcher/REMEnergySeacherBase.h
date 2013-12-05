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
#import "REMWidgetSearchModelBase.h"

@interface REMEnergySeacherBase : NSObject

@property (nonatomic,weak) REMWidgetObject *widgetInfo;
@property (nonatomic,weak) REMWidgetSearchModelBase *model;

@property (nonatomic,strong) UIActivityIndicatorView *loadingView;
@property (nonatomic,strong) UIView *loadingBackgroundView;

+ (REMEnergySeacherBase *)querySearcherByType:(REMDataStoreType) storeType withWidgetInfo:(REMWidgetObject *)widgetInfo;

- (void)queryEnergyDataByStoreType:(REMDataStoreType)storeType andParameters:(REMWidgetSearchModelBase *)model withMaserContainer:(UIView *)maskerContainer andGroupName:(NSString *)groupName callback:(void(^)(id,REMBusinessErrorInfo *))callback;

- (REMEnergyViewData *)processEnergyData:(NSDictionary *)rawData;

- (REMBusinessErrorInfo *)beforeSendRequest;

@end
