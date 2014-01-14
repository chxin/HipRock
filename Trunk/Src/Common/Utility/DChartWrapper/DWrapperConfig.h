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
@property (nonatomic, assign) REMEnergyStep step;   // Line, Column
@property (nonatomic, assign) BOOL stacked;         // Column
@property (nonatomic, assign) REMCalendarType calendarType; // Line, Column

@property (nonatomic, assign) REMRankingRange rankingRangeCode; // Ranking
@property (nonatomic, assign) NSComparisonResult rankingDefaultSortOrder; // Ranking

@property (nonatomic, strong) NSString* benckmarkText; // Labeling


@property (nonatomic) REMRelativeTimeRangeType relativeDateType; // Cover用电趋势图
@end
