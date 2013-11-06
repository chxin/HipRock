/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnergyConstants.m
 * Created      : 谭 坦 on 7/18/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMEnergyConstants.h"



@implementation REMEnergyConstants

static  NSDictionary *_sharedRelativeDate;


+(NSDictionary *)sharedRelativeDateDictionary
{
    if(_sharedRelativeDate==nil){
        _sharedRelativeDate=@{
          @"Customize":@"自定义",
          @"Last7Day":@"之前七天",
          @"Today":@"今天",
          @"Yesterday":@"昨天",
          @"ThisWeek":@"本周",
          @"LastWeek":@"上周",
          @"ThisMonth":@"本月",
          @"LastMonth":@"上月",
          @"ThisYear":@"本年",
          @"LastYear":@"去年"};
    }
    return _sharedRelativeDate;
}


@end
