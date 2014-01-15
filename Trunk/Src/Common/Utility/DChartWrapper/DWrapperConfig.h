//
//  DWrapperConfig.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 1/14/14.
//
//

#import <Foundation/Foundation.h>
#import "REMEnum.h"
#import "REMWidgetObject.h"


@interface DWrapperConfig : NSObject
@property (nonatomic, assign) REMEnergyStep step;   // Line, Column
@property (nonatomic, assign) BOOL stacked;         // Line, Column. Default No.
@property (nonatomic, assign) REMCalendarType calendarType; // Line, Column
@property (nonatomic, assign) BOOL isUnitOrRatioChart;     // Line, Column. Default No.

@property (nonatomic, assign) REMRankingRange rankingRangeCode; // Ranking
@property (nonatomic, assign) NSComparisonResult rankingDefaultSortOrder; // Ranking

@property (nonatomic, strong) NSString* benckmarkText; // Labeling


@property (nonatomic) REMRelativeTimeRangeType relativeDateType; // Cover用电趋势图

-(id)initWith:(REMWidgetObject*)widgetObj;
@end
