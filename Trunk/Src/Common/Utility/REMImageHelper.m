//
//  REMImageHelper.m
//  Blues
//
//  Created by Zilong-Oscar.Xu on 7/31/13.
//
//

#import "REMImageHelper.h"

@implementation REMImageHelper {
    CIImage* beginImage;
    CIContext *context;
    NSNumber* blur;
    NSNumber* gradientStart;
    NSNumber* gradientEnd;
    NSString* currentImagePath;
}


+ (UIImage *)blurImage:(UIImage *)origImage
{
    EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    [options setObject: [NSNull null] forKey: kCIContextWorkingColorSpace];
    CIContext *myContext = [CIContext contextWithEAGLContext:myEAGLContext options:options];
    
    CIImage *ci = [[CIImage alloc]initWithCGImage:origImage.CGImage];
    
    CIFilter *filter1 = [CIFilter filterWithName:@"CIGaussianBlur"
                                   keysAndValues: kCIInputImageKey,ci,@"inputRadius",@(15),nil];
    
    CIImage *outputImage = [filter1 outputImage];
    
    //NSLog(@"image size:%@",NSStringFromCGSize(imageView.image.size));
    CGImageRef cgimg =
    [myContext createCGImage:outputImage fromRect:CGRectMake(0, 0, origImage.size.width*origImage.scale, origImage.size.height*origImage.scale)];
    
    
    UIImage *view= [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    return view;
}

- (void) frostedGlassImage:(UIImageView*)view image:(NSData*)imageData gradientValue:(int)gradientValue {
    const int maxGradient = 20;
    const int minGradient = 0;
    
    CGSize imageSize = view.image.size;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    
    if (context == nil) {
        context = [CIContext contextWithOptions:nil];
    }
    
    beginImage = [[CIImage alloc] initWithCGImage:[UIImage imageWithData:imageData].CGImage];
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"preface-background" ofType:@"jpg"];
    //    NSURL *fileNameAndPath = [NSURL fileURLWithPath:filePath];
    //    beginImage = [CIImage imageWithContentsOfURL:fileNameAndPath];
    
    if (gradientValue < minGradient) gradientValue = minGradient;
    if (gradientValue > maxGradient) gradientValue = maxGradient;
    
    CIFilter *blurFilter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:
                            kCIInputImageKey, beginImage,
                            @"inputRadius", [NSNumber numberWithInt:gradientValue / 5], nil];
    CIImage *blurImg = [blurFilter outputImage];
    
    CIFilter *gradFilter = [CIFilter filterWithName:@"CILinearGradient"];
    
    [gradFilter setDefaults];
    //    [gradFilter setValue:[CIColor colorWithString:@"0.5 0.5 0.5 0"] forKey:@"inputColor0"];
    //    [gradFilter setValue:[CIColor colorWithString:@"0 0 0 0.95"] forKey:@"inputColor1"];
    //    [gradFilter setValue:[CIVector vectorWithX:screenWidth Y:screenHeight * (25 + 2 * gradientValue) / 100] forKey:@"inputPoint0"];
    //    [gradFilter setValue:[CIVector vectorWithX:screenWidth Y:screenHeight * (15 + 2 * gradientValue) / 100] forKey:@"inputPoint1"];
    
    NSString* colorString = [NSString stringWithFormat:@"0.1 0.1 0.1 %f", [NSNumber numberWithInt:gradientValue].floatValue / maxGradient / 1.5];
    [gradFilter setValue:[CIColor colorWithString:colorString] forKey:@"inputColor0"];
    [gradFilter setValue:[CIColor colorWithString:colorString] forKey:@"inputColor1"];
    [gradFilter setValue:[CIVector vectorWithX:0 Y:0] forKey:@"inputPoint0"];
    [gradFilter setValue:[CIVector vectorWithX:screenWidth Y:screenHeight] forKey:@"inputPoint1"];
    CIImage *gradImage = gradFilter.outputImage;
    
    CIFilter* CISourceOverCompositing = [CIFilter filterWithName:@"CIMultiplyBlendMode" keysAndValues:
                                         kCIInputImageKey, blurImg, @"inputBackgroundImage", gradImage, nil];
    CIImage *outputImage = [CISourceOverCompositing outputImage];
    
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    [view setImage:newImg];
    CGImageRelease(cgimg);
}

@end
