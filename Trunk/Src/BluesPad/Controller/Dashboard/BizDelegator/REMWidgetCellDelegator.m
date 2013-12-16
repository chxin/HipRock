/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetCellDelegator.m
 * Date Created : tantan on 12/16/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMWidgetCellDelegator.h"
#import "REMWidgetLabellingCellDelegator.h"
#import "REMBuildingConstants.h"
#import "REMColor.h"
#import "REMDashboardController.h"
#import "REMWidgetCollectionViewController.h"

@implementation REMWidgetCellDelegator

+ (REMWidgetCellDelegator *)bizWidgetCellDelegator:(REMWidgetObject *)widgetInfo
{
    REMWidgetCellDelegator *delegator;
    if (widgetInfo.contentSyntax.dataStoreType == REMDSEnergyLabeling) {
        delegator = [[REMWidgetLabellingCellDelegator alloc]init];
    }
    else{
        delegator = [[REMWidgetCellDelegator alloc]init];
    }
    delegator.widgetInfo=widgetInfo;
    return delegator;
}

- (void)initBizView{
    [self initWidgetCellTimeTitle];
}

- (NSString *)cellTimeTitle{
    if([self.widgetInfo.contentSyntax.relativeDate isEqual:[NSNull null]]==NO){
        return self.widgetInfo.contentSyntax.relativeDateComponent;
    }
    else{
        REMTimeRange *range = self.widgetInfo.contentSyntax.timeRanges[0];
        NSString *start= [REMTimeHelper formatTimeFullHour:range.startTime isChangeTo24Hour:NO];
        NSString *end= [REMTimeHelper formatTimeFullHour:range.endTime isChangeTo24Hour:YES];
        return [NSString stringWithFormat:NSLocalizedString(@"Dashboard_TimeRange", @""),start,end];//%@ 到 %@
    }
}

- (void)initWidgetCellTimeTitle
{
    UILabel *time=[[UILabel alloc]initWithFrame:CGRectMake(self.title.frame.origin.x, self.title.frame.origin.y+self.title.frame.size.height+kDashboardWidgetTimeTopMargin, self.view.frame.size.width, kDashboardWidgetTimeSize)];
    time.backgroundColor=[UIColor clearColor];
    time.textColor=[REMColor colorByHexString:@"#5e5e5e"];
    time.font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:kDashboardWidgetTimeSize];
    time.text=[self cellTimeTitle];
    [self.view addSubview:time];
    self.timeLabel=time;
}

@end
