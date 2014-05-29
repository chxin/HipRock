//
//  DAbstractChartWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/21/13.
//
//

#import "DAbstractChartWrapper.h"

@interface DAbstractChartWrapper()
@property (nonatomic, strong) NSMutableArray* hiddenTargets;
@end

@implementation DAbstractChartWrapper
-(void)beginAnimationDone {
    if (!(REMIsNilOrNull(self.delegate)) && [self.delegate respondsToSelector:@selector(beginAnimationDone)]) {
        [self.delegate beginAnimationDone];
    }
}

-(DAbstractChartWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData wrapperConfig:(DWrapperConfig *)wrapperConfig style:(DCChartStyle *)style {
    self = [self init];
    if (self) {
        _wrapperConfig = wrapperConfig;
        _seriesStates = [[NSMutableArray alloc]init];
        _energyViewData = energyViewData;
        _style = style;
        _chartStatus = DChartStatusNormal;
        _hiddenTargets = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)cancelToolTipStatus {
    _chartStatus = DChartStatusNormal;
}

-(void)redraw:(REMEnergyViewData *)energyViewData {
    _energyViewData = energyViewData;
    
    _chartStatus = DChartStatusNormal;
}

-(UIView*)getView {
    return nil;
}

-(NSUInteger)getVisableSeriesCount {
    return 0;
}

-(void)setHiddenAtIndex:(NSUInteger)seriesIndex hidden:(BOOL)hidden {
    
}

-(BOOL)canSeriesBeHiddenAtIndex:(NSUInteger)index {
    return [self getVisableSeriesCount] > 1;
}
-(DSeriesStatus*)getSeriesStatusByTarget:(REMEnergyTargetModel*)target index:(NSNumber*)seriesIndex {
    if (self.wrapperConfig.isMultiTimeEnergyAnalysisChart) {
        for (DSeriesStatus* state in self.seriesStates) {
            if ([state.seriesIndex isEqualToNumber:seriesIndex]) return state;
        }
    } else {
        for (DSeriesStatus* state in self.seriesStates) {
            if (target.type != REMEnergyTargetBenchmarkValue) {
                if ( ((state.targetId == target.targetId) || [state.targetId isEqualToNumber:target.targetId]) &&
                    state.type == target.type &&
                    state.commodityId == target.commodityId)
                    return state;
            } else {
                if (state.type == target.type)
                    return state;
            }
        }
    }
    return nil;
}
@end
