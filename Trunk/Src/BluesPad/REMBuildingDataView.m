//
//  REMBuildingDataView.m
//  TestImage
//
//  Created by tantan on 7/31/13.
//  Copyright (c) 2013 demo. All rights reserved.
//

#import "REMBuildingDataView.h"

@interface REMBuildingDataView()

@property (nonatomic,strong) NSArray *buttonArray;
@property (nonatomic,weak)  REMBuildingOverallModel *buildingInfo;

@property (nonatomic,strong) NSArray *commodityViewArray;
@property (nonatomic) NSUInteger currentIndex;

@property (nonatomic,strong) NSMutableDictionary *successDic;

@end
@implementation REMBuildingDataView

- (id)initWithFrame:(CGRect)frame withBuildingInfo:(REMBuildingOverallModel *)buildingInfo
{
    //NSLog(@"dataview:%@",NSStringFromCGRect(frame));
    self = [super initWithFrame:frame];
    if (self) {
        self.contentInset = UIEdgeInsetsMake(kBuildingCommodityViewTop, kBuildingLeftMargin, 0, 0);
        [self setScrollEnabled:YES];
        //self.clipsToBounds=NO;
        
        [self setContentSize:CGSizeMake(0, 1000)];
        self.buildingInfo=buildingInfo;
        self.currentIndex=0;
        self.successDic = [[NSMutableDictionary alloc]initWithCapacity:(self.buildingInfo.commodityUsage.count+1)];
        [self initCommodityButton];
        [self initCommodityView];
    }
    
    return self;
}


- (void)initCommodityButton
{
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:self.buildingInfo.commodityUsage.count];
    int i=0;
    for (;i<self.buildingInfo.commodityUsage.count;++i) {
        REMCommodityUsageModel *model = self.buildingInfo.commodityUsage[i];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*kBuildingCommodityButtonDimension, 0, kBuildingCommodityButtonDimension, kBuildingCommodityButtonDimension)];
        btn.titleLabel.text=[NSString stringWithFormat:@"%d",i];
        
        NSString *str = [self retrieveCommodityImageName:model.commodity];
        btn.imageView.contentMode=UIViewContentModeScaleToFill;
        btn.showsTouchWhenHighlighted=YES;
        btn.adjustsImageWhenHighlighted=YES;
        
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal.png",str]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_pressed.png",str]] forState:UIControlStateSelected];
        if(i==0){
            [btn setSelected:YES];
        }
        [self addSubview:btn];
        
        [btn addTarget:self action:@selector(commodityChanged:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
       
    }
    if(self.buildingInfo.airQuality!=nil){
        
        REMAirQualityModel *model = self.buildingInfo.airQuality;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*kBuildingCommodityButtonDimension, 0, kBuildingCommodityButtonDimension, kBuildingCommodityButtonDimension)];
        btn.titleLabel.text=[NSString stringWithFormat:@"%d",i];
        btn.layer.masksToBounds=NO;
        NSString *str = [self retrieveCommodityImageName:model.commodity];
        btn.imageView.contentMode=UIViewContentModeScaleToFill;
        btn.showsTouchWhenHighlighted=YES;
        btn.adjustsImageWhenHighlighted=YES;
        
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal.png",str]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_pressed.png",str]] forState:UIControlStateSelected];
        if(i==0){
            [btn setSelected:YES];
        }
        [self addSubview:btn];
        
        [btn addTarget:self action:@selector(commodityChanged:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
    }
    
    self.buttonArray=array;
}

- (NSString *)retrieveCommodityImageName:(REMCommodityModel *)model
{
    if ([model.commodityId isEqualToNumber:@(1)] == YES) {
        return @"Electricity";
    }
    else if([model.commodityId isEqualToNumber:@(2)] == YES)
    {
        return @"Water";
    }
    else if([model.commodityId isEqualToNumber:@(12)] == YES)
    {
        return @"PM2.5";
    }
    else if([model.commodityId isEqualToNumber:@(3)] == YES)
    {
        return @"Natural Gas";
    }
    else if([model.commodityId isEqualToNumber:@(5)] == YES)
    {
        return @"oil";
    }
    else{
        return @"elec";
    }
}

- (void)commodityChanged:(UIButton *)button
{
    if(button.selected == YES) return;
    int current =0;
    for (UIButton *btn in self.buttonArray) {
        if(btn.selected==YES){
            current=[btn.titleLabel.text intValue];
        }
        
        if([btn isEqual:button] == NO){
            [btn setSelected:NO];
        }
        else{
            [btn setSelected:YES];
        }
    }
    int to = [button.titleLabel.text intValue];
    REMBuildingCommodityView *view=    self.commodityViewArray[to];
    view.alpha=1;
    REMBuildingCommodityView *currentView= self.commodityViewArray[current];
    currentView.alpha=0;
    /*
    [UIView transitionFromView:self.commodityViewArray[current] toView:self.commodityViewArray[to] duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        REMBuildingCommodityView *view1=    self.commodityViewArray[current];
        view1.alpha=0;
        
    }];*/
}

- (void)initCommodityView
{
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:self.buildingInfo.commodityUsage.count];
    int i=0,height=800;
    for (;i<self.buildingInfo.commodityUsage.count;++i ) {
        REMCommodityUsageModel *model = self.buildingInfo.commodityUsage[i];
        REMBuildingCommodityView *view = [[REMBuildingCommodityView alloc]initWithFrame:CGRectMake(0, kBuildingCommodityBottomMargin+ kBuildingCommodityButtonDimension, self.frame.size.width, height) withCommodityInfo:model];
        
        if(i!=0){
            view.alpha=0;
        }
        [self addSubview:view];
        [array addObject:view];
    }
    if(self.buildingInfo.airQuality!=nil){
        
        REMBuildingAirQualityView *view = [[REMBuildingAirQualityView alloc]initWithFrame:CGRectMake(0, kBuildingCommodityBottomMargin+ kBuildingCommodityButtonDimension, self.frame.size.width, height) withAirQualityInfo:self.buildingInfo.airQuality];
        
        view.alpha=0;
        
        [self addSubview:view];
        [array addObject:view];
    }
    
    self.commodityViewArray=array;
}


- (void)requireChartDataWithBuildingId:(NSNumber *)buildingId complete:(void (^)(BOOL))callback
{
    int count = self.commodityViewArray.count;
    if(self.buildingInfo.airQuality!=nil) count--;
    for (int i=0; i<count; i++) {
        REMBuildingCommodityView *view = self.commodityViewArray[i];
        REMCommodityUsageModel *model = self.buildingInfo.commodityUsage[i];
        NSNumber *status=[self.successDic objectForKey:model.commodity.commodityId];
        if([status isEqualToNumber:@(1)] == YES) continue;
        [view requireChartDataWithBuildingId:buildingId withCommodityId:model.commodity.commodityId complete:^(BOOL success){
            [self.successDic setObject:@(1) forKey:model.commodity.commodityId];
            if (callback != nil) {
                callback(success);
            }
        }];
    }
    if(self.buildingInfo.airQuality!=nil){
        REMBuildingAirQualityView *view = self.commodityViewArray[self.commodityViewArray.count-1];
        REMAirQualityModel *model = self.buildingInfo.airQuality;
        NSNumber *status=[self.successDic objectForKey:model.commodity.commodityId];
        if([status isEqualToNumber:@(1)] == YES) return;
        [view requireChartDataWithBuildingId:buildingId withCommodityId:model.commodity.commodityId complete:^(BOOL success){
            [self.successDic setObject:@(1) forKey:model.commodity.commodityId];
            if (callback != nil) {
                callback(success);
            }
        }];
    }
}


-(void)cancelAllRequest{
    for (REMCommodityUsageModel *m in self.buildingInfo.commodityUsage) {
        NSString *key = [NSString stringWithFormat:@"b-%@-%@",self.buildingInfo.building.buildingId,m.commodity.commodityId];
        [REMDataAccessor cancelAccess:key];

    }
}

- (void)exportDataView:(void (^)(NSDictionary *))callback
{
    NSNumber *ret = [self.successDic objectForKey:@(self.currentIndex)];
    if([ret isEqualToNumber:@(1)] ==YES){
        callback([self realExport]);
    }
    else{
        [self requireChartDataWithBuildingId:self.buildingInfo.building.buildingId complete:^(BOOL success){
            callback([self realExport]);
        }];
    }
}

-(UIImage*)getImageOfLayer:(CALayer*) layer{
    UIGraphicsBeginImageContext(layer.frame.size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSDictionary *)realExport{
    CGFloat outWidth = self.frame.size.width;
    UIView* chartView = (UIView*)[self.commodityViewArray objectAtIndex:self.currentIndex];
    CGFloat chartHeight = chartView.frame.size.height;
    
    NSMutableArray* btnOutputImages = [[NSMutableArray alloc]initWithCapacity:self.buttonArray.count];
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton* btn = [self.buttonArray objectAtIndex:i];
        [btnOutputImages setObject:[self getImageOfLayer:btn.layer] atIndexedSubscript:i];
    }
    UIImage* chartImage = [self getImageOfLayer:chartView.layer];
    UIGraphicsBeginImageContext(CGSizeMake(outWidth, kBuildingCommodityButtonDimension + chartHeight));
    // Draw buttons
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton* btn = [self.buttonArray objectAtIndex:i];
        UIImage* btnImage = [btnOutputImages objectAtIndex:i];
        [btnImage drawInRect:btn.frame];
    }
    // Draw charts
    [chartImage drawInRect:CGRectMake(0, kBuildingCommodityButtonDimension, outWidth, chartHeight)];
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSDictionary* dic = @{@"image": img, @"height": [NSNumber numberWithFloat:kBuildingCommodityButtonDimension + chartHeight] };
    
    return dic;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer.view isKindOfClass:[REMBuildingDataView class]]==YES){
        if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]==YES){
            UIPanGestureRecognizer *p = (UIPanGestureRecognizer *)gestureRecognizer;
            CGPoint movement=[p translationInView:self];
          
            if(movement.x!=0){
                return NO;
            }
            
        }
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
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
