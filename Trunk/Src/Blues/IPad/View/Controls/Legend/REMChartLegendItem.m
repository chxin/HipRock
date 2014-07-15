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

@interface REMChartLegendItem()

@property (nonatomic) int seriesIndex;
@property (nonatomic,weak) REMChartLegendBase *legendView;

@property (nonatomic,weak) REMChartSeriesIndicator *indicator;
@property (nonatomic,weak) UIView* labelBackgroundView;
@property (nonatomic,weak) UILabel *label;
@property (nonatomic) REMChartSeriesIndicatorType indicatorType;
@property (nonatomic) BOOL canChangeSeriesType;

@end


@implementation REMChartLegendItem

-(REMChartLegendItem *)initWithFrame:(CGRect)frame andModel:(REMChartLegendItemModel *)model
{
    self = [super initWithFrame:frame];
    if(self){
        self.seriesIndex = model.index;
        self.legendView = model.legendView;
        self.indicatorType = model.type;
        
        //add indicator
        REMChartSeriesIndicator *indicator = [REMChartSeriesIndicator indicatorWithType:model.type andColor:model.color];
        indicator.frame = CGRectMake(0,0,kDMChart_LegendItemHeight,kDMChart_LegendItemHeight);
        [self addSubview:indicator];
        self.indicator = indicator;
        
        //add label
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:kDMChart_LegendLabelFontSize];
        label.text = model.title;
        label.textColor = [REMColor colorByHexString:kDMChart_LegendLabelFontColor];
        self.label = label;
        
        id<REMChartLegendItemDelegate> delegate = self.legendView.itemDelegate;
        _canChangeSeriesType = [delegate canChangeSeriesTypeOnIndex:self.seriesIndex];
        if (self.canChangeSeriesType) {
            UIView* labelBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(kDMChart_LegendItemHeight+kDMChart_LegendItemIconLabelMargin, 0, kDMChart_LegendItemWidth-kDMChart_LegendItemHeight-kDMChart_LegendItemIconLabelMargin, kDMChart_LegendItemHeight)];
            [self addSubview:labelBackgroundView];
            self.labelBackgroundView = labelBackgroundView;
            self.label.frame = CGRectMake(kDMChart_LegendItemHeight+kDMChart_LegendItemIconLabelMargin+kDMChart_LegendItemIconLabelBorderMargin, 0, kDMChart_LegendItemWidth-kDMChart_LegendItemHeight-kDMChart_LegendItemIconLabelMargin-kDMChart_LegendItemIconLabelBorderMargin*2, kDMChart_LegendItemHeight);
            self.label.layer.cornerRadius = kDMChart_LegendItemCornerRadius;
            self.indicator.layer.cornerRadius = kDMChart_LegendItemCornerRadius;
            self.backgroundColor = [UIColor clearColor];
            self.labelBackgroundView.backgroundColor = [REMColor colorByHexString:kDMChart_LegendItemBackgroundColor];
            self.indicator.backgroundColor = self.labelBackgroundView.backgroundColor;
        } else {
            self.label.frame =CGRectMake(kDMChart_LegendItemHeight, 0, kDMChart_LegendItemWidth-kDMChart_LegendItemHeight, kDMChart_LegendItemHeight);
            self.layer.cornerRadius = kDMChart_LegendItemCornerRadius;
            self.backgroundColor = [REMColor colorByHexString:kDMChart_LegendItemBackgroundColor];
        }
        [self addSubview:label];
        
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

-(void)didMoveToSuperview {
    
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
    BOOL isTapOnIcon = CGRectContainsPoint(self.indicator.frame, [gesture locationInView:self.indicator]);
    BOOL isSelected = self.state == UIControlStateSelected;
    id<REMChartLegendItemDelegate> delegate = self.legendView.itemDelegate;
    if (isTapOnIcon && self.canChangeSeriesType) {
        if (isSelected) return; // 已经隐藏的序列，无法修改序列的类型
        if (!REMIsNilOrNull(delegate)) {
            [delegate tapLegendIconOnIndex:self.seriesIndex];
            
            self.indicatorType = [self nextIndicatorType];//self.indicatorType == REMChartSeriesIndicatorLine ? REMChartSeriesIndicatorColumn : REMChartSeriesIndicatorLine;
            [self.indicator renderWithType:self.indicatorType];
        }
    } else {
        BOOL stateChanged = NO;
        if(isSelected){
            [self setSelected:NO];
            stateChanged = YES;
        }
        else{
            if (REMIsNilOrNull(delegate) || [delegate canBeHiddenOnIndex:self.seriesIndex]) {
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
}

-(REMChartSeriesIndicatorType)nextIndicatorType
{
    switch (self.indicatorType) {
        case REMChartSeriesIndicatorLine:
            return REMChartSeriesIndicatorColumn;
        case REMChartSeriesIndicatorColumn:
            return REMChartSeriesIndicatorStack;
        case REMChartSeriesIndicatorStack:
            return REMChartSeriesIndicatorLine;
        default:
            return REMChartSeriesIndicatorLine;
    }
}

-(void)updateState
{
    UIColor* bgColor = nil;
    UIColor* textColor = nil;
    if (self.state == UIControlStateNormal) {
        bgColor = [REMColor colorByHexString:kDMChart_LegendItemBackgroundColor];
        textColor = [REMColor colorByHexString:kDMChart_LegendLabelFontColor];
    } else{
        bgColor = [REMColor colorByHexString:kDMChart_LegendItemHiddenBackgroundColor];
        textColor = [REMColor colorByHexString:kDMChart_LegendLabelHiddenFontColor];
    }
    
    
    if (self.canChangeSeriesType) {
        self.labelBackgroundView.backgroundColor = bgColor;
        self.indicator.backgroundColor = bgColor;
    } else {
        self.backgroundColor = bgColor;
    }
    self.label.textColor = textColor;
}

-(void)setSelected:(BOOL)selected;
{
    [super setSelected:selected];
    [self updateState];
}

@end


@implementation REMChartLegendItemModel



@end
