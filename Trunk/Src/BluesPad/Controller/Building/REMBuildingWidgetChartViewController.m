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

- (NSDictionary *)assembleRequestParametersWithBuildingId:(long long)buildingId WithCommodityId:(long long)commodityID WithMetadata:(REMAverageUsageDataModel *)averageData
{
    REMWidgetSearchModelBase *model=[REMWidgetSearchModelBase searchModelByDataStoreType:self.widgetInfo.contentSyntax.dataStoreType withParam:self.widgetInfo.contentSyntax.params];
    if(self.widgetInfo.contentSyntax.relativeDateType!=REMRelativeTimeRangeTypeNone){
        model.relativeDateType=self.widgetInfo.contentSyntax.relativeDateType;
    }
    self.requestUrl=self.widgetInfo.contentSyntax.dataStoreType;
    return [model toSearchParam];
}

-(DCTrendWrapper*)constructWrapperWithFrame:(CGRect)frame {
    DCTrendWrapper *widgetWrapper = nil;
    REMDiagramType widgetType = self.widgetInfo.diagramType;
    REMChartStyle* style = [REMChartStyle getCoverStyle];
    if ([self getEnergyStep] == REMEnergyStepHour) style.acceptPan = NO;
    if (widgetType == REMDiagramTypeLine) {
        widgetWrapper = [[DCLineWrapper alloc]initWithFrame:frame data:self.energyViewData widgetContext:self.widgetInfo.contentSyntax style:style];
    }
    else if (widgetType == REMDiagramTypeColumn) {
        widgetWrapper = [[DCColumnWrapper alloc]initWithFrame:frame data:self.energyViewData widgetContext:self.widgetInfo.contentSyntax style:style];
    }
    else if (widgetType == REMDiagramTypeRanking) {
        widgetWrapper = [[DCRankingWrapper alloc]initWithFrame:frame data:self.energyViewData widgetContext:self.widgetInfo.contentSyntax style:style];
    }
    else if (widgetType == REMDiagramTypeStackColumn) {
        widgetWrapper = [[DCColumnWrapper alloc]initWithFrame:frame data:self.energyViewData widgetContext:self.widgetInfo.contentSyntax style:style];
    }
    return widgetWrapper;
}

-(REMEnergyStep)getEnergyStep {
    return self.widgetInfo.contentSyntax.step.integerValue;
}

@end
