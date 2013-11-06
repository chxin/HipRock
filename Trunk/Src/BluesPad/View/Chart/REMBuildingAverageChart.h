/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingAverageChart.h
 * Created      : 张 锋 on 8/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface REMBuildingAverageChart : UIView

@property (nonatomic,strong) CPTGraphHostingView *hostView;
@property (nonatomic,strong) CPTGraph *graph;
@property (nonatomic,strong) CPTAnnotation *annotation;
@property (nonatomic,strong) CPTLimitBand *annotationBand;

-(void)initializeGraph;

@end
