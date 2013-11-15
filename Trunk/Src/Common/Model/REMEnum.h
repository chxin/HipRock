/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnum.h
 * Created      : tantan on 9/27/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>


typedef enum _REMCalenderType{
    REMCalendarTypeNone,
    REMCalenderTypeWorkDay,
    REMCalenderTypeNonworkDay,
    REMCalenderTypeHoliday,
    REMCalenderTypeCoolSeason,
    REMCalenderTypeHeatSeason,
    REMCalendarTypeHCSeason
} REMCalendarType;

typedef enum _REMCarbonUnit{
    REMCarbonUnitNone=0,
    REMCarbonStardardCoal=2,
    REMCarbonUnitCO2=3,
    REMCarbonUnitTree=4
    
} REMCarbonUnit;

typedef enum _REMDiagramType
{
    REMDiagramTypePie,
    REMDiagramTypeRanking,
    REMDiagramTypeStackColumn,
    REMDiagramTypeLine,
    REMDiagramTypeColumn,
    REMDiagramTypeGrid
}
REMDiagramType;

typedef enum _REMEnergyStep:NSUInteger
{
    REMEnergyStepNone=0,
    REMEnergyStepHour=1,
    REMEnergyStepDay=2,
    REMEnergyStepWeek=5,
    REMEnergyStepMonth=3,
    REMEnergyStepYear=4
} REMEnergyStep;

typedef enum _REMRelativeTimeRangeType : NSInteger
{
    REMRelativeTimeRangeTypeNone=0,
    REMRelativeTimeRangeTypeLast7Days = 1,
    REMRelativeTimeRangeTypeToday = 2,
    REMRelativeTimeRangeTypeYesterday = 3,
    REMRelativeTimeRangeTypeThisWeek = 4,
    REMRelativeTimeRangeTypeLastWeek = 5,
    REMRelativeTimeRangeTypeThisMonth = 6,
    REMRelativeTimeRangeTypeLastMonth = 7,
    REMRelativeTimeRangeTypeThisYear = 8,
    REMRelativeTimeRangeTypeLastYear = 9,
} REMRelativeTimeRangeType;

typedef enum _REMRankingRange : NSInteger
{
    REMRankingRangeAll=0,
    REMRankingRange10 = 10,
    REMRankingRange20 = 20,
    REMRankingRange50 = 50
} REMRankingRange;

typedef enum _REMBuildingImageType :NSInteger {
    REMBuildingImageSmall = 0,
    REMBuildingImageSmallBlured = 1,
    REMBuildingImageNormal = 2,
    REMBuildingImageNormalBlured = 3,
} REMBuildingImageType;


@interface REMEnum : NSObject

@end
