/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMPieChartLegendView.m
 * Date Created : 张 锋 on 1/6/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMPieChartLegendView.h"
#import "DCPieWrapper.h"
#import "DCPieSeries.h"
#import "DCPieDataPoint.h"
#import "REMTextIndicatorFormator.h"

@implementation REMPieChartLegendView

-(NSArray *)convertItemModels
{
    NSMutableArray *models = [[NSMutableArray alloc] init];
    
    DCPieSeries *series = ((DCPieWrapper *)self.chartWrapper).view.series;
    
    for(int i=0;i<series.datas.count;i++){
        DCPieDataPoint *pieSlice = series.datas[i];
        
        REMChartLegendItemModel *model = [[REMChartLegendItemModel alloc] init];
        
        model.index = i;
        model.type = REMChartSeriesIndicatorPie;
        model.title = [self format:pieSlice.target];
        model.legendView = self;
        model.color = [pieSlice.color copy];
//        model.isBenchmark = pieSlice.target.type == REMEnergyTargetBenchmarkValue;
        model.isDefaultHidden = pieSlice.hidden;
        
        [models addObject:model];
    }
    
    return models;
}

-(NSString *)format:(REMEnergyTargetModel *)target
{
    return [REMTextIndicatorFormator formatTargetName:target inEnergyData:self.data withWidget:self.widget andParameters:self.parameters];
}

@end
