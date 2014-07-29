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
    DCSeriesTypeStatusNone = 0,
    DCSeriesTypeStatusLine = 1,
    DCSeriesTypeStatusColumn = 2,
    DCSeriesTypeStatusStackedColumn = 4,
    DCSeriesTypeStatusPie = 8
}DCSeriesTypeStatus;

@interface DCSeriesStatus : NSObject

//// Properties store in database
@property (nonatomic,assign) BOOL visible;
@property (nonatomic,assign) DCSeriesTypeStatus seriesType;
@property (nonatomic, strong) NSString* seriesKey;
@property (nonatomic, assign) NSUInteger avilableTypes;
@property (nonatomic, assign) BOOL suppressible;

// Customized properties for blues
@property (nonatomic, strong) UIColor* forcedColor;


-(void)applyToXYSeries:(DCXYSeries*)series;
-(void)applyToPieSlice:(DCPieDataPoint*)pieSlice;

-(DCSeriesTypeStatus)getNextSeriesType;
//@property (nonatomic,strong,readonly) NSNumber* targetId;
//@property (nonatomic,assign,readonly) REMEnergyTargetType type;
//@property (nonatomic,assign,readonly) long commodityId;
//@property (nonatomic,readonly) NSNumber* seriesIndex;
//-(id)initWithTarget:(REMEnergyTargetModel*)target index:(NSNumber*)seriesIndex;
@end
