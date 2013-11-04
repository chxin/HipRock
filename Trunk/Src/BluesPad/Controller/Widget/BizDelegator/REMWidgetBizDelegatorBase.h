//
//  REMWidgetBizDelegatorBase.h
//  Blues
//
//  Created by tantan on 11/4/13.
//
//

#import <Foundation/Foundation.h>
#import "REMEnum.h"
#import "REMEnergyViewData.h"
#import "REMWidgetObject.h"


@interface REMWidgetBizDelegatorBase : NSObject

@property (nonatomic,weak) REMWidgetObject *widgetInfo;
@property (nonatomic,strong) REMEnergyViewData *energyData;
@property (nonatomic,weak) UIView *view;

+ (REMWidgetBizDelegatorBase *)bizDelegatorByWidgetInfo:(REMWidgetObject *)widgetInfo;

- (void) initBizView;

@end
