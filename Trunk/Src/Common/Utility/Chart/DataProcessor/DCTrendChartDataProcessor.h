//
//  DCTrendChartDataProcessor.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 3/14/14.
//
//

#import <Foundation/Foundation.h>
#import "DCChartDataProcessor.h"
#import "REMEnum.h"

@interface DCTrendChartDataProcessor : DCChartDataProcessor
@property (nonatomic, strong) NSDate* baseDate;
@property (nonatomic, assign) REMEnergyStep step;
@end
