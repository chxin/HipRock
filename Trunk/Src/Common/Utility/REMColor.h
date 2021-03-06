/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMColor.h
 * Created      : TanTan on 7/1/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>



@interface REMColor : NSObject

+ (UIColor *)colorByHexString:(NSString *)hexString;
+ (UIColor *)colorByHexString:(NSString *)hexString alpha:(CGFloat)alpha;

+ (UIColor *)colorByIndex:(uint)index;
// 修改一个UIColor的alpha值
+(UIColor*)makeTransparent:(CGFloat)alpha withColor:(UIColor*)color;

+(UIColor*)getLabelingColor:(uint)index stageCount:(uint)stageCount;
@end
