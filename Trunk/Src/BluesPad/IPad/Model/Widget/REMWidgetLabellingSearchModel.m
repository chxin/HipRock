/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetLabellingSearchModel.m
 * Date Created : tantan on 12/13/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMWidgetLabellingSearchModel.h"

@implementation REMWidgetLabellingSearchModel

- (NSDictionary *)toSearchParam{
    NSDictionary *dic=[super toSearchParam];
    
    NSMutableDictionary *mutableDic=[dic mutableCopy];
    
    mutableDic[@"labelingType"]=@(self.labellingType);
    
    return mutableDic;
    
    
}

- (void)setModelBySearchParam:(NSDictionary *)param
{
    [super setModelBySearchParam:param];
    self.labellingType=(REMLabellingType)[param[@"labelingType"] integerValue];
}

@end
