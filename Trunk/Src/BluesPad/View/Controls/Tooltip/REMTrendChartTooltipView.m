/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTooltipView.m
 * Date Created : 张 锋 on 11/7/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <QuartzCore/QuartzCore.h>
#import "REMTrendChartTooltipView.h"
#import "REMDimensions.h"
#import "REMChartTooltipItem.h"
#import "REMColor.h"
#import "REMCommonHeaders.h"
#import "REMImages.h"
#import "REMWidgetTagSearchModel.h"
#import "REMWidgetCommoditySearchModel.h"
#import "REMTextIndicatorFormator.h"
#import "DCDataPoint.h"


@interface REMTrendChartTooltipView()

@property (nonatomic,strong) NSMutableArray *tooltipItems;

@property (nonatomic,weak) UILabel *pointTimeLabel;
@property (nonatomic,weak) UILabel *timeLabel;

@end

@implementation REMTrendChartTooltipView

/* Who has trend chart tooltip?
 * Common tags
 * Time slices
 * Carbon total and multiple commodities
 * Cost total and multiple commodities
 * Cost electricity Peak Plain Valley
 * Unit common tags
 * Unit carbon total and commodity
 * Unit cost total and commodity
 * Ratio common tags
 * Ratio carbon and cost total and commodity
 * Benchmark
 * Ranking
 */


-(REMTooltipViewBase *)initWithHighlightedPoints:(NSArray *)points inEnergyData:(REMEnergyViewData *)data widget:(REMWidgetObject *)widget andParameters:(REMWidgetSearchModelBase *)parameters
{
    self = [super initWithHighlightedPoints:points inEnergyData:data widget:widget andParameters:parameters];
    
    if(self){
        //add time view into content view
        UILabel *timeLabel = [self renderTimeView];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
    }
    
    return self;
}

-(UIScrollView *)renderScrollView
{
    self.tooltipItems = [[NSMutableArray alloc] init];
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:kDMChart_TooltipScrollViewFrame];
    
    view.pagingEnabled = NO;
    view.showsHorizontalScrollIndicator = NO;
    view.showsVerticalScrollIndicator = NO;
    view.clipsToBounds = YES;
//    view.layer.borderColor = [UIColor blackColor].CGColor;
//    view.layer.borderWidth = 1.0;
    
    int itemCount = self.itemModels.count;
    
    CGFloat itemOffset = kDMChart_TooltipItemOffset;
    CGFloat itemWidth = kDMChart_TooltipItemWidth;
    CGFloat contentWidth = (itemWidth + itemOffset) * itemCount - kDMChart_TooltipCloseViewWidth;
    
    if(contentWidth < view.bounds.size.width){
        itemOffset = itemCount == 1 ? 0 : (kDMChart_TooltipScrollViewWidth - (itemCount * itemWidth)) / (itemCount - 1);
        contentWidth = kDMChart_TooltipScrollViewWidth;
    }
    
    for(int i=0;i<itemCount;i++){
        CGRect itemFrame = CGRectMake(i*(itemWidth + itemOffset) ,0 , itemWidth, kDMChart_TooltipScrollViewHeight);
        
        REMChartTooltipItem *tooltipItem = [REMChartTooltipItem itemWithFrame:itemFrame andModel:self.itemModels[i]];
        
        [view addSubview:tooltipItem];
        [self.tooltipItems addObject:tooltipItem];
    }
    
    view.contentSize = CGSizeMake(contentWidth, kDMChart_TooltipScrollViewHeight);
    
    return view;
}

- (void)updateHighlightedData:(NSArray *)points
{
    self.highlightedPoints = points;
    self.itemModels = [self convertItemModels];
    
    for(int i=0;i<self.itemModels.count;i++)
        [[self.tooltipItems objectAtIndex:i] updateModel:self.itemModels[i]];
    
    DCDataPoint *point = self.highlightedPoints[0];
    self.timeLabel.text = [self formatTimeText:point.energyData.localTime];
}

- (NSArray *)convertItemModels
{
    NSArray *highlightedPoints = self.highlightedPoints; //highlightedPoints for trend data is an array of DCChartPoint
    NSMutableArray *itemModels = [[NSMutableArray alloc] init];
    
    for(int i=0;i<highlightedPoints.count;i++){
        DCDataPoint *point = highlightedPoints[i];
        
        REMChartTooltipItemModel *model = [[REMChartTooltipItemModel alloc] init];
        
        model.title = [self formatTargetName:point.target];
        model.value = REMIsNilOrNull(point) ? nil : point.value;
        model.color = [REMColor colorByIndex:i].uiColor;
        model.index = i;
        model.uom = point.target.uomName;
        
        [itemModels addObject:model];
    }
    
    return itemModels;
}

//-(UILabel *)renderTimeLabel
//{
//    DCDataPoint *point = self.highlightedPoints[0];
//    REMEnergyData *data = point.energyData;
//}

-(UILabel *)renderTimeView
{
    DCDataPoint *point = self.highlightedPoints[0];
    
    NSString *text = [self formatTimeText:point.energyData.localTime];
    if(self.widget.contentSyntax.dataStoreType == REMDSEnergyMultiTimeTrend){
        text = point.target.name;
    }
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:kDMChart_TooltipTimeViewFrame];
    timeLabel.text = text;
    timeLabel.textColor = [REMColor colorByHexString:kDMChart_TooltipTimeViewFontColor];
    timeLabel.font = [UIFont systemFontOfSize:kDMChart_TooltipTimeViewFontSize];
    timeLabel.backgroundColor = [UIColor clearColor];
    
    return timeLabel;
}

-(NSString *)formatTargetName:(REMEnergyTargetModel *)target
{
    return [REMTextIndicatorFormator formatTargetName:target withWidget:self.widget andParameters:self.parameters];
}

-(NSString *)formatTimeText:(NSDate *)time
{
    if([self.parameters isKindOfClass:[REMWidgetStepEnergyModel class]]){
        REMWidgetStepEnergyModel *stepModel = (REMWidgetStepEnergyModel *)self.parameters;
        
        REMEnergyStep step = stepModel.step;
        
        return [REMTimeHelper formatTooltipTime:time byStep:step inRange:nil];
    }
    
    return [REMTimeHelper formatTimeFullHour:time isChangeTo24Hour:YES];
}


@end
