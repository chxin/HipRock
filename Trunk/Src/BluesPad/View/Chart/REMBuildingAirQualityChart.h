/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingAirQualityChart.h
 * Created      : 张 锋 on 8/23/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"

@interface REMBuildingAirQualityChart : UIView

@property (nonatomic,strong) CPTGraphHostingView *hostView;


-(void)initializeGraph;

@end
