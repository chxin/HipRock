//
//  DAbstractChartWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/21/13.
//
//

#import "DAbstractChartWrapper.h"

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
        _seriesStates = [[NSMutableDictionary alloc]init];
        _energyViewData = energyViewData;
        _style = style;
        _chartStatus = DChartStatusNormal;
        
//        if(self.wrapperConfig.seriesStates != nil){
//            NSMutableDictionary *seriesStates = [[NSMutableDictionary alloc] init];
//            for(NSDictionary *item in self.wrapperConfig.seriesStates){
//                DCSeriesStatus *status = [[DCSeriesStatus alloc] init];
//                status.seriesType = REMIsNilOrNull(item[@"type"])?DCSeriesTypeStatusLine:(DCSeriesTypeStatus)[item[@"type"] shortValue];
//                status.seriesKey = item[@"seriesKey"];
//                status.canBeHidden = REMIsNilOrNull(item[@"suppressible"])? YES : [item[@"suppressible"] boolValue];
//                status.hidden = ![item[@"visible"] boolValue];
//                
//                int availableTypes = REMIsNilOrNull(item[@"availableType"]) ? (DCSeriesTypeStatusLine + DCSeriesTypeStatusColumn + DCSeriesTypeStatusStackedColumn) : [item[@"availableType"] intValue];
//                
//                NSMutableArray *types = [NSMutableArray arrayWithArray:@[@(DCSeriesTypeStatusLine),@(DCSeriesTypeStatusColumn),@(DCSeriesTypeStatusStackedColumn),@(DCSeriesTypeStatusPie)]];
//                for(int i=types.count-1;i>=0;i--){
//                    __block short sum = 0;
//                    [types enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { sum += [obj shortValue]; }];
//                    
//                    if(sum == availableTypes){
//                        status.avilableTypes = types;
//                        break;
//                    }
//                    
//                    [types removeObject:types[i]];
//                }
//                
//                [seriesStates setObject:status forKey:status.seriesKey];
//            }
//            
//            self.seriesStates = seriesStates;
//        }
    }
    return self;
}
-(void)cancelToolTipStatus {
    _chartStatus = DChartStatusNormal;
}

-(void)initializeStates {
    
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
//-(DSeriesStatus*)getSeriesStatusByTarget:(REMEnergyTargetModel*)target index:(NSNumber*)seriesIndex {
//    if (self.wrapperConfig.isMultiTimeEnergyAnalysisChart) {
//        for (DSeriesStatus* state in self.seriesStates) {
//            if ([state.seriesIndex isEqualToNumber:seriesIndex]) return state;
//        }
//    } else {
//        for (DSeriesStatus* state in self.seriesStates) {
//            if (target.type != REMEnergyTargetBenchmarkValue) {
//                if ( ((state.targetId == target.targetId) || [state.targetId isEqualToNumber:target.targetId]) &&
//                    state.type == target.type &&
//                    state.commodityId == target.commodityId)
//                    return state;
//            } else {
//                if (state.type == target.type)
//                    return state;
//            }
//        }
//    }
//    return nil;
//}
@end
