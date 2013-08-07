//
//  REMImageView.m
//  TestImage
//
//  Created by 谭 坦 on 7/23/13.
//  Copyright (c) 2013 demo. All rights reserved.
//

#import "REMImageView.h"

@interface REMImageView()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) REMBuildingDataView *dataView;
@property (nonatomic) BOOL dataViewUp;
@property (nonatomic) CGFloat cumulateY;
@property (nonatomic,strong) UIImageView *titleBg;
@property (nonatomic,strong) UIView *croppedTitleBg;
@property (nonatomic,strong) CIImage *clearImage;
@property (nonatomic,strong) NSData *origImageData;
@property (nonatomic,strong) UIImageView *blurredImageView;
@property (nonatomic,strong) UIView *glassView;
@property (nonatomic,strong) CAGradientLayer *bottomGradientLayer;


@property (nonatomic,strong) REMBuildingOverallModel *buildingInfo;
@end

@implementation REMImageView

#pragma mark -
#pragma mark init

- (id)initWithFrame:(CGRect)frame withBuildingOveralInfo:(REMBuildingOverallModel *)buildingInfo
{
    self = [super initWithFrame:frame];
    if(self){
        self.buildingInfo=buildingInfo;
        
        self.contentMode=UIViewContentModeScaleToFill;
        self.dataViewUp=NO;
        self.cumulateY=0;
        
        [self initImageView:frame];
        
        [self initBottomGradientLayer];
        
        //[self initBlurredImageView];
        
        [self initBlurredImageView2];
        
        [self initGlassView];
        
        [self initDataListView];
        
        [self initTitleView];
        
        
        
    }
    
    return self;
}

- (NSString *)retrieveBuildingImage:(NSString *)name
{
    if([name isEqualToString:@"B1"] == YES)
    {
        return @"shangdusoho";
    }
    else if([name isEqualToString:@"B2"] == YES)
    {
        return @"sanlitunsoho";
    }
    else if([name isEqualToString:@"B3"] == YES)
    {
        return @"wangjingsoho";
    }
    else if([name isEqualToString:@"B4"] == YES)
    {
        return @"yinhesoho";
    }
    else{
        return @"yinhesoho";
    }
}

- (void)initImageView:(CGRect)frame
{
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.imageView.contentMode=UIViewContentModeScaleToFill;
    
    
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[self retrieveBuildingImage:self.buildingInfo.building.code] ofType:@"jpg"];
    // NSURL *fileNameAndPath = [NSURL fileURLWithPath:filePath];
    NSData *image = [NSData dataWithContentsOfFile:filePath];
    self.origImageData=image;
    //CIImage *beginImage = [CIImage imageWithContentsOfURL:fileNameAndPath];
    self.imageView.image=  [UIImage imageWithData:image];
    //self.imageView.image = [UIImage imageWithCGImage:beginImage];
    [self addSubview:self.imageView];
    
    self.clearImage = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    
    

}

- (void)initBottomGradientLayer
{
    CGRect frame = CGRectMake(0, kBuildingCommodityViewTop, 1024, kBuildingCommodityTotalHeight+kBuildingCommodityTotalTitleHeight+kBuildingCommodityButtonDimension+kBuildingCommodityItemGroupMargin*2);
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    self.bottomGradientLayer=gradient;
    //gradient.opacity=0.2;
    gradient.frame = frame;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor clearColor].CGColor,
                       //(id)[UIColor lightGrayColor].CGColor,
                        (id)[UIColor blackColor].CGColor,
                       nil];
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    //CGContextConcatCTM(c, CGAffineTransformMakeTranslation(-frame.origin.x, -frame.origin.y));
    [gradient renderInContext:c];
    
    //UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    
    //CIImage *ciImage = [CIImage imageWithCGImage:screenshot.CGImage];
    
    UIGraphicsEndImageContext();
    
    
    //CIContext *context = [CIContext contextWithOptions:nil];
    //CIFilter *filter1 = [CIFilter filterWithName:@"CIGaussianBlur"
    //                               keysAndValues: kCIInputImageKey,ciImage,@"inputRadius",[NSNumber numberWithInt:5],nil];
    
    //CIImage *outputImage = [filter1 outputImage];
    // 2
    //CGImageRef cgimg =
    //[context createCGImage:outputImage fromRect:outputImage.extent];
    
    // 3
    //UIImage *newImage = [UIImage imageWithCGImage:cgimg ];
    
    //CGImageRelease(cgimg);
    
    //self.titleBg = [[UIImageView alloc] initWithFrame:frame];
    //self.titleBg.image=newImage;
    
    [self.layer insertSublayer:self.bottomGradientLayer above:self.imageView.layer];

}

- (void)initBlurredImageView2{
    
    self.blurredImageView = [[UIImageView alloc]initWithFrame:self.imageView.frame];
    self.blurredImageView.alpha=0;
    self.blurredImageView.contentMode=UIViewContentModeScaleToFill;
    self.backgroundColor=[UIColor clearColor];
     [self addSubview:self.blurredImageView];
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^ {
        CGFloat blur=0.9;
        UIImage *image= self.imageView.image;
        
        if ((blur < 0.0f) || (blur > 1.0f)) {
            blur = 0.5f;
        }
        
        int boxSize = (int)(blur * 100);
        boxSize -= (boxSize % 2) + 1;
        
        CGImageRef img = image.CGImage;
        
        vImage_Buffer inBuffer, outBuffer;
        vImage_Error error;
        void *pixelBuffer;
        
        CGDataProviderRef inProvider = CGImageGetDataProvider(img);
        CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
        
        inBuffer.width = CGImageGetWidth(img);
        inBuffer.height = CGImageGetHeight(img);
        inBuffer.rowBytes = CGImageGetBytesPerRow(img);
        inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
        
        pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
        
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
                                                 CGImageGetBitmapInfo(image.CGImage));
        
        CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
        UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
        
        //clean up
        CGContextRelease(ctx);
        CGColorSpaceRelease(colorSpace);
        
        free(pixelBuffer);
        CFRelease(inBitmapData);
        
        CGColorSpaceRelease(colorSpace);
        CGImageRelease(imageRef);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.blurredImageView.alpha = 0.0;
            self.blurredImageView.image=returnImage;
        });
    });

    
    
}

- (void)initBlurredImageView
{
    self.blurredImageView = [[UIImageView alloc]initWithFrame:self.imageView.frame];
    self.blurredImageView.alpha=0;
    self.blurredImageView.contentMode=UIViewContentModeScaleToFill;
    self.backgroundColor=[UIColor clearColor];
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
        NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
        [options setObject: [NSNull null] forKey: kCIContextWorkingColorSpace];
        CIContext *myContext = [CIContext contextWithEAGLContext:myEAGLContext options:options];
        
        CIFilter *filter1 = [CIFilter filterWithName:@"CIGaussianBlur"
                                       keysAndValues: kCIInputImageKey,self.clearImage,@"inputRadius",@(5),nil];
        
        CIImage *outputImage = [filter1 outputImage];
        
        
        CGImageRef cgimg =
        [myContext createCGImage:outputImage fromRect:CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height)];
        
        
        UIImage *view= [UIImage imageWithCGImage:cgimg];
        CGImageRelease(cgimg);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.blurredImageView.image=view;
        });
    });
    
    [self addSubview:self.blurredImageView];
}

- (void)initGlassView
{
    self.glassView = [[UIView alloc]initWithFrame:self.imageView.frame];
    self.glassView.alpha=0;
    self.glassView.contentMode=UIViewContentModeScaleToFill;
    self.glassView.backgroundColor=[UIColor blackColor];
    
    [self addSubview:self.glassView];
}

- (void)initDataListView
{
    
   
    REMBuildingDataView *view = [[REMBuildingDataView alloc]initWithFrame:CGRectMake(kBuildingCommodityLeftMargin, kBuildingCommodityViewTop, self.frame.size.width, 1000) withBuildingInfo:self.buildingInfo];
    
    [self addSubview:view];
    self.dataView=view;
    

}

- (void)initTitleView
{
    /*
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, 80);
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.opacity=0.2;
    gradient.frame = frame;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor lightGrayColor].CGColor,
                       (id)[UIColor lightGrayColor].CGColor,
                       nil];
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    //CGContextConcatCTM(c, CGAffineTransformMakeTranslation(-frame.origin.x, -frame.origin.y));
    [gradient renderInContext:c];
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    
    CIImage *ciImage = [CIImage imageWithCGImage:screenshot.CGImage];
    
    UIGraphicsEndImageContext();
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter1 = [CIFilter filterWithName:@"CIGaussianBlur"
                                   keysAndValues: kCIInputImageKey,ciImage,@"inputRadius",[NSNumber numberWithInt:5],nil];
    
    CIImage *outputImage = [filter1 outputImage];
    // 2
    CGImageRef cgimg =
    [context createCGImage:outputImage fromRect:outputImage.extent];
    
    // 3
    UIImage *newImage = [UIImage imageWithCGImage:cgimg ];
    
    CGImageRelease(cgimg);
    
    self.titleBg = [[UIImageView alloc] initWithFrame:frame];
    self.titleBg.image=newImage;
    
    [self addSubview:self.titleBg];
    */
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, kBuildingTitleHeight)];
    self.titleLabel.text=self.buildingInfo.building.name;
    self.titleLabel.shadowColor=[UIColor blackColor];
    self.titleLabel.shadowOffset=CGSizeMake(1, 1);
    
    self.titleLabel.backgroundColor=[UIColor clearColor];
    self.titleLabel.font = [UIFont fontWithName:@(kBuildingFont) size:kBuildingTitleFontSize];
    //self.titleLabel.font=[UIFont boldSystemFontOfSize:20];
    self.titleLabel.textColor=[UIColor whiteColor];
    self.titleLabel.contentMode = UIViewContentModeTopLeft;
    
    
    //self.titleLabel.b
    
    
    [self addSubview:self.titleLabel];
}



- (void)cropTitleBg
{
    // crop the image using CICrop
    CGRect rect = CGRectMake(0.0, 0.0, self.frame.size.width,80);
    
    CIImage *theCIImage = [CIFilter filterWithName:@"CICrop" keysAndValues:kCIInputImageKey, theCIImage, @"inputRectangle", rect, nil].outputImage;

}

#pragma mark -
#pragma mark event


-(void)tapthis
{
    if(self.dataViewUp==YES)
    {
        [self scrollDown];
    }
    else
    {
        [self scrollUp];
    }
}


- (void)blurImage
{
    
    [UIView animateWithDuration:0.2 animations:^(void){
        self.blurredImageView.alpha=0.7;
        self.glassView.alpha=0.7;
      
    }];
    
    

}

-(void)resetImage
{
    self.blurredImageView.alpha=0;
    self.glassView.alpha=0;

}

- (void)scrollUp
{
    if(self.dataViewUp == NO){
        
    [self blurImage];
        
        [self scrollTo:100];
        self.dataViewUp=YES;

        
    }
    
}

- (void)scrollDown
{
    
        [self scrollTo:kBuildingCommodityViewTop];
        self.dataViewUp=NO;
        
        [self resetImage];
        
    
}

- (void)scrollTo:(CGFloat)y
{
 
    NSLog(@"dataview:%@",NSStringFromCGRect(self.dataView.frame));
    
        [UIView animateWithDuration:0.2 delay:0
                            options: UIViewAnimationOptionCurveEaseOut animations:^(void) {
                                [self.dataView setFrame:CGRectMake(self.dataView.frame.origin.x, y, self.dataView.bounds.size.width, self.dataView.bounds.size.height)];
                                /*if(y==500){
                                    [self.imageView setCenter:CGPointMake(self.center.x, self.center.y+10) ];
                                }
                                else
                                     {
                                         [self.imageView setCenter:CGPointMake(self.center.x, self.center.y-10) ];
                                     }*/
                                
                            } completion:^(BOOL ret){
                                
                            }];
        


    
}

- (void)moveEndByVelocity:(CGFloat)y
{
    CGFloat origEnd= self.dataView.frame.origin.y;
    if(origEnd == kBuildingCommodityViewTop && y>0){
        return;
    }
    CGFloat end=origEnd+y;
    NSLog(@"end:%f",end);
    
    if(end>kBuildingCommodityViewTop)
    {
        end=kBuildingCommodityViewTop+50;
    }
    
    if(end<100)
    {
        end=50;
    }
    
    [UIView animateWithDuration:0.5 delay:0
                        options: UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                            if(y<0){
                                [self blurImage];
                            }
                            else{
                                [self resetImage];
                            }
                            
                        } completion:^(BOOL ret){
                            
                        }];
    [UIView animateWithDuration:0.5 delay:0
                        options: UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                            [self.dataView setFrame:CGRectMake(0, end, self.dataView.bounds.size.width, self.dataView.bounds.size.height)];
                            
                            
                            
                            
                        } completion:^(BOOL ret){
                            if(y<0)
                            {
                                [UIView animateWithDuration:0.5 delay:0
                                                    options: UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                                                        CGFloat f=100;
                                                            [self.dataView setFrame:CGRectMake(0, f, self.dataView.bounds.size.width, self.dataView.bounds.size.height)];
                                                    } completion:nil];
                            }
                            else{
                                [self scrollDown];
                            }
                        }];
}



- (void)move:(CGFloat)y
{
    [self.dataView setCenter:CGPointMake(self.dataView.center.x,self.dataView.center.y+y)];
    self.cumulateY+=y;
    CGFloat deep;
    //NSLog(@"cumulateY:%f",self.cumulateY);
    CGFloat top = self.dataView.frame.origin.y;
    //NSLog(@"top:%f",top);
    if(top<=100){
        deep=0.7;
    }
    else if(top >= kBuildingCommodityViewTop){
        deep=0;
    }
    else{
        deep =  floorf(ABS(self.cumulateY/1000)*100)/100;
    }
    if(deep>0.7) deep=0.7;
    
    
    self.glassView.alpha=deep;
    self.blurredImageView.alpha=deep;
    
    
}

- (void)moveEnd
{
     CGFloat top = self.dataView.frame.origin.y;
    NSLog(@"top:%f",top);
    if( top<300){
        [self scrollUp];
    }
    else{
        [self scrollDown];
    }
    
    self.cumulateY=0;

}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
