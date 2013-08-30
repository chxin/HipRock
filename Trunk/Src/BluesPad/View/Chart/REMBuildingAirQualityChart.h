//
//  REMBuildingAirQualityChart.h
//  Blues
//
//  Created by 张 锋 on 8/23/13.
//
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"

@interface REMBuildingAirQualityChart : UIView

@property (nonatomic,strong) CPTGraphHostingView *hostView;


-(void)initializeGraph;

@end
