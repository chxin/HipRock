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
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.marker = marker;
        self.buildingInfo = marker.userData;
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor greenColor].CGColor;
        
        
        
        
        //titles
        UILabel *mainTitleLabel = [self getMainTitleLabel], *subTitleLabel = [self getSubTitleLabel];
        CGSize mainTitleLabelSize = mainTitleLabel.frame.size, subTitleLabelSize = subTitleLabel.frame.size;
        
        
        //calc self frame
        CGPoint markerPoint = [marker.map.projection pointForCoordinate:marker.position];
        CGFloat contentWidth = (mainTitleLabelSize.width > subTitleLabelSize.width? mainTitleLabelSize.width : subTitleLabelSize.width) + 2*kDMMap_BubbleContentLeftOffset;
        CGRect frame = CGRectMake(markerPoint.x, markerPoint.y, contentWidth, kDMMap_BubbleHeight);
        self.frame = frame;
        
        //render rectangle
        UIImage *bubbleBodyImage = [REMIMG_MapPopover_Rectangle resizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
        UIImageView *bubbleBody = [[UIImageView alloc] initWithImage:bubbleBodyImage];
        bubbleBody.layer.borderColor = [UIColor redColor].CGColor;
        bubbleBody.layer.borderWidth = 1.0f;
        bubbleBody.frame = CGRectMake(markerPoint.x, markerPoint.y, contentWidth, kDMMap_BubbleBodyHeight);
        
        [self addSubview:bubbleBody];
        
        //render arrow
        UIImageView *bubbleArrow = [[UIImageView alloc] initWithImage:REMIMG_MapPopover_Arrow];
        bubbleArrow.frame = CGRectMake((contentWidth - kDMMap_BubbleArrowWidth)/2, kDMMap_BubbleBodyHeight, kDMMap_BubbleArrowWidth, kDMMap_BubbleArrowHeight);
        
        [self addSubview:bubbleArrow];
        
        //render label
        [self addSubview:mainTitleLabel];
        [self addSubview:subTitleLabel];
    }
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
    NSString *text = self.buildingInfo.building.name;
    UIFont *font = [UIFont systemFontOfSize:kDMMap_BubbleContentMainTitleFontSize];
    CGSize size = [text sizeWithFont:font];
    
    UILabel *label =  [[UILabel alloc] initWithFrame:CGRectMake(kDMMap_BubbleContentLeftOffset,kDMMap_BubbleContentTopOffset,size.width,size.height)];
    label.text = self.buildingInfo.building.name;
    label.textColor = [UIColor blackColor];
    label.font = font;
    
    return label;
}


-(UILabel *)getSubTitleLabel
{
    REMCommodityUsageModel *usage = nil;
    REMCommodityModel *commodity = nil;
    
    for(int i=0; i<self.buildingInfo.commodityArray.count; i++){
        commodity = self.buildingInfo.commodityArray[i];
        usage = self.buildingInfo.commodityUsage[i];
        
        if([commodity.commodityId intValue] == REMCommodityElectricity){
            break;
        }
    }
    
    if(usage == nil || commodity == nil || usage.commodityUsage == nil)
        return nil;
    
    NSString *text = [NSString stringWithFormat:@"本月用电量：%f%@", [usage.commodityUsage.dataValue floatValue], usage.commodityUsage.uom.code];
    UIFont *font = [UIFont systemFontOfSize:kDMMap_BubbleContentSubTitleFontSize];
    CGSize size = [text sizeWithFont:font];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kDMMap_BubbleContentLeftOffset,kDMMap_BubbleContentSubTitleTopOffset, size.width, size.height)];
    label.text = text;
    label.font = font;
    label.textColor = [UIColor blackColor];
    
    return label;
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
