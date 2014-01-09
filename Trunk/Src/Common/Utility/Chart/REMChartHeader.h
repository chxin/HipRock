/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartHeader.h
 * Created      : Zilong-Oscar.Xu on 9/12/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMWidgetObject.h"
#import "REMEnergyData.h"
#import "REMBuildingConstants.h"
#import "REMEnergyTargetModel.h"
#import "REMColor.h"
#import "DCLabelingLabel.h"
#import "DCPieDataPoint.h"

typedef enum _DCLineType {
    DCLineTypeDefault = 0,
    DCLineTypeDotted = 1,
    DCLineTypeDashed = 2,
    DCLineTypeShortDashed = 3
}DCLineType;

@protocol REMChartDelegate <NSObject>
@end

@protocol REMChartLabelingDelegate <REMChartDelegate>

-(void)highlightPoint:(DCLabelingLabel*)point;

@end

@protocol REMTrendChartDelegate <REMChartDelegate>
/*
 * points: List<DCDataPoint>
 */
-(void)highlightPoints:(NSArray*)points x:(id)x;

/*
 * Parameter data type: NSDate for line/column. NSNumber for ranking.
 */
-(void)willRangeChange:(id)start end:(id)end;
-(void)gestureEndFrom:(id)start end:(id)end;
@end

typedef enum _REMDirection{
    REMDirectionLeft = -1,  // 顺时针
    REMDirectionNone = 0,
    REMDirectionRight = 1   // 逆时针
}REMDirection;

@protocol REMTPieChartDelegate <REMChartDelegate>
/*
 * points: List<REMEnergyData>
 * colors: List<UIColor>
 * names: List<NSString>
 */
-(void)highlightPoint:(DCPieDataPoint*)point direction:(REMDirection)direction;

@end


//@interface REMTrendChartPoint : NSObject
//
//@property (nonatomic,readonly) float x;
//@property (nonatomic,readonly) NSNumber* y;
//@property (nonatomic,readonly) REMEnergyData* energyData;
//
//-(REMTrendChartPoint*)initWithX:(float)x y:(NSNumber*)y point:(REMEnergyData*)p;
//
//@end








@interface REMChartDataProcessor : NSObject
-(NSNumber*)processX:(NSDate*)xLocalTime;
-(NSNumber*)processY:(NSNumber*)yVal;
-(NSDate*)deprocessX:(float)x;
@end
@interface REMTrendChartDataProcessor : REMChartDataProcessor
@property (nonatomic, weak) NSDate* baseDate;
@property (nonatomic, assign) REMEnergyStep step;
@end
