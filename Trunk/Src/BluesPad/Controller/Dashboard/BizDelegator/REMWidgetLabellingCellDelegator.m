/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetLabellingCellDelegator.m
 * Date Created : tantan on 12/16/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMWidgetLabellingCellDelegator.h"
#import "REMWidgetLabellingSearchModel.h"


@implementation REMWidgetLabellingCellDelegator

- (NSString *)cellTimeTitle
{
    REMWidgetLabellingSearchModel *labellingModel=(REMWidgetLabellingSearchModel *)self.searchModel;
    return labellingModel.benchmarkText;
}

@end
