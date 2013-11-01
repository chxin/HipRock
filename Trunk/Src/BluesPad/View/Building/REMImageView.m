//
//  REMImageView.m
//  TestImage
//
//  Created by 谭 坦 on 7/23/13.
//  Copyright (c) 2013 demo. All rights reserved.
//

#import "REMImageView.h"
#import "REMCommonHeaders.h"
#import "REMDimensions.h"

#define kDashboardThreshold 361+65+85+45

#define kBuildingImageLoadingKeyPrefix "buildingimage-%@"

@interface REMImageView()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) REMBuildingDataView *dataView;
@property (nonatomic) BOOL dataViewUp;
@property (nonatomic) CGFloat cumulateY;
@property (nonatomic,strong) UIImageView *titleBg;

@property (nonatomic,strong) UIImageView *blurredImageView;
@property (nonatomic,strong) UIView *glassView;
@property (nonatomic,weak) CAGradientLayer *bottomGradientLayer;
@property (nonatomic,weak) CAGradientLayer *titleGradientLayer;


@property (nonatomic,weak) REMBuildingOverallModel *buildingInfo;
@property (nonatomic) BOOL loadingImage;
@property (nonatomic) BOOL customImageLoaded;
@property (nonatomic,strong) NSString *loadingImageKey;
@property (nonatomic,weak) UIButton *backButton;
@property (nonatomic,weak) UIButton *shareButton;
@property (nonatomic,weak) UIButton *shareDashboardButton;

@property (nonatomic,weak) UIButton *logoButton;

@property (nonatomic) BOOL isActive;

@property (nonatomic) BOOL hasLoadingChartData;

@property (nonatomic) BOOL isInDashboard;

@property (nonatomic) BOOL isSwitchingCommodityButtonGroup;



@property (nonatomic) BOOL hasLoadedWholeView;

@end

@implementation REMImageView

#pragma mark -
#pragma mark init

- (id)initWithFrame:(CGRect)frame withBuildingOveralInfo:(REMBuildingOverallModel *)buildingInfo
{
    self = [super initWithFrame:frame];
    if(self){
        self.buildingInfo=buildingInfo;
        
        self.contentMode=UIViewContentModeScaleAspectFit;
        self.dataViewUp=NO;
        self.cumulateY=0;
        self.loadingImage=NO;
        self.isInDashboard=NO;
        
        self.loadingImageKey=[NSString stringWithFormat:@(kBuildingImageLoadingKeyPrefix),self.buildingInfo.building.buildingId];
        
        
    }
    
    return self;
}

- (void)moveOutOfWindow{
    @autoreleasepool {
        
        [REMDataAccessor cancelAccess:self.loadingImageKey];
        [self.dataView cancelAllRequest];
        [self.dataView resetDefaultCommodity];
        [self.dashboardController cancelAllRequest];
        //[self.imageView removeFromSuperview];
        //[self.blurredImageView removeFromSuperview];
        
        //self.imageView.image=self.defaultImage;
        //self.imageView=nil;
        //self.blurredImageView.image=self.defaultBlurImage;
        //self.blurredImageView=nil;
        //    self.customImageLoaded=NO;
        self.isActive=NO;
    }
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
    self.customImageLoaded=NO;
    self.imageView.image=nil;
    self.imageView=nil;
    self.blurredImageView.image=nil;
    self.blurredImageView=nil;
    self.glassView=nil;
    
    self.titleLabel=nil;
    self.bottomGradientLayer=nil;
    self.backButton=nil;
    self.shareButton=nil;
    self.logoButton=nil;
    [self.dataView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    self.dataView=nil;
    self.dashboardController=nil;
}

- (void)initWholeViewUseThumbnail:(BOOL)useThumbnail{
    
    [self initImageView2:self.frame useThumbnail:useThumbnail];
    if(useThumbnail==NO && self.hasLoadedWholeView==NO){
            
        [self initGlassView];
    
        [self initBottomGradientLayer];
    
        [self initDataListView];
        
        [self initTitleView];
        
        [self initButtons];

        self.hasLoadedWholeView=YES;
        
    }
    
    
    
    
}
- (void)didMoveToSuperview
{
    //NSLog(@"parent changed");
    if(self.superview == nil){
        
        [self reset];
        return;
    }
}

/*
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
        
        //[self initDataListView];
        
        [self initTitleView];
        
        
        [self initButtons];
        
        //[self loadingBuildingImage];
        
    }
    
    
    
}
 */

- (void)initButtons{
    
    
    UIButton *shareButton=[[UIButton alloc]initWithFrame:CGRectMake(950, kBuildingTitleTop, kBuildingTitleButtonDimension, kBuildingTitleButtonDimension)];
    [shareButton setImage:[UIImage imageNamed:@"Share_normal.png"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"Share_disable.png"] forState:UIControlStateDisabled];
    //if (self.buildingInfo.commodityUsage.count == 0) {
        shareButton.enabled = NO;
    //}
    shareButton.showsTouchWhenHighlighted=YES;
    shareButton.adjustsImageWhenHighlighted=YES;
    shareButton.titleLabel.text=@"分享";
    [shareButton addTarget:self.controller action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:shareButton];
    self.shareButton=shareButton;
    
    self.dataView.shareButton=self.shareButton;
    
    
    UIButton *shareDashboard=[[UIButton alloc]initWithFrame:shareButton.frame];
    [shareDashboard setImage:[UIImage imageNamed:@"mail"] forState:UIControlStateNormal];
    //[shareDashboard setImage:[UIImage imageNamed:@"Share_disable.png"] forState:UIControlStateDisabled];
    
    shareDashboard.showsTouchWhenHighlighted=YES;
    shareDashboard.adjustsImageWhenHighlighted=YES;
    shareDashboard.titleLabel.text=@"查看分享记录";
    [shareDashboard addTarget:self.controller action:@selector(shareDashboardButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:shareDashboard];
    self.shareDashboardButton=shareDashboard;
    [self.shareDashboardButton setHidden:YES];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:kDMCommon_TopLeftButtonFrame];
    
    backButton.adjustsImageWhenHighlighted=YES;
    backButton.showsTouchWhenHighlighted=YES;
    backButton.titleLabel.text=@"地图";
    [backButton setBackgroundImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
    [backButton addTarget:self.controller action:@selector(backButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
   
    [self addSubview:backButton];
    self.backButton=backButton;
}

- (void)shareDashboardButtonPressed:(UIButton *)button{
    
}


- (void)loadingBuildingImage{
    
    if([self hasExistBuildingPic]==NO)return;
    if(self.customImageLoaded==YES)return;
    NSDictionary *param=@{@"pictureId":self.buildingInfo.building.pictureIds[0]};
    REMDataStore *store =[[REMDataStore alloc]initWithName:REMDSBuildingPicture parameter:param];
    store.groupName=self.loadingImageKey;
    self.loadingImage=YES;
    if(self.isActive==NO)return;
    [REMDataAccessor access: store success:^(NSData *data){
        if(data == nil || [data length] == 2) return;
        if(self.isActive==NO)return;
        self.customImageLoaded=YES;
        self.loadingImage=NO;
        
        UIImageView *newView = [[UIImageView alloc]initWithFrame:self.imageView.frame];
        newView.contentMode=UIViewContentModeScaleToFill;
        newView.alpha=0;
        
        
    
            @autoreleasepool {
                UIImage *view = [self getCachedImage:data];
                newView.image=view;
                UIImageView *newBlurred= [self blurredImageView:newView];
            
            
                
                [self insertSubview:newView aboveSubview:self.blurredImageView];
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
                    if(self.isActive == NO){
                        [self moveOutOfWindow];
                    }
                }];

            }

    }];
    
    return ;
}



- (NSString *)buildingPictureFileName{
    
    
    
    if([self hasExistBuildingPic]==NO)return nil;
    
    return [REMImageHelper buildingImagePathWithId:self.buildingInfo.building.pictureIds[0] andType:REMBuildingImageNormal];
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




- (BOOL)hasExistBuildingPic{
    if(self.buildingInfo.building.pictureIds==nil ||
       [self.buildingInfo.building.pictureIds isEqual:[NSNull null]] ||
       self.buildingInfo.building.pictureIds.count==0){
        
        return NO;
    }
    
    return YES;
}

- (NSArray *)loadSmallImage{
    
    if([self hasExistBuildingPic]==NO) return nil;
    
    NSString *smallPicPath= [REMImageHelper buildingImagePathWithId:self.buildingInfo.building.pictureIds[0] andType:REMBuildingImageSmall];
    NSString *smallBlurPicPath= [REMImageHelper buildingImagePathWithId:self.buildingInfo.building.pictureIds[0] andType:REMBuildingImageSmallBlured];
    BOOL hasExist= [[NSFileManager defaultManager] fileExistsAtPath:smallPicPath];
    if (hasExist==NO) {
        return nil;
    }
    
    UIImage *image= [[UIImage alloc] initWithContentsOfFile:smallPicPath];
    
    hasExist= [[NSFileManager defaultManager] fileExistsAtPath:smallBlurPicPath];
    if (hasExist==NO) {
        return @[image];
    }
    UIImage *blurImage= [[UIImage alloc] initWithContentsOfFile:smallBlurPicPath];
    return @[image,blurImage];
}


- (void)initImageView2:(CGRect)frame useThumbnail:(BOOL)thumbnail{
    
    if(self.imageView==nil){
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView.contentMode=UIViewContentModeScaleToFill;
        [self addSubview:imageView];
        self.imageView=imageView;
        
        UIImageView *blurred= [[UIImageView alloc]initWithFrame:self.imageView.frame];
        blurred.alpha=0;
        [self addSubview:blurred];
        self.blurredImageView=blurred;
    }
    if(self.customImageLoaded == YES) return;
    
    if(thumbnail == NO){
        UIImage *image = [self getCachedImage:nil];
        
        if(image != nil){
            self.customImageLoaded=YES;
            UIImageView *newView = [[UIImageView alloc]initWithFrame:self.imageView.frame];
            newView.contentMode=UIViewContentModeScaleToFill;
            newView.alpha=0;
            newView.image=image;
            UIImageView *newBlurred= [self blurredImageView:newView];
            
            [self insertSubview:newView aboveSubview:self.blurredImageView];
            [self insertSubview:newBlurred aboveSubview:newView];

            
            newView.alpha=self.imageView.alpha;
            newBlurred.alpha=self.blurredImageView.alpha;
            self.imageView.image=nil;
            self.blurredImageView.image=nil;
            [self.imageView removeFromSuperview];
            [self.blurredImageView removeFromSuperview];
            self.imageView = newView;
            self.blurredImageView=newBlurred;
            
            
            return;
            
        }

    }
    
    
        
    if(self.defaultImage!=nil){
        
        NSArray *array=[self loadSmallImage];
        
        if(array==nil){
            self.imageView.image = self.defaultImage;
            self.blurredImageView.image = self.defaultBlurImage;
        }
        else{
            self.imageView.image=array[0];
            if(array.count>1){
                self.blurredImageView.image=array[1];
            }
            else{
                self.blurredImageView.image=array[0];
            }
        }
    }

    
    
}


- (void)initBottomGradientLayer
{
    CGFloat height=kBuildingBottomGradientLayerHeight;
    CGRect frame = CGRectMake(0, self.frame.size.height-height, 1024, height);
    
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
    
    
    [self.layer insertSublayer:gradient above:self.glassView.layer];
    
    self.bottomGradientLayer=gradient;
    
    
    CAGradientLayer *layer=[self.controller getTitleGradientLayer];
    [self.layer insertSublayer:layer above:self.glassView.layer];
    
    self.titleGradientLayer=layer;

    
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
    
    
    REMBuildingDataView *dataView = [[REMBuildingDataView alloc]initWithFrame:CGRectMake(0, kBuildingTitleHeight, self.frame.size.width, self.frame.size.height-kBuildingTitleHeight) withBuildingInfo:self.buildingInfo];
    
    [self addSubview:dataView];
    self.dataView=dataView;
    [self.dataView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    self.dataView.delegate=self;
    
    
    
}

-(void)checkIfRequestChartData:(UIScrollView *)scrollView{
    if(self.isInDashboard){
        [self showDashboard];
    }
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
    else{
        if(scrollView.contentOffset.y>kDashboardThreshold){
            [self.controller switchToDashboard];
        }
    }
}



- (void) showDashboard{
    self.isInDashboard=YES;
    if(self.superview==nil)return;
    
    if(self.dashboardController==nil){
        self.dashboardController = [[REMDashboardController alloc]initWithStyle:UITableViewStyleGrouped];
        self.dashboardController.dashboardArray=self.buildingInfo.dashboardArray;
        CGRect newFrame = CGRectMake(kBuildingLeftMargin, self.dataView.frame.origin.y+self.dataView.frame.size.height, self.frame.size.width-kBuildingLeftMargin*2, self.dataView.frame.size.height);
        self.dashboardController.viewFrame=newFrame;
        self.dashboardController.imageView=self;
        self.dashboardController.buildingController=self.controller;
        self.dashboardController.buildingInfo=self.buildingInfo;
        self.dashboardController.dashboardArray=self.buildingInfo.dashboardArray;
        [self addSubview:self.dashboardController.tableView];
    }
    if(self.dataView.frame.origin.y<0)return;
    
    //NSLog(@"data view old frame:%@",NSStringFromCGRect(self.dataView.frame));
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        [self.dashboardController.tableView setFrame:CGRectMake(kBuildingLeftMargin, self.dataView.frame.origin.y-20, self.frame.size.width-kBuildingLeftMargin*2, self.dataView.frame.size.height)];
        
        [self.dataView setFrame:CGRectMake(self.dataView.frame.origin.x, self.dataView.frame.origin.y-self.dataView.frame.size.height, self.dataView.frame.size.width, self.dataView.frame.size.height)];
        
    } completion:^(BOOL finished){
        [self changeShareButton:NO];
        [self.dataView setHidden:YES];
        //NSLog(@"data view now frame:%@",NSStringFromCGRect(self.dataView.frame));
    }];
}

- (void)changeShareButton:(BOOL)weibo{
    if(weibo){
        [self.shareButton setHidden:NO];
        [self.shareDashboardButton setHidden:YES];
    }
    else{
        [self.shareButton setHidden:YES];
        [self.shareDashboardButton setHidden:NO];
    }
}

- (void)showBuildingInfo{
    self.isInDashboard=NO;
    if(self.superview==nil)return;
    if(self.dataView.frame.origin.y>0)return;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        [self.dashboardController.tableView setFrame:CGRectMake(kBuildingLeftMargin, self.dataView.frame.origin.y+self.dataView.frame.size.height*2, self.frame.size.width-kBuildingLeftMargin*2, self.dataView.frame.size.height)];
        [self.dataView setHidden:NO];
        [self.dataView setFrame:CGRectMake(self.dataView.frame.origin.x, self.dataView.frame.origin.y+self.dataView.frame.size.height, self.dataView.frame.size.width, self.dataView.frame.size.height)];
        
    } completion:^(BOOL finished){
        //[self.dashboardController.view removeFromSuperview];
        //self.dashboardController=nil;
        [self changeShareButton:YES];
        [self requireChartData];
        
    }];
}

- (void)gotoBuildingInfo{
    [self.controller switchToBuildingInfo];
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y>kDashboardThreshold){
        [self.dataView showDashboardLabel:YES];
    }
    else{
        [self.dataView showDashboardLabel:NO];
    }
    //NSLog(@"scrollheight:%@",NSStringFromCGPoint(scrollView.contentOffset));
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
    [self setBlurLevel];
}


- (void)setBlurLevel {
    float blurLevel=(self.dataView.contentOffset.y + self.dataView.contentInset.top) / (kBuildingCommodityViewTop+kCommodityScrollTop);
    //NSLog(@"blurlevel:%f",blurLevel);
    if(self.blurredImageView.alpha == blurLevel) return;
    self.blurredImageView.alpha = MAX(blurLevel,0);
    
    
    self.glassView.alpha = MAX(0,MIN(blurLevel,0.8));
    
}







- (void)initTitleView
{
        //CGFloat leftMargin=kBuildingLeftMargin+kBuildingTitleButtonDimension+kBuildingTitleIconMargin;
    UILabel *buildingType=[[UILabel alloc]initWithFrame:CGRectMake(0, 13, self.frame.size.width, kBuildingTypeTitleFontSize)];
    buildingType.backgroundColor=[UIColor clearColor];
    buildingType.text=NSLocalizedString(@"Common_Building", @"");//  @"楼宇";
    buildingType.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    buildingType.shadowOffset=CGSizeMake(1, 1);
    buildingType.font = [UIFont fontWithName:@(kBuildingFontLight) size:kBuildingTypeTitleFontSize];
    
    buildingType.textAlignment=NSTextAlignmentCenter;
    buildingType.textColor=[UIColor whiteColor];
    
    [self addSubview:buildingType];
    
    CGFloat titleSize=kBuildingTitleFontSize;

    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, buildingType.frame.origin.y+buildingType.frame.size.height+7, self.frame.size.width, titleSize+5)];
    titleLabel.text=self.buildingInfo.building.name ;
    titleLabel.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    titleLabel.shadowOffset=CGSizeMake(1, 1);
    
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@(kBuildingFontLight) size:titleSize];

    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.textColor=[UIColor whiteColor];
    
    [self addSubview:titleLabel];
    
    self.titleLabel=titleLabel;
    
    UIButton *logoButton = [self.controller getCustomerLogoButton];
    
   
    //[logoButton setFrame:CGRectMake(kBuildingLeftMargin+kBuildingTitleButtonDimension, titleLabel.frame.origin.y, logoButton.frame.size.width, logoButton.frame.size.height)];
    
    [logoButton setBackgroundImage:[REMApplicationContext instance].currentCustomerLogo forState:UIControlStateNormal];
    
    logoButton.titleLabel.text=@"logo";
    
    [logoButton addTarget:self.controller action:@selector(settingButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:logoButton];
    
    self.logoButton=logoButton;
    
}

- (void)setScrollOffset:(CGFloat)offsetY
{
    
    [self.dataView setContentOffset:CGPointMake(-kBuildingLeftMargin, offsetY) animated:NO];
    [self checkIfRequestChartData:self.dataView];
}


#pragma mark -
#pragma mark should respose swipe

- (BOOL)shouldResponseSwipe:(UITouch *)touch
{
    //NSLog(@"touch.view:%@",touch.view.class);
    if( [touch.view isKindOfClass:[CPTGraphHostingView class]] == YES) return NO;
    
    return YES;
    
    
}



#pragma mark -
#pragma mark require data

- (void)requireChartData
{
    
    self.isActive=YES;
    [self loadingBuildingImage];
    if(self.isInDashboard==YES){
        [self showDashboard];
    }
    else{
        if(self.dataViewUp==YES){
            [self.dataView requireChartDataWithBuildingId:self.buildingInfo.building.buildingId complete:^(BOOL success){
                if(success==YES){
                    [self.shareButton setEnabled:YES];
                }
            }];
        }
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



- (void)scrollUp
{
    
    
    [self scrollTo:kCommodityScrollTop];
    self.dataViewUp=YES;
    self.dataView.isUpScroll=YES;
    
    
}

- (void)scrollDown
{
    
    [self scrollTo:-kBuildingCommodityViewTop];
    self.dataViewUp=NO;
    self.dataView.isUpScroll=NO;
    
    
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

#pragma mark -
#pragma mark export

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
        [[self getImageOfLayer:self.titleLabel.layer]drawInRect:CGRectMake(self.backButton.frame.origin.x, self.backButton.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height)];
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
