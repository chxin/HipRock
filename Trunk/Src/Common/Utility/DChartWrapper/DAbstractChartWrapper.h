//
//  DAbstractChartWrapper.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/21/13.
//
//

#import <Foundation/Foundation.h>
#import "REMChartHeader.h"
#import "REMEnergyViewData.h"
#import "REMCommonHeaders.h"
#import "REMChartStyle.h"
#import "DWrapperConfig.h"
  
typedef enum _DChartStatus {
    DChartStatusNormal,
    DChartStatusFocus
}DChartStatus;

@interface DAbstractChartWrapper : NSObject

@property (nonatomic, weak) id<REMChartDelegate> delegate;
@property (nonatomic, readonly, weak) REMEnergyViewData* energyViewData;
@property (nonatomic, readonly) REMChartStyle* style;
@property (nonatomic, assign) DChartStatus chartStatus;
@property (nonatomic, assign, readonly) BOOL isMultiTimeChart;

-(void)cancelToolTipStatus;
-(void)redraw:(REMEnergyViewData *)energyViewData;
-(UIView*)getView;
-(DAbstractChartWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData wrapperConfig:(DWrapperConfig*) wrapperConfig style:(REMChartStyle*)style;
-(void)setHiddenAtIndex:(NSUInteger)seriesIndex hidden:(BOOL)hidden;
-(NSUInteger)getVisableSeriesCount;

-(void)addHiddenTarget:(REMEnergyTargetModel*)target index:(NSUInteger)index;
-(void)removeHiddenTarget:(REMEnergyTargetModel*)target index:(NSUInteger)index;
-(BOOL) isTargetHidden:(REMEnergyTargetModel*)target index:(NSUInteger)index;

@end
