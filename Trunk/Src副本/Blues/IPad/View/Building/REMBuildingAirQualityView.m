/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingAirQualityView.m
 * Created      : tantan on 8/22/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingAirQualityView.h"

@interface REMBuildingAirQualityView()

@property (nonatomic,strong) REMBuildingTitleLabelView *totalLabel;

@property (nonatomic,strong) NSArray *detailLabelArray;


@end

@implementation REMBuildingAirQualityView


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if(point.y>self.frame.origin.y)return YES;
    
    return [super pointInside:point withEvent:event];
    
}

@end
