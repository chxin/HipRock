/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMColor.h
 * Created      : TanTan on 7/1/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"



@interface REMColor : NSObject

+ (UIColor *)colorByHexString:(NSString *)hexString;
+ (UIColor *)colorByHexString:(NSString *)hexString alpha:(CGFloat)alpha;

+ (CPTColor *)colorByIndex:(uint)index;

@end
