/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingTrendChartHandler.m
 * Created      : 张 锋 on 8/9/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingTrendChartViewController.h"
#import "REMBuildingTimeRangeDataModel.h"
#import "REMTimeHelper.h"
#import "REMBuildingTrendWrapper.h"
#import "REMBuildingChartSeriesIndicator.h"
#import "REMToggleButtonGroup.h"

@interface REMBuildingTrendChartViewController ()

@property (nonatomic, assign) REMRelativeTimeRangeType timeRangeType;

@property (nonatomic, assign) BOOL loadDataSuccess;
@property (nonatomic,strong) NSMutableArray *datasource;
@property (nonatomic,strong) REMToggleButtonGroup* toggleGroup;
@property (nonatomic,strong) REMToggleButton* defaultButton;
@end

@implementation REMBuildingTrendChartViewController

const int buttonHeight = 30;
const int buttonWidth = 70;
const int buttonMargin = 5;
const int buttonFirstMargin = -20;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.requestUrl=REMDSBuildingTimeRangeData;
    self.datasource = [[NSMutableArray alloc]initWithCapacity:6];
    
    REMToggleButtonGroup* toggleGroup = [[REMToggleButtonGroup alloc]init];
    _toggleGroup = toggleGroup;
    [self makeButton:REMLocalizedString(@"Common_Today") rect:CGRectMake(buttonFirstMargin, 0, buttonWidth,buttonHeight) group:toggleGroup].value = @(REMRelativeTimeRangeTypeToday);
    [self makeButton:REMLocalizedString(@"Common_Yesterday") rect:CGRectMake(buttonMargin + buttonWidth+buttonFirstMargin,0,buttonWidth,buttonHeight) group:toggleGroup].value = @(REMRelativeTimeRangeTypeYesterday);
    self.defaultButton = [self makeButton:REMLocalizedString(@"Common_ThisMonth") rect:CGRectMake((buttonMargin + buttonWidth)*2+buttonFirstMargin,0,buttonWidth,buttonHeight) group:toggleGroup];
    self.defaultButton.on = YES;
    self.defaultButton.value = @(REMRelativeTimeRangeTypeThisMonth);
    [self makeButton:REMLocalizedString(@"Common_LastMonth") rect:CGRectMake((buttonMargin + buttonWidth)*3+buttonFirstMargin,0,buttonWidth,buttonHeight) group:toggleGroup].value = @(REMRelativeTimeRangeTypeLastMonth);
    [self makeButton:REMLocalizedString(@"Common_ThisYear") rect:CGRectMake((buttonMargin + buttonWidth)*4+buttonFirstMargin,0,buttonWidth,buttonHeight) group:toggleGroup].value = @(REMRelativeTimeRangeTypeThisYear);
    [self makeButton:REMLocalizedString(@"Common_LastYear") rect:CGRectMake((buttonMargin + buttonWidth)*5+buttonFirstMargin,0,buttonWidth,buttonHeight) group:toggleGroup].value = @(REMRelativeTimeRangeTypeLastYear);
    toggleGroup.delegate = self;
    self.loadDataSuccess = NO;
    self.timeRangeType = REMRelativeTimeRangeTypeThisMonth;
}
//- (REMBuildingChartBaseViewController *)initWithViewFrame:(CGRect)frame
//{
//    self = [super initWithViewFrame:frame];
//    if (self) {
//        self.requestUrl=REMDSBuildingTimeRangeData;
//        self.datasource = [[NSMutableArray alloc]initWithCapacity:6];
//        
//        REMToggleButtonGroup* toggleGroup = [[REMToggleButtonGroup alloc]init];
//        _toggleGroup = toggleGroup;
//        [self makeButton:REMLocalizedString(@"Common_Today") rect:CGRectMake(buttonFirstMargin, 0, buttonWidth,buttonHeight) group:toggleGroup].value = @(REMRelativeTimeRangeTypeToday);
//        [self makeButton:REMLocalizedString(@"Common_Yesterday") rect:CGRectMake(buttonMargin + buttonWidth+buttonFirstMargin,0,buttonWidth,buttonHeight) group:toggleGroup].value = @(REMRelativeTimeRangeTypeYesterday);
//        self.defaultButton = [self makeButton:REMLocalizedString(@"Common_ThisMonth") rect:CGRectMake((buttonMargin + buttonWidth)*2+buttonFirstMargin,0,buttonWidth,buttonHeight) group:toggleGroup];
//        self.defaultButton.on = YES;
//        self.defaultButton.value = @(REMRelativeTimeRangeTypeThisMonth);
//        [self makeButton:REMLocalizedString(@"Common_LastMonth") rect:CGRectMake((buttonMargin + buttonWidth)*3+buttonFirstMargin,0,buttonWidth,buttonHeight) group:toggleGroup].value = @(REMRelativeTimeRangeTypeLastMonth);
//        [self makeButton:REMLocalizedString(@"Common_ThisYear") rect:CGRectMake((buttonMargin + buttonWidth)*4+buttonFirstMargin,0,buttonWidth,buttonHeight) group:toggleGroup].value = @(REMRelativeTimeRangeTypeThisYear);
//        [self makeButton:REMLocalizedString(@"Common_LastYear") rect:CGRectMake((buttonMargin + buttonWidth)*5+buttonFirstMargin,0,buttonWidth,buttonHeight) group:toggleGroup].value = @(REMRelativeTimeRangeTypeLastYear);
//        toggleGroup.delegate = self;
//        self.loadDataSuccess = NO;
//        self.timeRangeType = REMRelativeTimeRangeTypeThisMonth;
//    }
//    return self;
//}
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

-(void)activedButtonChanged:(REMToggleButton*)newButton {
    self.timeRangeType = [newButton.value intValue];
    [self intervalChanged];
    [self updateLegendView];
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
    DWrapperConfig* wrapperConfig = [[DWrapperConfig alloc]init];
    wrapperConfig.step = [self getEnergyStep];
    wrapperConfig.relativeDateType = self.timeRangeType;
    
    REMChartStyle* style = [REMChartStyle getCoverStyle];
    frame.origin.y = buttonHeight;
    frame.size.height = frame.size.height - buttonHeight;
    REMBuildingTrendWrapper* wrapper = [[REMBuildingTrendWrapper alloc]initWithFrame:frame data:self.energyViewData wrapperConfig:wrapperConfig style:style];
    return wrapper;
}

-(void)prepareShare {
    if (self.timeRangeType != REMRelativeTimeRangeTypeThisMonth) {
        self.defaultButton.on = YES;
        self.timeRangeType = [self.defaultButton.value intValue];
        [self intervalChanged];
        [self updateLegendView];
    }
}

- (void)intervalChanged {
    if (!self.loadDataSuccess) return;
    ((REMBuildingTrendWrapper*)self.chartWrapper).timeRangeType = self.timeRangeType;
    for(REMBuildingTimeRangeDataModel *item in self.datasource){
        if (item.timeRangeType == self.timeRangeType) {
            self.energyViewData = item.timeRangeData;
            break;
        }
    }
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

- (void)loadDataFailureWithError:(REMBusinessErrorInfo *)error withStatus:(REMDataAccessErrorStatus)status {
    self.loadDataSuccess = NO;
    [super loadDataFailureWithError:error withStatus:status];
}

@end
