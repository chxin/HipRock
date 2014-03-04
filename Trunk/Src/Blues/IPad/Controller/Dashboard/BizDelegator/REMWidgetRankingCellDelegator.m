/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetRankingCellDelegator.m
 * Date Created : tantan on 12/16/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMWidgetRankingCellDelegator.h"

@implementation REMWidgetRankingCellDelegator


- (NSString *)cellTimeTitle{
    
    if (self.searchModel.relativeDateType != REMRelativeTimeRangeTypeNone) {
        return self.searchModel.relativeDateComponent;
    }
    else{
        REMTimeRange *range = self.searchModel.timeRangeArray[0];
        NSString *start= [REMTimeHelper formatTimeFullDay:range.startTime isChangeTo24Hour:NO];
        NSString *end= [REMTimeHelper formatTimeFullDay:range.endTime isChangeTo24Hour:YES];
        return [NSString stringWithFormat:REMIPadLocalizedString(@"Dashboard_TimeRange"),start,end];//%@ 到 %@
    }
}

@end
