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
const int buttonMargin = 20;
const int buttonFirstMargin = 0;

- (id)init{
    self = [super init];
    if (self) {
        self.datasource = [[NSMutableArray alloc]initWithCapacity:6];
        self.loadDataSuccess=NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.requestUrl=REMDSBuildingTimeRangeData;
    
    REMToggleButtonGroup* toggleGroup = [[REMToggleButtonGroup alloc]init];
    toggleGroup.delegate = self;
    _toggleGroup = toggleGroup;
    
    NSDictionary *buttons = [self makeButtons];
    for(REMToggleButton *button in [buttons allValues]){
        [toggleGroup registerButton:button];
    }
    
    self.defaultButton = buttons[@(REMRelativeTimeRangeTypeThisMonth)];
    self.defaultButton.on = YES;
    
    self.timeRangeType = REMRelativeTimeRangeTypeThisMonth;
}



- (NSDictionary *)makeButtons {
    NSMutableArray *timeRangeButtons = [[NSMutableArray alloc] init];
    
    NSArray *types = @[@(REMRelativeTimeRangeTypeToday),@(REMRelativeTimeRangeTypeYesterday),@(REMRelativeTimeRangeTypeThisMonth),@(REMRelativeTimeRangeTypeLastMonth),@(REMRelativeTimeRangeTypeThisYear),@(REMRelativeTimeRangeTypeLastYear)];
    NSArray *texts = @[@"Common_Today",@"Common_Yesterday",@"Common_ThisMonth",@"Common_LastMonth",@"Common_ThisYear",@"Common_LastYear"];
    
    for(int i=0;i<types.count;i++){
        REMToggleButton* btn = [REMToggleButton buttonWithType: UIButtonTypeCustom];
        btn.tintColor=[UIColor whiteColor];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        btn.showsTouchWhenHighlighted = YES;
        btn.titleLabel.font = [REMFont defaultFontSystemSize];
        btn.value = types[i];
        [btn setTitle:REMIPadLocalizedString(texts[i]) forState:UIControlStateNormal];
        
        if(i == 0){
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        }
        else{
            UIButton *previous = timeRangeButtons[i-1];
            
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previous attribute:NSLayoutAttributeRight multiplier:1.0 constant:buttonMargin]];
            [self.view addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:previous attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        }
        
        [self.view addSubview:btn];
        [timeRangeButtons addObject:btn];
    }
    
    return [NSDictionary dictionaryWithObjects:timeRangeButtons forKeys:types];
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
    
    DCChartStyle* style = [DCChartStyle getCoverStyle];
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
    ((REMBuildingTrendWrapper*)self.chartWrapper).wrapperConfig.relativeDateType = self.timeRangeType;
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

- (void)loadDataFailureWithError:(REMBusinessErrorInfo *)error withStatus:(REMDataAccessStatus)status {
    self.loadDataSuccess = NO;
    [super loadDataFailureWithError:error withStatus:status];
}

@end
