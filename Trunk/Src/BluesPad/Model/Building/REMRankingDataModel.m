/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMRankingDataModel.m
 * Created      : 张 锋 on 8/1/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMRankingDataModel.h"

@implementation REMRankingDataModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.numerator = [dictionary[@"RankingNumerator"] intValue];
    self.denominator = [dictionary[@"RankingDenominator"] intValue];
}

@end
