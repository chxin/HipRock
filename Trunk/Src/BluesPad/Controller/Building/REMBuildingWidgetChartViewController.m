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
#import "REMWidgetStepEnergyModel.h"
#import "REMWidgetRankingSearchModel.h"
#import "REMTextIndicatorFormator.h"
#import "REMEnergySeacherBase.h"

@interface REMBuildingWidgetChartViewController ()


@property (nonatomic,strong) DAbstractChartWrapper *wrapper;
@property (nonatomic,strong) REMWidgetSearchModelBase *model;
@property (nonatomic,strong) REMEnergySeacherBase *searcher;
@end

@implementation REMBuildingWidgetChartViewController

- (void)loadData:(long long)buildingId :(long long)commodityID :(REMAverageUsageDataModel *)averageUsageData :(void (^)(id, REMBusinessErrorInfo *))loadCompleted
{
    REMWidgetSearchModelBase *model=[REMWidgetSearchModelBase searchModelByDataStoreType:self.widgetInfo.contentSyntax.dataStoreType withParam:self.widgetInfo.contentSyntax.params];
    if(self.widgetInfo.contentSyntax.relativeDateType!=REMRelativeTimeRangeTypeNone){
        model.relativeDateType=self.widgetInfo.contentSyntax.relativeDateType;
    }
    self.model=model;
    
    self.requestUrl=self.widgetInfo.contentSyntax.dataStoreType;

    self.searcher = [REMEnergySeacherBase querySearcherByType:self.widgetInfo.contentSyntax.dataStoreType withWidgetInfo:self.widgetInfo];
    
    [self startLoadingActivity];
    [self.searcher queryEnergyDataByStoreType:self.widgetInfo.contentSyntax.dataStoreType andParameters:self.model withMaserContainer:nil andGroupName:[NSString stringWithFormat:@"building-data-%@", @(buildingId)] callback:^(id data, REMBusinessErrorInfo *bizError) {
        [self stopLoadingActivity];
        if (bizError==nil) {
            if(self.isViewLoaded==NO)return ;
            self.energyViewData = data;
            loadCompleted(data,nil);
        }
        else{
            loadCompleted(nil,bizError);
            if(bizError!=nil){
                [self loadDataFailureWithError:bizError];
            }
        }
        
    }];
    
}


-(DCTrendWrapper*)constructWrapperWithFrame:(CGRect)frame {
    DCTrendWrapper *widgetWrapper = nil;
    REMDiagramType widgetType = self.widgetInfo.diagramType;
    REMChartStyle* style = [REMChartStyle getCoverStyle];
    style.acceptPan = [self getEnergyStep] != REMEnergyStepHour;
    DWrapperConfig* wrapperConfig = [[DWrapperConfig alloc]initWith:self.widgetInfo];
    if ([self.model isKindOfClass:[REMWidgetStepEnergyModel class]]==YES) {
        REMWidgetStepEnergyModel *stepModel=(REMWidgetStepEnergyModel *)self.model;
        wrapperConfig.stacked=NO;
        wrapperConfig.step=stepModel.step;
        wrapperConfig.benckmarkText=stepModel.benchmarkText;
        wrapperConfig.relativeDateType=stepModel.relativeDateType;
    }
    
    
    if (widgetType == REMDiagramTypeLine) {
        widgetWrapper = [[DCLineWrapper alloc]initWithFrame:frame data:self.energyViewData wrapperConfig:wrapperConfig style:style];
        
    }
    else if (widgetType == REMDiagramTypeColumn) {
        widgetWrapper = [[DCColumnWrapper alloc]initWithFrame:frame data:self.energyViewData wrapperConfig:wrapperConfig style:style];
    }
    else if (widgetType == REMDiagramTypeRanking) {
        
        widgetWrapper = [[DCRankingWrapper alloc]initWithFrame:frame data:self.energyViewData wrapperConfig:wrapperConfig  style:style];
    }
    else if (widgetType == REMDiagramTypeStackColumn) {
        wrapperConfig.stacked=YES;
        widgetWrapper = [[DCColumnWrapper alloc]initWithFrame:frame data:self.energyViewData wrapperConfig:wrapperConfig  style:style];
    }
    return widgetWrapper;
}

-(REMEnergyStep)getEnergyStep {
    return self.widgetInfo.contentSyntax.step.integerValue;
}

-(NSString*)getLegendText:(DCXYSeries*)series index:(NSUInteger)index {
    return [REMTextIndicatorFormator formatTargetName:series.target inEnergyData:self.energyViewData withWidget:self.widgetInfo andParameters:self.model];
}
@end
