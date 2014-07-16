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
        _energyViewData = energyViewData;
        _style = style;
        _chartStatus = DChartStatusNormal;
        _chartStrategy = [REMChartStrategyFactor getStrategyByStoreType:self.wrapperConfig.storeType];
        
        NSMutableDictionary *seriesStates = [[NSMutableDictionary alloc] init];
        for (NSUInteger i = 0; i < self.energyViewData.targetEnergyData.count; i++) {
            REMTargetEnergyData* t = self.energyViewData.targetEnergyData[i];
            DCSeriesStatus* status = nil;
            
            NSString* sKey = [REMSeriesKeyFormattor seriesKeyWithEnergyTarget:t.target energyData:self.energyViewData andWidgetContentSyntax:self.wrapperConfig.contentSyntax];
            if (self.wrapperConfig.seriesStates != nil) {
                for(NSDictionary *item in self.wrapperConfig.seriesStates){
                    NSString* dicSKey = item[@"seriesKey"];
                    if (dicSKey != nil && dicSKey != NULL && [dicSKey isEqualToString:sKey]) {
                        status = [[DCSeriesStatus alloc] init];
                        status.seriesKey = sKey;
                        
                        status.seriesType = REMIsNilOrNull(item[@"type"])?self.wrapperConfig.defaultSeriesType:(DCSeriesTypeStatus)[item[@"type"] shortValue];
                        status.suppressible = REMIsNilOrNull(item[@"suppressible"])? YES : [item[@"suppressible"] boolValue];
                        status.visible = REMIsNilOrNull(item[@"visible"]) ? [self.chartStrategy.defaultVisibleGen getDefaultVisible:t.target] : [item[@"visible"] boolValue];
                        status.avilableTypes = REMIsNilOrNull(item[@"availableType"]) ? [self.chartStrategy.avalibleTypeGen getAvalibleTypeBySeriesKey:sKey targetTypeFromServer:t.target.type defaultChartType:self.wrapperConfig.defaultSeriesType] : [item[@"availableType"] intValue];
                    }
                }
            }
            
            if (status == nil) {
                status = [self getDefaultSeriesState:t.target seriesIndex:i];
            }
            [seriesStates setObject:status forKey:status.seriesKey];
//            [status applyToXYSeries:s];
        }
        _seriesStates = seriesStates;
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

-(NSString*)getSeriesKeyByTarget:(REMEnergyTargetModel*)target seriesIndex:(NSUInteger)index {
    return [REMSeriesKeyFormattor seriesKeyWithEnergyTarget:target energyData:self.energyViewData andWidgetContentSyntax:self.wrapperConfig.contentSyntax];
}

-(void)setHiddenAtIndex:(NSUInteger)seriesIndex hidden:(BOOL)hidden {
    
}

-(DCSeriesStatus*)getDefaultSeriesState:(REMEnergyTargetModel*)target seriesIndex:(NSUInteger)index {
    return nil;
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
