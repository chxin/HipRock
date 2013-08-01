//
//  REMRankingDataModel.m
//  Blues
//
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
