//
//  REMDataRange.h
//  Blues
//
//  Created by 张 锋 on 8/12/13.
//
//

#import <Foundation/Foundation.h>

@interface REMDataRange : NSObject

@property (nonatomic) double start;
@property (nonatomic) double end;

- (REMDataRange *)initWithConstants;
- (REMDataRange *)initWithStart:(double)start andEnd:(double)end;

- (double)distance;
- (REMDataRange *)expandByFactor:(float)factor;
- (BOOL)isValueInside:(double)value;

@end
