/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingDataViewController.m
 * Created      : tantan on 10/24/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingDataViewController.h"
#import "REMBuildingDataView.h"
#import "REMBuildingChartBaseViewController.h"
#import "REMManagedBuildingAirQualityModel.h"
#import "REMManagedBuildingCommodityUsageModel.h"
#import "REMCommonHeaders.h"

#define kDashboardThreshold 361+65+85*2+45

@interface REMBuildingDataViewController (){
    @private
    NSArray *_commodityArray;
}
@property (nonatomic,weak) UILabel *dashboardLabel;
@property (nonatomic,strong) NSArray *buttonArray;

@property (nonatomic) NSUInteger currentCommodityIndex;

@property (nonatomic,weak) UIImageView *arrow;
@property (nonatomic,strong) NSMutableDictionary *commodityDataLoadStatus;
@property (nonatomic,strong,readonly) NSArray *commodityArray;

@end

@implementation REMBuildingDataViewController

-(NSArray *)commodityArray
{
    if(self.buildingInfo==nil || self.buildingInfo.commodities == nil){
        return nil;
    }
    
    if(_commodityArray == nil){
        _commodityArray = [self.buildingInfo.commodities.allObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [((REMManagedBuildingCommodityUsageModel *)obj1).id compare:( (REMManagedBuildingCommodityUsageModel *)obj2).id];
        }];
    }
    
    return _commodityArray;
}

- (id)init{
    if(self=[super init]){
        _currentOffsetY=NSNotFound;
        self.commodityDataLoadStatus=[NSMutableDictionary dictionary];
        self.currentCommodityIndex=0;
    }
    return self;
}

-(void)loadView
{
    REMBuildingDataView *scroll=[[REMBuildingDataView alloc]initWithFrame:self.viewFrame];
    scroll.contentInset = UIEdgeInsetsMake(kBuildingCommodityViewTop, kBuildingLeftMargin, 0, 0);
    scroll.showsVerticalScrollIndicator=NO;
    [scroll setContentSize:CGSizeMake(0, 1165+85)];
    self.view=scroll;
    //scroll.layer.borderColor=[UIColor yellowColor].CGColor;
    //scroll.layer.borderWidth=1;
    scroll.delegate=self;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapthis)];
    [self.view addGestureRecognizer:tap];
    
    
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    [self initButtons];
    [self initDragLabel];
    [self initCommodityController];
    [self initCurrentCommodityView];
    if(self.currentOffsetY!=NSNotFound){//must put behand the initCommodityController
        [self scrollTo:self.currentOffsetY];
    }
}

- (void) initButtons{
    if(self.commodityArray==nil)return ;
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:self.commodityArray.count];
    int i=0;
    for (;i<self.commodityArray.count;++i) {
        REMManagedBuildingCommodityUsageModel *model = self.commodityArray[i];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(kBuildingCommodityButtonDimension+kBuildingCommodityBottomMargin), 0, kBuildingCommodityButtonDimension, kBuildingCommodityButtonDimension)];
        //btn.titleLabel.text=[NSString stringWithFormat:@"%d",i];
        btn.tag=i;
        [btn setTitle:model.comment forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[REMColor colorByHexString:@"#00ff48"] forState:UIControlStateSelected];
        btn.titleLabel.textColor=[UIColor whiteColor];
        
        [btn.titleLabel setFont:[UIFont fontWithName:@(kBuildingFontSCRegular) size:12]];
        NSString *str = [self retrieveCommodityImageName:model];
        btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        //btn.showsTouchWhenHighlighted=YES;
        btn.adjustsImageWhenHighlighted=YES;
        
        btn.titleEdgeInsets=UIEdgeInsetsMake(41, 0, 0, 0);
        btn.titleLabel.textAlignment=NSTextAlignmentCenter;
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal.png",str] ] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_pressed.png",str]] forState:UIControlStateSelected];
        if(i==self.currentCommodityIndex){
            [btn setSelected:YES];
        }
        
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
        
        
    }
    if(self.buildingInfo.airQuality!=nil){
        
        //REMManagedBuildingAirQualityModel *model = self.buildingInfo.airQuality;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(kBuildingCommodityButtonDimension+kBuildingCommodityBottomMargin), 0, kBuildingCommodityButtonDimension, kBuildingCommodityButtonDimension)];
        
        btn.tag=i;
        
//        REMManagedBuildingCommodityUsageModel *commodityUsage = [[REMManagedBuildingCommodityUsageModel alloc] init];
//        commodityUsage.id = model.commodityId;
//        
//        NSString *str = [self retrieveCommodityImageName:commodityUsage];
        NSString *str = @"PM2.5";
        //btn.showsTouchWhenHighlighted=YES;
        btn.adjustsImageWhenHighlighted=YES;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal.png",str]]forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_pressed.png",str]] forState:UIControlStateSelected];
        
        
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [array addObject:btn];
    }
    
    if (array.count==0) {
        UILabel *label =[[ UILabel alloc]initWithFrame:CGRectMake(0, 225, 600, 25)];
        label.text=REMIPadLocalizedString(@"BuildingChart_DataError");
        label.shadowColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        label.shadowOffset=CGSizeMake(1, 1);
        
        label.backgroundColor=[UIColor clearColor];
        label.font = [UIFont fontWithName:@(kBuildingFontSC) size:25];
        label.textColor=[[UIColor whiteColor] colorWithAlphaComponent:0.6];
        
        [self.view addSubview:label];
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, array.count*(kBuildingCommodityButtonDimension+kBuildingCommodityBottomMargin), kBuildingCommodityButtonDimension)];
    
    for (int i=0; i<array.count; ++i) {
        UIButton *btn = array[i];
        [view addSubview:btn];
    }
    self.buttonArray=array;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    
    [view addGestureRecognizer:tap];//eat tap event in button group to prevent scrollview from moving
    
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc]init];
    [view addGestureRecognizer:pan];//eat tap event in button group to prevent imageview from moving

    
    [self.view addSubview:view];

}

- (NSString *)retrieveCommodityImageName:(REMManagedBuildingCommodityUsageModel *)model
{
    NSNumber *commodityId= model.id;
    if ([commodityId isEqualToNumber:@(1)] == YES) {
        return @"Electricity";
    }
    else if([commodityId isEqualToNumber:@(2)] == YES)//自来水
    {
        return @"Water";
    }
    else if([commodityId isEqualToNumber:@(12)] == YES)//pm2.5
    {
        return @"PM2.5";
    }
    else if([commodityId isEqualToNumber:@(4)] == YES){ //软水
        return @"Water";
    }
    else if([commodityId isEqualToNumber:@(5)]==YES){//汽油
        return @"Oil";
    }
    else if([commodityId isEqualToNumber:@(6)]==YES){ //低压蒸汽
        return @"NaturalGas";
    }
    else if([commodityId isEqualToNumber:@(7)]==YES){ //柴油
        return @"Oil";
    }
    else if([commodityId isEqualToNumber:@(8)]==YES){ //热量
        return @"Heating";
    }
    else if([commodityId isEqualToNumber:@(9)]==YES){ //冷量
        return @"Cooling";
    }
    else if([commodityId isEqualToNumber:@(10)]==YES){ //煤
        return @"Coal";
    }
    else if([commodityId isEqualToNumber:@(11)]==YES){ //煤油
        return @"Oil";
    }
    else if([commodityId isEqualToNumber:@(3)] == YES)
    {
        return @"NaturalGas";
    }
    else{
        return @"Electricity";
    }
}

- (void)buttonPressed:(UIButton *)button
{
    if(button.selected == YES) return;
    int current = button.tag;
    for (int i=0;i<self.buttonArray.count;++i) {
        UIButton *btn = self.buttonArray[i];
        if([btn isEqual:button] == NO){
            [btn setSelected:NO];
        }
        else{
            [btn setSelected:YES];
        }
    }
    
    REMBuildingCommodityViewController *vc = self.childViewControllers[self.currentCommodityIndex];
    [vc.view setHidden:YES];
    self.currentCommodityIndex=current;
    [self initCurrentCommodityView];
    
}

- (void)initCurrentCommodityView{
    if(self.childViewControllers.count>self.currentCommodityIndex){
        REMBuildingCommodityViewController *controller=self.childViewControllers[self.currentCommodityIndex];
        REMBuildingImageViewController *imageController=(REMBuildingImageViewController *)self.parentViewController;
        if(controller.isViewLoaded==NO){
            imageController.shareButton.enabled=NO;
            [self.view addSubview:controller.view];
        }
        else{
            [controller.view setHidden:NO];
            
            NSNumber *status;
            if ([controller isKindOfClass:[REMBuildingAirQualityViewController class]]==YES ) {
                REMBuildingAirQualityViewController *controller1=(REMBuildingAirQualityViewController *)controller;
                status=self.commodityDataLoadStatus[controller1.airQualityInfo.commodityId];
            }
            else{
                status=self.commodityDataLoadStatus[controller.commodityInfo.id];
            }
            if ([status isEqualToNumber:@(1)]==YES) {
                imageController.shareButton.enabled=YES;
            }
            else{
                imageController.shareButton.enabled=NO;
            }
        }
        [self checkIfRequestChartData:(UIScrollView *)self.view];

    }
}


- (void)initCommodityController
{
    if(self.childViewControllers.count>0)return;
    int count= self.commodityArray==nil ? 0:self.commodityArray.count;
    
    CGRect frame=CGRectMake(0, kBuildingCommodityBottomMargin+ kBuildingCommodityButtonDimension, self.view.frame.size.width, self.view.frame.size.height+kBuildingCommodityViewTop);
    int i=0;

    for (; i<count; ++i) {
        REMManagedBuildingCommodityUsageModel *model = self.commodityArray[i];
        REMBuildingCommodityViewController *controller=[[REMBuildingCommodityViewController alloc]init];
        controller.commodityInfo=model;
        controller.buildingInfo=self.buildingInfo;
        controller.viewFrame=frame;
        controller.index=i;
        [self addChildViewController:controller];
        self.commodityDataLoadStatus[model.id]=@(0);
    }
    if(self.buildingInfo.airQuality!=nil){
        REMBuildingAirQualityViewController *controller=[[REMBuildingAirQualityViewController alloc]init];
        controller.viewFrame=frame;
        controller.index=i;
        controller.airQualityInfo=self.buildingInfo.airQuality;
        controller.buildingInfo=self.buildingInfo;
        [self addChildViewController:controller];
        self.commodityDataLoadStatus[self.buildingInfo.airQuality.commodityId]=@(0);
    }
    
    
    
    
}






- (void)initDragLabel
{
    UIScrollView *scroll=(UIScrollView *)self.view;
    CGRect frame = CGRectMake(0, scroll.contentSize.height-27- REMDMCOMPATIOS7(10), 500, 17);
    
    UILabel *label =[[UILabel alloc]initWithFrame:frame];
    //label.layer.borderColor=[UIColor redColor].CGColor;
    //label.layer.borderWidth=1;
    label.textAlignment=NSTextAlignmentLeft;
    label.font=[UIFont fontWithName:@(kBuildingFontSCRegular) size:frame.size.height];
    
    label.text=REMIPadLocalizedString(@"Building_PullUpMoreInfo");//  @"￼上拉查看更多能耗信息";
    //label.text=@"asd上拉查看更多能耗信息";
    //label.adjustsLetterSpacingToFitWidth=YES;
    //label.lineBreakMode=NSLineBreakByTruncatingTail;
    
    //label.autoresizingMask = UIViewAutoresizingNone;
    //[label sizeToFit];
    
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    [self.view addSubview:label];
    
    self.dashboardLabel=label;
    
    
    CGRect imgFrame=CGRectMake(178, scroll.contentSize.height-30-REMDMCOMPATIOS7(10), 15, 20);
    UIImageView *arrow=[[UIImageView alloc]initWithImage:REMIMG_Up];
    [arrow setFrame:imgFrame];
    [self.view addSubview:arrow];
    self.arrow=arrow;
}

- (void)showDashboardLabel:(BOOL)overThreshold{
    if(overThreshold==YES){
        self.dashboardLabel.text=REMIPadLocalizedString(@"Building_ReleaseSwitchView");//  @"松开以显示";
        
        [UIView animateWithDuration:0.2 animations:^(void){
            //self.arrow.layer.transform=CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            self.arrow.transform=CGAffineTransformMakeRotation(M_PI);
        }];
    }
    else{
        self.dashboardLabel.text=REMIPadLocalizedString(@"Building_PullUpMoreInfo");//@"￼上拉查看更多能耗信息";
        [UIView animateWithDuration:0.2 animations:^(void){
            //self.arrow.layer.transform=CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            self.arrow.transform=CGAffineTransformMakeRotation(M_PI*2);
        }];
    }
}


- (void)setCurrentOffsetY:(CGFloat)currentOffsetY{
    if(_currentOffsetY!=currentOffsetY){
         _currentOffsetY=currentOffsetY;
        if(self.isViewLoaded==YES){
            UIScrollView *view=(UIScrollView *)self.view;
            if(view.contentOffset.y != currentOffsetY){
                [view setContentOffset:CGPointMake(view.contentOffset.x, currentOffsetY)];
                [self checkIfRequestChartData:view];
            }
        }
        REMBuildingImageViewController *parent=(REMBuildingImageViewController *)self.parentViewController;
        [parent setBlurLevel:currentOffsetY];
        if(parent.currentOffset!=currentOffsetY){
            parent.currentOffset=currentOffsetY;
        }
    }
}

-(void)tapthis
{
    UIScrollView *scroll=(UIScrollView *)self.view;
    if(scroll.contentOffset.y>kCommodityScrollTop) return;
    
    if(scroll.contentOffset.y<kCommodityScrollTop)
    {
        [self scrollTo:kCommodityScrollTop]; //up
    }
    else
    {
        [self scrollTo:-kBuildingCommodityViewTop]; //down
    }
}

- (void)scrollTo:(CGFloat)y
{
    //NSLog(@"x:%f",self.dataView.frame.origin.x);
    UIScrollView *scroll=(UIScrollView *)self.view;
    [scroll setContentOffset:CGPointMake(-kBuildingLeftMargin, y) animated:YES];
    //self.currentOffsetY=y;
    
}




-(void)checkIfRequestChartData:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y>=kCommodityScrollTop){
        if(self.childViewControllers.count>self.currentCommodityIndex){
            REMBuildingCommodityViewController *controller=self.childViewControllers[self.currentCommodityIndex];
            [controller showChart];
        }
    }
}

- (void)roundPositionWhenDrag:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y<kCommodityScrollTop && scrollView.contentOffset.y>-kBuildingCommodityViewTop){
        if(ABS(scrollView.contentOffset.y) < (kBuildingCommodityViewTop+kCommodityScrollTop)/2){
            [self scrollTo:kCommodityScrollTop]; //up
        }
        else{
            [self scrollTo:-kBuildingCommodityViewTop]; //down
        }
    }
    else{
        [self scrollTo:scrollView.contentOffset.y];
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self checkIfRequestChartData:scrollView];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.currentOffsetY=scrollView.contentOffset.y;
    if(scrollView.contentOffset.y>kDashboardThreshold){
        [self showDashboardLabel:YES];
    }
    else{
        [self showDashboardLabel:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    [self roundPositionWhenDrag:scrollView];
    
    if(scrollView.contentOffset.y>kCommodityScrollTop){
        [self checkIfRequestChartData:scrollView];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate == NO){
        [self roundPositionWhenDrag:scrollView];
        [self checkIfRequestChartData:scrollView];
        
    }
    else{
        if(scrollView.contentOffset.y>kDashboardThreshold){
            REMBuildingImageViewController *parent=(REMBuildingImageViewController *)self.parentViewController;
            parent.currentCoverStatus=REMBuildingCoverStatusDashboard;
            
        }
    }
}

- (void)loadingDataComplete:(NSUInteger)index{
    REMBuildingImageViewController *parent=(REMBuildingImageViewController *)self.parentViewController;
    REMBuildingCommodityViewController *controller=self.childViewControllers[index];
    if([controller isKindOfClass:[REMBuildingAirQualityViewController class]]==YES){
        REMBuildingAirQualityViewController *controller1=(REMBuildingAirQualityViewController *)controller;
        self.commodityDataLoadStatus[controller1.airQualityInfo.commodityId]=@(1);
    }
    else{
        self.commodityDataLoadStatus[controller.commodityInfo.id]=@(1);
    }
    
    if(index == self.currentCommodityIndex){
        
        parent.shareButton.enabled=YES;
    }
}



- (NSDictionary *)realExport{
    REMBuildingCommodityViewController *controller=self.childViewControllers[self.currentCommodityIndex];
    UIView* chartView = controller.view;
    UIScrollView *scrollView=(UIScrollView *)self.view;
    CGFloat chartHeight = scrollView.contentSize.height;
    
    for (UIViewController *container in self.childViewControllers) {
        for (REMBuildingChartBaseViewController *chart in container.childViewControllers) {
            if ([chart respondsToSelector:@selector(prepareShare)])
                [chart prepareShare];
        }
    }
    
    NSMutableArray* btnOutputImages = [[NSMutableArray alloc]initWithCapacity:self.buttonArray.count];
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton* btn = [self.buttonArray objectAtIndex:i];
        [btnOutputImages setObject:[REMImageHelper imageWithView:btn] atIndexedSubscript:i];
    }
    NSMutableArray* chartViewImages = [[NSMutableArray alloc]initWithCapacity:[chartView subviews].count];
    for (int i = 0; i < [[chartView subviews]count]; i++) {
        UIView* chartSubView = [[chartView subviews]objectAtIndex:i];
        [chartViewImages setObject:[REMImageHelper imageWithLayer:chartSubView.layer] atIndexedSubscript:i];
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.frame.size.width, kBuildingCommodityButtonDimension + kBuildingCommodityBottomMargin + chartHeight),0,1);
    // Draw buttons
    
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton* btn = [self.buttonArray objectAtIndex:i];
        UIImage* btnImage = [btnOutputImages objectAtIndex:i];
        [btnImage drawInRect:CGRectMake(btn.frame.origin.x + kBuildingLeftMargin, 0, kBuildingCommodityButtonDimension, kBuildingCommodityButtonDimension)];
    }
    // Draw charts
    for (int i = 0; i < chartViewImages.count; i++) {
        UIImage* chartImage = [chartViewImages objectAtIndex:i];
        UIView* chartSubView = [[chartView subviews]objectAtIndex:i];
        [chartImage drawInRect:CGRectMake(chartSubView.frame.origin.x + kBuildingLeftMargin, kBuildingCommodityButtonDimension + kBuildingCommodityBottomMargin + chartSubView.frame.origin.y, chartSubView.frame.size.width, chartSubView.frame.size.height)];
    }
    //    [chartImage drawInRect:CGRectMake(kBuildingLeftMargin, kBuildingCommodityButtonDimension + kBuildingCommodityBottomMargin, chartView.frame.size.width, chartHeight)];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString* stringFormat = nil;
    if (self.currentCommodityIndex<self.buildingInfo.commodities.count) {
        stringFormat = REMIPadLocalizedString(@"Weibo_ContentOfElectirc");
        REMManagedBuildingCommodityUsageModel *model =controller.commodityUsage;
        NSString* commodityName = model.comment;
        NSString* uomName = model.totalUom;
        NSString* val = [model.totalValue isEqual:[NSNull null]] ? nil : model.totalValue.stringValue;
        if (val == nil || commodityName == nil || uomName == nil) {
            stringFormat = REMIPadLocalizedString(@"BuildingChart_NoData");
        } else {
            stringFormat = [stringFormat stringByReplacingOccurrencesOfString:@"#Commodity#" withString:commodityName];
            stringFormat = [stringFormat stringByReplacingOccurrencesOfString:@"#UomName#" withString:uomName];
            stringFormat = [stringFormat stringByReplacingOccurrencesOfString:@"#Usage#" withString:val];
        }
    } else {
        stringFormat = REMIPadLocalizedString(@"Weibo_ContentOfPM25");
        REMManagedBuildingAirQualityModel *model = self.buildingInfo.airQuality;
        NSString* commodityName = model.commodityName;
        NSString* outdoorVal = model.outdoorValue == nil ? nil : model.outdoorValue.stringValue;
        NSString* outdoorUom = model.outdoorUom;
        NSString* honeywellVal = model.honeywellValue == nil ? nil : model.honeywellValue.stringValue;
        NSString* honeywellUom = model.honeywellUom;
        NSString* mayairVal = model.mayairValue == nil ? nil : model.mayairValue.stringValue;
        NSString* mayairUom = model.mayairUom;
        if (commodityName == nil || outdoorUom == nil || outdoorVal == nil || honeywellUom == nil || honeywellVal == nil || mayairUom == nil || mayairVal == nil) {
            stringFormat = REMIPadLocalizedString(@"BuildingChart_NoData");
        } else {
            stringFormat = [stringFormat stringByReplacingOccurrencesOfString:@"#Commodity#" withString:commodityName];
            stringFormat = [stringFormat stringByReplacingOccurrencesOfString:@"#OutdoorVal#" withString:outdoorVal];
            stringFormat = [stringFormat stringByReplacingOccurrencesOfString:@"#OutdoorUomName#" withString:outdoorUom];
            stringFormat = [stringFormat stringByReplacingOccurrencesOfString:@"#HoneywellVal#" withString:honeywellVal];
            stringFormat = [stringFormat stringByReplacingOccurrencesOfString:@"#HoneywellUomName#" withString:honeywellUom];
            stringFormat = [stringFormat stringByReplacingOccurrencesOfString:@"#MayairVal#" withString:mayairVal];
            stringFormat = [stringFormat stringByReplacingOccurrencesOfString:@"#MayairUomName#" withString:mayairUom];
        }
    }
    //    NSArray* myPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //    NSString* myDocPath = myPaths[0];
    //    NSString* fileName = [myDocPath stringByAppendingFormat:@"/cachefiles/weibo2.png"];
    //    [UIImagePNGRepresentation(img) writeToFile:fileName atomically:NO];
    return @{
             @"image": img,
             @"text": stringFormat
             };
}


@end
