//
//  REMTrendWidget.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 9/27/13.
//
//

#import "REMAbstractChartWrapper.h"

@interface REMTrendWidgetWrapper : REMAbstractChartWrapper
-(NSArray*)extraSeriesConfig;
@property (nonatomic, weak) NSDate* baseDateOfX;
@end
