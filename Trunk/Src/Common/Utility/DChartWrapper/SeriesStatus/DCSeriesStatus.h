//
//  DCSeriesStatus.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 4/23/14.
//
//

#import <Foundation/Foundation.h>
#import "REMEnergyTargetModel.h"
#import "DCXYSeries.h"

typedef enum _DCSeriesTypeStatus {
    DCSeriesTypeStatusLine = 1,
    DCSeriesTypeStatusColumn = 2,
    DCSeriesTypeStatusStackedColumn = 4,
    DCSeriesTypeStatusPie = 8
}DCSeriesTypeStatus;

@interface DCSeriesStatus : NSObject
@property (nonatomic,assign) BOOL hidden;
@property (nonatomic,assign) DCSeriesTypeStatus seriesType;
@property (nonatomic, strong) NSString* seriesKey;
@property (nonatomic, strong) UIColor* forcedColor;
@property (nonatomic, strong) NSArray* avilableTypes;
-(void)applyToXYSeries:(DCXYSeries*)series;
-(void)applyToPieSlice:(DCPieDataPoint*)pieSlice;
//@property (nonatomic,strong,readonly) NSNumber* targetId;
//@property (nonatomic,assign,readonly) REMEnergyTargetType type;
//@property (nonatomic,assign,readonly) long commodityId;
//@property (nonatomic,readonly) NSNumber* seriesIndex;
//-(id)initWithTarget:(REMEnergyTargetModel*)target index:(NSNumber*)seriesIndex;
@end
