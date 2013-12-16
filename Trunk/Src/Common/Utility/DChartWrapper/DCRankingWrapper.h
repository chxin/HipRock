//
//  DCRankingWrapper.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/22/13.
//
//

#import "DCColumnWrapper.h"

@interface DCRankingWrapper : DCColumnWrapper
@property (nonatomic) NSComparisonResult sortOrder;
@property (nonatomic, readonly) REMRankingRange rankingRangeCode;
@end
