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
#import "DCSeriesStatus.h"
#import "REMSeriesKeyFormattor.h"
#import "REMChartStrategyFactor.h"

@interface DAbstractChartWrapper : NSObject

@property (nonatomic, weak) id<DCChartWrapperDelegate> delegate;
@property (nonatomic, readonly, weak) REMEnergyViewData* energyViewData;
@property (nonatomic, readonly) DCChartStyle* style;
@property (nonatomic, assign) DChartStatus chartStatus;
@property (nonatomic,strong) NSMutableDictionary* seriesStates;
@property (nonatomic,strong) DWrapperConfig* wrapperConfig;
@property (nonatomic,strong,readonly) REMChartStrategy* chartStrategy;

-(void)cancelToolTipStatus;
-(void)redraw:(REMEnergyViewData *)energyViewData;
-(UIView*)getView;
-(DAbstractChartWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData wrapperConfig:(DWrapperConfig*) wrapperConfig style:(DCChartStyle*)style;
-(BOOL)canSeriesBeHiddenAtIndex:(NSUInteger)index;
-(void)setHiddenAtIndex:(NSUInteger)seriesIndex hidden:(BOOL)hidden;
-(NSUInteger)getVisableSeriesCount;
//-(DCSeriesStatus*)getSeriesStatusByTarget:(REMEnergyTargetModel*)target index:(NSNumber*)seriesIndex;

-(void)beginAnimationDone;
-(DCSeriesStatus*)getDefaultSeriesState:(REMEnergyTargetModel*)target seriesIndex:(NSUInteger)index;
-(NSString*)getSeriesKeyByTarget:(REMEnergyTargetModel*)target seriesIndex:(NSUInteger)index;
@end
