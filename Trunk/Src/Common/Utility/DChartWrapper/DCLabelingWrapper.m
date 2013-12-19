//
//  DCLabelingWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 12/16/13.
//
//

#import "DCLabelingWrapper.h"
#import "DCLabelingChartView.h"
#import "DCLabelingSeries.h"
#import "DCLabelingLabel.h"
#import "REMColor.h"

@interface DCLabelingWrapper()
@property (nonatomic, strong) DCLabelingChartView* view;
@end

@implementation DCLabelingWrapper
-(DAbstractChartWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax style:(REMChartStyle*)style {
    self = [super initWithFrame:frame data:energyViewData widgetContext:widgetSyntax style:style];
    if (self && energyViewData.labellingLevelArray.count != 0) {
        self.view = [self createView:frame];
    }
    return self;
}

-(DCLabelingChartView*)createView:(CGRect)frame {
    DCLabelingChartView *view = [[DCLabelingChartView alloc]initWithFrame:frame];
    NSArray* textArray = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L"];
    DCLabelingSeries* s = [[DCLabelingSeries alloc]init];
    NSMutableArray* stages = [[NSMutableArray alloc]initWithCapacity:self.energyViewData.targetEnergyData.count];
    for (int i = 0; i < self.energyViewData.labellingLevelArray.count; i++) {
        REMEnergyLabellingLevelData* d = self.energyViewData.labellingLevelArray[i];
        DCLabelingStage* stage = [[DCLabelingStage alloc]init];
        stage.stageText = textArray[i];
        stage.color = [REMColor getLabelingColor:i stageCount:self.energyViewData.labellingLevelArray.count];
        BOOL minValueNil = REMIsNilOrNull(d.minValue);
        BOOL maxValueNil = REMIsNilOrNull(d.maxValue);
        if (minValueNil && maxValueNil) {
            stage.tooltipText = REMEmptyString;
        } else if (minValueNil && !maxValueNil) {
            stage.tooltipText = [NSString stringWithFormat:@"%@%@%@", REMLocalizedString(@"Chart_Labeling_LessThan"), d.maxValue.stringValue, d.uom];
        } else if(!minValueNil && maxValueNil) {
            stage.tooltipText = [NSString stringWithFormat:@"%@%@%@", REMLocalizedString(@"Chart_Labeling_MoreThan"), d.minValue.stringValue, d.uom];
        } else {
            stage.tooltipText = [NSString stringWithFormat:@"%@-%@%@", d.minValue.stringValue, d.maxValue.stringValue, d.uom];
        }
        [stages addObject:stage];
    }
    s.stages = stages;
    
    NSMutableArray* labels = [[NSMutableArray alloc]init];
    for (REMTargetEnergyData* targetEnergyData in self.energyViewData.targetEnergyData) {
        if (REMIsNilOrNull(targetEnergyData.energyData) || targetEnergyData.energyData.count == 0) continue;
        REMEnergyData* energyData = targetEnergyData.energyData[0];
        if (REMIsNilOrNull(energyData.dataValue)) continue;
        for (int i = 0; i < stages.count; i++) {
            REMEnergyLabellingLevelData* d = self.energyViewData.labellingLevelArray[i];
            if ((REMIsNilOrNull(d.minValue) || [d.minValue compare:energyData.dataValue]!=NSOrderedDescending) &&
                (REMIsNilOrNull(d.maxValue) || [d.maxValue compare:energyData.dataValue]==NSOrderedDescending)) {
                DCLabelingLabel* label = [[DCLabelingLabel alloc]init];
                label.name = targetEnergyData.target.name;
                label.color = [stages[i] color];
                label.stageText = [stages[i] stageText];
                label.labelText = [NSString stringWithFormat:@"%ld%@", (long)energyData.dataValue.integerValue, d.uom];
                label.stage = i;
                [labels addObject:label];
                break;
            }
        }
    }
    s.labels = labels;
    view.paddingRight = self.style.plotPaddingRight;
    view.paddingLeft = self.style.plotPaddingLeft;
    view.paddingTop = self.style.plotPaddingTop;
    view.paddingBottom = self.style.plotPaddingBottom;
    view.lineWidth = self.style.labelingLineWidth;
    view.lineColor = self.style.labelingLineColor;
    view.fontName = self.style.labelingFontName;
    view.tooltipArcLineWidth = self.style.labelingTooltipArcLineWidth;
    view.series = s;
    view.delegate = self;
    return view;
}

-(UIView*)getView {
    return self.view;
}

-(void)redraw:(REMEnergyViewData *)energyViewData {
    [super redraw:energyViewData];
    CGRect frame = self.view.frame;
    UIView* superView = self.view.superview;
    [self.view removeFromSuperview];
    
    self.view = [self createView:frame];
    [superView addSubview:self.view];
}
@end
