

#import <Foundation/Foundation.h>

@interface REMSeries : NSObject

@property (nonatomic,retain) NSString *uid;
@property (nonatomic,retain) UIColor *color;
@property (nonatomic,retain) NSMutableArray *data;

@end

@interface REMEnergyData : NSObject
    @property (nonatomic,retain) NSMutableArray *series;
@end
