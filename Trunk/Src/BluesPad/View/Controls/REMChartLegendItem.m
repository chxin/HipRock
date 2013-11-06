/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMChartSeriesLegend.m
 * Created      : 张 锋 on 11/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMChartLegendItem.h"
#import "REMChartSeriesIndicator.h"
#import "REMDimensions.h"
#import "REMCommonHeaders.h"


#define kREMLegendItemFrame CGRectMake(0,0,kDMChart_LegendItemWidth,kDMChart_LegendItemHeight)

#define kREMLegendInnerIndicatorFrame CGRectMake(kDMChart_LegendIndicatorLeftOffset,kDMChart_LegendIndicatorTopOffset, kDMChart_LegendIndicatorSize,kDMChart_LegendIndicatorSize)

#define kREMLegendInnerLabelFrame CGRectMake(kDMChart_LegendIndicatorLeftOffset + kDMChart_LegendIndicatorSize + kDMChart_LegendLabelLeftOffset, kDMChart_LegendLabelTopOffset, kDMChart_LegendItemWidth - (kDMChart_LegendIndicatorLeftOffset + kDMChart_LegendIndicatorSize + kDMChart_LegendLabelLeftOffset), kDMChart_LegendLabelFontSize+1)

@interface REMChartLegendItem()

@property (nonatomic,weak) REMChartSeriesIndicator *indicator;
@property (nonatomic,weak) UILabel *label;

@end


@implementation REMChartLegendItem

-(REMChartLegendItem *)initWithSeriesIndex:(int)index type:(REMChartSeriesIndicatorType)type andName:(NSString *)name
{
    self = [super initWithFrame:kREMLegendItemFrame];
    if(self){
        self.seriesIndex = index;
        self.seriesName = name;
        
//        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
//        self.layer.borderWidth = 1.0f;
        
        self.layer.cornerRadius = 5.0f;
        [self updateState];
        
        
        //add indicator
        REMChartSeriesIndicator *indicator = [REMChartSeriesIndicator indicatorWithType:type andColor:[REMColor colorByIndex:index].uiColor];
        indicator.frame = kREMLegendInnerIndicatorFrame;
        [self addSubview:indicator];
        
        //add label
        UILabel *label = [[UILabel alloc] initWithFrame:kREMLegendInnerLabelFrame];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:kDMChart_LegendLabelFontSize];
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
    if(self.state == UIControlStateNormal)
        [self setSelected:YES];
    else
        [self setSelected:NO];
    
    [self updateState];
    NSLog(@"legend tapped, status: %d!", self.state);
    
    //set the conrresponding series status
    if(self.delegate != nil){
        [self.delegate legendStateChanged:self.state onIndex:self.seriesIndex];
    }
}

-(void)updateState
{
    if(self.state == UIControlStateNormal){
        self.backgroundColor = [UIColor lightGrayColor];
    }
    else{
        self.backgroundColor = [UIColor darkGrayColor];
    }
}

@end
