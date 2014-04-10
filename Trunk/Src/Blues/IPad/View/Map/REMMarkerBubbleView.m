/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMMarkerBubbleView.m
 * Created      : 张 锋 on 10/28/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMMarkerBubbleView.h"
#import <GoogleMaps/GoogleMaps.h>
#import "REMImages.h"
#import "REMDimensions.h"
#import "REMEnergyUsageDataModel.h"
#import "REMCommonHeaders.h"
#import "REMManagedBuildingModel.h"
#import "REMManagedBuildingCommodityUsageModel.h"

@interface REMMarkerBubbleView ()

@property (nonatomic,weak) REMManagedBuildingModel *buildingInfo;

@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UILabel *subTitleLabel;

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
        UILabel *subTitleLabel = [self getSubTitleLabel];
        [self addSubview:subTitleLabel];
        self.subTitleLabel = subTitleLabel;
        
        UILabel *mainTitleLabel = [self getMainTitleLabel];
        [self addSubview:mainTitleLabel];
        self.titleLabel = mainTitleLabel;
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
    
    CGFloat top = self.subTitleLabel == nil ? kDMMap_BubbleContentTopOffsetWithoutSubTitle : kDMMap_BubbleContentTopOffsetWithSubTitle;
    
    UILabel *label =  [[UILabel alloc] initWithFrame:CGRectMake(kDMMap_BubbleContentLeftOffset,top,size.width,size.height)];
    label.text = self.buildingInfo.name;
    label.textColor = [UIColor blackColor];
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

-(UILabel *)getSubTitleLabel
{
    NSString *subTitleText = [self getSubTitleText:self.buildingInfo];
    
    if(subTitleText == nil)
        return nil;
    
    UIFont *font = [UIFont systemFontOfSize:kDMMap_BubbleContentSubTitleFontSize];
    CGSize size = [subTitleText sizeWithFont:font];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kDMMap_BubbleContentLeftOffset,kDMMap_BubbleContentSubTitleTopOffset , size.width, size.height)];
    label.text = subTitleText;
    label.font = font;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

-(CGRect)getBubbleFrame:(GMSMarker *)marker
{
    REMManagedBuildingModel *buildingInfo = marker.userData;
    
    NSString *mainTitleText = [self getMainTitleText:buildingInfo], *subTitleText = [self getSubTitleText:buildingInfo];
    
    CGSize mainTitleSize = [mainTitleText sizeWithFont:[UIFont systemFontOfSize:kDMMap_BubbleContentMainTitleFontSize]];
    CGSize subTitleSize = subTitleText == nil ? CGSizeZero : [subTitleText sizeWithFont:[UIFont systemFontOfSize:kDMMap_BubbleContentSubTitleFontSize]];
    
    CGFloat contentWidth = mainTitleSize.width > subTitleSize.width ? mainTitleSize.width : subTitleSize.width;
    
    CGPoint markerPoint = [marker.map.projection pointForCoordinate:marker.position];
    
    return CGRectMake(markerPoint.x, markerPoint.y, contentWidth + 2*kDMMap_BubbleContentLeftOffset, kDMMap_BubbleHeight);
}

-(NSString *)getMainTitleText:(REMManagedBuildingModel *)buildingInfo
{
    return buildingInfo.name;
}

-(NSString *)getSubTitleText:(REMManagedBuildingModel *)buildingInfo
{
    NSNumber *dataValue = buildingInfo.electricityUsageThisMonth.totalValue;//    .electricityUsageThisMonth .commodityUsage.dataValue;
    NSString *uom = buildingInfo.electricityUsageThisMonth.totalUom;//  .commodityUsage.uom.code;
    
    NSString *formattedDataValue = [REMNumberHelper formatDataValueWithCarry:dataValue];
    
    return REMIsNilOrNull(dataValue) ? nil : [NSString stringWithFormat:REMIPadLocalizedString(@"Map_MarkerBubbleSubtitleFormat"),  formattedDataValue, uom];
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
