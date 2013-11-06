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

@interface REMMarkerBubbleView ()


@end

@implementation REMMarkerBubbleView

- (id)initWithMarker:(GMSMarker *)marker
{
    self = [super initWithFrame:[self getBubbleFrame:marker]];
    if (self) {
        self.marker = marker;
        
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *background = [UIButton buttonWithType:UIButtonTypeCustom];
        background.frame = self.bounds;
        //NSLog(@"h:%f",self.bounds.size.height);
//        [background setUserInteractionEnabled:NO];
        [background setBackgroundImage:[REMIMG_MarkerBubble resizableImageWithCapInsets:UIEdgeInsetsMake(36.0f, 10.0f, 19.0f, 10.0f)] forState:UIControlStateNormal];
        [background setBackgroundImage:[REMIMG_MarkerBubble_Pressed resizableImageWithCapInsets:UIEdgeInsetsMake(36.0f, 10.0f, 19.0f, 10.0f)] forState:UIControlStateHighlighted];
//        background.layer.shadowColor = [UIColor blackColor].CGColor;
//        background.layer.shadowOpacity = 0.5;
//        background.layer.shadowOffset = CGSizeMake(-5.0, -5.0);
//        background.layer.shadowRadius = 3;
        [background addTarget:self action:@selector(bubbleTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:background];
        
        
        CGSize contentSize = [self getContentSize:marker];
        CGRect contentFrame = CGRectMake(0, 0, contentSize.width, contentSize.height);
        
        UILabel *label = [[UILabel alloc] initWithFrame:contentFrame];
        label.text = [marker.userData building].name;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:55.0/255.0 green:55.0/255.0 blue:55.0/255.0 alpha:1];
        
        [self addSubview:label];
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

-(void)highlight
{
}

-(CGRect)getBubbleFrame:(GMSMarker *)marker
{
    CGPoint markerPoint = [marker.map.projection pointForCoordinate:marker.position];
    CGSize contentSize = [self getContentSize:marker];
    
    return CGRectMake(markerPoint.x, markerPoint.y-40, contentSize.width, contentSize.height+18);
}

-(CGSize)getContentSize:(GMSMarker *)marker
{
    CGSize textSize = [[marker.userData building].name sizeWithFont: [UIFont systemFontOfSize:20]];
    
    return CGSizeMake(textSize.width+96, textSize.height+20);
}

-(void)bubbleTapped
{
    NSLog(@"Bubble tapped");
    [self.controller bubbleTapped:self];
}

@end
