/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDataRange.h
 * Created      : 张 锋 on 8/12/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
