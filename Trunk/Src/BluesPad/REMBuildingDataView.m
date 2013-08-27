//
//  REMBuildingDataView.m
//  TestImage
//
//  Created by tantan on 7/31/13.
//  Copyright (c) 2013 demo. All rights reserved.
//

#import "REMBuildingDataView.h"

@interface REMBuildingDataView()

typedef void(^SuccessCallback)(BOOL success);

@property (nonatomic,strong) NSArray *buttonArray;
@property (nonatomic,weak)  REMBuildingOverallModel *buildingInfo;

@property (nonatomic,strong) NSArray *commodityViewArray;
@property (nonatomic) NSUInteger currentIndex;

@property (nonatomic,strong) NSMutableDictionary *successDic;

@property (nonatomic,strong) SuccessCallback successBlock;
@property (nonatomic) NSUInteger successCounter;
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
        self.successCounter=0;
        [self setContentSize:CGSizeMake(0, 1100)];
        self.buildingInfo=buildingInfo;
        self.currentIndex=0;
        self.successDic = [[NSMutableDictionary alloc]initWithCapacity:(self.buildingInfo.commodityUsage.count+1)];
        [self initCommodityButton];
        [self initCommodityView];
    }
    
    return self;
}

- (NSArray *)retrieveButtons{
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:self.buildingInfo.commodityUsage.count];
    int i=0;
    for (;i<self.buildingInfo.commodityUsage.count;++i) {
        REMCommodityUsageModel *model = self.buildingInfo.commodityUsage[i];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(kBuildingCommodityButtonDimension+kBuildingCommodityBottomMargin), 0, kBuildingCommodityButtonDimension, kBuildingCommodityButtonDimension)];
        btn.titleLabel.text=[NSString stringWithFormat:@"%d",i];
        
        [btn setTitle:model.commodity.comment forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
        btn.titleLabel.textColor=[UIColor whiteColor];
        btn.titleLabel.font=[UIFont fontWithName:@(kBuildingFontSC) size:11];
        NSString *str = [self retrieveCommodityImageName:model.commodity];
        btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        btn.showsTouchWhenHighlighted=YES;
        btn.adjustsImageWhenHighlighted=YES;
       
        btn.titleEdgeInsets=UIEdgeInsetsMake(41, 0, 0, 0);
        btn.titleLabel.textAlignment=NSTextAlignmentCenter;
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",str] ] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_pressed",str]] forState:UIControlStateSelected];
        if(i==0){
            [btn setSelected:YES];
        }
        
        
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
        
    }
    if(self.buildingInfo.airQuality!=nil){
        
        REMAirQualityModel *model = self.buildingInfo.airQuality;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*(kBuildingCommodityButtonDimension+kBuildingCommodityBottomMargin), 0, kBuildingCommodityButtonDimension, kBuildingCommodityButtonDimension)];
        btn.titleLabel.text=[NSString stringWithFormat:@"%d",i];
        btn.layer.masksToBounds=NO;
        NSString *str = [self retrieveCommodityImageName:model.commodity];
        btn.imageView.contentMode=UIViewContentModeScaleToFill;
        btn.showsTouchWhenHighlighted=YES;
        btn.adjustsImageWhenHighlighted=YES;
        
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",str]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_pressed",str]] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:btn];
    }
    
    return array;
}



- (void)initCommodityButton
{
    self.buttonArray=[self retrieveButtons];
    for (int i=0; i<self.buttonArray.count; ++i) {
        UIButton *btn = self.buttonArray[i];
        [self addSubview:btn];
    }
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

- (void)buttonPressed:(UIButton *)button
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
        //view.delegate=self;
        if(i!=0){
            view.alpha=0;
        }
        [self addSubview:view];
        [array addObject:view];
    }
    if(self.buildingInfo.airQuality!=nil){
        
        REMBuildingAirQualityView *view = [[REMBuildingAirQualityView alloc]initWithFrame:CGRectMake(0, kBuildingCommodityBottomMargin+ kBuildingCommodityButtonDimension, self.frame.size.width, height) withAirQualityInfo:self.buildingInfo.airQuality];
        //view.delegate=self;
        view.alpha=0;
        
        [self addSubview:view];
        [array addObject:view];
    }
    
    self.commodityViewArray=array;
}

- (void)sucessRequest{
    self.successCounter+=1;
    int total=self.buildingInfo.commodityUsage.count;
    if(self.buildingInfo.airQuality!=nil) total++;
    if(self.successCounter == total){
        if(self.successBlock!=nil){
            self.successBlock(YES);
            self.successCounter=0;
            self.successBlock=nil;
        }
    }
}

- (void)requireChartDataWithBuildingId:(NSNumber *)buildingId complete:(void (^)(BOOL))callback
{
    int count = self.commodityViewArray.count;
    if(self.buildingInfo.airQuality!=nil) count--;
    self.successBlock=callback;
    self.successCounter=0;
    for (int i=0; i<count; i++) {
        REMBuildingCommodityView *view = self.commodityViewArray[i];
        REMCommodityUsageModel *model = self.buildingInfo.commodityUsage[i];
        NSNumber *status=[self.successDic objectForKey:model.commodity.commodityId];
        if([status isEqualToNumber:@(1)] == YES) {
            [self sucessRequest];
            continue;
        }
        [view requireChartDataWithBuildingId:buildingId withCommodityId:model.commodity.commodityId complete:^(BOOL success){
            [self.successDic setObject:@(1) forKey:model.commodity.commodityId];
            [self sucessRequest];
        }];
    }
    if(self.buildingInfo.airQuality!=nil){
        REMBuildingAirQualityView *view = self.commodityViewArray[self.commodityViewArray.count-1];
        REMAirQualityModel *model = self.buildingInfo.airQuality;
        NSNumber *status=[self.successDic objectForKey:model.commodity.commodityId];
        if([status isEqualToNumber:@(1)] == YES) {
            [self sucessRequest];
            return ;
        }
        [view requireChartDataWithBuildingId:buildingId withCommodityId:model.commodity.commodityId complete:^(BOOL success){
            [self.successDic setObject:@(1) forKey:model.commodity.commodityId];
            [self sucessRequest];
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
            /*
            if(movement.y<0){
                [self setBounces:NO];
            }
            else{
                [self setBounces:YES];
            }*/
          
            if(movement.x!=0){
                return NO;
            }
            //if(self.contentOffset.y>=-20 && movement.y<=0)return NO;
            
            
            
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
