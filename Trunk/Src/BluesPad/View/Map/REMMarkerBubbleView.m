//
//  REMMarkerBubbleView.m
//  Blues
//
//  Created by 张 锋 on 10/28/13.
//
//

#import "REMMarkerBubbleView.h"
#import "REMBuildingModel.h"
#import <GoogleMaps/GoogleMaps.h>

@interface REMMarkerBubbleView ()

@property (nonatomic,weak) REMBuildingModel *building;

@end

@implementation REMMarkerBubbleView

- (id)initWithMarker:(GMSMarker *)marker
{
    self = [super initWithFrame:[self getBubbleFrame:marker]];
    if (self) {
        // Initialization code
        self.building = marker.userData;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
    
    UIImage *image = [[UIImage imageNamed:@"MarkerBubble.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(9, 9, 17, 9)];
    [self addSubview:[[UIImageView alloc] initWithImage:image]];
}

-(void)highlight
{
}

-(CGRect)getBubbleFrame:(GMSMarker *)marker
{
    CGPoint markerPoint = [marker.map.projection pointForCoordinate:marker.position];
    return CGRectMake(markerPoint.x, markerPoint.y-40, 5.12, 3.84);
}

@end
