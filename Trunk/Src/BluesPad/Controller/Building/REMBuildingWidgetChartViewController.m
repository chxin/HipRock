/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingWidgetChartViewController.m
 * Date Created : tantan on 12/27/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMBuildingWidgetChartViewController.h"
#import "DCRankingWrapper.h"
#import "DCPieWrapper.h"
#import "REMChartHeader.h"
#import "DCLineWrapper.h"
#import "DCLabelingWrapper.h"
#import "REMBuildingChartView.h"
@interface REMBuildingWidgetChartViewController ()


@property (nonatomic,strong) DAbstractChartWrapper *wrapper;


@end

@implementation REMBuildingWidgetChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
//    self.view = [[REMBuildingChartView alloc]initWithFrame:self.viewFrame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (NSDictionary *)assembleRequestParametersWithBuildingId:(long long)buildingId WithCommodityId:(long long)commodityID WithMetadata:(REMAverageUsageDataModel *)averageData
{
    REMWidgetSearchModelBase *model=[REMWidgetSearchModelBase searchModelByDataStoreType:self.widgetInfo.contentSyntax.dataStoreType withParam:self.widgetInfo.contentSyntax.params];
    if(self.widgetInfo.contentSyntax.relativeDateType!=REMRelativeTimeRangeTypeNone){
        model.relativeDateType=self.widgetInfo.contentSyntax.relativeDateType;
    }
    self.requestUrl=self.widgetInfo.contentSyntax.dataStoreType;
    return [model toSearchParam];
}

- (void)loadDataSuccessWithData:(NSDictionary *)data{
    DAbstractChartWrapper *widgetWrapper = nil;
    REMDiagramType widgetType = self.widgetInfo.diagramType;
    CGRect widgetRect = self.view.bounds;
    REMChartStyle* style = [REMChartStyle getCoverStyle];
    REMEnergyViewData *energyData=[[REMEnergyViewData alloc]initWithDictionary:data];
    if (widgetType == REMDiagramTypeLine) {
        widgetWrapper = [[DCLineWrapper alloc]initWithFrame:widgetRect data:energyData widgetContext:self.widgetInfo.contentSyntax style:style];
    } else if (widgetType == REMDiagramTypeColumn) {
        widgetWrapper = [[DCColumnWrapper alloc]initWithFrame:widgetRect data:energyData widgetContext:self.widgetInfo.contentSyntax style:style];
    } else if (widgetType == REMDiagramTypePie) {
        widgetWrapper = [[DCPieWrapper alloc]initWithFrame:widgetRect data:energyData widgetContext:self.widgetInfo.contentSyntax style:style];
    } else if (widgetType == REMDiagramTypeRanking) {
        widgetWrapper = [[DCRankingWrapper alloc]initWithFrame:widgetRect data:energyData widgetContext:self.widgetInfo.contentSyntax style:style];
    } else if (widgetType == REMDiagramTypeStackColumn) {
        widgetWrapper = [[DCColumnWrapper alloc]initWithFrame:widgetRect data:energyData widgetContext:self.widgetInfo.contentSyntax style:style];
    } else if (widgetType == REMDiagramTypeLabelling) {
        widgetWrapper = [[DCLabelingWrapper alloc]initWithFrame:widgetRect data:energyData widgetContext:self.widgetInfo.contentSyntax style:style];
    }
    if (widgetWrapper != nil) {
        self.wrapper=widgetWrapper;
        
        [self.view addSubview:[widgetWrapper getView]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
