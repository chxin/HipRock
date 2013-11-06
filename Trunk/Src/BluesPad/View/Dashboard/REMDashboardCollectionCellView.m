/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDashboardCollectionCellView.m
 * Created      : tantan on 9/25/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMDashboardCollectionCellView.h"
#import <QuartzCore/QuartzCore.h>
#import "REMEnergySeacherBase.h"
#import "REMLineWidgetWrapper.h"
#import "REMColumnWidgetWrapper.h"
#import "REMPieChartWrapper.h"
#import "REMRankingWidgetWrapper.h"
#import "REMStackColumnWidgetWrapper.h"

@interface REMDashboardCollectionCellView ()

//@property (nonatomic,weak) UIView *chartContainer;
//@property (nonatomic,strong) REMAbstractChartWrapper *wrapper;
@end

@implementation REMDashboardCollectionCellView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.contentView.layer.borderColor=[UIColor redColor].CGColor;
        //self.contentView.layer.borderWidth=1;
        self.backgroundColor=[UIColor whiteColor];
        self.contentView.backgroundColor=[UIColor whiteColor];
        
        //self.chartLoaded=NO;
        
    }
    return self;
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
