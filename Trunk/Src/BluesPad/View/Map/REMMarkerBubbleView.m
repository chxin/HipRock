/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMMarkerBubbleView.m
 * Created      : 张 锋 on 10/28/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMMarkerBubbleView.h"
#import "REMBuildingModel.h"
#import <GoogleMaps/GoogleMaps.h>
#import "REMBuildingOverallModel.h"
#import "REMImages.h"
#import "REMDimensions.h"
#import "REMCommodityUsageModel.h"
#import "REMEnergyUsageDataModel.h"

@interface REMMarkerBubbleView ()

@property (nonatomic,weak) REMBuildingOverallModel *buildingInfo;

@end

@implementation REMMarkerBubbleView

- (id)initWithMarker:(GMSMarker *)marker
{
    CGRect frame = [self getBubbleFrame:marker];
    
    self = [super initWithFrame:frame];
    if (self) {
        self.marker = marker;
        self.buildingInfo = marker.userData;
        
        
        //render rectangle
        UIImage *bubbleBodyImage = [REMIMG_MapPopover_Rectangle resizableImageWithCapInsets:UIEdgeInsetsMake(0, 9, 0, 9) resizingMode:UIImageResizingModeTile];
        UIImageView *bubbleBody = [[UIImageView alloc] initWithImage:bubbleBodyImage];
        bubbleBody.frame = CGRectMake(0, 0, frame.size.width, kDMMap_BubbleBodyHeight);
        
        [self addSubview:bubbleBody];
        
        //render arrow
        UIImageView *bubbleArrow = [[UIImageView alloc] initWithImage:REMIMG_MapPopover_Arrow];
        bubbleArrow.frame = CGRectMake((frame.size.width - kDMMap_BubbleArrowWidth)/2, kDMMap_BubbleBodyHeight, kDMMap_BubbleArrowWidth, kDMMap_BubbleArrowHeight);
        
        [self addSubview:bubbleArrow];
        
        //render label
        [self addSubview:[self getMainTitleLabel]];
        [self addSubview:[self getSubTitleLabel]];
    }
    
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
}


-(UILabel *)getMainTitleLabel
{
    NSString *mainTitleText = [self getMainTitleText:self.buildingInfo];
    
    UIFont *font = [UIFont systemFontOfSize:kDMMap_BubbleContentMainTitleFontSize];
    CGSize size = [mainTitleText sizeWithFont:font];
    
    UILabel *label =  [[UILabel alloc] initWithFrame:CGRectMake(kDMMap_BubbleContentLeftOffset,kDMMap_BubbleContentTopOffset,size.width,size.height)];
    label.text = self.buildingInfo.building.name;
    label.textColor = [UIColor blackColor];
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

-(UILabel *)getSubTitleLabel
{
    NSString *subTitleText = [self getSubTitleText:self.buildingInfo];
    UIFont *font = [UIFont systemFontOfSize:kDMMap_BubbleContentSubTitleFontSize];
    CGSize size = [subTitleText sizeWithFont:font];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kDMMap_BubbleContentLeftOffset,kDMMap_BubbleContentSubTitleTopOffset, size.width, size.height)];
    label.text = @"Hello kitty";
    label.font = font;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

-(CGRect)getBubbleFrame:(GMSMarker *)marker
{
    REMBuildingOverallModel *buildingInfo = marker.userData;
    
    NSString *mainTitleText = [self getMainTitleText:buildingInfo], *subTitleText = [self getSubTitleText:buildingInfo];
    
    CGSize mainTitleSize = [mainTitleText sizeWithFont:[UIFont systemFontOfSize:kDMMap_BubbleContentMainTitleFontSize]];
    CGSize subTitleSize = subTitleText == nil ? CGSizeZero : [subTitleText sizeWithFont:[UIFont systemFontOfSize:kDMMap_BubbleContentSubTitleFontSize]];
    
    CGFloat contentWidth = mainTitleSize.width > subTitleSize.width ? mainTitleSize.width : subTitleSize.width;
    
    CGPoint markerPoint = [marker.map.projection pointForCoordinate:marker.position];
    
    return CGRectMake(markerPoint.x, markerPoint.y, contentWidth + 2*kDMMap_BubbleContentLeftOffset, kDMMap_BubbleHeight);
}

-(NSString *)getMainTitleText:(REMBuildingOverallModel *)buildingInfo
{
    return buildingInfo.building.name;
}

-(NSString *)getSubTitleText:(REMBuildingOverallModel *)buildingInfo
{
    REMCommodityUsageModel *usage = nil;
    REMCommodityModel *commodity = nil;
    
    for(int i=0; i<buildingInfo.commodityArray.count; i++){
        commodity = buildingInfo.commodityArray[i];
        usage = buildingInfo.commodityUsage[i];
        
        if([commodity.commodityId intValue] == REMCommodityElectricity){
            break;
        }
    }
    
    if(usage == nil || commodity == nil || usage.commodityUsage == nil)
        return nil;
    
    return [NSString stringWithFormat:@"本月用电量：%f%@", [usage.commodityUsage.dataValue floatValue], usage.commodityUsage.uom.code];
}






//// Initialization code
//self.backgroundColor = [UIColor clearColor];
//
//UIButton *background = [UIButton buttonWithType:UIButtonTypeCustom];
//background.frame = self.bounds;
////NSLog(@"h:%f",self.bounds.size.height);
////        [background setUserInteractionEnabled:NO];
////[background setBackgroundImage:[REMIMG_MarkerBubble resizableImageWithCapInsets:UIEdgeInsetsMake(36.0f, 10.0f, 19.0f, 10.0f)] forState:UIControlStateNormal];
////[background setBackgroundImage:[REMIMG_MarkerBubble_Pressed resizableImageWithCapInsets:UIEdgeInsetsMake(36.0f, 10.0f, 19.0f, 10.0f)] forState:UIControlStateHighlighted];
////        background.layer.shadowColor = [UIColor blackColor].CGColor;
////        background.layer.shadowOpacity = 0.5;
////        background.layer.shadowOffset = CGSizeMake(-5.0, -5.0);
////        background.layer.shadowRadius = 3;
//[background addTarget:self action:@selector(bubbleTapped) forControlEvents:UIControlEventTouchUpInside];
//[self addSubview:background];
//
//
//CGSize contentSize = [self getContentSize:marker];
//CGRect contentFrame = CGRectMake(0, 0, contentSize.width, contentSize.height);
//
//UILabel *label = [[UILabel alloc] initWithFrame:contentFrame];
//label.text = [marker.userData building].name;
//label.textAlignment = NSTextAlignmentCenter;
//label.backgroundColor = [UIColor clearColor];
//label.textColor = [UIColor colorWithRed:55.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1];
//
//[self addSubview:label];

@end
