//
//  REMBuildingChartContainerView.m
//  Blues
//
//  Created by tantan on 8/9/13.
//
//

#import "REMBuildingChartContainerView.h"

@interface REMBuildingChartContainerView()

@property (nonatomic,strong) UIView *chartContainerView;
@property (nonatomic) BOOL hasLoaded;
@property (nonatomic,strong) NSNumber *buildingId;
@property (nonatomic,strong) NSNumber *commodityId;
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

- (void)initChartViewWithSize:(CGFloat)titleSize
{
    self.chartContainerView = [[UIView alloc]initWithFrame:CGRectMake(0, titleSize, 1024, kBuildingChartHeight-titleSize-kBuildingCommodityItemMargin)];
    
    [self addSubview:self.chartContainerView];
}

- (void)requireChartDataWithBuildingId:(NSNumber *)buildingId withCommodityId:(NSNumber *)commodityId
{
    if (self.hasLoaded == NO) {
        self.buildingId=buildingId;
        self.commodityId=commodityId;
        
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
