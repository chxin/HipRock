/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMStackChartLegendView.m
 * Date Created : 张 锋 on 11/18/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMStackChartLegendView.h"
#import "REMChartLegendItem.h"

@implementation REMStackChartLegendView

-(NSArray *)convertItemModels
{
    // Peak, blue; Valley, green; Plain, purple;
    NSArray *names = @[REMIPadLocalizedString(@"Chart_TOUPeak"),REMIPadLocalizedString(@"Chart_TOUValley"),REMIPadLocalizedString(@"Chart_TOUPlain")];
    NSMutableArray *models = [[NSMutableArray alloc] init];
    
    for(int i=0;i<3;i++){
        REMChartLegendItemModel *model = [[REMChartLegendItemModel alloc] init];
        model.index = i;
        model.title = names[i];
        model.type = REMChartSeriesIndicatorColumn;
        //if(self.widget.contentSyntax.dataStoreType == REMDSEnergyCostElectricity){
            model.tappable = NO;
//        }
//        else{
//            model.tappable = YES;
//        }
        model.legendView = self;
        
        
        [models addObject:model];
    }
    
    return models;
}

@end
