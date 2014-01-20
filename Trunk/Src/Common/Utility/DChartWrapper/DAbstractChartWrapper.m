//
//  DAbstractChartWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/21/13.
//
//

#import "DAbstractChartWrapper.h"
@interface DCHiddenSeries : NSObject
@property (nonatomic,strong,readonly) NSNumber* targetId;
@property (nonatomic,assign,readonly) REMEnergyTargetType type;
@property (nonatomic,assign,readonly) long commodityId;
-(id)initWithTarget:(REMEnergyTargetModel*)target;
-(BOOL)isSameTargetWith:(REMEnergyTargetModel*)target;
@end

@implementation DCHiddenSeries
-(id)initWithTarget:(REMEnergyTargetModel *)target {
    self = [super init];
    if (self) {
        if (target.type != REMEnergyTargetBenchmarkValue) {
            _targetId = [target.targetId copy];
        }
        _type = target.type;
        _commodityId = target.commodityId;
    }
    return self;
}
-(BOOL)isSameTargetWith:(REMEnergyTargetModel *)target {
    if (target.type != REMEnergyTargetBenchmarkValue) {
        
        return ((self.targetId == target.targetId) || [self.targetId isEqualToNumber:target.targetId]) &&
        self.type == target.type &&
        self.commodityId == target.commodityId;
    } else {
        return self.type == target.type;
    }
}
@end

@interface DAbstractChartWrapper()
@property (nonatomic, strong) NSMutableArray* hiddenTargets;
@end

@implementation DAbstractChartWrapper

-(DAbstractChartWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData wrapperConfig:(DWrapperConfig *)wrapperConfig style:(REMChartStyle *)style {
    self = [self init];
    if (self) {
        _energyViewData = energyViewData;
        _style = style;
        _chartStatus = DChartStatusNormal;
        _hiddenTargets = [[NSMutableArray alloc]init];
        _isMultiTimeChart = wrapperConfig.isMultiTimeChart;
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

-(BOOL) isTargetHidden:(REMEnergyTargetModel*)target index:(NSUInteger)index {
    BOOL isHidden = NO;
    if (self.isMultiTimeChart) {
        for (NSNumber* hIndex in self.hiddenTargets) {
            if (hIndex.integerValue == index) {
                isHidden = YES;
                break;
            }
        }
    } else {
        for (DCHiddenSeries* hs in self.hiddenTargets) {
            if ([hs isSameTargetWith:target]) {
                isHidden = YES;
                break;
            }
        }
    }
    return isHidden;
}

-(void)addHiddenTarget:(REMEnergyTargetModel*)target index:(NSUInteger)index {
    if (self.isMultiTimeChart) {
        [self.hiddenTargets addObject:@(index)];
    } else {
        [self.hiddenTargets addObject:[[DCHiddenSeries alloc] initWithTarget:target]];
    }
}

-(void)removeHiddenTarget:(REMEnergyTargetModel*)target index:(NSUInteger)index {
    if (self.isMultiTimeChart) {
        for (NSNumber* hIndex in self.hiddenTargets) {
            if (hIndex.integerValue == index) {
                [self.hiddenTargets removeObject:hIndex];
                break;
            }
        }
    } else {
        for (DCHiddenSeries* hs in self.hiddenTargets) {
            if ([hs isSameTargetWith:target]) {
                [self.hiddenTargets removeObject:hs];
                break;
            }
        }
    }
}
@end
