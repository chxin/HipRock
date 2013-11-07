/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMAbstractChartWrapper.h
 * Created      : Zilong-Oscar.Xu on 9/27/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMChartHeader.h"
#import "REMEnergyViewData.h"
#import "REMWidgetContentSyntax.h"

@interface REMAbstractChartWrapper : NSObject {
@protected REMTrendChartDataProcessor* sharedProcessor;
}

-(REMAbstractChartWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax styleDictionary:(NSDictionary*)style;
-(void)destroyView;
-(void)redraw:(REMEnergyViewData *)energyViewData;
-(void)extraSyntax:(REMWidgetContentSyntax*)widgetSyntax;
@property (nonatomic, readonly) UIView* view;
//@property (nonatomic, readonly, weak) REMWidgetContentSyntax* widgetSyntax;
@property (nonatomic, readonly, weak) REMEnergyViewData* energyViewData;

//@property (nonatomic, readonly) REMChartDataProcessor* dataProcessor;

@end
