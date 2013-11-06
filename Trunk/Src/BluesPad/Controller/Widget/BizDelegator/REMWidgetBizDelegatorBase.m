//
//  REMWidgetBizDelegatorBase.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/4/13.
//
//

#import "REMWidgetBizDelegatorBase.h"
#import "REMWidgetEnergyDelegator.h"
#import "REMWidgetRankingDelegator.h"

@implementation REMWidgetBizDelegatorBase

+ (REMWidgetBizDelegatorBase *)bizDelegatorByWidgetInfo:(REMWidgetObject *)widgetInfo
{
    REMWidgetBizDelegatorBase *delegator;
    if(widgetInfo.contentSyntax.dataStoreType == REMDSEnergyRankingCarbon ||
       widgetInfo.contentSyntax.dataStoreType == REMDSEnergyRankingCost ||
       widgetInfo.contentSyntax.dataStoreType == REMDSEnergyRankingEnergy){
        delegator=[[REMWidgetRankingDelegator alloc]init];
    }
    else if(widgetInfo.contentSyntax.dataStoreType == REMDSEnergyLabeling){
        
    }
    else{
        delegator=[[REMWidgetEnergyDelegator alloc]init];
    }
    
    return delegator;
}

- (void)initBizView{}

- (void)showChart{}

- (void)doSearchWithModel:(REMWidgetSearchModelBase *)model callback:(void (^)(REMEnergyViewData *, REMBusinessErrorInfo *))callback
{
    [self.searcher queryEnergyDataByStoreType:self.widgetInfo.contentSyntax.dataStoreType andParameters:[model toSearchParam] withMaserContainer:self.maskerView  andGroupName:self.groupName callback:^(REMEnergyViewData *energyData,REMBusinessErrorInfo *errorInfo){
        
        self.energyData=energyData;
        
        if(callback!=nil){
            callback(energyData,errorInfo);
        }
        
    }];
}


@end
