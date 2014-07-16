//
//  DCColumnSeriesGroup.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 6/3/14.
//
//

#import <Foundation/Foundation.h>
@class DCXYSeries;
@class _DCCoordinateSystem;

@interface DCColumnSeriesGroup : NSObject
@property (nonatomic, strong, readonly) NSString* groupName;
@property (nonatomic, weak, readonly) _DCCoordinateSystem* coordinateSystem;
//@property (nonatomic, assign) CGFloat xRectStartAt;
@property (nonatomic, assign) CGFloat columnWidthInCoordinate;
@property (nonatomic, readonly, getter = getCount) NSUInteger count;
@property (nonatomic, readonly, getter = getAllSeries) NSArray* allSeries;
-(id)initWithGroupName:(NSString*)groupName coordinateSystem:(_DCCoordinateSystem*)coordinateSystem;
-(void)addSeries:(DCXYSeries*)series;
-(BOOL)containsSeries:(DCXYSeries*)series;
-(void)removeSeries:(DCXYSeries*)series;
@end
