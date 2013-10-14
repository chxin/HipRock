//
//  REMPieChartSeries.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 10/9/13.
//
//

#import "REMChartHeader.h"

@implementation REMPieChartSeries

-(REMChartSeries*)initWithData:(NSArray*)energyData dataProcessor:(REMChartDataProcessor*)processor plotStyle:(NSDictionary*)plotStyle {
    
    
    
    self = [super initWithData:energyData dataProcessor:processor plotStyle:plotStyle];
    plot = [[CPTPieChart alloc]init];
    ((CPTPieChart*)plot).pieRadius=0;
    ((CPTPieChart*)plot).pieInnerRadius=0;
    
    ((CPTPieChart*)plot).startAngle=M_PI_4;

    plot.identifier=@"pieplot1";
    ((CPTPieChart*)plot).sliceDirection=CPTPieDirectionClockwise;
    seriesType = REMChartSeriesPie;
    return self;
}

- (NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)idx
{
    REMEnergyData* point = [self.energyData objectAtIndex:idx];
    if (fieldEnum == CPTPieChartFieldSliceWidth) {
        return [self.dataProcessor processY:point.dataValue startDate:nil step:0];
    } else {
        return [NSNumber numberWithInteger:idx];
    }
}
@end
