/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMImageHelper.m
 * Created      : Zilong-Oscar.Xu on 7/31/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMImageHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "REMEnum.h"
#import "REMApplicationContext.h"
#import <GPUImage/GPUImage.h>

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
    
    CGImageRelease(imageRef);
    
    return returnImage;

}

+ (UIImage *)blurImageGaussian:(UIImage *)origImage{

    [EAGLContext setCurrentContext:nil];

    EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if([EAGLContext setCurrentContext:myEAGLContext] == NO){
        return nil;
    }
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    [options setObject: [NSNull null] forKey: kCIContextWorkingColorSpace];
    CIContext *myContext = [CIContext contextWithEAGLContext:myEAGLContext options:options];


    UIImage *image=origImage;
    if(origImage.size.width>1024){
        CGSize newSize=CGSizeMake(origImage.size.width/2, origImage.size.height/2);
        UIGraphicsBeginImageContext(newSize);
        [origImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        image=newImage;
    }





    // CIContext *myContext = [CIContext contextWithOptions:nil];
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
    
    [EAGLContext setCurrentContext:nil];
    
    
    
    return view;
}

+ (UIImage *)blurImage:(UIImage *)origImage
{
    UIImage *image=origImage;
//    if(origImage.size.width>1024){
//        CGSize newSize=CGSizeMake(origImage.size.width/2, origImage.size.height/2);
//        UIGraphicsBeginImageContext(newSize);
//        [origImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        image=newImage;
//    }
    
    //GPUImageView *primaryView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    GPUImagePicture *pic=[[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:YES];
    
    GPUImageGaussianBlurFilter *filter=[[GPUImageGaussianBlurFilter alloc]init];
    //[filter forceProcessingAtSize:CGSizeMake(1024, 768)];
    
    filter.blurRadiusInPixels=15;
    [pic addTarget:filter];
    //[filter addTarget:primaryView];
    [pic processImage];
    
    UIImage *retImage= [filter imageFromCurrentlyProcessedOutputWithOrientation:UIImageOrientationUp];
    
    return retImage;
    //return  [filter imageFromCurrentlyProcessedOutput];
    
//    
//    [EAGLContext setCurrentContext:nil];
//    
//    EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
//    if([EAGLContext setCurrentContext:myEAGLContext] == NO){
//        return nil;
//    }
//    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
//    [options setObject: [NSNull null] forKey: kCIContextWorkingColorSpace];
//    CIContext *myContext = [CIContext contextWithEAGLContext:myEAGLContext options:options];
//    
// 
//    UIImage *image=origImage;
//    if(origImage.size.width>1024){
//        CGSize newSize=CGSizeMake(origImage.size.width/2, origImage.size.height/2);
//        UIGraphicsBeginImageContext(newSize);
//        [origImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        image=newImage;
//    }
//
//    
//    
//    
//    
//    // CIContext *myContext = [CIContext contextWithOptions:nil];
//    CIImage *ci = [[CIImage alloc]initWithCGImage:image.CGImage];
//    
//    CIFilter *filter1 = [CIFilter filterWithName:@"CIGaussianBlur"
//                                   keysAndValues: kCIInputImageKey,ci,@"inputRadius",@(15),nil];
//    
//    CIImage *outputImage = [filter1 outputImage];
//    
//    //NSLog(@"image size:%@",NSStringFromCGSize(imageView.image.size));
//    
//    //UIScreen *screen = [UIScreen mainScreen];
//    
//    //CGRect frame = CGRectMake(0, 0, screen.bounds.size.height*screen.scale,screen.bounds.size.width*screen.scale);
//    
//    //NSLog(@"blur frame:%@",NSStringFromCGRect(frame));
//    
//    CGRect retFrame=CGRectMake(0, 0, image.size.width*image.scale, image.size.height*image.scale);
//    
//    //NSLog(@"retframe:%@",NSStringFromCGRect(retFrame));
//    
//    CGImageRef cgimg =
//    [myContext createCGImage:outputImage fromRect:retFrame];
//    
//    
//    UIImage *view= [UIImage imageWithCGImage:cgimg];
//    CGImageRelease(cgimg);
//    
//    [EAGLContext setCurrentContext:nil];
//    
//    
//    
//    return view;
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

+ (UIImage *)parseImageFromNSData:(NSData *)data withScale:(CGFloat)scaleFactor{
    if (!data || [data length] == 0) {
        return nil;
    }
    
    
    
    
    CGImageRef imageRef = nil;
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    imageRef = CGImageCreateWithPNGDataProvider(dataProvider,  NULL, true, kCGRenderingIntentDefault);
    
    if(!imageRef){
        imageRef = CGImageCreateWithJPEGDataProvider(dataProvider, NULL, true, kCGRenderingIntentDefault);
    }
    
    if (!imageRef) {
        UIImage *image;
        if ([UIImage instancesRespondToSelector:@selector(initWithData:scale:)]) {
            image= [[UIImage alloc] initWithData:data scale:1];
        } else {
            image= [[UIImage alloc] initWithCGImage:[[[UIImage alloc] initWithData:data] CGImage] scale:1 orientation:image.imageOrientation];
        }
        if (image.images) {
            CGDataProviderRelease(dataProvider);
            
            return image;
        }
        
        imageRef = CGImageCreateCopy([image CGImage]);
    }
    
    CGDataProviderRelease(dataProvider);
    
    if (!imageRef) {
        return nil;
    }
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bytesPerRow = 0; // CGImageGetBytesPerRow() calculates incorrectly in iOS 5.0, so defer to CGBitmapContextCreate()
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    if (CGColorSpaceGetNumberOfComponents(colorSpace) == 3) {
        int alpha = (bitmapInfo & kCGBitmapAlphaInfoMask);
        if (alpha == kCGImageAlphaNone) {
            bitmapInfo &= ~kCGBitmapAlphaInfoMask;
            bitmapInfo |= kCGImageAlphaNoneSkipFirst;
        } else if (!(alpha == kCGImageAlphaNoneSkipFirst || alpha == kCGImageAlphaNoneSkipLast)) {
            bitmapInfo &= ~kCGBitmapAlphaInfoMask;
            bitmapInfo |= kCGImageAlphaPremultipliedFirst;
        }
    }
    
    UIScreen *screen = [UIScreen mainScreen];
    
    CGRect frame=  CGRectMake(0, 0, screen.bounds.size.height, screen.bounds.size.width);
    
    if(width>frame.size.width) {
        width=frame.size.width;
    }
    
    if(height>frame.size.height){
        height=frame.size.height;
    }
    width*=scaleFactor;
    height*=scaleFactor;
    
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
    
    CGColorSpaceRelease(colorSpace);
    
    if (!context) {
        CGImageRelease(imageRef);
        
        return [[UIImage alloc] initWithData:data];
    }
    
    CGRect rect = CGRectMake(0.0f, 0.0f, width, height);
    //NSLog(@"image size:%@",NSStringFromCGRect(rect));
    CGContextDrawImage(context, rect, imageRef);
    CGImageRef inflatedImageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage *inflatedImage = [[UIImage alloc] initWithCGImage:inflatedImageRef scale:1 orientation:UIImageOrientationUp];
    CGImageRelease(inflatedImageRef);
    CGImageRelease(imageRef);
    
    
    
    return inflatedImage;
}

+ (void)writeImageFile:(UIImage *)image withFileName:(NSString *)fileName{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSData * binaryImageData = UIImagePNGRepresentation(image);
    
    [binaryImageData writeToFile:[basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",fileName]] atomically:YES];
}

+ (UIImage *)readImageFile:(NSString *)fileName{
    return  nil;
}

+ (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, view.window.screen.scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImage *) imageWithLayer:(CALayer *)layer
{
    UIScreen *screen=[UIScreen mainScreen];
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.opaque, screen.scale);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


+ (NSString *)buildingImagePathWithId:(NSNumber *)imageId andType:(REMBuildingImageType)type
{
    if(REMAppContext.currentManagedUser == nil){
        return nil;
    }
    
    NSString *currentUserName = REMAppContext.currentManagedUser.name;
    
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
	return [NSString stringWithFormat:@"%@/building-%@-%d-%d.png",documents,currentUserName,[imageId intValue],type];
}

+ (void)writeImageFile:(UIImage *)image withFullPath:(NSString *)fullPath;
{
    if([fullPath isEqual:[NSNull null]])
        return;
    
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [imageData writeToFile:fullPath atomically:YES];
    
    imageData = nil;
}

+ (UIImage *) drawText:(NSString*) text inImage:(UIImage*)image inRect:(CGRect)rect
{
    UIFont *font = [UIFont systemFontOfSize:24.0];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];

    [text drawInRect:CGRectIntegral(rect) withFont:font];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledWithFactor:(CGFloat)factor
{
    NSData* pictureData = UIImagePNGRepresentation(image);
    
    return [REMImageHelper parseImageFromNSData:pictureData withScale:factor];
    
}

+ (UIImage*)scaleImage:(UIImage*)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext( size );
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UIImage *)cropImage:(UIImage *)image toRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropped;
}


@end
