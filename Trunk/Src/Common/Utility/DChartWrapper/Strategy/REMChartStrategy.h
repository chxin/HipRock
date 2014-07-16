//
//  REMChartStrategy.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 7/15/14.
//
//

#import <Foundation/Foundation.h>
#import "REMChartStrategyHeader.h"

@interface REMChartStrategy : NSObject
@property (nonatomic, strong) id<REMSeriesAvalibleTypeGenProtocal> avalibleTypeGen;
@property (nonatomic, strong) id<REMSeriesDefaultVisableGenProtocal> defaultVisibleGen;
@property (nonatomic, strong) id<REMSeriesGroupingGenProtocal> groupingGen;
@end
