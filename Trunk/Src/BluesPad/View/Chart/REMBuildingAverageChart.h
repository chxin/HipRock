//
//  REMBuildingAverageChart.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 8/9/13.
//
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface REMBuildingAverageChart : UIView

@property (nonatomic,strong) CPTGraphHostingView *hostView;
@property (nonatomic,strong) CPTGraph *graph;
@property (nonatomic,strong) CPTAnnotation *annotation;
@property (nonatomic,strong) CPTLimitBand *annotationBand;

-(void)initializeGraph;

@end
