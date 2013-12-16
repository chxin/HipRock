//
//  DCPieWrapper.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/28/13.
//
//

#import "DAbstractChartWrapper.h"
#import "DCPieChartView.h"
#import "DCPieChartViewDelegate.h"

@interface DCPieWrapper : DAbstractChartWrapper<DCPieChartViewDelegate>
@property (nonatomic, readonly) DCPieChartView* view;
@property (nonatomic, readonly, weak) REMEnergyViewData* energyViewData;
@property (nonatomic, assign) REMCalendarType calenderType;

@end
