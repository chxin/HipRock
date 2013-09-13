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

@property (nonatomic,strong) UIImageView *blurredImageView;
@property (nonatomic,strong) UIView *glassView;
@property (nonatomic,strong) CAGradientLayer *bottomGradientLayer;
@property (nonatomic,strong) CAGradientLayer *titleGradientLayer;


@property (nonatomic,weak) REMBuildingOverallModel *buildingInfo;
@property (nonatomic) BOOL loadingImage;
@property (nonatomic) BOOL customImageLoaded;
@property (nonatomic,strong) NSString *loadingImageKey;
@property (nonatomic,strong) UIButton *settingButton;
@property (nonatomic,strong) UIButton *shareButton;

@property (nonatomic) BOOL isActive;

@property (nonatomic) BOOL hasLoadingChartData;

@property (nonatomic,strong) UIView *commodityButtonsView;

#define kBuildingImageLoadingKeyPrefix "buildingimage-%@"

@property (nonatomic) BOOL isSwitchingCommodityButtonGroup;

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
        
        
        self.loadingImageKey=[NSString stringWithFormat:@(kBuildingImageLoadingKeyPrefix),self.buildingInfo.building.buildingId];
        
        
    }
    
    return self;
}

- (void)moveOutOfWindow{
    [REMDataAccessor cancelAccess:self.loadingImageKey];
    [self.dataView cancelAllRequest];
    [self.dataView resetDefaultCommodity];
    self.isActive=NO;
}

-(void)prepareShare
{
    [self.dataView prepareShare];
}

- (void)reset{
    [REMDataAccessor cancelAccess:self.loadingImageKey];
    
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    self.isActive=NO;
    self.hasLoadingChartData=NO;
    [self.bottomGradientLayer removeFromSuperlayer];
    
    self.imageView.image=nil;
    self.imageView=nil;
    self.blurredImageView.image=nil;
    self.blurredImageView=nil;
    self.glassView=nil;
    
    self.titleLabel=nil;
    self.bottomGradientLayer=nil;
    self.settingButton=nil;
    [self.dataView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    self.dataView=nil;
}

- (void)didMoveToSuperview
{
    //NSLog(@"parent changed");
    if(self.superview == nil){
        
        [self reset];
        return;
    }
    else{
        //NSLog(@"subview count:%d",self.subviews.count);
        [self initImageView2:self.frame];
        
        [self initBottomGradientLayer];
        
        [self initGlassView];
        
        [self initDataListView];
        
        [self initTitleView];
        
        [self initSettingButton];
        
        [self loadingBuildingImage];
        
    }
    
    
    
}

- (void)initSettingButton{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kBuildingLeftMargin, kBuildingTitleTop, kBuildingTitleButtonDimension, kBuildingTitleButtonDimension)];
    [btn setImage:[UIImage imageNamed:@"Menu_normal.png"] forState:UIControlStateNormal];
    btn.adjustsImageWhenHighlighted=YES;
    btn.showsTouchWhenHighlighted=YES;
    btn.titleLabel.text=@"设置";
    
    [btn addTarget:self.controller action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.settingButton=btn;
    [self addSubview:btn];
    
    UIButton *shareButton=[[UIButton alloc]initWithFrame:CGRectMake(950, kBuildingTitleTop, kBuildingTitleButtonDimension, kBuildingTitleButtonDimension)];
    [shareButton setImage:[UIImage imageNamed:@"Share_normal.png"] forState:UIControlStateNormal];
    if (self.buildingInfo.commodityUsage.count == 0) {
        shareButton.enabled = NO;
    }
    shareButton.showsTouchWhenHighlighted=YES;
    shareButton.adjustsImageWhenHighlighted=YES;
    shareButton.titleLabel.text=@"分享";
    [shareButton addTarget:self.controller action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.shareButton=shareButton;
    [self addSubview:shareButton];

}

- (void)loadingBuildingImage{
    if(self.buildingInfo.building.pictureIds==nil ||
       [self.buildingInfo.building.pictureIds isEqual:[NSNull null]] ||
       self.buildingInfo.building.pictureIds.count==0){
        
        return;
    }
    NSDictionary *param=@{@"pictureId":self.buildingInfo.building.pictureIds[0]};
    REMDataStore *store =[[REMDataStore alloc]initWithName:REMDSBuildingPicture parameter:param];
    store.isAccessLocal=YES;
    store.isStoreLocal=YES;
    store.groupName=self.loadingImageKey;
    store.isStoreLocal = YES;
    store.isAccessLocal = YES;
    self.loadingImage=YES;
    [REMDataAccessor access: store success:^(NSData *data){
        if(data == nil || [data length] == 2) return;
        self.customImageLoaded=YES;
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
            self.imageView.image=nil;
            self.imageView=nil;
            self.blurredImageView.image=nil;
            self.blurredImageView=nil;
            self.imageView = newView;
            self.blurredImageView=newBlurred;
            self.defaultImage=nil;
            self.defaultBlurImage=nil;
            [self.controller notifyCustomImageLoaded:self.buildingInfo.building.buildingId];
        }];
        
        
        
        
        
    }];
    
    return ;
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

- (void)addImageDefer:(NSTimer *)timer{
    if(self.customImageLoaded == YES) return;
    
    if(self.defaultImage!=nil){
        self.imageView.image=  self.defaultImage;
        self.blurredImageView.image=self.defaultBlurImage;
    }
}

- (void)initImageView2:(CGRect)frame{
    
  
    
    NSTimer *timer = [ NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(addImageDefer:) userInfo:nil repeats:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
   
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.imageView.contentMode=UIViewContentModeScaleToFill;
    [self addSubview:self.imageView];
    
    UIImageView *blurred= [[UIImageView alloc]initWithFrame:self.imageView.frame];
    blurred.alpha=0;
    self.blurredImageView=blurred;
    [self addSubview:blurred];


}

/*
- (void)initImageView:(CGRect)frame
{
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.imageView.contentMode=UIViewContentModeScaleToFill;
    
    
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[self retrieveBuildingImage:self.buildingInfo.building.code] ofType:@"jpg"];
   
    NSData *image = [NSData dataWithContentsOfFile:filePath];
    
    self.imageView.image=  [UIImage imageWithData:image];
   
    [self addSubview:self.imageView];
    
    
    UIImageView *blurred= [self blurredImageView:self.imageView];
    self.blurredImageView=blurred;
    [self addSubview:blurred];
}*/

- (void)initBottomGradientLayer
{
    CGFloat height=kBuildingBottomGradientLayerHeight;
    CGRect frame = CGRectMake(0, self.frame.size.height-height, 1024, height);
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    self.bottomGradientLayer=gradient;

    gradient.frame = frame;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor clearColor].CGColor,
                       (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8].CGColor,
                       nil];
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    [gradient renderInContext:c];
    
    
    UIGraphicsEndImageContext();
    
    
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
        UIImage *view = [REMImageHelper blurImage:imageView.image];
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
    self.glassView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    [self addSubview:self.glassView];
}

- (void)initDataListView
{
    
    
    self.dataView = [[REMBuildingDataView alloc]initWithFrame:CGRectMake(0, kBuildingTitleHeight, self.frame.size.width, self.frame.size.height-kBuildingTitleHeight) withBuildingInfo:self.buildingInfo];
    
    [self addSubview:self.dataView];
    
    [self.dataView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    self.dataView.delegate=self;
    
    
    
    
}

-(void)checkIfRequestChartData:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y>=kCommodityScrollTop){
        self.dataViewUp=YES;
        if(self.isActive == YES && self.hasLoadingChartData==NO){
            [self requireChartData];
            self.hasLoadingChartData=YES;
        }
    }
}

- (void)roundPositionWhenDrag:(UIScrollView *)scrollView{
    //NSLog(@"dec end:%@",NSStringFromCGPoint(scrollView.contentOffset));
    if(scrollView.contentOffset.y<kCommodityScrollTop && scrollView.contentOffset.y>-kBuildingCommodityViewTop){
        if(ABS(scrollView.contentOffset.y) < (kBuildingCommodityViewTop+kCommodityScrollTop)/2){
            [self scrollUp];
        }
        else{
            [self scrollDown];
        }
    }
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y > kCommodityScrollTop){
        [self.dataView replaceImagesShowReal:NO];
    }
    
    
}




- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self checkIfRequestChartData:scrollView];
    
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate == NO){
        [self roundPositionWhenDrag:scrollView];
        [self.dataView replaceImagesShowReal:YES];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [self roundPositionWhenDrag:scrollView];
    
    if(scrollView.contentOffset.y>kCommodityScrollTop){
        [self checkIfRequestChartData:scrollView];
        [self.dataView replaceImagesShowReal:YES];
        
    }
    
}




- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    
    self.controller.currentScrollOffset = self.dataView.contentOffset.y;
    
    //NSLog(@"offset:%@",NSStringFromCGPoint(self.dataView.contentOffset));
    //NSLog(@"contentInset:%@",NSStringFromUIEdgeInsets(self.dataView.contentInset));
    
    //[self setBlurLevel:(self.dataView.contentOffset.y + self.dataView.contentInset.top) / (2 * CGRectGetHeight(self.bounds) / 3)];
    [self setBlurLevel:(self.dataView.contentOffset.y + self.dataView.contentInset.top) / (kBuildingCommodityViewTop+kCommodityScrollTop)];
}

- (void)setBlurLevel:(float)blurLevel {
    //NSLog(@"blurlevel:%f",blurLevel);
    self.blurredImageView.alpha = MAX(blurLevel,0);
    
    
    self.glassView.alpha = MAX(0,MIN(blurLevel,0.8));
    
}

- (BOOL)shouldResponseSwipe:(UITouch *)touch
{
    NSLog(@"touch.view:%@",touch.view.class);
    if( [touch.view isKindOfClass:[CPTGraphHostingView class]] == YES) return NO;
    
    return YES;
    
    
}




- (void)initTitleView
{
    CGFloat height=kBuildingTitleHeight;
    CGRect frame = CGRectMake(0, 0, 1024, height);
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
   
    gradient.frame = frame;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor,
                       (id)[UIColor clearColor].CGColor,
                       nil];
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    [gradient renderInContext:c];
    
    UIGraphicsEndImageContext();
    
    self.titleGradientLayer=gradient;
    
    [self.layer insertSublayer:self.titleGradientLayer above:self.blurredImageView.layer];

    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kBuildingLeftMargin+kBuildingTitleButtonDimension+kBuildingTitleIconMargin, kBuildingTitleTop, self.frame.size.width, kBuildingTitleFontSize+5)];
    self.titleLabel.text=self.buildingInfo.building.name;
    self.titleLabel.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    self.titleLabel.shadowOffset=CGSizeMake(1, 1);
    
    self.titleLabel.backgroundColor=[UIColor clearColor];
    self.titleLabel.font = [UIFont fontWithName:@(kBuildingFontLight) size:kBuildingTitleFontSize];

    
    self.titleLabel.textColor=[UIColor whiteColor];
    self.titleLabel.contentMode = UIViewContentModeTopLeft;
    
    
    [self addSubview:self.titleLabel];
}



#pragma mark -
#pragma mark require data

- (void)requireChartData
{
    self.isActive=YES;
    if(self.dataViewUp==YES){
        [self.dataView requireChartDataWithBuildingId:self.buildingInfo.building.buildingId complete:nil];
    }
    
}


#pragma mark -
#pragma mark event


-(void)tapthis
{
    if(self.dataView.contentOffset.y>kCommodityScrollTop) return;
    
    if(self.dataViewUp==YES)
    {
        [self scrollDown];
    }
    else
    {
        [self scrollUp];
    }
}

- (void)setScrollOffset:(CGFloat)offsetY
{
   [self.dataView setContentOffset:CGPointMake(-kBuildingLeftMargin, offsetY) animated:NO];
    [self checkIfRequestChartData:self.dataView];
}


- (void)scrollUp
{
    
    
    [self scrollTo:kCommodityScrollTop];
    self.dataViewUp=YES;
    
    
    
}

- (void)scrollDown
{
    
    [self scrollTo:-kBuildingCommodityViewTop];
    self.dataViewUp=NO;
    
    
    
}

- (void)scrollTo:(CGFloat)y
{
    //NSLog(@"x:%f",self.dataView.frame.origin.x);
    [self.dataView setContentOffset:CGPointMake(-kBuildingLeftMargin, y) animated:YES];
}




- (void)moveCenter:(CGFloat)x
{
    [self setCenter:CGPointMake(self.center.x+x, self.center.y)];
    
    //CGFloat origx=self.center.x;
    //CGFloat imagex=self.imageView.center.x;
    //[self.dataView setCenter:CGPointMake(self.dataView.center.x+x, self.dataView.center.y)];
    
    //[self.imageView setCenter:CGPointMake(imagex+x*0.8, self.imageView.center.y)];
}

- (void)exportImage:(void (^)(UIImage *, NSString*))callback
{
    [self.dataView exportDataView:^(NSDictionary *outputDic){
        UIImage* dataImage = [outputDic objectForKey:@"image"];
        float dataImageHeight = dataImage.size.height;
        
        CGFloat outputWidth = self.frame.size.width;
        CGFloat outputHeightWithoutFooter = dataImageHeight + kBuildingCommodityViewTop + kBuildingTitleHeight;
        CGFloat footerHeight = 98;
        UIImage *footerImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WeiboBana" ofType:@"jpg"]];
        UIGraphicsBeginImageContext(CGSizeMake(outputWidth, outputHeightWithoutFooter + footerHeight));
        [[UIColor blackColor]set];
        UIRectFill(CGRectMake(0, 0, outputWidth, outputHeightWithoutFooter + footerHeight));
        [[self getImageOfLayer:self.imageView.layer]drawInRect:self.imageView.frame];
        [[self getImageOfLayer:self.titleLabel.layer]drawInRect:CGRectMake(self.settingButton.frame.origin.x, self.settingButton.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height)];
        //[[self getImageOfLayer:self.settingButton.layer]drawInRect:self.settingButton.frame];
        [[self getImageOfLayer:self.bottomGradientLayer]drawInRect:self.bottomGradientLayer.frame];
        [dataImage drawInRect:CGRectMake(0, kBuildingCommodityViewTop + kBuildingTitleHeight, outputWidth, dataImageHeight)];
        
        [footerImage drawInRect:CGRectMake(0, outputHeightWithoutFooter, 800, footerHeight)];
        [[self getImageOfLayer:self.titleGradientLayer]drawInRect:self.titleGradientLayer.frame];
        UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
//        NSArray* myPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        NSString* myDocPath = myPaths[0];
//        NSString* fileName = [myDocPath stringByAppendingFormat:@"/cachefiles/weibo.png"];
//        [UIImagePNGRepresentation(img) writeToFile:fileName atomically:NO];

        
        //[NSString str]
        NSString* buildingName = self.buildingInfo.building.name;
        NSString* text = [NSString stringWithFormat:[outputDic objectForKey:@"text"], buildingName];
        callback(img, text);
    }];
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(UIImage*)getImageOfLayer:(CALayer*) layer{
    UIGraphicsBeginImageContext(layer.frame.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
