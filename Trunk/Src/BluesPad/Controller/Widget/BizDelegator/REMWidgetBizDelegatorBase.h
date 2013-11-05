//
//  REMWidgetBizDelegatorBase.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/4/13.
//
//

#import <Foundation/Foundation.h>
#import "REMEnum.h"
#import "REMEnergyViewData.h"
#import "REMWidgetObject.h"
#import "REMEnergySeacherBase.h"
#import "REMWidgetSearchModelBase.h"
#import "REMError.h"

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

- (void) doSearch:(void(^)(REMEnergyViewData *data,REMError *error))callback;

- (void) showChart;


@end
