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

+ (UIImage *)blurImage2:(UIImage *)origImage{
    CGFloat blur=0.5;
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    //UIImage *small = [UIImage imageWithCGImage:origImage.CGImage scale:0.5 orientation:origImage.imageOrientation];
    CGSize newSize=CGSizeMake(1024, 768);
    UIGraphicsBeginImageContext(newSize);
    [origImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    CGImageRef img = newImage.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    
    
    
    pixelBuffer = malloc(inBuffer.rowBytes * inBuffer.height);
    
    if(pixelBuffer==NULL){
        return nil;
    }
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    
    
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(origImage.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;

}


+ (UIImage *)blurImage:(UIImage *)origImage
{
    //EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    //NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    //[options setObject: [NSNull null] forKey: kCIContextWorkingColorSpace];
    //CIContext *myContext = [CIContext contextWithEAGLContext:myEAGLContext options:options];
    
    //UIImage *small = [UIImage imageWithCGImage:origImage.CGImage scale:0.5 orientation:origImage.imageOrientation];
    UIImage *image=origImage;
    if(origImage.size.width>1024){
        CGSize newSize=CGSizeMake(origImage.size.width/2, origImage.size.height/2);
        UIGraphicsBeginImageContext(newSize);
        [origImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        image=newImage;
    }

    
    
    
    
     CIContext *myContext = [CIContext contextWithOptions:nil];
    CIImage *ci = [[CIImage alloc]initWithCGImage:image.CGImage];
    
    CIFilter *filter1 = [CIFilter filterWithName:@"CIGaussianBlur"
                                   keysAndValues: kCIInputImageKey,ci,@"inputRadius",@(15),nil];
    
    CIImage *outputImage = [filter1 outputImage];
    
    //NSLog(@"image size:%@",NSStringFromCGSize(imageView.image.size));
    
    //UIScreen *screen = [UIScreen mainScreen];
    
    //CGRect frame = CGRectMake(0, 0, screen.bounds.size.height*screen.scale,screen.bounds.size.width*screen.scale);
    
    //NSLog(@"blur frame:%@",NSStringFromCGRect(frame));
    
    CGRect retFrame=CGRectMake(0, 0, image.size.width*image.scale, image.size.height*image.scale);
    
    //NSLog(@"retframe:%@",NSStringFromCGRect(retFrame));
    
    CGImageRef cgimg =
    [myContext createCGImage:outputImage fromRect:retFrame];
    
    
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
