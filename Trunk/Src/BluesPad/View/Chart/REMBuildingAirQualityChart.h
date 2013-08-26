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

@property (nonatomic,strong) UILabel *chinaStandardLabel;
@property (nonatomic,strong) UILabel *americanStandardLabel;

@property (nonatomic,strong) UIView *honeywellDotView;
@property (nonatomic,strong) UILabel *honeywellLineLabel;

@property (nonatomic,strong) UIView *mayairDotView;
@property (nonatomic,strong) UILabel *mayairLineLabel;

@property (nonatomic,strong) UIView *outdoorDotView;
@property (nonatomic,strong) UILabel *outdoorLineLabel;

-(void)initializeGraph;

@end
