//
//  REMWidgetBizDelegatorBase.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/4/13.
//
//

#import "REMWidgetBizDelegatorBase.h"
#import "REMWidgetEnergyDelegator.h"

@implementation REMWidgetBizDelegatorBase

+ (REMWidgetBizDelegatorBase *)bizDelegatorByWidgetInfo:(REMWidgetObject *)widgetInfo
{
    REMWidgetBizDelegatorBase *base=[[REMWidgetEnergyDelegator alloc]init];
    
    
    return base;
}

- (void)initBizView{}

- (void)showChart{}

- (void)doSearch:(void (^)(REMEnergyViewData *data,REMBusinessErrorInfo *error))callback{
    [self.searcher queryEnergyDataByStoreType:self.widgetInfo.contentSyntax.dataStoreType andParameters:[self.model toSearchParam] withMaserContainer:self.maskerView  andGroupName:self.groupName callback:^(REMEnergyViewData *energyData,REMBusinessErrorInfo *errorInfo){
    
        self.energyData=energyData;
        
        if(callback!=nil){
            callback(energyData,errorInfo);
        }
    
    }];
     

}

@end
