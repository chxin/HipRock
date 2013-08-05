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
@property (nonatomic) NSUInteger lastBlurDeep;
@property (nonatomic,strong) UIImageView *blurredImageView;
@property (nonatomic,strong) UIView *glassView;
@end

@implementation REMImageView

#pragma mark -
#pragma mark init

- (id)initWithFrame:(CGRect)frame WithImageName:(NSString *)name
{
    self = [super initWithFrame:frame];
    if(self){
        self.contentMode=UIViewContentModeScaleToFill;
        self.dataViewUp=NO;
        self.cumulateY=0;
        
        [self initImageView:frame withName:name];
                
        [self initBlurredImageView];
        
        [self initGlassView];
        
        [self initDataListView];
        
        [self initTitleView];
        
        
        
    }
    
    return self;
}

- (void)initImageView:(CGRect)frame withName:(NSString *)name
{
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.imageView.contentMode=UIViewContentModeScaleToFill;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"jpg"];
    // NSURL *fileNameAndPath = [NSURL fileURLWithPath:filePath];
    NSData *image = [NSData dataWithContentsOfFile:filePath];
    self.origImageData=image;
    //CIImage *beginImage = [CIImage imageWithContentsOfURL:fileNameAndPath];
    self.imageView.image=  [UIImage imageWithData:image];
    //self.imageView.image = [UIImage imageWithCGImage:beginImage];
    [self addSubview:self.imageView];
    
    self.clearImage = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    
    

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
    self.glassView.backgroundColor=[UIColor grayColor];
    
    [self addSubview:self.glassView];
}

- (void)initDataListView
{
    self.dataView = [[REMBuildingDataView alloc]initWithFrame:CGRectMake(0, 500, self.frame.size.width, 1000)];
    
    [self addSubview:self.dataView];

}

- (void)initTitleView
{
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
    
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 80)];
    self.titleLabel.text=@"银河SOHO";
    self.titleLabel.shadowColor=[UIColor blackColor];
    self.titleLabel.shadowOffset=CGSizeMake(1, 1);
    
    self.titleLabel.backgroundColor=[UIColor clearColor];
    self.titleLabel.font = [UIFont fontWithName:@"Avenir" size:80];
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
        self.glassView.alpha=0.5;
      
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
        self.lastBlurDeep=5;
        
    }
    
}

- (void)scrollDown
{
    if(self.dataViewUp==YES){
        [self scrollTo:500];
        self.dataViewUp=NO;
        
        [self resetImage];
        
        self.lastBlurDeep=0;
    }
}

- (void)scrollTo:(CGFloat)y
{
 
        [UIView animateWithDuration:0.2 delay:0
                            options: UIViewAnimationOptionCurveEaseOut animations:^(void) {
                                [self.dataView setFrame:CGRectMake(0, y, self.dataView.bounds.size.width, self.dataView.bounds.size.height)];
                                if(y==500){
                                    [self.imageView setCenter:CGPointMake(self.center.x, self.center.y+10) ];
                                }
                                else
                                     {
                                         [self.imageView setCenter:CGPointMake(self.center.x, self.center.y-10) ];
                                     }
                                
                            } completion:^(BOOL ret){
                                
                            }];
        


    
}

- (void)moveEndByVelocity:(CGFloat)y
{
    CGFloat end=self.dataView.frame.origin.y+y;
    //NSLog(@"end:%f",end);
    if(end>500)
    {
        end=550;
    }
    
    if(end<100)
    {
        end=748-self.dataView.bounds.size.height-100;
    }
    
    
    [UIView animateWithDuration:1 delay:0
                        options: UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                            [self.dataView setFrame:CGRectMake(0, end, self.dataView.bounds.size.width, self.dataView.bounds.size.height)];
                            
                            
                            
                        } completion:^(BOOL ret){
                            if(y<0)
                            {
                                [UIView animateWithDuration:1 delay:0
                                                    options: UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                                                            CGFloat f=748-self.dataView.bounds.size.height;
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
    __block NSUInteger deep;
    //NSLog(@"cumulateY:%f",self.cumulateY);
    //    NSLog(@"deep:%d",self.lastBlurDeep);
    if(self.cumulateY>=400){
        deep=5;
    }
    else{
        deep = ABS(floor(self.cumulateY/1000));
    }
    if(self.lastBlurDeep != deep){
        self.lastBlurDeep=deep;
    
    }
}

- (void)moveEnd
{
    if(ABS(self.cumulateY)<200){
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
