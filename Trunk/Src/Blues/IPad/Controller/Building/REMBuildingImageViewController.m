/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingImageViewController.m
 * Date Created : tantan on 11/11/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMBuildingImageViewController.h"
#import "REMBuildingDataViewController.h"
#import "REMDashboardController.h"
#import "REMDimensionForBuilding.h"
#import "REMDimensions.h"
#import "REMBuildingConstants.h"
#import "REMManagedBuildingPictureModel.h"
#import "REMCustomerLogoButton.h"
#import <QuartzCore/QuartzCore.h>
#import "REMButton.h"

#define kBuildingImageLoadingKeyPrefix "buildingimage-%@"

@interface REMBuildingImageViewController ()

@property (nonatomic,weak) UIImageView *imageView;
@property (nonatomic,weak) UIImageView *blurImageView;

@property (nonatomic,weak) REMCustomerLogoButton *backButton;
@property (nonatomic,weak) UIView *glassView;
@property (nonatomic,weak) UIView *container;
@property (nonatomic,weak) CALayer *bottomGradientLayer;
@property (nonatomic,weak) UILabel *buildingTypeTitleView;
@property (nonatomic,weak) UILabel *buildingTitleView;
//@property (nonatomic,weak) UIView *logoButton;
@property (nonatomic,strong) NSString *loadingImageKey;

@property (nonatomic,weak) UIImageView *cropTitleView;


@end


@implementation REMBuildingImageViewController

- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
        REMBuildingDataViewController *dataViewController=[[REMBuildingDataViewController alloc]init];
        REMDashboardController *dashboardController=[[REMDashboardController alloc]initWithStyle:UITableViewStyleGrouped];
        _currentCoverStatus=REMBuildingCoverStatusCoverPage;
        _currentOffset=NSNotFound;
        [self addChildViewController:dataViewController];
        [self addChildViewController:dashboardController];

    }
    return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    
    self.loadingImageKey=[NSString stringWithFormat:@(kBuildingImageLoadingKeyPrefix),self.buildingInfo.id];
    [self.view setFrame:self.viewFrame];
    [self setChildControllerFrame];
    [self loadSmallImageView];
    
//    self.imageView.center = CGPointMake(512-1024/3, 384);
//    self.blurImageView.center = CGPointMake(512-1024/3, 284);
}

- (void)setChildControllerFrame{
    REMBuildingDataViewController *coverController=self.childViewControllers[0];
    REMDashboardController *dashboardController=self.childViewControllers[1];
    
    coverController.buildingInfo=self.buildingInfo;
    coverController.viewFrame=CGRectMake(0, kBuildingTitleHeight, self.view.frame.size.width, self.view.frame.size.height-kBuildingTitleHeight);
    coverController.upViewFrame=CGRectMake(coverController.viewFrame.origin.x, coverController.viewFrame.origin.y-coverController.viewFrame.size.height, coverController.viewFrame.size.width, coverController.viewFrame.size.height);
    
    dashboardController.buildingInfo=self.buildingInfo;
    dashboardController.viewFrame=CGRectMake(kBuildingLeftMargin, coverController.viewFrame.origin.y+coverController.viewFrame.size.height, self.view.frame.size.width-kBuildingLeftMargin*2, coverController.viewFrame.size.height);
    dashboardController.upViewFrame=CGRectMake(dashboardController.viewFrame.origin.x, coverController.viewFrame.origin.y-20, dashboardController.viewFrame.size.width, dashboardController.viewFrame.size.height);
}

- (NSString *)buildingPictureFileName{
    if([self hasExistBuildingPic]==NO)return nil;
    REMManagedBuildingPictureModel *picModel = self.buildingInfo.pictures[0];
    return [REMImageHelper buildingImagePathWithId: picModel.id andType:REMBuildingImageNormal];
}

- (BOOL)hasExistBuildingPic{
    if(self.buildingInfo.pictures==nil ||
       [self.buildingInfo.pictures isEqual:[NSNull null]] ||
       self.buildingInfo.pictures.count==0){
        
        return NO;
    }
    
    return YES;
}

- (void)loadSmallImageView{
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*kDMCommon_ImageScale)];
    imageView.contentMode=UIViewContentModeScaleToFill;
    imageView.clipsToBounds=YES;
    UIImageView *blurImageView=[[UIImageView alloc]initWithFrame:imageView.frame];
    blurImageView.alpha=0;
    if([self hasExistBuildingPic]==NO){
        imageView.contentMode=UIViewContentModeTop;
        blurImageView.contentMode=UIViewContentModeTop;
        imageView.image=self.defaultImage;
        blurImageView.image=self.defaultBlurImage;
    }
    else{
        REMManagedBuildingPictureModel *picModel = self.buildingInfo.pictures[0];
        NSNumber *picId =picModel.id;
        NSString *smallPicPath= [REMImageHelper buildingImagePathWithId:picId andType:REMBuildingImageSmall];
        NSString *smallBlurPicPath= [REMImageHelper buildingImagePathWithId:picId andType:REMBuildingImageSmallBlured];
        NSString *normalPicPath= [REMImageHelper buildingImagePathWithId:picId andType:REMBuildingImageNormal];
        NSString *normalBlurPicPath= [REMImageHelper buildingImagePathWithId:picId andType:REMBuildingImageNormalBlured];

        BOOL hasExistNormal = [[NSFileManager defaultManager] fileExistsAtPath:normalPicPath];
        UIImage *normalImage = hasExistNormal ? [[UIImage alloc] initWithContentsOfFile:normalPicPath] : nil;
        
        if (hasExistNormal && normalImage!=nil) {
            imageView.contentMode=UIViewContentModeTop;
            imageView.image=normalImage;
            UIImage *blurredNormalImage = [[UIImage alloc] initWithContentsOfFile:normalBlurPicPath];
            blurImageView.contentMode=UIViewContentModeTop;
            blurImageView.image=blurredNormalImage;
        }
        else{
            BOOL hasExistSmall= [[NSFileManager defaultManager] fileExistsAtPath:smallPicPath];
            UIImage *smallImage= hasExistSmall ? [[UIImage alloc] initWithContentsOfFile:smallPicPath] : nil;
            if(hasExistSmall && smallImage!=nil){
                imageView.image=smallImage;
                BOOL hasExistBlurredSmall = [[NSFileManager defaultManager] fileExistsAtPath:smallBlurPicPath];
                UIImage *blurredSmallImage;
                if (hasExistBlurredSmall==YES) {
                    blurredSmallImage= [[UIImage alloc] initWithContentsOfFile:smallBlurPicPath];
                }
                else{
                    blurredSmallImage=[REMImageHelper blurImage:smallImage];
                    NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(blurredSmallImage)];
                    [data1 writeToFile:smallBlurPicPath atomically:YES];
//                    [REMImageHelper writeImageData:data1 toFile:smallBlurPicPath];
                }
                blurImageView.image=blurredSmallImage;
            }
            else {
                imageView.image=self.defaultImage;
                imageView.contentMode=UIViewContentModeTop;
                blurImageView.contentMode=UIViewContentModeTop;
                blurImageView.image=self.defaultBlurImage;
            }
        }
    }
    [self.view addSubview:imageView];
    [self.view addSubview:blurImageView];
    self.imageView=imageView;
    self.blurImageView=blurImageView;
    //NSLog(@"image view:%@",NSStringFromCGRect(self.imageView.frame));
    //NSLog(@"blur image view:%@",NSStringFromCGRect(self.blurImageView.frame));
}


- (void)loadContentView{
    if (self.glassView==nil) {
        [self initGlassView];
        [self initContainer];
        [self initBottomGradientLayer];
        [self initButtons];
        
        if(self.currentOffset!=NSNotFound){
            [self setBlurLevel:self.currentOffset];
        }
        
        [self loadingBuildingImage];
        [self initTitleView];
        
        
    }
    if(self.currentCoverStatus == REMBuildingCoverStatusCoverPage){
        REMBuildingDataViewController *controller=self.childViewControllers[0];
        
       
        if(controller.isViewLoaded == NO){
            [self.shareButton setHidden:NO];
            [self.container addSubview:controller.view];
            [controller.view setFrame:controller.viewFrame];
        }
        else{
            [controller.view setHidden:NO];
            [controller.view setFrame:controller.viewFrame];
        }
    }
    else{
        REMDashboardController *controller=self.childViewControllers[1];
        if(controller.isViewLoaded == NO){
            [self.shareButton setHidden:YES];
            [self.container addSubview:controller.view];
            [controller.view setFrame:controller.upViewFrame];
        }
        else{
            [controller.view setFrame:controller.upViewFrame];
            [controller.view setHidden:NO];
        }
        
        
        
    }
    
}

- (void)initContainer{
    UIView *container=[[UIView alloc]initWithFrame:CGRectMake(0, REMDMCOMPATIOS7(0), self.view.frame.size.width, self.view.frame.size.height)];
    [container setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:container];
    self.container=container;
}

- (void)initGlassView
{
    UIView *glassView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
    glassView.alpha=0;
    glassView.contentMode=UIViewContentModeScaleToFill;
    glassView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:glassView];
    self.glassView=glassView;
    //glassView.layer.borderColor=[UIColor redColor].CGColor;
    //glassView.layer.borderWidth=1;
}

- (void)initBottomGradientLayer
{
    CGFloat height=kBuildingBottomGradientLayerHeight;
    CGRect frame = CGRectMake(0, self.container.frame.size.height-height, self.glassView.frame.size.width, height);
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    
    gradient.frame = frame;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor clearColor].CGColor,
                       (id)[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8].CGColor,
                       nil];
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    [gradient renderInContext:c];
    
    
    UIGraphicsEndImageContext();
    
    
    [self.view.layer insertSublayer:gradient above:self.glassView.layer];
    self.bottomGradientLayer=gradient;
    
    CAGradientLayer *layer=[self getTitleGradientLayer];
    [self.view.layer insertSublayer:layer above:self.glassView.layer];
    
    
}

- (void)initButtons{
    REMCustomerLogoButton *backButton = [[REMCustomerLogoButton alloc] initWithIcon:REMIMG_Back];
    CGRect frame = backButton.frame;
    frame.origin.y = kDMCommon_CustomerLogoTop;
    [backButton setFrame: frame];
    [backButton addTarget:self.parentViewController action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.container addSubview:backButton];
    self.backButton=backButton;
    
    UIButton *settingButton=self.settingButton;
    if (REMISIOS7) {
        [settingButton setFrame:CGRectMake(settingButton.frame.origin.x, settingButton.frame.origin.y-kDMStatusBarHeight , settingButton.frame.size.width, settingButton.frame.size.height)];
    }
    
    [settingButton removeTarget:self action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [settingButton addTarget:self.parentViewController action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.container addSubview:settingButton];
    
    
    UIButton *shareButton=[REMButton buttonWithType:UIButtonTypeCustom];
    if (REMISIOS7) {
        shareButton=[REMButton buttonWithType:UIButtonTypeSystem];
        [shareButton setTintColor:[UIColor whiteColor]];
    }
    //CGRectMake(settingButton.frame.origin.x-kDMCommon_TopLeftButtonWidth-kDMCommon_ContentLeftMargin, settingButton.frame.origin.y, kDMCommon_TopLeftButtonWidth, kDMCommon_TopLeftButtonHeight)
    CGRect shareButtonFrame = CGRectMake(settingButton.frame.origin.x-kDMCommon_TopLeftButtonWidth-kDMCommon_ContentLeftMargin, settingButton.frame.origin.y, kDMCommon_TopLeftButtonWidth + 2*kDMButtonExtending, kDMCommon_TopLeftButtonHeight + 2*kDMButtonExtending);
    
    [shareButton setFrame:shareButtonFrame];
    [shareButton setImage:REMIMG_Share_normal forState:UIControlStateNormal];
    //if (self.buildingInfo.commodityUsage.count == 0) {
    shareButton.enabled = NO;
    //}
    //shareButton.showsTouchWhenHighlighted=YES;
    shareButton.adjustsImageWhenHighlighted=NO;
    if (!REMISIOS7) {
        shareButton.showsTouchWhenHighlighted=YES;
    }
    shareButton.titleLabel.text=@"Share";
    [shareButton addTarget:self.parentViewController action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.container addSubview:shareButton];
    
    self.shareButton=shareButton;
}

- (void)initTitleView
{
    //CGFloat leftMargin=kBuildingLeftMargin+kBuildingTitleButtonDimension+kBuildingTitleIconMargin;
    UILabel *buildingType=[[UILabel alloc]initWithFrame:CGRectMake(0, 12, self.container.frame.size.width, kBuildingTypeTitleFontSize)];
    buildingType.backgroundColor=[UIColor clearColor];
    buildingType.text=REMIPadLocalizedString(@"Common_Building");//  @"楼宇";
    buildingType.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    buildingType.shadowOffset=CGSizeMake(1, 1);
    buildingType.font = [REMFont defaultFontOfSize:kBuildingTypeTitleFontSize];
    
    buildingType.textAlignment=NSTextAlignmentCenter;
    buildingType.textColor=[UIColor whiteColor];
    
    [self.container addSubview:buildingType];
    self.buildingTypeTitleView=buildingType;
    CGFloat titleSize=kBuildingTitleFontSize;
    if(self.buildingInfo.name.length>25){
        titleSize=titleSize-3;
    }
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, buildingType.frame.origin.y+buildingType.frame.size.height+4, self.container.frame.size.width, titleSize+2)];
    titleLabel.text=self.buildingInfo.name ;
    titleLabel.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    titleLabel.shadowOffset=CGSizeMake(1, 1);
    
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font = [REMFont defaultFontOfSize:titleSize];
    
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    
    [self.container addSubview:titleLabel];
    
    self.buildingTitleView=titleLabel;
}



- (UIImage *)getCachedImage:(NSData *)data{
    
    NSString *pngFilePath=[self buildingPictureFileName];
    if(pngFilePath==nil)return nil;
    BOOL hasExist= [[NSFileManager defaultManager] fileExistsAtPath:pngFilePath];
    if(hasExist ==YES){
        
        return [[UIImage alloc] initWithContentsOfFile:pngFilePath];
    }
    else{
        if(data==nil)return nil;
        UIImage *image= [REMImageHelper parseImageFromNSData:data withScale:kDMCommon_ImageScale];
        
        NSString *pngFilePath = [self buildingPictureFileName];
        NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
        [data1 writeToFile:pngFilePath atomically:YES];
//        [REMImageHelper writeImageData:data1 toFile:pngFilePath];
        
        CGSize newSize=CGSizeMake(174, 110);
        
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        REMManagedBuildingPictureModel *picModel = self.buildingInfo.pictures[0];
        NSString *smallPicPath= [REMImageHelper buildingImagePathWithId:picModel.id andType:REMBuildingImageSmall];
        
        BOOL hasExist= [[NSFileManager defaultManager] fileExistsAtPath:smallPicPath];
        if (hasExist==NO) {
            data1 = [NSData dataWithData:UIImagePNGRepresentation(newImage)];
            [data1 writeToFile:smallPicPath atomically:YES];
//            [REMImageHelper writeImageData:data1 toFile:smallPicPath];
        }
        
        
        return image;
        
    }
}





- (void)loadImageViewByImage:(UIImage *)image{
    UIImageView *newView = [[UIImageView alloc]initWithFrame:CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height*kDMCommon_ImageScale)];
    newView.contentMode=UIViewContentModeTop;
    newView.clipsToBounds=YES;
    newView.alpha=0;
    UIImage *view = image;
    newView.image=view;
    UIImageView *newBlurred= [self blurredImageView:newView];
    newBlurred.contentMode=UIViewContentModeTop;
    newBlurred.clipsToBounds=YES;
    //[newBlurred setFrame:CGRectMake(-25, -25, newBlurred.frame.size.width+50, newBlurred.frame.size.height+50)];
//    newBlurred.layer.borderColor=[UIColor redColor].CGColor;
//    newBlurred.layer.borderWidth=1;
    [self.view insertSubview:newView aboveSubview:self.blurImageView];
    [self.view insertSubview:newBlurred aboveSubview:newView];
    
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        newView.alpha=self.imageView.alpha;
        newBlurred.alpha=self.blurImageView.alpha;
    } completion:^(BOOL finished){
        newView.alpha=self.imageView.alpha;
        newBlurred.alpha=self.blurImageView.alpha;
        [self.imageView removeFromSuperview];
        [self.blurImageView removeFromSuperview];
        self.imageView.image=nil;
        self.imageView=nil;
        self.blurImageView.image=nil;
        self.blurImageView=nil;
        self.imageView = newView;
        self.blurImageView=newBlurred;
        
        if (self.cropTitleView!=nil) {
            [self.cropTitleView removeFromSuperview];
            self.cropTitleView=nil;
        }

    }];

}

- (void)loadingBuildingImage{
    
    if([self hasExistBuildingPic]==NO)return;
    
    UIImage *image = [self getCachedImage:nil];
    if(image!=nil){
        [self loadImageViewByImage:image];
    }
    else{
        REMManagedBuildingPictureModel *picModel = self.buildingInfo.pictures[0];
        NSDictionary *param=@{@"pictureId":picModel.id};
        REMDataStore *store =[[REMDataStore alloc]initWithName:REMDSBuildingPicture parameter:param accessCache:YES andMessageMap:nil];
        store.groupName=self.loadingImageKey;
        
        store.isDisableAlert=YES;
        [store access:^(id img){
            if(img == nil)
                return ;
            
            NSData *data = UIImagePNGRepresentation(img);
            //if(data == nil || [data length] == 2) return;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                UIImage *view = [self getCachedImage:data];
                UIImageView *blurView=[[UIImageView alloc]initWithImage:view];
                [self blurredImageView:blurView];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                   [self loadImageViewByImage:view];
                });
            });
            
        }];
    
    }
}


- (UIImageView *)blurredImageView:(UIImageView *)imageView
{
    UIImageView *blurred = [[UIImageView alloc]initWithFrame:imageView.frame];
    blurred.alpha=0;
    blurred.contentMode=UIViewContentModeTop;
    blurred.clipsToBounds=YES;
    blurred.backgroundColor=[UIColor clearColor];
    REMManagedBuildingPictureModel *picModel = self.buildingInfo.pictures[0];
    NSString *blurImagePath= [REMImageHelper buildingImagePathWithId:picModel.id  andType:REMBuildingImageNormalBlured];
    
    BOOL hasExist= [[NSFileManager defaultManager] fileExistsAtPath:blurImagePath];
    if(hasExist ==YES){
        
        UIImage *image= [[UIImage alloc] initWithContentsOfFile:blurImagePath];
        blurred.image=image;
        return blurred;
    }
    else{
        UIImage *view = [REMImageHelper blurImage2:imageView.image];
        if(view!=nil){
            blurred.image=view;
            NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(view)];
            [data1 writeToFile:blurImagePath atomically:YES];
//            [REMImageHelper writeImageData:data1 toFile:blurImagePath];
        }
        
        return blurred;
    }
    
    
}
- (void)clipTitleView{
//    if(self.cropTitleView!=nil){
//        [self.cropTitleView setHidden:NO];
//        return;
//    }
    if (self.isViewLoaded==NO) {
        return;
    }
    //UIImage *image=[REMImageHelper imageWithView:self.container];
    CGRect rect=CGRectMake(0, 0, self.view.frame.size.width, REMDMCOMPATIOS7(kBuildingTitleHeight));
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.view.window.screen.scale);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    //UIImage *img = [UIImage imageWithCGImage:imageRef];
    //CGImageRelease(imageRef);
    
    UIImageView *view=[[UIImageView alloc]initWithImage:img];
    [self.view addSubview:view];
    self.cropTitleView=view;
}



- (void)setCurrentOffset:(CGFloat)currentOffset{
    if(currentOffset!=_currentOffset){
        _currentOffset=currentOffset;

           // NSLog(@"image controller:%f",currentOffset);
        CGFloat offset=currentOffset;
        if (offset>=kCommodityScrollTop) {
            offset=ABS(kCommodityScrollTop);
        }
        else if (offset<=-kBuildingCommodityViewTop){
            offset=-kBuildingCommodityViewTop;
        }
        CGFloat move=20;
        CGFloat y=(kBuildingCommodityViewTop+offset)*move/(kBuildingCommodityViewTop+kCommodityScrollTop);
        //NSLog(@"center:%@",NSStringFromCGPoint(self.imageView.center));
        CGFloat center=self.imageView.frame.size.height/2.0;
        self.blurImageView.center=CGPointMake(self.imageView.center.x, center-y);
        self.imageView.center=CGPointMake(self.imageView.center.x, center-y);
        if(self.currentCoverStatus == REMBuildingCoverStatusCoverPage){
            REMBuildingDataViewController *controller=(REMBuildingDataViewController *)self.childViewControllers[0];
            [controller setCurrentOffsetY:currentOffset];
        }
        else{
            REMDashboardController *controller=(REMDashboardController *)self.childViewControllers[1];
            [controller setCurrentOffsetY:currentOffset];
        }
        
        REMBuildingViewController *buildingController=(REMBuildingViewController *)self.parentViewController;

        [buildingController setViewOffset:currentOffset];
    }
    
    
}

- (void)setBlurLevel:(CGFloat)offsetY {
//    float blurLevel=(offsetY + kBuildingCommodityViewTop) / (kBuildingCommodityViewTop+kCommodityScrollTop);
//     self.glassView.alpha = MAX(0,MIN(blurLevel,0.8));
//    return;
    float blurLevel=(offsetY + kBuildingCommodityViewTop) / (kBuildingCommodityViewTop+kCommodityScrollTop);
    
    self.blurImageView.alpha = MAX(blurLevel,0);
    
    if(blurLevel>=1.0){
        self.imageView.alpha=0;
    }
    else{
        self.imageView.alpha=1;
    }
    
    self.glassView.alpha = MAX(0,MIN(blurLevel,0.8));
    //NSLog(@"blurlevel:%f",blurLevel);
    
    
}



- (void)setCurrentCoverStatus:(REMBuildingCoverStatus)currentCoverStatus{
    if(_currentCoverStatus!=currentCoverStatus){
        _currentCoverStatus=currentCoverStatus;
        REMDashboardController *dashBoardController=(REMDashboardController *)self.childViewControllers[1];
        REMBuildingDataViewController *coverController=(REMBuildingDataViewController *)self.childViewControllers[0];
        
        if (currentCoverStatus==REMBuildingCoverStatusDashboard) {
            [self.shareButton setHidden:YES];
            REMBuildingViewController *buildingController=(REMBuildingViewController *)self.parentViewController;
            if(coverController.isViewLoaded==YES){
                
                if(dashBoardController.isViewLoaded==NO &&buildingController.currentCoverStatus!=currentCoverStatus){
                    [self.container addSubview:dashBoardController.view];
                }
                if(buildingController.currentCoverStatus!=currentCoverStatus){
                    [self clipTitleView];
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
                        [dashBoardController.view setHidden:NO];
                        [dashBoardController.view setFrame:dashBoardController.upViewFrame];
                        [coverController.view setFrame:coverController.upViewFrame];
                        
                    } completion:^(BOOL finished){
                        [coverController.view setHidden:YES];
                        //[self.cropTitleView setHidden:YES];
                        [self.cropTitleView removeFromSuperview];
                    }];
                }
                else{
                    [coverController.view setFrame:coverController.upViewFrame];
                    [coverController.view setHidden:YES];
                    if(dashBoardController.isViewLoaded){
                        [dashBoardController.view setHidden:NO];
                        [dashBoardController.view setFrame:dashBoardController.upViewFrame];
                    }
                }
            }
            
            buildingController.currentCoverStatus=REMBuildingCoverStatusDashboard;
        }
        else{
            [self.shareButton setHidden:NO];
            REMBuildingViewController *buildingController=(REMBuildingViewController *)self.parentViewController;
            if(dashBoardController.isViewLoaded==YES){

                if(coverController.isViewLoaded==NO && buildingController.currentCoverStatus!=currentCoverStatus){
                    [self.container addSubview:coverController.view];
                    [coverController.view setFrame:coverController.upViewFrame];
                }
                if (buildingController.currentCoverStatus!=currentCoverStatus) {
                    [self clipTitleView];
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
                        [coverController.view setHidden:NO];
                        [coverController.view setFrame:coverController.viewFrame];
                        [dashBoardController.view setFrame:dashBoardController.viewFrame];
                        
                    } completion:^(BOOL finished){
                        [dashBoardController.view setHidden:YES];
                        //[self.cropTitleView setHidden:YES];
                        [self.cropTitleView removeFromSuperview];
                    }];
                }
                else{
                    [dashBoardController.view setFrame:dashBoardController.viewFrame];
                    [dashBoardController.view setHidden:YES];
                    if(coverController.isViewLoaded){
                        [coverController.view setHidden:NO];
                        [coverController.view setFrame:coverController.viewFrame];
                    }
                }
            }
            
            buildingController.currentCoverStatus=REMBuildingCoverStatusCoverPage;
        }
        
        
        
    }
}



- (void)releaseContentView{
    [self releaseViewInController:self.childViewControllers];
}

- (void)releaseViewInController:(NSArray *)controllers{
    if(controllers.count>0){
        for (UIViewController *vc in controllers) {
            if(vc.isViewLoaded==YES){
                vc.view=nil;
            }
            [self releaseViewInController:vc.childViewControllers];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //NSLog(@"didReceiveMemoryWarning :%@",[self class]);
    if(self.childViewControllers.count>0){
        if(self.currentCoverStatus==REMBuildingCoverStatusCoverPage){
            UIViewController *controller= self.childViewControllers[1];
            [self releaseViewInController:@[controller]];
        }
        else{
            UIViewController *controller= self.childViewControllers[0];
            [self releaseViewInController:@[controller]];
        }
    }
    // Dispose of any resources that can be recreated.
}

- (void)releaseAllDataView{
    if (self.childViewControllers.count>0) {
        UIViewController *controller= self.childViewControllers[0];
        [self releaseViewInController:@[controller]];
    }
    
}

- (void)exportImage:(void (^)(UIImage *, NSString*))callback :(BOOL)isMail
{
    REMBuildingDataViewController *dataViewController=self.childViewControllers[0];
    
    NSDictionary *outputDic=[dataViewController realExport:isMail];
    UIImage* dataImage = [outputDic objectForKey:@"image"];
    float dataImageHeight = dataImage.size.height;
    
    CGFloat outputWidth = self.view.frame.size.width;
    CGFloat outputHeightWithoutFooter = dataImageHeight + kBuildingCommodityViewTop + kBuildingTitleHeight;
    CGFloat footerHeight = 98;
    UIImage *footerImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WeiboBana" ofType:@"jpg"]];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(outputWidth, outputHeightWithoutFooter + footerHeight),1,1);
    
    [[UIColor blackColor] set];
    
    UIRectFill(CGRectMake(0, 0, outputWidth, outputHeightWithoutFooter + footerHeight));
    
    UIImage *newBgImage=[self getCachedImage:nil];
    if(newBgImage==nil){
        newBgImage = REMIMG_DefaultBuilding;
    }
    
    [newBgImage drawInRect:self.imageView.frame];
    [[REMImageHelper imageWithView:self.backButton.logoView] drawInRect:CGRectMake(self.backButton.frame.origin.x, self.backButton.frame.origin.y, self.backButton.logoView.frame.size.width, self.backButton.logoView.frame.size.height)];
    [[REMImageHelper imageWithLayer:self.buildingTypeTitleView.layer] drawInRect:self.buildingTypeTitleView.frame];
    [[REMImageHelper imageWithLayer:self.buildingTitleView.layer] drawInRect:self.buildingTitleView.frame];
    //[[self getImageOfLayer:self.settingButton.layer]drawInRect:self.settingButton.frame];
    CGRect ffds = self.bottomGradientLayer.frame;
    ffds = CGRectMake(ffds.origin.x, ffds.origin.y+kBuildingTitleTop, ffds.size.width, ffds.size.height);
    [[REMImageHelper imageWithLayer:self.bottomGradientLayer] drawInRect:ffds];
    
    [dataImage drawInRect:CGRectMake(0, kBuildingCommodityViewTop + kBuildingTitleHeight, outputWidth, dataImageHeight)];
    
    [footerImage drawInRect:CGRectMake(0, outputHeightWithoutFooter, 800, footerHeight)];
    //[[REMImageHelper imageWithLayer:self.titleGradientLayer] drawInRect:self.titleGradientLayer.frame];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //UIImage *img = dataImage;
    
    //UIImage *compressedImage=[UIImage imageWithData:UIImagePNGRepresentation(img)];
    
    //        NSArray* myPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //        NSString* myDocPath = myPaths[0];
    //        NSString* fileName = [myDocPath stringByAppendingFormat:@"/cachefiles/weibo.png"];
    //        [UIImagePNGRepresentation(img) writeToFile:fileName atomically:NO];
    
    
    //[NSString str]
    NSString* buildingName = self.buildingInfo.name;
    NSString* text = [NSString stringWithFormat:[outputDic objectForKey:@"text"], buildingName];
    callback(img, text);
}

-(void)centerChangedFrom:(CGPoint)oldCenter to:(CGPoint)newCenter
{
    CGFloat diff = newCenter.x - oldCenter.x;
    
    CGPoint imageCenter = CGPointMake(self.imageView.center.x-diff/3, self.imageView.center.y);
    
    
    self.imageView.center = imageCenter;
    self.blurImageView.center = imageCenter;
}


@end
