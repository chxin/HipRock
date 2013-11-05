//
//  REMChartSeriesLegend.m
//  Blues
//
//  Created by 张 锋 on 11/4/13.
//
//

#import "REMChartSeriesLegend.h"
#import "REMChartSeriesIndicator.h"
#import "REMDimensions.h"
#import "REMCommonHeaders.h"


#define kREMChartSeriesLegendFrame CGRectMake(0,0,kDMChart_LegendItemWidth,kDMChart_LegendItemHeight)

@interface REMChartSeriesLegend()

@property (nonatomic,weak) REMChartSeriesIndicator *indicator;
@property (nonatomic,weak) UILabel *label;
@property (nonatomic) UIControlState state;

@end


@implementation REMChartSeriesLegend

-(REMChartSeriesLegend *)initWithSeriesIndex:(int)index type:(REMChartSeriesIndicatorType)type andName:(NSString *)name
{
    self = [super initWithFrame:kREMChartSeriesLegendFrame];
    if(self){
        self.seriesIndex = index;
        self.seriesName = name;
        
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 5.0f;
        
        
        //add indicator
        REMChartSeriesIndicator *indicator = [REMChartSeriesIndicator indicatorWithType:type andColor:[REMColor colorByIndex:index].uiColor];
        [self addSubview:indicator];
        
        //add label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16.0];
        label.text = name;
        label.textColor = [UIColor blackColor];
        [self addSubview:label];
        
        //add tap gesture
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(legendTapped:)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)legendTapped:(UITapGestureRecognizer *)gesture
{
    NSLog(@"legend tapped!");
}

@end
