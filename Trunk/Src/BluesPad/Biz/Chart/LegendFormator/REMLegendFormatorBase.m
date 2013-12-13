/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLegendFormatorBase.m
 * Date Created : 张 锋 on 11/20/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMLegendFormatorBase.h"

@implementation REMLegendFormatorBase


+ (REMLegendFormatorBase *)formatorWidthData:(REMEnergyViewData *)data widget:(REMWidgetObject *) widget andParameters:(REMWidgetSearchModelBase *)parameters
{
    REMLegendFormatorBase *formator = nil;
    
    switch (widget.contentSyntax.dataStoreType) {
        case REMDSEnergyTagsTrend:
            //formator = [[REMAnalysisLegendFormator alloc] init];
            break;
            
        //TODO: more types
            
        default:
            break;
    }
    
    if(formator){
        formator.data = data;
        formator.widget = widget;
        formator.parameters = parameters;
    }
    
    return formator;
}

-(NSArray *)format
{
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    
    for(int i=0;i<self.data.targetEnergyData.count;i++){
        [titles addObject:[self format:i]];
    }
    
    return titles;
}

-(NSString *)format:(int)index
{
    return nil;
}

@end
