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
#import "REMWidgetDetailViewController.h"
#import "REMManagedWidgetModel.h"

@interface REMWidgetBizDelegatorBase : NSObject

@property (nonatomic,weak) REMManagedWidgetModel *widgetInfo;
@property (nonatomic,strong) REMWidgetContentSyntax *contentSyntax;
@property (nonatomic,strong) REMEnergyViewData *energyData;
@property (nonatomic,weak) UIView *view;
@property (nonatomic,strong) REMEnergySeacherBase *searcher;
@property (nonatomic,strong) REMWidgetSearchModelBase *model;
@property (nonatomic,strong) REMWidgetSearchModelBase *tempModel;
@property (nonatomic,strong) NSString *groupName;
@property (nonatomic,weak) UIView *maskerView;
@property (nonatomic,weak) REMWidgetDetailViewController *ownerController;
@property (nonatomic,copy) NSString *status;
@property (nonatomic,weak) UIView *chartContainer;

+ (REMWidgetBizDelegatorBase *)bizDelegatorByWidgetInfo:(REMManagedWidgetModel *)widgetInfo andSyntax:(REMWidgetContentSyntax *)contentSyntax;

- (void) initBizView;

- (void) doSearchWithModel:(REMWidgetSearchModelBase *)model callback:(void(^)(REMEnergyViewData *data,REMBusinessErrorInfo *error))callback;

- (void)searchData:(REMWidgetSearchModelBase *)model;

- (void)rollbackWithError:(REMBusinessErrorInfo *)error;

- (void)processEnergyDataInnerError:(id)data;

- (void)reloadChart;

- (void) showChart;

- (void) showPopupMsg:(NSString *)msg;
- (void) hidePopupMsg;

-(void) releaseChart;

- (BOOL) shouldPinToBuildingCover;

- (BOOL) shouldEnablePinToBuildingCoverButton;

- (CGFloat) xPositionForPinToBuildingCoverButton;

- (void)mergeTempModel;


@end
