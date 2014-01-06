/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingTrendChartHandler.m
 * Created      : 张 锋 on 8/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingTrendChartViewController.h"
#import "REMWidgetAxisHelper.h"
#import "REMBuildingTimeRangeDataModel.h"
#import "REMTimeHelper.h"
#import "REMBuildingTrendWrapper.h"
#import "REMBuildingChartSeriesIndicator.h"

@interface REMBuildingTrendChartViewController ()

@property (nonatomic, assign) REMRelativeTimeRangeType timeRangeType;

@property (nonatomic) CGRect viewFrame;
@property (nonatomic, assign) BOOL loadDataSuccess;
@property (nonatomic,strong) NSMutableArray *datasource;
@end

@implementation REMBuildingTrendChartViewController

const int buttonHeight = 30;
const int buttonWidth = 70;
const int buttonMargin = 5;
const int buttonFirstMargin = -20;
- (REMBuildingChartBaseViewController *)initWithViewFrame:(CGRect)frame
{
    self = [super initWithViewFrame:frame];
    if (self) {
        self.requestUrl=REMDSBuildingTimeRangeData;
        self.datasource = [[NSMutableArray alloc]initWithCapacity:6];
        
        REMToggleButtonGroup* toggleGroup = [[REMToggleButtonGroup alloc]init];
        [self makeButton:REMLocalizedString(@"Common_Today") rect:CGRectMake(buttonFirstMargin, 0, buttonWidth,buttonHeight) group:toggleGroup];
        [self makeButton:REMLocalizedString(@"Common_Yesterday") rect:CGRectMake(buttonMargin + buttonWidth+buttonFirstMargin,0,buttonWidth,buttonHeight) group:toggleGroup];
        [self makeButton:REMLocalizedString(@"Common_ThisMonth") rect:CGRectMake((buttonMargin + buttonWidth)*2+buttonFirstMargin,0,buttonWidth,buttonHeight) group:toggleGroup];
        [self makeButton:REMLocalizedString(@"Common_LastMonth") rect:CGRectMake((buttonMargin + buttonWidth)*3+buttonFirstMargin,0,buttonWidth,buttonHeight) group:toggleGroup];
        [self makeButton:REMLocalizedString(@"Common_ThisYear") rect:CGRectMake((buttonMargin + buttonWidth)*4+buttonFirstMargin,0,buttonWidth,buttonHeight) group:toggleGroup];
        [self makeButton:REMLocalizedString(@"Common_LastYear") rect:CGRectMake((buttonMargin + buttonWidth)*5+buttonFirstMargin,0,buttonWidth,buttonHeight) group:toggleGroup];
        toggleGroup.delegate = self;
        self.loadDataSuccess = NO;
        self.timeRangeType = REMRelativeTimeRangeTypeThisMonth;
    }
//    CGRect fff = CGRectMake(0, buttonHeight, self.frame.size.width + 22, self.frame.size.height - buttonHeight - 20 - kBuildingTrendChartLegendHeight);
    return self;
}
- (REMToggleButton*) makeButton:(NSString*)buttonText rect:(CGRect)rect group:(REMToggleButtonGroup*)toggleGroup{
    REMToggleButton* btn = [REMToggleButton buttonWithType: UIButtonTypeCustom];
    [btn setFrame:rect];
    btn.showsTouchWhenHighlighted = YES;
    btn.adjustsImageWhenHighlighted = YES;
    [btn setTitle:buttonText forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [toggleGroup registerButton:btn];
    return btn;
}

-(void)activedButtonChanged:(UIButton*)newButton {
    [self intervalChanged:newButton];
}

-(REMEnergyViewData*)convertData:(id)data {
    [self.datasource removeAllObjects];
    for(NSDictionary *item in (NSArray *)data){
        REMBuildingTimeRangeDataModel* dataItem = [[REMBuildingTimeRangeDataModel alloc] initWithDictionary:item];
        [self.datasource addObject:dataItem];
    }
    for(REMBuildingTimeRangeDataModel *item in self.datasource){
        if (item.timeRangeType == self.timeRangeType) return item.timeRangeData;
    }
    return nil;
}
-(DCTrendWrapper*)constructWrapperWithFrame:(CGRect)frame {
    REMWidgetContentSyntax* syntax = [[REMWidgetContentSyntax alloc]init];
    syntax.relativeDateType = self.timeRangeType;
    syntax.step = @([self getEnergyStep]);
    REMChartStyle* style = [REMChartStyle getCoverStyle];
    frame.origin.y = buttonHeight;
    frame.size.height = frame.size.height - buttonHeight;
    REMBuildingTrendWrapper* wrapper = [[REMBuildingTrendWrapper alloc]initWithFrame:frame data:self.energyViewData widgetContext:syntax style:style];
    return wrapper;
}

-(void)prepareShare {
//    if (currentSourceIndex != 2) {
//        REMToggleButton* activeBtn = nil;
//        REMBuildingTrendChart* myView = (REMBuildingTrendChart*)self.view;
//        if (currentSourceIndex == 0) {
//            activeBtn = myView.todayButton;
//        } else if (currentSourceIndex == 1) {
//            activeBtn = myView.yestodayButton;
//        } else if (currentSourceIndex == 2) {
//            activeBtn = myView.thisMonthButton;
//        } else if (currentSourceIndex == 3) {
//            activeBtn = myView.lastMonthButton;
//        } else if (currentSourceIndex == 4) {
//            activeBtn = myView.thisYearButton;
//        } else if (currentSourceIndex == 5) {
//            activeBtn = myView.lastYearButton;
//        }
//        [myView.thisMonthButton setOn:YES];
//        [activeBtn setOn:NO];
//        [self intervalChanged:myView.thisMonthButton];
//    }
}

- (int)getSourceIndex: (REMRelativeTimeRangeType)type {
    int i = 0;
    
    if (type == REMRelativeTimeRangeTypeToday) {
        i = 0;
    } else if (type == REMRelativeTimeRangeTypeYesterday) {
        i = 1;
    } else if (type == REMRelativeTimeRangeTypeThisMonth) {
        i = 2;
    } else if (type == REMRelativeTimeRangeTypeLastMonth) {
        i = 3;
    } else if (type == REMRelativeTimeRangeTypeThisYear) {
        i = 4;
    } else if (type == REMRelativeTimeRangeTypeLastYear) {
        i = 5;
    }
    
    return i;
}


- (void)intervalChanged:(UIButton *)button {
//    if (!self.loadDataSuccess) return;
//    REMRelativeTimeRangeType timeRange = REMRelativeTimeRangeTypeToday;
//    REMBuildingTrendChart* myView = (REMBuildingTrendChart*)self.view;
//    if (button == myView.todayButton) {
//        timeRange = REMRelativeTimeRangeTypeToday;
//    } else if (button == myView.yestodayButton) {
//        timeRange = REMRelativeTimeRangeTypeYesterday;
//    } else if (button == myView.thisMonthButton) {
//        timeRange = REMRelativeTimeRangeTypeThisMonth;
//    } else if (button == myView.lastMonthButton) {
//        timeRange = REMRelativeTimeRangeTypeLastMonth;
//    } else if (button == myView.thisYearButton) {
//        timeRange = REMRelativeTimeRangeTypeThisYear;
//    } else if (button == myView.lastYearButton) {
//        timeRange = REMRelativeTimeRangeTypeLastYear;
//    }
//    currentSourceIndex = [self getSourceIndex:timeRange];
//    
//    REMBuildingTimeRangeDataModel* seriesArray = [self.datasource objectAtIndex:currentSourceIndex];
//    int pointCount = 0;
//    if (!REMIsNilOrNull(seriesArray)) {
//        for (int i = 0; i < seriesArray.timeRangeData.targetEnergyData.count; i++) {
//            REMTargetEnergyData* s = seriesArray.timeRangeData.targetEnergyData[i];
//            pointCount+= s.energyData.count;
//        }
//    }
//    if (pointCount == 0) {
//        myView.chartView.hidden = YES;
//        [self drawLabelWithText:NSLocalizedString(@"BuildingChart_NoData", @"")];
//        myView.legendView.hidden = YES;
//        return;
//    }
//    self.textLabel.hidden = YES;
//    myView.legendView.hidden = NO;
//    REMEnergyStep step = currentSourceIndex < 2 ? REMEnergyStepHour : (currentSourceIndex < 4 ? REMEnergyStepDay : REMEnergyStepMonth);
//    [myView redrawWith:self.datasource[currentSourceIndex] step:step timeRangeType:timeRange];
//    CGFloat legendLeft = 57;
//    CGFloat labelDistance = 18;
//    CGFloat legendTop = 0;
//    for (DCXYSeries* series in myView.chartView.seriesList) {
//        CGFloat fontSize = 14;
//        // Draw legend
//        NSString* legendText = series.target.name;
//        CGSize textSize = [legendText sizeWithFont:[UIFont systemFontOfSize:fontSize]];
//        CGFloat benchmarkWidth = textSize.width + 26;
//        CGRect benchmarkFrame = CGRectMake(legendLeft, legendTop, benchmarkWidth, MAX(textSize.height, 15));
//        legendLeft = legendLeft + benchmarkWidth + labelDistance;
//        if (legendLeft > myView.legendView.bounds.size.width) {
//            legendLeft = 57;
//            legendTop += 14*2;
//        }
//        REMBuildingChartSeriesIndicator *benchmarkIndicator = [[REMBuildingChartSeriesIndicator alloc] initWithFrame:benchmarkFrame title:legendText andColor:series.color];
//        [myView.legendView addSubview:benchmarkIndicator];
//    }
}

-(REMEnergyStep)getEnergyStep {
    REMEnergyStep step = REMEnergyStepNone;
    switch (self.timeRangeType) {
        case REMRelativeTimeRangeTypeToday:
        case REMRelativeTimeRangeTypeYesterday:
            step = REMEnergyStepHour;
            break;
        case REMRelativeTimeRangeTypeThisMonth:
        case REMRelativeTimeRangeTypeLastMonth:
            step = REMEnergyStepDay;
            break;
        case REMRelativeTimeRangeTypeThisYear:
        case REMRelativeTimeRangeTypeLastYear:
            step = REMEnergyStepMonth;
        default:
            break;
    }
    return step;
}


-(NSDictionary *)assembleRequestParametersWithBuildingId:(long long)buildingId WithCommodityId:(long long)commodityID WithMetadata:(REMAverageUsageDataModel *)averageData
{
    NSMutableDictionary *buildingCommodityInfo = [[NSMutableDictionary alloc] init];
    //    self.buildingInfo.building.buildingId
    [buildingCommodityInfo setValue:[NSNumber numberWithLong: buildingId] forKey:@"buildingId"];
    [buildingCommodityInfo setValue:[NSNumber numberWithLong:commodityID] forKey:@"commodityId"];
    [buildingCommodityInfo setValue:[NSNumber numberWithInt:1] forKey:@"relativeType"];
    
    return buildingCommodityInfo;
}


- (void)loadDataSuccessWithData:(id)data {
    self.loadDataSuccess = YES;
    [super loadDataSuccessWithData:data];
}

- (void)loadDataFailureWithError:(REMBusinessErrorInfo *)error {
    self.loadDataSuccess = NO;

//    REMBuildingTrendChart* myView = (REMBuildingTrendChart*)self.view;
//    [myView.thisMonthButton setOn:YES];
//    [self intervalChanged:myView.thisMonthButton];
    
    [super loadDataFailureWithError:error];
}

@end
