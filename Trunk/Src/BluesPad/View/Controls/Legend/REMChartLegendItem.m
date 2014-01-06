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
#import "REMChartLegendBase.h"
#import "DCSeries.h"
#import "DCXYSeries.h"

//#define kREMLegendItemFrame CGRectMake(0,0,kDMChart_LegendItemWidth,kDMChart_LegendItemHeight)

#define kREMLegendInnerIndicatorFrame CGRectMake(kDMChart_LegendIndicatorLeftOffset,kDMChart_LegendIndicatorTopOffset, kDMChart_IndicatorSize,kDMChart_IndicatorSize)

#define kREMLegendInnerLabelFrame CGRectMake(kDMChart_LegendIndicatorLeftOffset + kDMChart_IndicatorSize + kDMChart_LegendLabelLeftOffset, kDMChart_LegendLabelTopOffset, self.frame.size.width - (kDMChart_LegendIndicatorLeftOffset + kDMChart_IndicatorSize + kDMChart_LegendLabelLeftOffset), kDMChart_LegendLabelFontSize+1)

@interface REMChartLegendItem()

@property (nonatomic) BOOL tappable;
@property (nonatomic) int seriesIndex;
@property (nonatomic,weak) REMChartLegendBase *legendView;

@property (nonatomic,weak) REMChartSeriesIndicator *indicator;
@property (nonatomic,weak) UILabel *label;

@end


@implementation REMChartLegendItem

-(REMChartLegendItem *)initWithFrame:(CGRect)frame andModel:(REMChartLegendItemModel *)model
{
    self = [super initWithFrame:frame];
    if(self){
        self.seriesIndex = model.index;
        self.legendView = model.legendView;
        self.tappable = model.tappable;
//        self.seriesName = name;
        
//        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
//        self.layer.borderWidth = 1.0f;
        
        self.layer.cornerRadius = kDMChart_LegendItemCornerRadius;
        self.backgroundColor = [REMColor colorByHexString:kDMChart_LegendItemBackgroundColor];
        
        //add indicator
        REMChartSeriesIndicator *indicator = model.isBenchmark ? [REMChartSeriesIndicator indicatorWithType:REMChartSeriesIndicatorLine andColor:[REMColor colorByHexString:kDMChart_BenchmarkColor]] : [REMChartSeriesIndicator indicatorWithType:model.type andColor:[REMColor colorByIndex:model.index].uiColor];
        indicator.frame = kREMLegendInnerIndicatorFrame;
        [self addSubview:indicator];
        self.indicator = indicator;
        
        //add label
        UILabel *label = [[UILabel alloc] initWithFrame:kREMLegendInnerLabelFrame];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:kDMChart_LegendLabelFontSize];
        label.text = model.title;
        label.textColor = [REMColor colorByHexString:kDMChart_LegendLabelFontColor];
        [self addSubview:label];
        self.label = label;
        
        //add tap gesture
        //[self addTarget:self action:@selector(legendTapped:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(legendTapped:)];
        [self addGestureRecognizer:tap];
        
        if(model.isDefaultHidden){
            [self setSelected:YES];
        }
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
    if(self.tappable == NO)
        return;
    
    BOOL stateChanged = NO;
    id<REMChartLegendItemDelegate> delegate = self.legendView.itemDelegate;
    if(self.state == UIControlStateSelected){
        [self setSelected:NO];
        stateChanged = YES;
    }
    else{
        if (REMIsNilOrNull(delegate) || [delegate canBeHidden]) {
            [self setSelected:YES];
            stateChanged = YES;
        }
    }
    
    if (stateChanged) {
        [self updateState];
        //NSLog(@"legend tapped, status: %d!", self.state);
        
        //set the conrresponding series status
        if(!REMIsNilOrNull(delegate)){
            [delegate legendStateChanged:self.state onIndex:self.seriesIndex];
        }
    }
}

-(void)updateState
{
    if(self.state == UIControlStateNormal){
        self.backgroundColor = [REMColor colorByHexString:kDMChart_LegendItemBackgroundColor];
        self.label.textColor = [REMColor colorByHexString:kDMChart_LegendLabelFontColor];
    }
    else{
        self.backgroundColor = [REMColor colorByHexString:kDMChart_LegendItemHiddenBackgroundColor];
        self.label.textColor = [REMColor colorByHexString:kDMChart_LegendLabelHiddenFontColor];
    }
}

-(void)setSelected:(BOOL)selected;
{
    [super setSelected:selected];
    [self updateState];
}

@end


@implementation REMChartLegendItemModel



@end
