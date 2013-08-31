//
//  REMChartSeriesIndicator.m
//  Blues
//
//  Created by 张 锋 on 8/29/13.
//
//

#import "REMChartSeriesIndicator.h"
#import <QuartzCore/QuartzCore.h>
#import "REMCommonHeaders.h"
#import "REMBuildingConstants.h"


@interface REMChartSeriesIndicator()

@property (nonatomic,strong) UIColor *color;
@property (nonatomic,strong) NSString *title;

@property (nonatomic,strong) UIView *pointView;
@property (nonatomic,strong) UILabel *label;

@end 

@implementation REMChartSeriesIndicator

static CGFloat pointRadius = 7.5;
static CGFloat pointLabelSpace = 11;
static CGFloat fontSize = 14;

- (id)initWithFrame:(CGRect)frame title:(NSString *)text andColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.color = color;
        self.title = text;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
    
    //draw a point with color
    if(self.pointView != nil){
        self.pointView = nil;
    }
    
    CGFloat pointWidth = pointRadius*2;
    self.pointView = [[UIView alloc] initWithFrame:CGRectMake(0,0, pointWidth, pointWidth)];
    self.pointView.layer.cornerRadius = pointRadius;
    self.pointView.backgroundColor = self.color;
    
    //draw a text label
    if(self.label != nil){
        self.label = nil;
    }
    
    CGFloat labelOffset = pointWidth+pointLabelSpace, labelWidth = self.bounds.size.width-labelOffset, labelHeight=self.bounds.size.height;
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(labelOffset, 0, labelWidth, labelHeight)];
    self.label.text = self.title;
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont systemFontOfSize:fontSize];
    self.label.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.pointView];
    [self addSubview:self.label];
    
//    self.layer.borderColor = [UIColor redColor].CGColor;
//    self.layer.borderWidth = 1.0;
}


@end
