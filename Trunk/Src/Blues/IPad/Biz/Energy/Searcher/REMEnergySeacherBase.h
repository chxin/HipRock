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
#import "REMWidgetSearchModelBase.h"
#import "REMManagedWidgetModel.h"

typedef enum _REMEnergySearcherLoadingType{
    REMEnergySearcherLoadingTypeSmall,
    REMEnergySearcherLoadingTypeLarge
} REMEnergySearcherLoadingType;

@interface REMEnergySeacherBase : NSObject

@property (nonatomic,weak) REMManagedWidgetModel *widgetInfo;
@property (nonatomic,strong) REMWidgetContentSyntax *contentSyntax;
@property (nonatomic,weak) REMWidgetSearchModelBase *model;
@property (nonatomic) BOOL disableNetworkAlert;

@property (nonatomic,strong) UIActivityIndicatorView *loadingView;
@property (nonatomic,strong) UIView *loadingBackgroundView;
@property (nonatomic) REMEnergySearcherLoadingType loadingType;


+ (REMEnergySeacherBase *)querySearcherByType:(REMDataStoreType) storeType withWidgetInfo:(REMManagedWidgetModel *)widgetInfo andSyntax:(REMWidgetContentSyntax *)contentSyntax;

- (void)queryEnergyDataByStoreType:(REMDataStoreType)storeType andParameters:(REMWidgetSearchModelBase *)model withMaserContainer:(UIView *)maskerContainer andGroupName:(NSString *)groupName callback:(void(^)(id,REMBusinessErrorInfo *))callback;

- (REMEnergyViewData *)processEnergyData:(NSDictionary *)rawData;

- (REMBusinessErrorInfo *)beforeSendRequest;

@end
