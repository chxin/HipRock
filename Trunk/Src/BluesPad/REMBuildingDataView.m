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

@property (nonatomic)BOOL freeze;

@end
@implementation REMBuildingDataView

- (id)initWithFrame:(CGRect)frame withBuildingInfo:(REMBuildingOverallModel *)buildingInfo
{
    //NSLog(@"dataview:%@",NSStringFromCGRect(frame));
    self = [super initWithFrame:frame];
    if (self) {
        self.contentInset = UIEdgeInsetsMake(kBuildingCommodityViewTop, 0, 0, 0);
        [self setScrollEnabled:YES];
        //[self setDelaysContentTouches:NO];
        [self setContentSize:CGSizeMake(frame.size.width, 1000)];
        self.buildingInfo=buildingInfo;
        self.currentIndex=0;
        self.freeze=NO;
        [self initCommodityButton];
        [self initCommodityView];
    }
    
    return self;
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    if(!self.freeze) [super setContentOffset:contentOffset];
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
        
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",str]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-pressed.png",str]] forState:UIControlStateSelected];
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
        return @"elec";
    }
    else if([model.commodityId isEqualToNumber:@(2)] == YES)
    {
        return @"water";
    }
    else if([model.commodityId isEqualToNumber:@(4)] == YES)
    {
        return @"water";
    }
    else if([model.commodityId isEqualToNumber:@(3)] == YES)
    {
        return @"oil";
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
    [UIView transitionFromView:self.commodityViewArray[current] toView:self.commodityViewArray[to] duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        REMBuildingCommodityView *view1=    self.commodityViewArray[current];
        view1.alpha=0;
        
    }];
}

- (void)initCommodityView
{
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:self.buildingInfo.commodityUsage.count];
    int i=0;
    for (;i<self.buildingInfo.commodityUsage.count;++i ) {
        REMCommodityUsageModel *model = self.buildingInfo.commodityUsage[i];
        REMBuildingCommodityView *view = [[REMBuildingCommodityView alloc]initWithFrame:CGRectMake(0, kBuildingCommodityItemGroupMargin+ kBuildingCommodityButtonDimension, self.frame.size.width, 800) withCommodityInfo:model];
        
        if(i!=0){
            view.alpha=0;
        }
        [self addSubview:view];
        [array addObject:view];
    }
    
    self.commodityViewArray=array;
}


- (void)requireChartDataWithBuildingId:(NSNumber *)buildingId
{
    for (int i=0; i<self.commodityViewArray.count; i++) {
        REMBuildingCommodityView *view = self.commodityViewArray[i];
        REMCommodityUsageModel *model = self.buildingInfo.commodityUsage[i];
        [view requireChartDataWithBuildingId:buildingId withCommodityId:model.commodity.commodityId];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.allObjects[0];
    if ([touch.view isKindOfClass:[CPTGraphHostingView class]] == YES) {
        self.freeze=YES;
    }
    else{
        self.freeze=NO;
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = touches.allObjects[0];
    if ([touch.view isKindOfClass:[CPTGraphHostingView class]] == YES) {
        
    }
    else{
        [super touchesBegan:touches withEvent:event];
    }
}
/*
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    NSLog(@"touchesShouldCancelInContentView");
    if([view isKindOfClass:[CPTGraphHostingView class]] == YES){
        self.freeze=YES;
        return NO;
    }
    self.freeze=NO;
    return YES;
}
*/
/*
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
{
    //NSLog(@"touchesShouldBegin");
    if([view isKindOfClass:[CPTGraphHostingView class]] == YES){
        if(self.tracking) return YES;
        //CGPoint p=[self.panGestureRecognizer locationInView:view];
        //CGPoint p1=[self.panGestureRecognizer velocityInView:view];
        //NSLog(@"pan p:%@,p1:%@",NSStringFromCGPoint(p),NSStringFromCGPoint(p1));
        UITouch *touch = touches.allObjects[0];
        CGPoint point= [touch locationInView:view];
        CGPoint oldPoint = [touch previousLocationInView:view];
        CGFloat diff=point.x-oldPoint.x;
        if(diff!=0){
            //self.freeze=YES;
            return YES;
        }
        else{
            //self.freeze=NO;
            return  NO;
        }
    }
    else{
        self.freeze=NO;
        return NO;
    }
}
*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
