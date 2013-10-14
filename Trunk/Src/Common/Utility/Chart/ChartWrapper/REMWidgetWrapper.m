//
//  REMWidgetWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/11/13.
//
//

#import "REMWidgetWrapper.h"

@implementation REMWidgetWrapper

-(REMWidgetWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax {
    return [self initWithFrame:frame data:energyViewData widgetContext:widgetSyntax status:REMWidgetStatusMinimized];
}
-(REMWidgetWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax status:(REMWidgetStatus)status {
    _status = status;
    self = [super initWithFrame:frame data:energyViewData widgetContext:widgetSyntax];
    return self;
}
@end
