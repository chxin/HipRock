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
#import "REMWidgetMultiTimespanSearchModel.h"
#import "DCXYSeries.h"
#import "DCTrendWrapper.h"


@interface REMTrendChartTooltipView()

@property (nonatomic,strong) NSMutableArray *tooltipItems;

@property (nonatomic,weak) UILabel *pointTimeLabel;
@property (nonatomic,weak) UILabel *timeLabel;

@property (nonatomic,strong) NSDate *xTime;

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

#define REMSeriesIsMultiTime ([self.parameters isKindOfClass:[REMWidgetMultiTimespanSearchModel class]])

-(REMTooltipViewBase *)initWithHighlightedPoints:(NSArray *)points atX:(id)x chartWrapper:(DAbstractChartWrapper *)chartWrapper  inEnergyData:(REMEnergyViewData *)data widget:(REMManagedWidgetModel *)widget andParameters:(REMWidgetSearchModelBase *)parameters
{
    self = [super initWithHighlightedPoints:points atX:x chartWrapper:chartWrapper inEnergyData:data widget:widget andParameters:parameters];
    
    if(self){
        //add time view into content view
        self.xTime = [x isKindOfClass:[NSDate class]] ? x : nil;
        
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
    CGFloat itemWidth = REMSeriesIsMultiTime ? 300 : kDMChart_TooltipItemWidth;
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

- (void)updateHighlightedData:(NSArray *)points atX:(id)x
{
    self.x = x;
    self.highlightedPoints = points;
    self.xTime = [x isKindOfClass:[NSDate class]] ? x : nil;
    self.itemModels = [self convertItemModels];
    
    
    for(int i=0;i<self.itemModels.count;i++)
        [[self.tooltipItems objectAtIndex:i] updateModel:self.itemModels[i]];
    
    DCDataPoint *point = self.highlightedPoints.count>0?self.highlightedPoints[0]:nil;
    NSString *timeLabelText = REMSeriesIsMultiTime ? (point ? point.target.name:@"") : (REMIsNilOrNull(self.xTime) ? @"" : [self formatTimeText:self.xTime]);
    self.timeLabel.text = timeLabelText;
}

- (NSArray *)convertItemModels
{
    NSArray *highlightedPoints = self.highlightedPoints; //highlightedPoints for trend data is an array of DCChartPoint
    NSMutableArray *itemModels = [[NSMutableArray alloc] init];
    
    int index = 0;
    for(int i=0;i<highlightedPoints.count;i++){
        DCDataPoint *point = highlightedPoints[i];
        if([point.series isKindOfClass:[DCXYSeries class]] && ((DCXYSeries *)point.series).hidden == NO){
            REMChartTooltipItemModel *model = [[REMChartTooltipItemModel alloc] init];
            
            NSString *targetName = [self formatTargetName:point];
            model.title = [targetName isEqual:[NSNull null]] ? nil : targetName;
            model.value = REMIsNilOrNull(point) ? nil : point.value;
            model.color = point.series.color;
            model.index = index;
            model.uom = point.target.uomName;
            
            [itemModels addObject:model];
            index++;
        }
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
    
    NSString *text = REMSeriesIsMultiTime ? point.target.name : [self formatTimeText:self.xTime];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:kDMChart_TooltipTimeViewFrame];
    timeLabel.text = text == nil ? @" " : text;
    timeLabel.textColor = [REMColor colorByHexString:kDMChart_TooltipTimeViewFontColor];
    timeLabel.font = [UIFont systemFontOfSize:kDMChart_TooltipTimeViewFontSize];
    timeLabel.backgroundColor = [UIColor clearColor];
    
    return timeLabel;
}

-(NSString *)formatTargetName:(DCDataPoint *)point
{
    REMEnergyStep step = ((REMWidgetStepEnergyModel *)self.parameters).step;
    
    if(REMSeriesIsMultiTime){
        //get the point's time
        //add time difference according to its index
        if(point.energyData.localTime == nil){
            return nil;
        }
        
        NSDate *realtime = [point.energyData.localTime dateByAddingTimeInterval: point.energyData.offset];
        
        return [REMTimeHelper formatTooltipTime:realtime byStep:step inRange:nil];
        
        
//        int index = [self.data.targetEnergyData indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
//            if([((REMTargetEnergyData *)obj).target isEqual:point.target]){
//                *stop = YES;
//                return YES;
//            }
//            return NO;
//        }];
//        
//        if(index != NSNotFound && index>=0 && index<self.data.targetEnergyData.count){
//            return @"wrong";
//        }
//        
//        
//        REMTimeRange *range0 = self.parameters.searchTimeRangeArray[0], *rangei = self.parameters.searchTimeRangeArray[index];
//        NSDate *start0 = [self alignDataPointTime:range0.startTime withStep:step], *starti = [self alignDataPointTime:rangei.startTime withStep:step];
//        
//        NSDate *pointtime = point.energyData.localTime, *realtime;
//        if(step == REMEnergyStepMonth || step == REMEnergyStepYear){
//            int monthDiff = [[REMTimeHelper getMonthTicksFromDate:starti] intValue] - [[REMTimeHelper getMonthTicksFromDate:start0] intValue];
//            
//            realtime = [REMTimeHelper add:monthDiff onPart:REMDateTimePartMonth ofDate:pointtime];
//        }
//        else{
//            NSTimeInterval diff = [starti timeIntervalSinceDate: start0];
//            realtime = [pointtime dateByAddingTimeInterval:diff];
//        }
//        
//        return [REMTimeHelper formatTooltipTime:realtime byStep:step inRange:rangei];
    }
    
    return [REMTextIndicatorFormator formatTargetName:point.target inEnergyData:self.data withWidget:self.widget andParameters:self.parameters];
}

-(NSDate *)alignDataPointTime:(NSDate *)date withStep:(REMEnergyStep)step
{
    int hour = [REMTimeHelper getHour:date], day=[REMTimeHelper getDay:date], month=[REMTimeHelper getMonth:date], year=[REMTimeHelper getYear:date];
    
    switch (step) {
        case REMEnergyStepHour:{
            //next HH:00
            return date;
        }
        case REMEnergyStepDay:{
            //next 00:00
            if(hour == 0)
                return date;
            
            NSDate *cut = [REMTimeHelper dateFromYear:year Month:month Day:day Hour:0];
            return [REMTimeHelper add:1 onPart:REMDateTimePartDay ofDate:cut];
        }
        case REMEnergyStepWeek:{
            //next monday 00:00
            return [REMTimeHelper getNextMondayFromDate:date];
        }
        case REMEnergyStepMonth:{
            //next 1st 00:00
            if(day==1 && hour==0)
                return date;
            
            NSDate *cut = [REMTimeHelper dateFromYear:year Month:month Day:1 Hour:0];
            return [REMTimeHelper add:1 onPart:REMDateTimePartMonth ofDate:cut];
        }
        case REMEnergyStepYear:{
            //next Jan 1st 00:00
            if(month==1 && day==1 && hour==0)
                return date;
            
            NSDate *cut = [REMTimeHelper dateFromYear:year Month:1 Day:1 Hour:0];
            return [REMTimeHelper add:1 onPart:REMDateTimePartYear ofDate:cut];
        }
        default:{
            return nil;
        }
    }
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
