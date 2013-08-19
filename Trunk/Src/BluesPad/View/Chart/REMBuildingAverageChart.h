//
//  REMBuildingAverageChart.h
//  Blues
//
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

@end
