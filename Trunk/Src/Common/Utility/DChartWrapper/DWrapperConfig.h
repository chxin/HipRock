//
//  DWrapperConfig.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 1/14/14.
//
//

#import <Foundation/Foundation.h>
#import "REMEnum.h"

@interface DWrapperConfig : NSObject
@property (nonatomic) REMEnergyStep step;   // Line, Column
@property (nonatomic) BOOL stacked;         // Column
@property (nonatomic) REMCalendarType calendarType; // Line, Column

@property (nonatomic) REMRankingRange rankingRangeCode; // Ranking
@property (nonatomic) NSComparisonResult rankingDefaultSortOrder; // Ranking

@property (nonatomic, copy) NSString* benckmarkText; // Labeling


@property (nonatomic) REMRelativeTimeRangeType relativeDateType; // Cover用电趋势图
@end
