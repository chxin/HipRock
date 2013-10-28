//
//  REMTrendWidget.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 9/27/13.
//
//

#import "REMAbstractChartWrapper.h"

@interface REMTrendWidgetWrapper : REMAbstractChartWrapper
-(NSArray*)extraSeriesConfig;
@property (nonatomic, weak) NSDate* baseDateOfX;
@end
