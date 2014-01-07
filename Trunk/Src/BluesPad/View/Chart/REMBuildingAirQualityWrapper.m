//
//  REMBuildingAirQualityWrapper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 1/7/14.
//
//

#import "REMBuildingAirQualityWrapper.h"
#import "_DCXLabelFormatter.h"
#import "REMAirQualityDataModel.h"
#import "DCXYChartBackgroundBand.h"
#import "DCUtility.h"

@interface REMBuildingAirQualityWrapper()
@property (nonatomic, strong) NSMutableDictionary* standardLabels;
@end

@implementation REMBuildingAirQualityWrapper
#define kTagCodeSuffixOutdoor @"Outdoor"
#define kTagCodeSuffixHoneywell @"Honeywell"
#define kTagCodeSuffixMayAir @"MayAir"
#define kAmericanStandardCode @"美国标准"
#define kChinaStandardCode @"中国标准"

@synthesize isStacked = _isStacked;
@synthesize processors = _processors;
@synthesize sharedProcessor = _sharedProcessor;

//CGRect hostViewFrame = CGRectMake(0, 0, 710, self.bounds.size.height - topAxisOffset - 45);

-(DAbstractChartWrapper*)initWithFrame:(CGRect)frame data:(REMEnergyViewData*)energyViewData widgetContext:(REMWidgetContentSyntax*) widgetSyntax style:(REMChartStyle*)style {
    style.plotPaddingRight = 152;
    self.standardLabels = [[NSMutableDictionary alloc]init];
    return [super initWithFrame:frame data:energyViewData widgetContext:widgetSyntax style:style];
}

-(NSDictionary*)updateProcessorRangesFormatter:(REMEnergyStep)step {
    _isStacked = NO;
    
    NSUInteger seriesAmount = [self getSeriesAmount];
    _processors = [[NSMutableArray alloc]init];
    
    _sharedProcessor = [[REMTrendChartDataProcessor alloc]init];
    self.sharedProcessor.step = step;
    
    for (int i = 0; i < seriesAmount; i++) {
        [self.processors addObject:self.sharedProcessor];
    }
    
    NSDate* now = [NSDate date];
    int year = [REMTimeHelper getTimePart:REMDateTimePartYear ofLocalDate:now];
    int month = [REMTimeHelper getTimePart:REMDateTimePartMonth ofLocalDate:now];
    int date = [REMTimeHelper getTimePart:REMDateTimePartDay ofLocalDate:now];
    NSDate* today0H = [REMTimeHelper dateFromYear:year Month:month Day:date Hour:0];
    NSDate* minDateOfData = today0H;
    
    for (int i=0;i<self.energyViewData.targetEnergyData.count;i++) {
        REMTargetEnergyData *targetEnergyData = (REMTargetEnergyData *)self.energyViewData.targetEnergyData[i];
        for (int j=0;j<targetEnergyData.energyData.count;j++) {
            REMEnergyData *point = (REMEnergyData *)targetEnergyData.energyData[j];
            
            if([point.dataValue isEqual:[NSNull null]])
                continue;
            if ([point.localTime compare:minDateOfData] == NSOrderedAscending) minDateOfData = point.localTime;
        }
    }
    self.sharedProcessor.baseDate = minDateOfData;
    
    NSDate* globalStartDate = [NSDate dateWithTimeInterval:-365*24*3600 sinceDate:today0H];
    if ([globalStartDate compare:minDateOfData] == NSOrderedAscending) globalStartDate = minDateOfData;
    int globalStart = [self.sharedProcessor processX:globalStartDate].integerValue;
    int globalEnd = [self.sharedProcessor processX:today0H].integerValue;
    
    DCRange* range = [[DCRange alloc]initWithLocation:globalStart length:globalEnd-globalStart+1];
    NSFormatter* formatter = [[_DCXLabelFormatter alloc]initWithStartDate:minDateOfData dataStep:step interval:1];
    return @{ @"globalRange": range, @"beginRange": [[DCRange alloc]initWithLocation:globalEnd-13 length:14], @"xformatter": formatter};
}

-(void)customizeView:(DCXYChartView *)view {
    view.graphContext.pointAlignToTick = NO;
    view.graphContext.xLabelAlignToTick = NO;
}

-(void)didYIntervalChange:(double)yInterval forAxis:(DCAxis *)yAxis range:(DCRange*)range {
    for (NSString* code in self.standardLabels.allKeys) {
        UILabel* label = self.standardLabels[code];
        for (REMAirQualityStandardModel* standard in self.standardsBands) {
            if ([standard.standardName isEqualToString:code]) {
                label.frame = CGRectMake(label.frame.origin.x, [DCUtility getScreenYIn:self.view.graphContext.plotRect yVal:standard.standardValue.integerValue vRange:range], label.frame.size.width, label.frame.size.height);
            }
        }
    }
}

-(void)customizeSeries:(DCXYSeries *)series seriesIndex:(int)index chartStyle:(REMChartStyle *)style {
    [super customizeSeries:series seriesIndex:index chartStyle:style];
    REMEnergyTargetModel* target = series.target;
    if([target.code hasSuffix:kTagCodeSuffixHoneywell]){
        series.color = [UIColor colorWithRed:97.0/255.0 green:184.0/255.0 blue:2.0/255.0 alpha:1];
    }
    else if([target.code hasSuffix:kTagCodeSuffixMayAir]){
        series.color = [UIColor colorWithRed:0.0/255.0 green:163.0/255.0 blue:179.0/255.0 alpha:1];
    }
    else if([target.code hasSuffix:kTagCodeSuffixOutdoor]){
        series.color = [UIColor colorWithRed:106.0/255.0 green:99.0/255.0 blue:74.0/255.0 alpha:1];
    }
    series.visableYMaxThreshold = @(100);
    ((DCLineSeries*)series).symbolType = DCLineSymbolTypeRound;
}

-(void)setStandardsBands:(NSArray *)standardsBands {
    _standardsBands = standardsBands;
    
    NSMutableArray* bands = [[NSMutableArray alloc]init];
    for (REMAirQualityStandardModel* standard in self.standardsBands) {
        DCRange* bandRange = [[DCRange alloc]initWithLocation:0 length:standard.standardValue.doubleValue];
        DCXYChartBackgroundBand* b = [[DCXYChartBackgroundBand alloc]init];
        b.range = bandRange;
        NSString* labelText = nil;
        if ([standard.standardName isEqualToString:kAmericanStandardCode]) {
            labelText = REMLocalizedString(@"Building_AirQualityAmericanStandard");
            b.color = [UIColor colorWithRed:0.0/255.0 green:226.0/255.0 blue:255.0/255.0 alpha:0.39];
        } else {
            labelText = REMLocalizedString(@"Building_AirQualityChinaStandard");
            b.color = [UIColor colorWithRed:58.0/255.0 green:255.0/255.0 blue:168.0/255.0 alpha:0.43];
        }
        if (self.standardLabels[standard.standardName] == nil) {
            UILabel* label = [[UILabel alloc]init];
            label.backgroundColor = [UIColor clearColor];
            label.font = [UIFont systemFontOfSize:11];
            label.textColor = b.color;
            label.text = [NSString stringWithFormat:labelText, standard.standardValue.integerValue, standard.uom];
            [self.view addSubview:label];
            [label sizeToFit];
            [self.standardLabels setObject:label forKey:standard.standardName];
        }
        UILabel* sLabel = self.standardLabels[standard.standardName];
        CGRect frame = CGRectMake(self.view.frame.size.width-141, 0, sLabel.frame.size.width, sLabel.frame.size.height);
        sLabel.frame = frame;
        b.axis = self.view.yAxisList[0];
        [bands addObject:b];
    }
    self.view.clipsToBounds = NO;
    [self.view setBackgoundBands:bands];
}
@end
