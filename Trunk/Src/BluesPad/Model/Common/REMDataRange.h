//
//  REMDataRange.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
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
