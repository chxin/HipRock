//
//  DChartColumnWrapper.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/18/13.
//
//

#import <Foundation/Foundation.h>
#import "DCXYChartView.h"
#import "REMChartStyle.h"
#import "REMEnergyViewData.h"
#import "REMWidgetContentSyntax.h"
#import "DCColumnSeries.h"
#import "DCLineSeries.h"
#import "DCContext.h"

@interface DChartColumnWrapper : NSObject
@property (nonatomic, readonly) DCXYChartView* view;
@property (nonatomic, readonly, weak) REMEnergyViewData* energyViewData;
-(DChartColumnWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax style:(REMChartStyle*)style;
@end
