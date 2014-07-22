/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartLegendView.m
 * Date Created : 张 锋 on 11/18/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMTrendChartLegendView.h"
#import "REMChartLegendItem.h"
#import "REMColor.h"
#import "REMWidgetStepEnergyModel.h"
#import "REMWidgetCommoditySearchModel.h"
#import "REMWidgetTagSearchModel.h"
#import "REMTextIndicatorFormator.h"
#import "REMChartLegendBase.h"
#import "DCXYSeries.h"
#import "DCXYChartView.h"
#import "DCTrendWrapper.h"

@implementation REMTrendChartLegendView

-(NSArray *)convertItemModels
{
    NSMutableArray *models = [[NSMutableArray alloc] init];
    
    NSArray *serieses = ((DCTrendWrapper *)self.chartWrapper).view.seriesList;
    
    for(int i=0;i<serieses.count;i++){
        DCXYSeries *series = serieses[i];
        
        REMChartLegendItemModel *model = [[REMChartLegendItemModel alloc] init];
        
        
        DCSeriesStatus *seriesState = ((DCTrendWrapper *)self.chartWrapper).seriesStates[series.seriesKey];
        
        model.index = i;
        model.type = seriesState.seriesType == DCSeriesTypeStatusLine ? REMChartSeriesIndicatorLine : (seriesState.seriesType == DCSeriesTypeStatusColumn ? REMChartSeriesIndicatorColumn : REMChartSeriesIndicatorStack);//series.type == DCSeriesTypeColumn ? REMChartSeriesIndicatorColumn : REMChartSeriesIndicatorLine;
        model.title = [self format:series.target];
        model.legendView = self;
        model.color = [series.color copy];
//        model.isBenchmark = series.target.type == REMEnergyTargetBenchmarkValue;
        model.isDefaultHidden = series.hidden;
        
        [models addObject:model];
    }
    
    return models;
}

-(NSString *)format:(REMEnergyTargetModel *)target
{
    return [REMTextIndicatorFormator formatTargetName:target inEnergyData:self.data withWidget:self.widget andParameters:self.parameters];
}

@end
