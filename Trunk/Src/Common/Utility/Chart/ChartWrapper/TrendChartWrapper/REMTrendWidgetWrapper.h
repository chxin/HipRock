/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTrendWidget.h
 * Created      : Zilong-Oscar.Xu on 9/27/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMAbstractChartWrapper.h"

@interface REMTrendWidgetWrapper : REMAbstractChartWrapper
-(NSArray*)extraSeriesConfig;
@property (nonatomic, weak) NSDate* baseDateOfX;
@end
