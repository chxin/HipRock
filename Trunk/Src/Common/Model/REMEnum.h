/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMEnum.h
 * Created      : tantan on 9/27/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>

typedef enum _REMUserTitleType : NSUInteger {
    REMUserTitleEEConsultant = 0,
    REMUserTitleTechnician = 1,
    REMUserTitleCustomerAdmin = 2,
    REMUserTitlePlatformAdmin=3,
    REMUserTitleEnergyManager=4,
    REMUserTitleEnergyEngineer=5,
    REMUserTitleDepartmentManager=6,
    REMUserTitleCEO=7,
    REMUserTitleBusinessPersonnel=8,
    REMUserTitleSaleman=9,
    REMUserTitleServiceProviderAdmin=10
} REMUserTitleType;

typedef enum _REMCalenderType{
    REMCalendarTypeNone=-1,
    REMCalenderTypeWorkDay=0,
    REMCalenderTypeRestTime=3,
    REMCalenderTypeHoliday=1,
    REMCalendarTypeWorkTime=2,
    REMCalenderTypeCoolSeason=5,
    REMCalenderTypeHeatSeason=4,
    REMCalendarTypeHCSeason=6
} REMCalendarType;

typedef enum _REMCarbonUnit{
    REMCarbonUnitNone=0,
    REMCarbonStardardCoal=2,
    REMCarbonUnitCO2=3,
    REMCarbonUnitTree=4
    
} REMCarbonUnit;

typedef enum _REMUnitType{
    REMUnitTypeNone=0,
    REMUnitTypeTotalPersonUnit=2,
    REMUnitTypeTotalAreaUnit=3,
    REMUnitTypeCoolingAreaUnit=4,
    REMUnitTypeHeatingAreaUnit=5
    
} REMUnitType;

typedef enum _REMRankingType{
    REMRankingTypeNone=0,
    REMRankingTypeCorporation=1,
    REMRankingTypeTotalPersonUnit=2,
    REMRankingTypeTotalAreaUnit=3,
    REMRankingTypeCoolingAreaUnit=4,
    REMRankingTypeHeatingAreaUnit=5
    
} REMRankingType;

typedef enum _REMLabellingType{
    REMLabellingTypeNone=0,
    
    REMLabellingTypeTotalPersonUnit=1,
    REMLabellingTypeTotalAreaUnit=2,
    REMLabellingTypeCoolingAreaUnit=3,
    REMLabellingTypeHeatingAreaUnit=4,
    REMLabellingTypeDayNightRatioValue=5,
    REMLabellingTypeWorkDayRatioValue=6
    
} REMLabellingType;

typedef enum _REMRatioType{
    REMRatioTypeNone=0,
    REMRatioTypeDayNight=1,
    REMRatioTypeWorkDay=2,
    REMRatioTypeDataValue=3
    
} REMRatioType;


typedef enum _REMDiagramType
{
    REMDiagramTypePie,
    REMDiagramTypeRanking,
    REMDiagramTypeStackColumn,
    REMDiagramTypeLine,
    REMDiagramTypeColumn,
    REMDiagramTypeGrid,
    REMDiagramTypeLabelling
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
    REMRelativeTimeRangeTypeLast30Day = 10,
    REMRelativeTimeRangeTypeLast12Month = 11,
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
