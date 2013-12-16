//
//  DCLabelingWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/16/13.
//
//

#import "DCLabelingWrapper.h"
#import "DCLabelingChartView.h"

@interface DCLabelingWrapper()
@property (nonatomic, strong) DCLabelingChartView* view;
@end

@implementation DCLabelingWrapper
-(DAbstractChartWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax style:(REMChartStyle*)style {
    self = [super initWithFrame:frame data:energyViewData widgetContext:widgetSyntax style:style];
    if (self && energyViewData.labellingLevelArray.count != 0) {
        self.view = [[DCLabelingChartView alloc]initWithFrame:frame];
        self.view.delegate = self;
    }
    return self;
}

-(NSUInteger)getStageCount {
    return self.energyViewData.labellingLevelArray.count;
}

-(NSUInteger)getLabelCount {
    return self.energyViewData.targetEnergyData.count;
}
@end
