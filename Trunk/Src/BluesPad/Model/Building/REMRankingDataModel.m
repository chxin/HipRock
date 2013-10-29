//
//  REMRankingDataModel.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 8/1/13.
//
//

#import "REMRankingDataModel.h"

@implementation REMRankingDataModel

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.numerator = [dictionary[@"RankingNumerator"] intValue];
    self.denominator = [dictionary[@"RankingDenominator"] intValue];
}

@end
