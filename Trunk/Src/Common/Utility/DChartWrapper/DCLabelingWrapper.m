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
#import "REMNumberHelper.h"
#import "DCLabelingLabel.h"
#import "REMColor.h"

@interface DCLabelingWrapper()
@property (nonatomic, strong) DCLabelingChartView* view;
@property (nonatomic, strong) NSString* benckmarkText;
@end

@implementation DCLabelingWrapper
-(DAbstractChartWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData wrapperConfig:(DWrapperConfig *)wrapperConfig style:(DCChartStyle *)style {
    self = [super initWithFrame:frame data:energyViewData wrapperConfig:wrapperConfig style:style];
    NSString* format = REMIPadLocalizedString(@"Chart_Labeling_EffecioncyTextFormat");
    self.benckmarkText = REMIsNilOrNull(wrapperConfig.benckmarkText) ? REMEmptyString : [NSString stringWithFormat:format, wrapperConfig.benckmarkText];
    if (self && energyViewData.labellingLevelArray.count != 0) {
        self.view = [self createView:frame];
    }
    return self;
}

-(DCLabelingChartView*)createView:(CGRect)frame {
    DCLabelingChartView *view = [[DCLabelingChartView alloc]initWithFrame:frame];
    NSArray* textArray = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L"];
    DCLabelingSeries* s = [[DCLabelingSeries alloc]init];
    s.benchmarkText = self.benckmarkText;
    NSMutableArray* stages = [[NSMutableArray alloc]initWithCapacity:self.energyViewData.targetEnergyData.count];
    for (int i = 0; i < self.energyViewData.labellingLevelArray.count; i++) {
        REMEnergyLabellingLevelData* d = self.energyViewData.labellingLevelArray[i];
        DCLabelingStage* stage = [[DCLabelingStage alloc]init];
        stage.stageText = textArray[i];
        stage.color = [REMColor getLabelingColor:i stageCount:(int)self.energyViewData.labellingLevelArray.count];
        BOOL minValueNil = REMIsNilOrNull(d.minValue);
        BOOL maxValueNil = REMIsNilOrNull(d.maxValue);
        if (minValueNil && maxValueNil) {
            stage.tooltipText = REMEmptyString;
        } else if (minValueNil && !maxValueNil) {
            stage.tooltipText = [NSString stringWithFormat:@"%@%@%@", REMIPadLocalizedString(@"Chart_Labeling_LessOrEqualThan"), [REMNumberHelper formatDataValueWithCarry:d.maxValue], d.uom];
        } else if(!minValueNil && maxValueNil) {
            stage.tooltipText = [NSString stringWithFormat:@"%@%@%@", REMIPadLocalizedString(@"Chart_Labeling_MoreThan"), [REMNumberHelper formatDataValueWithCarry:d.minValue], d.uom];
        } else {
            stage.tooltipText = [NSString stringWithFormat:@"%@%@ - %@%@", [REMNumberHelper formatDataValueWithCarry:d.minValue], d.uom, [REMNumberHelper formatDataValueWithCarry:d.maxValue], d.uom];
        }
        [stages addObject:stage];
    }
    s.stages = stages;
    
    NSMutableArray* labels = [[NSMutableArray alloc]init];
    for (REMTargetEnergyData* targetEnergyData in self.energyViewData.targetEnergyData) {
        REMEnergyData* energyData = nil;
        if (!REMIsNilOrNull(targetEnergyData.energyData) && targetEnergyData.energyData.count != 0)
            energyData = targetEnergyData.energyData[0];
//        if (REMIsNilOrNull(energyData.dataValue)) continue;
        NSUInteger i = targetEnergyData.target.targetId.unsignedIntegerValue - 1;
        DCLabelingLabel* label = [[DCLabelingLabel alloc]init];
        label.target = targetEnergyData.target;
        label.energyData = energyData;
        label.name = targetEnergyData.target.name;
        if (i < stages.count) {
            label.stageText = [stages[i] stageText];
            label.color = ((DCLabelingStage*)stages[i]).color;
        }
        label.labelText = [NSString stringWithFormat:@"%@%@", [REMNumberHelper formatDataValueWithCarry:energyData.dataValue], targetEnergyData.target.uomName];
        label.stage = i;
        [labels addObject:label];
    }
    s.labels = labels;
    view.series = s;
    view.delegate = self;
    view.style = self.style;
    
    return view;
}

-(NSUInteger)getVisableSeriesCount {
    return self.view.series.labels.count;
}

-(BOOL)canSeriesBeHiddenAtIndex:(NSUInteger)index {
    return NO;
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

-(void)focusOn:(DCLabelingLabel *)point {
    if (self.delegate && [self.delegate respondsToSelector:@selector(highlightPoint:)]) {
        [((id<DCChartLabelingWrapperDelegate>)(self.delegate)) highlightPoint:point];
    }
}

-(void)cancelToolTipStatus {
    [super cancelToolTipStatus];
    [self.view unfocusLabel];
}
@end
