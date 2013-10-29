//
//  REMImageHelper.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 7/31/13.
//
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>
#import "REMEnum.h"

@interface REMImageHelper : NSObject

- (void) frostedGlassImage:(UIImageView*)view image:(NSData*)imageData gradientValue:(int)gradientValue;

 + (UIImage *)blurImage:(UIImage *)origImage;

+ (UIImage *)blurImage2:(UIImage *)origImage;

+ (UIImage *)parseImageFromNSData:(NSData *)data;

+ (void)writeImageFile:(UIImage *)image withFileName:(NSString *)fileName;

+ (UIImage *)readImageFile:(NSString *)fileName;

+ (UIImage *) imageWithView:(UIView *)view;

+ (NSString *)buildingImagePathWithId:(NSNumber *)imageId andType:(REMBuildingImageType)type;

+ (void)writeImageFile:(UIImage *)image withFullPath:(NSString *)fullPath;

@end
