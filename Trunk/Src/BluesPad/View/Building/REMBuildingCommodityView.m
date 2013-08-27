//
//  REMBuildingCommodityView.m
//  Blues
//
//  Created by tantan on 8/6/13.
//
//

#import "REMBuildingCommodityView.h"

@interface REMBuildingCommodityView()

typedef void(^SuccessCallback)(BOOL success);

@property (nonatomic,strong) REMBuildingTitleLabelView *totalLabel;

@property (nonatomic,strong) NSArray *detailLabelArray;
@property (nonatomic,strong) NSArray *chartViewArray;

@property (nonatomic,strong) SuccessCallback successBlock;

@property (nonatomic) NSUInteger successCounter;

@property (nonatomic,weak) REMCommodityUsageModel *commodityInfo;

@end

@implementation REMBuildingCommodityView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        self.successCounter=0;
        //self.contentSize=CGSizeMake(0, 2000);
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame withCommodityInfo:(REMCommodityUsageModel *)commodityInfo
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.commodityInfo=commodityInfo;
        
        [self initTotalValue];
        [self initDetailValue];
        [self initChartContainer];
    }
    
    return self;
}
/*
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer.view isKindOfClass:[REMBuildingCommodityView class]] == YES){
        if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] == YES){
            UIScrollView *parent = (UIScrollView *)self.superview;
            
            UIPanGestureRecognizer *p = (UIPanGestureRecognizer *)gestureRecognizer;
            CGPoint movement=[p translationInView:self];
            NSLog(@"movement:%@",NSStringFromCGPoint(movement));
            
            if(movement.y>0){
                self.bounces=NO;
            }
            else{
                self.bounces=YES;
            }
            
            if(parent.contentOffset.y>=-20){
                if(movement.y>0 && self.contentOffset.y<=0){
                    return NO;
                }
                
                return YES;
            }
            else{
                return NO;
            }
        }
    }
    
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}
*/


- (void)initTotalValue
{
    
    self.totalLabel=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(0, 0, 900, kBuildingCommodityTotalHeight) withData:self.commodityInfo.commodityUsage withTitle:[NSString stringWithFormat:@"上月用%@总量",self.commodityInfo.commodity.comment] andTitleFontSize:kBuildingCommodityTitleFontSize withTitleMargin:kBuildingTotalInnerMargin withLeftMargin:0   withValueFontSize:kBuildingCommodityTotalValueFontSize withUomFontSize:kBuildingCommodityTotalUomFontSize];
    
    [self addSubview:self.totalLabel];
    
}

- (void)initDetailValue
{
    int marginTop=kBuildingCommodityTotalHeight+kBuildingCommodityBottomMargin;
    
    REMBuildingTitleLabelView *carbon=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(0, marginTop, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight) withData:self.commodityInfo.carbonEquivalent withTitle:@"二氧化碳当量" andTitleFontSize:kBuildingCommodityTitleFontSize withTitleMargin:kBuildingDetailInnerMargin withLeftMargin:0   withValueFontSize:kBuildingCommodityDetailValueFontSize withUomFontSize:kBuildingCommodityDetailUomFontSize];
    
    [self addSubview:carbon];
    
    REMBuildingRankingView *ranking=[[REMBuildingRankingView alloc]initWithFrame:CGRectMake(kBuildingCommodityDetailWidth, marginTop, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight) withData:self.commodityInfo.rankingData withTitle:@"集团排名" andTitleFontSize:kBuildingCommodityTitleFontSize withTitleMargin:kBuildingDetailInnerMargin withLeftMargin:kBuildingCommodityDetailTextMargin ];
    
    
    
    [self addSubview:ranking];
    
    [self addSplitBar:ranking];
    
    
    REMBuildingTitleLabelView *target=[[REMBuildingTitleLabelView alloc]initWithFrame:CGRectMake(kBuildingCommodityDetailWidth*2, marginTop, kBuildingCommodityDetailWidth, kBuildingCommodityDetailHeight) withData:self.commodityInfo.targetValue withTitle:@"目标值"  andTitleFontSize:kBuildingCommodityTitleFontSize withTitleMargin:kBuildingDetailInnerMargin withLeftMargin:kBuildingCommodityDetailTextMargin  withValueFontSize:kBuildingCommodityDetailValueFontSize withUomFontSize:kBuildingCommodityDetailUomFontSize];
    [self addSplitBar:target];
    
    if(self.commodityInfo.isTargetAchieved==YES){
        [target setTitleIcon:[UIImage imageNamed:@"OverTarget"]];
    }
    else{
        [target setTitleIcon:[UIImage imageNamed:@"NotOverTarget"]];
    }
    
    
    [self addSubview:target];
}

- (void)addSplitBar:(UIView *)view
{
    CGRect frame=view.frame;
    //NSLog(@"splitbar:%@",NSStringFromCGRect(frame));
    CGRect frame1 = CGRectMake(0, 0, 2, frame.size.height);
    CGRect frame2 = CGRectMake(2, 0, 2, frame.size.height);
    
    CALayer *layer1 = [CALayer layer];
    
    layer1.frame=frame1;
    layer1.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.25].CGColor;
    UIGraphicsBeginImageContextWithOptions(frame1.size, NO, 0.0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    [layer1 renderInContext:c];
    
    
      
    CAGradientLayer *layer2 = [CALayer layer];
    
    
    layer2.frame = frame2;
    layer2.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.11].CGColor;
    

    
    [layer2 renderInContext:c];
    
    
    UIGraphicsEndImageContext();
    
    
    [view.layer insertSublayer:layer1 above:view.layer];
    [view.layer insertSublayer:layer2 above:view.layer];
}

- (void)initChartContainer
{
    int marginTop=kBuildingCommodityTotalHeight+kBuildingCommodityDetailHeight+kBuildingDetailInnerMargin+kBuildingCommodityBottomMargin*2;

    REMBuildingChartContainerView *view = [[REMBuildingChartContainerView alloc]initWithFrame:CGRectMake(0,marginTop , kBuildingChartWidth, kBuildingChartHeight) withTitle: [NSString stringWithFormat:@"单位面积逐月用%@",self.commodityInfo.commodity.comment] andTitleFontSize:kBuildingCommodityTitleFontSize ];
    
    
    
    
    [self addSubview:view];
    
    int marginTop1=marginTop+kBuildingChartHeight;
    
    REMBuildingChartContainerView *view1 = [[REMBuildingChartContainerView alloc]initWithFrame:CGRectMake(0, marginTop1, kBuildingChartWidth, kBuildingChartHeight) withTitle:[NSString stringWithFormat:@"用%@趋势图",self.commodityInfo.commodity.comment] andTitleFontSize:kBuildingCommodityTitleFontSize ];
    
    [self addSubview:view1];
    
    self.chartViewArray=@[view,view1];
}

- (void)sucessRequest{
    self.successCounter+=1;
    if(self.successCounter == self.chartViewArray.count){
        self.successBlock(YES);
        self.successBlock=nil;
    }
}

- (void)requireChartDataWithBuildingId:(NSNumber *)buildingId withCommodityId:(NSNumber *)commodityId complete:(void(^)(BOOL))callback
{
    self.successBlock=callback;
    
    REMBuildingChartContainerView *averageContainer = self.chartViewArray[0];
    
    if(averageContainer.controller==nil){
        REMBuildingAverageChartHandler *averageController = [[REMBuildingAverageChartHandler alloc]initWithViewFrame:averageContainer.chartContainer.frame];
        averageContainer.controller=averageController;
    }
    
    
    [averageContainer requireChartDataWithBuildingId:buildingId withCommodityId:commodityId withEnergyData:nil complete:^(BOOL success){
        [self sucessRequest];
    }];
    
    
    REMBuildingChartContainerView *trendContainer = self.chartViewArray[1];
    
    if (trendContainer.controller==nil) {
        REMBuildingTrendChartHandler  *trendController = [[REMBuildingTrendChartHandler alloc]initWithViewFrame:trendContainer.chartContainer.frame];
        trendContainer.controller=trendController;
        
    }
    
   
    [trendContainer requireChartDataWithBuildingId:buildingId withCommodityId:commodityId withEnergyData:nil complete:^(BOOL success){
        [self sucessRequest];    
    }];
}
/*
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *result = [super hitTest:point withEvent:event];
    UIView *average = self.chartViewArray[0];
    CGPoint p = [average convertPoint:point fromView:self];
    if ([average pointInside:p withEvent:event]) {
        
        return average;
    }
    return result;
}
*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
