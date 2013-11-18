/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetBizDelegatorBase.h
 * Created      : tantan on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMEnum.h"
#import "REMEnergyViewData.h"
#import "REMWidgetObject.h"
#import "REMEnergySeacherBase.h"
#import "REMWidgetSearchModelBase.h"
#import "REMBusinessErrorInfo.h"

@interface REMWidgetBizDelegatorBase : NSObject

@property (nonatomic,weak) REMWidgetObject *widgetInfo;
@property (nonatomic,strong) REMEnergyViewData *energyData;
@property (nonatomic,weak) UIView *view;
@property (nonatomic,strong) REMEnergySeacherBase *searcher;
@property (nonatomic,strong) REMWidgetSearchModelBase *model;
@property (nonatomic,strong) NSString *groupName;
@property (nonatomic,weak) UIView *maskerView;

+ (REMWidgetBizDelegatorBase *)bizDelegatorByWidgetInfo:(REMWidgetObject *)widgetInfo;

- (void) initBizView;

- (void) doSearchWithModel:(REMWidgetSearchModelBase *)model callback:(void(^)(REMEnergyViewData *data,REMBusinessErrorInfo *error))callback;

- (void) showChart;

-(void) releaseChart;


@end
