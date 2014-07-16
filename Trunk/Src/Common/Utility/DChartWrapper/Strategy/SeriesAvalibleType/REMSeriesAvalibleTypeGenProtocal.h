//
//  REMSeriesAvalibleTypeGenProtocal.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 7/15/14.
//
//

#import <Foundation/Foundation.h>
#import "DCSeriesStatus.h"

@protocol REMSeriesAvalibleTypeGenProtocal <NSObject>
-(int)getAvalibleTypeBySeriesKey:(NSString*)seriesKey targetTypeFromServer:(REMEnergyTargetType)targetType defaultChartType:(DCSeriesTypeStatus)defaultChartType;
@end
