//
//  REMBuildingChartContainerView.m
//  Blues
//
//  Created by tantan on 8/9/13.
//
//

#import "REMBuildingChartContainerView.h"
#import "REMAverageUsageDataModel.h"

@interface REMBuildingChartContainerView()

@property (nonatomic) BOOL hasLoaded;
@property (nonatomic,strong) NSNumber *buildingId;
@property (nonatomic,strong) NSNumber *commodityId;
@property (nonatomic,strong) REMBuildingChartHandler *chartController;
@end

@implementation REMBuildingChartContainerView

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title andTitleFontSize:(CGFloat)size;
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.hasLoaded=NO;
        self.backgroundColor=[UIColor clearColor];
        [self initTitle:title withSize:size];
        [self initChartViewWithSize:size];
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    if(self.superview == nil){
        self.buildingId=nil;
        self.commodityId=nil;
        self.chartController=nil;
    }
}

- (void)initChartViewWithSize:(CGFloat)titleSize
{
    self.chartContainer = [[UIView alloc]initWithFrame:CGRectMake(0, titleSize, 1024, kBuildingChartHeight-titleSize-kBuildingCommodityItemMargin)];
    
    [self addSubview:self.chartContainer];
}

- (void)requireChartDataWithBuildingId:(NSNumber *)buildingId withCommodityId:(NSNumber *)commodityId withController:(REMBuildingChartHandler *)controller withEnergyData:(REMAverageUsageDataModel *)averageData
{
    if(self.hasLoaded == NO){
        self.chartController = controller;
        [self.chartContainer addSubview:controller.view];
        [self.chartController loadData:[buildingId longLongValue] :[commodityId longLongValue] :averageData :^(void){
            self.hasLoaded=YES;
        }];
    }
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
