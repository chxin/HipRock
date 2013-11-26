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

#define kBuildingImageLoadingKeyPrefix "buildingimage-%@"

@interface REMBuildingImageViewController ()

@property (nonatomic,weak) UIImageView *imageView;
@property (nonatomic,weak) UIImageView *blurImageView;
@property (nonatomic,weak) UIButton *shareButton;
@property (nonatomic,weak) UIButton *backButton;
@property (nonatomic,weak) UIView *glassView;
@property (nonatomic,weak) UIView *container;
@property (nonatomic,weak) CALayer *bottomGradientLayer;
@property (nonatomic,weak) UILabel *buildingTypeTitleView;
@property (nonatomic,weak) UILabel *buildingTitleView;

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
	// Do any additional setup after loading the view.
    self.loadingImageKey=[NSString stringWithFormat:@(kBuildingImageLoadingKeyPrefix),self.buildingInfo.building.buildingId];
    //NSLog(@"self view:%@",NSStringFromCGRect(self.view.frame));
    [self.view setFrame:self.viewFrame];
    //NSLog(@"self view:%@",NSStringFromCGRect(self.view.frame));
    REMBuildingDataViewController *coverController=self.childViewControllers[0];
    REMDashboardController *dashboardController=self.childViewControllers[1];
    coverController.buildingInfo=self.buildingInfo;
    coverController.viewFrame=CGRectMake(0, kBuildingTitleHeight, self.view.frame.size.width, self.view.frame.size.height-kBuildingTitleHeight);
    coverController.upViewFrame=CGRectMake(coverController.viewFrame.origin.x, coverController.viewFrame.origin.y-coverController.viewFrame.size.height, coverController.viewFrame.size.width, coverController.viewFrame.size.height);
    dashboardController.buildingInfo=self.buildingInfo;
    dashboardController.viewFrame=CGRectMake(kBuildingLeftMargin, coverController.viewFrame.origin.y+coverController.viewFrame.size.height, self.view.frame.size.width-kBuildingLeftMargin*2, coverController.viewFrame.size.height);
    dashboardController.upViewFrame=CGRectMake(dashboardController.viewFrame.origin.x, coverController.viewFrame.origin.y-20, dashboardController.viewFrame.size.width, dashboardController.viewFrame.size.height);
    [self loadSmallImageView];

    
}

- (NSString *)buildingPictureFileName{
    if([self hasExistBuildingPic]==NO)return nil;
    
    return [REMImageHelper buildingImagePathWithId:self.buildingInfo.building.pictureIds[0] andType:REMBuildingImageNormal];
}

- (BOOL)hasExistBuildingPic{
    if(self.buildingInfo.building.pictureIds==nil ||
       [self.buildingInfo.building.pictureIds isEqual:[NSNull null]] ||
       self.buildingInfo.building.pictureIds.count==0){
        
        return NO;
    }
    
    return YES;
}

- (void)loadSmallImageView{
    
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //NSLog(@"imageview:%@",NSStringFromCGRect(imageView.frame));
    UIImageView *blurImageView=[[UIImageView alloc]initWithFrame:imageView.frame];
    blurImageView.alpha=0;
    if([self hasExistBuildingPic]==NO){
        imageView.image=self.defaultImage;
        blurImageView.image=self.defaultBlurImage;
    }
    else{
        NSString *smallPicPath= [REMImageHelper buildingImagePathWithId:self.buildingInfo.building.pictureIds[0] andType:REMBuildingImageSmall];
        NSString *smallBlurPicPath= [REMImageHelper buildingImagePathWithId:self.buildingInfo.building.pictureIds[0] andType:REMBuildingImageSmallBlured];
        BOOL hasExist= [[NSFileManager defaultManager] fileExistsAtPath:smallPicPath];
        if (hasExist==NO) {
            imageView.image=self.defaultImage;
            blurImageView.image=self.defaultBlurImage;
        }
        else{
            UIImage *image= [[UIImage alloc] initWithContentsOfFile:smallPicPath];
            imageView.image=image;
            hasExist= [[NSFileManager defaultManager] fileExistsAtPath:smallBlurPicPath];
            UIImage *blurImage;
            if (hasExist==YES) {
                blurImage= [[UIImage alloc] initWithContentsOfFile:smallBlurPicPath];
            }
            else{
                //blurImage=[REMImageHelper blurImage:image];
                blurImage=nil;
            }
            blurImageView.image=blurImage;
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
        [self loadingBuildingImage];
        [self initTitleView];
        if(self.currentOffset!=NSNotFound){
            [self setBlurLevel:self.currentOffset];
        }
        
    }
    if(self.currentCoverStatus == REMBuildingCoverStatusCoverPage){
        REMBuildingDataViewController *controller=self.childViewControllers[0];
        
       
        if(controller.isViewLoaded == NO){
            [self.container addSubview:controller.view];
        }
    }
    else{
        REMDashboardController *controller=self.childViewControllers[1];
        if(controller.isViewLoaded == NO){
            [self.container addSubview:controller.view];
            [controller.view setFrame:controller.upViewFrame];
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
    UIView *glassView= [[UIView alloc]initWithFrame:self.imageView.frame];
    glassView.alpha=0;
    glassView.contentMode=UIViewContentModeScaleToFill;
    glassView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
    [self.view addSubview:glassView];
    self.glassView=glassView;
}

- (void)initBottomGradientLayer
{
    CGFloat height=kBuildingBottomGradientLayerHeight;
    CGRect frame = CGRectMake(0, self.container.frame.size.height-height, 1024, height);
    
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
    
   
    
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(kDMCommon_TopLeftButtonLeft, kDMCommon_TopLeftButtonTop,kDMCommon_TopLeftButtonWidth,kDMCommon_TopLeftButtonHeight)];
    
    backButton.adjustsImageWhenHighlighted=YES;
    backButton.showsTouchWhenHighlighted=YES;
    backButton.titleLabel.text=@"Back";
    [backButton setBackgroundImage:REMIMG_Back forState:UIControlStateNormal];
    [backButton addTarget:self.parentViewController action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.container addSubview:backButton];
    self.backButton=backButton;
    
    UIButton *shareButton=[[UIButton alloc]initWithFrame:CGRectMake(950, backButton.frame.origin.y, kBuildingTitleButtonDimension, kBuildingTitleButtonDimension)];
    [shareButton setImage:REMIMG_Share_normal forState:UIControlStateNormal];
    //if (self.buildingInfo.commodityUsage.count == 0) {
    shareButton.enabled = NO;
    //}
    shareButton.showsTouchWhenHighlighted=YES;
    shareButton.adjustsImageWhenHighlighted=YES;
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
    buildingType.text=NSLocalizedString(@"Common_Building", @"");//  @"楼宇";
    buildingType.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    buildingType.shadowOffset=CGSizeMake(1, 1);
    buildingType.font = [UIFont fontWithName:@(kBuildingFontLight) size:kBuildingTypeTitleFontSize];
    
    buildingType.textAlignment=NSTextAlignmentCenter;
    buildingType.textColor=[UIColor whiteColor];
    
    [self.container addSubview:buildingType];
    self.buildingTypeTitleView=buildingType;
    CGFloat titleSize=kBuildingTitleFontSize;
    if(self.buildingInfo.building.name.length>25){
        titleSize=titleSize-3;
    }
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, buildingType.frame.origin.y+buildingType.frame.size.height+4, self.container.frame.size.width, titleSize+2)];
    titleLabel.text=self.buildingInfo.building.name ;
    titleLabel.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    titleLabel.shadowOffset=CGSizeMake(1, 1);
    
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@(kBuildingFontSC) size:titleSize];
    
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    
    [self.container addSubview:titleLabel];
    
    self.buildingTitleView=titleLabel;
    
    
    UIButton *logoButton = [self getCustomerLogoButton];
    [logoButton setFrame:CGRectMake(self.backButton.frame.origin.x+self.backButton.frame.size.width, kDMCommon_CustomerLogoTop, logoButton.frame.size.width, logoButton.frame.size.height)];
    [logoButton setBackgroundImage:REMAppCurrentLogo forState:UIControlStateNormal];
    
    logoButton.titleLabel.text=@"logo";
    [logoButton removeTarget:self action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [logoButton addTarget:self.parentViewController action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.container addSubview:logoButton];
    
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
        UIImage *image= [REMImageHelper parseImageFromNSData:data];
        
        NSString *pngFilePath = [self buildingPictureFileName];
        NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(image)];
        [data1 writeToFile:pngFilePath atomically:YES];
        
        CGSize newSize=CGSizeMake(174, 110);
        
        UIGraphicsBeginImageContext(newSize);
        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSString *smallPicPath= [REMImageHelper buildingImagePathWithId:self.buildingInfo.building.pictureIds[0] andType:REMBuildingImageSmall];
        
        BOOL hasExist= [[NSFileManager defaultManager] fileExistsAtPath:smallPicPath];
        if (hasExist==NO) {
            data1 = [NSData dataWithData:UIImagePNGRepresentation(newImage)];
            [data1 writeToFile:smallPicPath atomically:YES];
        }
        
        
        return image;
        
    }
}





- (void)loadImageViewByImage:(UIImage *)image{
    UIImageView *newView = [[UIImageView alloc]initWithFrame:self.imageView.frame];
    newView.contentMode=UIViewContentModeScaleToFill;
    newView.alpha=0;
    UIImage *view = image;
    newView.image=view;
    UIImageView *newBlurred= [self blurredImageView:newView];
    
    //[newBlurred setFrame:CGRectMake(-25, -25, newBlurred.frame.size.width+50, newBlurred.frame.size.height+50)];
    
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

    }];

}

- (void)loadingBuildingImage{
    
    if([self hasExistBuildingPic]==NO)return;
    
    UIImage *image = [self getCachedImage:nil];
    if(image!=nil){
        [self loadImageViewByImage:image];
    }
    else{
        NSDictionary *param=@{@"pictureId":self.buildingInfo.building.pictureIds[0]};
        REMDataStore *store =[[REMDataStore alloc]initWithName:REMDSBuildingPicture parameter:param];
        store.groupName=self.loadingImageKey;
        
        
        [REMDataAccessor access: store success:^(NSData *data){
            if(data == nil || [data length] == 2) return;
            UIImage *view = [self getCachedImage:data];
            [self loadImageViewByImage:view];
        }];
    
    }
}


- (UIImageView *)blurredImageView:(UIImageView *)imageView
{
    UIImageView *blurred = [[UIImageView alloc]initWithFrame:imageView.frame];
    blurred.alpha=0;
    blurred.contentMode=UIViewContentModeScaleToFill;
    blurred.backgroundColor=[UIColor clearColor];
    
    NSString *blurImagePath= [REMImageHelper buildingImagePathWithId:self.buildingInfo.building.pictureIds[0] andType:REMBuildingImageNormalBlured];
    
    BOOL hasExist= [[NSFileManager defaultManager] fileExistsAtPath:blurImagePath];
    if(hasExist ==YES){
        
        UIImage *image= [[UIImage alloc] initWithContentsOfFile:blurImagePath];
        blurred.image=image;
        return blurred;
    }
    else{
        
        UIImage *view = [REMImageHelper blurImage:imageView.image];
        if(view!=nil){
            blurred.image=view;
            NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(view)];
            [data1 writeToFile:blurImagePath atomically:YES];
        }
        
        return blurred;
    }
    
    
}
- (void)clipTitleView{
    if(self.cropTitleView!=nil){
        [self.cropTitleView setHidden:NO];
        return;
    }
    //UIImage *image=[REMImageHelper imageWithView:self.container];
    CGRect rect=CGRectMake(0, 0, self.view.frame.size.width, kBuildingTitleHeight);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.view.window.screen.scale);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    //UIImage *img = [UIImage imageWithCGImage:imageRef];
    //CGImageRelease(imageRef);
    
    UIImageView *view=[[UIImageView alloc]initWithImage:img];
    [self.container addSubview:view];
    self.cropTitleView=view;
}



- (void)setCurrentOffset:(CGFloat)currentOffset{
    if(currentOffset!=_currentOffset){
        _currentOffset=currentOffset;
        if(self.isViewLoaded==YES){
            if(self.currentCoverStatus == REMBuildingCoverStatusCoverPage){
                REMBuildingDataViewController *controller=(REMBuildingDataViewController *)self.childViewControllers[0];
                [controller setCurrentOffsetY:currentOffset];
            }
            else{
                REMDashboardController *controller=(REMDashboardController *)self.childViewControllers[1];
                [controller setCurrentOffsetY:currentOffset];
            }
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
    
    if(self.blurImageView.alpha == blurLevel) return;
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
                        [self.cropTitleView setHidden:YES];
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
                        [self.cropTitleView setHidden:YES];
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

- (void)loadingDataNow{
    [self.shareButton setEnabled:NO];
}

- (void)loadingDataComplete{
    [self.shareButton setEnabled:YES];
}

- (void)horizonalMoving{
    REMBuildingDataViewController *dataController=(REMBuildingDataViewController *)self.childViewControllers[0];
    REMDashboardController *dashboardController=(REMDashboardController *)self.childViewControllers[1];
    if(dataController.isViewLoaded==YES){
        [dataController horizonalMoving];
    }
    if(dashboardController.isViewLoaded==YES){
        [dashboardController horizonalMoving];
    }
}

- (void)horizonalStopped{
    REMBuildingDataViewController *dataController=(REMBuildingDataViewController *)self.childViewControllers[0];
    REMDashboardController *dashboardController=(REMDashboardController *)self.childViewControllers[1];
    if(dataController.isViewLoaded==YES){
        [dataController horizonalStopped];
    }
    if(dashboardController.isViewLoaded==YES){
        [dashboardController horizonalStopped];
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
-(UIImage*)getImageOfLayer:(CALayer*) layer{
    UIGraphicsBeginImageContext(layer.frame.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (void)exportImage:(void (^)(UIImage *, NSString*))callback
{
    REMBuildingDataViewController *dataViewController=self.childViewControllers[0];
    NSDictionary *outputDic=[dataViewController realExport];
    UIImage* dataImage = [outputDic objectForKey:@"image"];
    float dataImageHeight = dataImage.size.height;
    
    CGFloat outputWidth = self.view.frame.size.width;
    CGFloat outputHeightWithoutFooter = dataImageHeight + kBuildingCommodityViewTop + kBuildingTitleHeight;
    CGFloat footerHeight = 98;
    UIImage *footerImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"WeiboBana" ofType:@"jpg"]];
    UIGraphicsBeginImageContext(CGSizeMake(outputWidth, outputHeightWithoutFooter + footerHeight));
    [[UIColor blackColor]set];
    UIRectFill(CGRectMake(0, 0, outputWidth, outputHeightWithoutFooter + footerHeight));
    [[self getImageOfLayer:self.imageView.layer]drawInRect:self.imageView.frame];
    [[self getImageOfLayer:self.buildingTitleView.layer]drawInRect:CGRectMake(self.backButton.frame.origin.x, self.backButton.frame.origin.y, self.buildingTitleView.frame.size.width, self.buildingTitleView.frame.size.height)];
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
}




@end
