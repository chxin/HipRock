//
//  REMAbstractChartWrapper.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/27/13.
//
//

#import <Foundation/Foundation.h>
#import "REMChartHeader.h"
#import "REMEnergyViewData.h"
#import "REMWidgetContentSyntax.h"

@interface REMAbstractChartWrapper : NSObject {
@protected REMTrendChartDataProcessor* sharedProcessor;
}

-(REMAbstractChartWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax styleDictionary:(NSDictionary*)style;
-(void)destroyView;

@property (nonatomic, readonly) UIView* view;
@property (nonatomic, readonly, weak) REMWidgetContentSyntax* widgetSyntax;
@property (nonatomic, readonly, weak) REMEnergyViewData* energyViewData;

//@property (nonatomic, readonly) REMChartDataProcessor* dataProcessor;

@end
