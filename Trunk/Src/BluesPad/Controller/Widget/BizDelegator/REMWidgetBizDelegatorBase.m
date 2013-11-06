/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetBizDelegatorBase.m
 * Created      : tantan on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMWidgetBizDelegatorBase.h"
#import "REMWidgetEnergyDelegator.h"

@implementation REMWidgetBizDelegatorBase

+ (REMWidgetBizDelegatorBase *)bizDelegatorByWidgetInfo:(REMWidgetObject *)widgetInfo
{
    REMWidgetBizDelegatorBase *base=[[REMWidgetEnergyDelegator alloc]init];
    
    
    return base;
}

- (void)doSearch:(void (^)(REMEnergyViewData *data,REMError *error))callback{
    [self.searcher queryEnergyDataByStoreType:self.widgetInfo.contentSyntax.dataStoreType andParameters:[self.model toSearchParam] withMaserContainer:self.maskerView  andGroupName:self.groupName callback:^(REMEnergyViewData *energyData){
    
        self.energyData=energyData;
        
        if(callback!=nil){
            callback(energyData,nil);
        }
    
    }];
     

}

@end
