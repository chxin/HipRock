//
//  DAbstractChartWrapper.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/21/13.
//
//

#import <Foundation/Foundation.h>
#import "DCChartEnum.h"
#import "REMEnergyViewData.h"
#import "REMCommonHeaders.h"
#import "DCChartStyle.h"
#import "DWrapperConfig.h"
#import "DCChartWrapperDelegate.h"

@interface DAbstractChartWrapper : NSObject

@property (nonatomic, weak) id<DCChartWrapperDelegate> delegate;
@property (nonatomic, readonly, weak) REMEnergyViewData* energyViewData;
@property (nonatomic, readonly) DCChartStyle* style;
@property (nonatomic, assign) DChartStatus chartStatus;
@property (nonatomic, assign, readonly) BOOL isMultiTimeChart;

-(void)cancelToolTipStatus;
-(void)redraw:(REMEnergyViewData *)energyViewData;
-(UIView*)getView;
-(DAbstractChartWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData wrapperConfig:(DWrapperConfig*) wrapperConfig style:(DCChartStyle*)style;
-(void)setHiddenAtIndex:(NSUInteger)seriesIndex hidden:(BOOL)hidden;
-(NSUInteger)getVisableSeriesCount;

-(void)addHiddenTarget:(REMEnergyTargetModel*)target index:(NSUInteger)index;
-(void)removeHiddenTarget:(REMEnergyTargetModel*)target index:(NSUInteger)index;
-(BOOL) isTargetHidden:(REMEnergyTargetModel*)target index:(NSUInteger)index;
-(void)beginAnimationDone;
@end
