//
//  REMWidgetWrapper.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/11/13.
//
//

#import "REMAbstractChartWrapper.h"
typedef enum {
    REMWidgetStatusMinimized,
    REMWidgetStatusMaximized
} REMWidgetStatus;

@interface REMWidgetWrapper : REMAbstractChartWrapper
@property (nonatomic, readonly)REMWidgetStatus status;
-(REMWidgetWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax status:(REMWidgetStatus)status;
@end
