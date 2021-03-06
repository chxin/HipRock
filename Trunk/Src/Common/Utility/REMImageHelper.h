/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMImageHelper.h
 * Created      : Zilong-Oscar.Xu on 7/31/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>
#import "REMEnum.h"

@interface REMImageHelper : NSObject

- (void) frostedGlassImage:(UIImageView*)view image:(NSData*)imageData gradientValue:(int)gradientValue;

 + (UIImage *)blurImage:(UIImage *)origImage;

+ (UIImage *)blurImage2:(UIImage *)origImage;

+ (UIImage *)parseImageFromNSData:(NSData *)data withScale:(CGFloat)scaleFactor;

+ (void)writeImageFile:(UIImage *)image withFileName:(NSString *)fileName;

+ (UIImage *)readImageFile:(NSString *)fileName;

+ (UIImage *) imageWithView:(UIView *)view;

+ (UIImage *) imageWithLayer:(CALayer *)layer;

+ (NSString *)buildingImagePathWithId:(NSNumber *)imageId andType:(REMBuildingImageType)type;

+ (UIImage *)blurImageGaussian:(UIImage *)origImage;


+ (void)writeImageFile:(UIImage *)image withFullPath:(NSString *)fullPath;


+ (UIImage*)imageWithImage:(UIImage*)image scaledWithFactor:(CGFloat)factor;

+ (UIImage *)scaleImage:(UIImage*)image toSize:(CGSize)size;

+ (UIImage *)cropImage:(UIImage *)image toRect:(CGRect)rect;

@end
