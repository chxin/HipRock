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
#import "DCChartEnum.h"
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
@property (nonatomic,strong) REMWidgetContentSyntax *contentSyntax;
@end

@implementation REMBuildingWidgetChartViewController


- (void)loadData:(long long)buildingId :(long long)commodityID :(REMAverageUsageDataModel *)averageUsageData :(void (^)(id, REMBusinessErrorInfo *))loadCompleted
{
    self.contentSyntax = [[REMWidgetContentSyntax alloc]initWithJSONString:self.widgetInfo.contentSyntax];
    
    
    REMWidgetSearchModelBase *model=[REMWidgetSearchModelBase searchModelByDataStoreType:self.contentSyntax.dataStoreType withParam:self.contentSyntax.params];
    if(self.contentSyntax.relativeDateType!=REMRelativeTimeRangeTypeNone){
        model.relativeDateType=self.contentSyntax.relativeDateType;
    }
    self.model=model;
    
    self.requestUrl=self.contentSyntax.dataStoreType;

    self.searcher = [REMEnergySeacherBase querySearcherByType:self.contentSyntax.dataStoreType withWidgetInfo:self.widgetInfo andSyntax:self.contentSyntax];
    self.searcher.disableNetworkAlert=YES;
    [self startLoadingActivity];
    [self.searcher queryEnergyDataByStoreType:self.contentSyntax.dataStoreType andParameters:self.model withMaserContainer:nil andGroupName:[NSString stringWithFormat:@"building-data-%@", @(buildingId)] callback:^(id data, REMBusinessErrorInfo *bizError) {
        [self stopLoadingActivity];
        if (data!=nil) {
            if(self.isViewLoaded==NO)return ;
            self.energyViewData = data;
            loadCompleted(data,nil);
        }
        else{
            loadCompleted(nil,bizError);
            if (bizError == nil) {
                [self loadDataFailureWithError:bizError withStatus:REMDataAccessFailed];
            }
            else{
                [self loadDataFailureWithError:bizError withStatus:REMDataAccessErrorMessage];
            }
            
        }
        
    }];
    
}


-(DCTrendWrapper*)constructWrapperWithFrame:(CGRect)frame {
    DCTrendWrapper *widgetWrapper = nil;
<<<<<<< HEAD
    REMDiagramType widgetType = self.widgetInfo.diagramType;
    DCChartStyle* style = [DCChartStyle getCoverStyle];
=======
    REMDiagramType widgetType = (REMDiagramType)[self.widgetInfo.diagramType intValue];
    REMChartStyle* style = [REMChartStyle getCoverStyle];
>>>>>>> UseCoreData
    style.acceptPan = [self getEnergyStep] != REMEnergyStepHour;
    DWrapperConfig* wrapperConfig = [[DWrapperConfig alloc]initWith:self.contentSyntax];
    if ([self.model isKindOfClass:[REMWidgetStepEnergyModel class]]==YES) {
        REMWidgetStepEnergyModel *stepModel=(REMWidgetStepEnergyModel *)self.model;
        wrapperConfig.stacked=NO;
        wrapperConfig.step=stepModel.step;
        wrapperConfig.benckmarkText=stepModel.benchmarkText;
        wrapperConfig.relativeDateType=stepModel.relativeDateType;
//        wrapperConfig.multiTimeSpans=stepModel.timeRangeArray;
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
    for (DCXYSeries* s in widgetWrapper.view.seriesList) {
        s.color = [REMColor makeTransparent:0.8 withColor:s.color];
    }
    return widgetWrapper;
}

-(REMEnergyStep)getEnergyStep {
    return self.contentSyntax.step.integerValue;
}

-(NSString*)getLegendText:(DCXYSeries*)series index:(NSUInteger)index {
    return [REMTextIndicatorFormator formatTargetName:series.target inEnergyData:self.energyViewData withWidget:self.widgetInfo andParameters:self.model];
}
@end
