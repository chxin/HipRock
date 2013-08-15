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
@property (nonatomic,strong) CIImage *clearImage;

@property (nonatomic,strong) UIImageView *blurredImageView;
@property (nonatomic,strong) UIView *glassView;
@property (nonatomic,strong) CAGradientLayer *bottomGradientLayer;

@property (nonatomic) BOOL hasLoadedChartData;
@property (nonatomic,weak) REMBuildingOverallModel *buildingInfo;
@property (nonatomic) BOOL loadingImage;
@property (nonatomic,strong) NSString *loadingImageKey;
#define kBuildingImageLoadingKeyPrefix "buildingimage-%@"

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
        self.loadingImage=NO;
        self.hasLoadedChartData=NO;
        
        
        self.loadingImageKey=[NSString stringWithFormat:@(kBuildingImageLoadingKeyPrefix),self.buildingInfo.building.buildingId];
        
        
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    //NSLog(@"parent changed");
    if(self.superview == nil){
        
        [REMDataAccessor cancelAccess:self.loadingImageKey];
        self.clearImage=nil;
        self.imageView.image=nil;
        self.imageView=nil;
        return;
    }
    else{
        
        [self initImageView:self.frame];
        
        [self initBottomGradientLayer];
        
        [self initGlassView];
        
        [self initDataListView];
        
        [self initTitleView];
        
    }
    
    [self loadingBuildingImage];
    
}

- (void)loadingBuildingImage{
    NSDictionary *param=@{@"pictureId":self.buildingInfo.building.buildingId};
    REMDataStore *store =[[REMDataStore alloc]initWithName:REMDSBuildingImage parameter:param];
    store.isAccessLocal=YES;
    store.isStoreLocal=YES;
    store.groupName=self.loadingImageKey;
    store.isStoreLocal = YES;
    store.isAccessLocal = YES;
    self.loadingImage=YES;
    [REMDataAccessor access: store success:^(NSData *data){
        if(data == nil) return;
        self.loadingImage=NO;
        
        UIImageView *newView = [[UIImageView alloc]initWithFrame:self.imageView.frame];
        newView.contentMode=UIViewContentModeScaleToFill;
        newView.alpha=0;
        newView.image=[self AFInflatedImageFromResponseWithDataAtScale:data];
        [self insertSubview:newView aboveSubview:self.blurredImageView];
        
        
        UIImageView *newBlurred= [self blurredImageView:newView];
        [self insertSubview:newBlurred aboveSubview:newView];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
            newView.alpha=self.imageView.alpha;
            newBlurred.alpha=self.blurredImageView.alpha;
        } completion:^(BOOL finished){
            [self.imageView removeFromSuperview];
            [self.blurredImageView removeFromSuperview];
            self.imageView = newView;
            self.clearImage = [CIImage imageWithCGImage:self.imageView.image.CGImage];
            self.blurredImageView=newBlurred;
            
        }];
        
        
        
        
        
    }];
    
    return ;
}


- (NSString *)retrieveBuildingImage:(NSString *)name
{
    return @"default-building";
}

- (UIImage *) AFImageWithDataAtScale:(NSData *)data {
    if ([UIImage instancesRespondToSelector:@selector(initWithData:scale:)]) {
        return [[UIImage alloc] initWithData:data scale:1];
    } else {
        UIImage *image = [[UIImage alloc] initWithData:data];
        return [[UIImage alloc] initWithCGImage:[image CGImage] scale:1 orientation:image.imageOrientation];
    }
}

- (UIImage *) AFInflatedImageFromResponseWithDataAtScale:(NSData *)data {
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
        UIImage *image = [self AFImageWithDataAtScale:data];
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
    
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
    
    CGColorSpaceRelease(colorSpace);
    
    if (!context) {
        CGImageRelease(imageRef);
        
        return [[UIImage alloc] initWithData:data];
    }
    
    CGRect rect = CGRectMake(0.0f, 0.0f, width, height);
    CGContextDrawImage(context, rect, imageRef);
    CGImageRef inflatedImageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage *inflatedImage = [[UIImage alloc] initWithCGImage:inflatedImageRef scale:1 orientation:UIImageOrientationUp];
    CGImageRelease(inflatedImageRef);
    CGImageRelease(imageRef);
    
    return inflatedImage;
}






- (void)initImageView:(CGRect)frame
{
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.imageView.contentMode=UIViewContentModeScaleToFill;
    
    
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[self retrieveBuildingImage:self.buildingInfo.building.code] ofType:@"jpg"];
    // NSURL *fileNameAndPath = [NSURL fileURLWithPath:filePath];
    NSData *image = [NSData dataWithContentsOfFile:filePath];
    
    //CIImage *beginImage = [CIImage imageWithContentsOfURL:fileNameAndPath];
    self.imageView.image=  [UIImage imageWithData:image];
    //self.imageView.image = [UIImage imageWithCGImage:beginImage];
    [self addSubview:self.imageView];
    
    self.clearImage = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    
    UIImageView *blurred= [self blurredImageView:self.imageView];
    self.blurredImageView=blurred;
    [self addSubview:blurred];
}

- (void)initBottomGradientLayer
{
    CGFloat height=kBuildingCommodityTotalHeight+kBuildingCommodityTotalTitleHeight+kBuildingCommodityButtonDimension+kBuildingCommodityItemGroupMargin*2;
    CGRect frame = CGRectMake(0, self.frame.size.height-height, 1024, height);
    
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
    
    [self.layer insertSublayer:self.bottomGradientLayer above:self.blurredImageView.layer];
    
}



- (UIImageView *)blurredImageView:(UIImageView *)imageView
{
    UIImageView *blurred = [[UIImageView alloc]initWithFrame:imageView.frame];
    blurred.alpha=0;
    blurred.contentMode=UIViewContentModeScaleToFill;
    blurred.backgroundColor=[UIColor clearColor];
    
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        EAGLContext *myEAGLContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        
        NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
        [options setObject: [NSNull null] forKey: kCIContextWorkingColorSpace];
        CIContext *myContext = [CIContext contextWithEAGLContext:myEAGLContext options:options];
        
        CIImage *ci = [[CIImage alloc]initWithCGImage:imageView.image.CGImage];
        
        CIFilter *filter1 = [CIFilter filterWithName:@"CIGaussianBlur"
                                       keysAndValues: kCIInputImageKey,ci,@"inputRadius",@(5),nil];
        
        CIImage *outputImage = [filter1 outputImage];
        
        NSLog(@"image size:%@",NSStringFromCGSize(imageView.image.size));
        CGImageRef cgimg =
        [myContext createCGImage:outputImage fromRect:CGRectMake(0, 0, imageView.image.size.width, imageView.image.size.height)];
        
        
        UIImage *view= [UIImage imageWithCGImage:cgimg];
        CGImageRelease(cgimg);
        dispatch_async(dispatch_get_main_queue(), ^{
            blurred.image=view;
        });
    });
    
    return blurred;
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
    
    
    self.dataView = [[REMBuildingDataView alloc]initWithFrame:CGRectMake(kBuildingLeftMargin, kBuildingTitleHeight+kBuildingCommodityItemGroupMargin, self.frame.size.width, self.frame.size.height-kBuildingTitleHeight-kBuildingCommodityItemGroupMargin) withBuildingInfo:self.buildingInfo];
    
    [self addSubview:self.dataView];
    
    [self.dataView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    
    // closer to zero, less blur applied
    [self setBlurLevel:(self.dataView.contentOffset.y + self.dataView.contentInset.top) / (2 * CGRectGetHeight(self.bounds) / 3)];
}

- (void)setBlurLevel:(float)blurLevel {
    //NSLog(@"blurlevel:%f",blurLevel);
    self.blurredImageView.alpha = blurLevel;
    
    
    self.glassView.alpha = MAX(0,MIN(blurLevel,0.7));
    
}

- (BOOL)shouldResponseSwipe:(UITouch *)touch
{
    if( [touch.view isKindOfClass:[CPTGraphHostingView class]] == YES) return NO;
    
    return YES;
    
    
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
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kBuildingLeftMargin, 0, self.frame.size.width, kBuildingTitleHeight)];
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



#pragma mark -
#pragma mark require data

- (void)requireChartData
{
    [self.dataView requireChartDataWithBuildingId:self.buildingInfo.building.buildingId];
    
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



- (void)scrollUp
{
    
    
    [self scrollTo:0];
    self.dataViewUp=YES;
    
    
}

- (void)scrollDown
{
    
    [self scrollTo:-kBuildingCommodityViewTop];
    self.dataViewUp=NO;
    
    
    
}

- (void)scrollTo:(CGFloat)y
{
    
    //NSLog(@"dataview:%@",NSStringFromCGRect(self.dataView.frame));
    //[self.dataView scrollRectToVisible:CGRectMake(self.dataView.frame.origin.x, y, self.dataView.bounds.size.width, self.dataView.bounds.size.height) animated:YES];
    [self.dataView setContentOffset:CGPointMake(0, y) animated:YES];
    /*[UIView animateWithDuration:0.2 delay:0
     options: UIViewAnimationOptionCurveEaseOut animations:^(void) {
     //[self.dataView setFrame:CGRectMake(self.dataView.frame.origin.x, y, self.dataView.bounds.size.width, self.dataView.bounds.size.height)];
     
     
     } completion:^(BOOL ret){
     
     }];*/
    
    
    
    
}




- (void)moveCenter:(CGFloat)x
{
    [self setCenter:CGPointMake(self.center.x+x, self.center.y)];
    
    //CGFloat origx=self.center.x;
    //CGFloat imagex=self.imageView.center.x;
    //[self.dataView setCenter:CGPointMake(self.dataView.center.x+x, self.dataView.center.y)];
    
    //[self.imageView setCenter:CGPointMake(imagex+x*0.8, self.imageView.center.y)];
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
