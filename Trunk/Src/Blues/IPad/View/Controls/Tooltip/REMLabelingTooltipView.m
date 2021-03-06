/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLabelingTooltipView.m
 * Date Created : 张 锋 on 1/1/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMLabelingTooltipView.h"
#import "DCLabelingLabel.h"
#import "REMChartTooltipItem.h"
#import "REMCommonHeaders.h"
#import "REMWidgetStepEnergyModel.h"

@interface REMLabelingTooltipView ()

@property (nonatomic,strong) NSMutableArray *tooltipItems;

@property (nonatomic,weak) UILabel *timeLabel;

@property (nonatomic,strong) NSDate *xTime;

@end

@implementation REMLabelingTooltipView


-(REMTooltipViewBase *)initWithHighlightedPoints:(NSArray *)points atX:(id)x chartWrapper:(DAbstractChartWrapper *)chartWrapper  inEnergyData:(REMEnergyViewData *)data widget:(REMManagedWidgetModel *)widget andParameters:(REMWidgetSearchModelBase *)parameters
{
    self = [super initWithHighlightedPoints:points atX:x chartWrapper:chartWrapper inEnergyData:data widget:widget andParameters:parameters];
    
    return self;
}


- (NSArray *)convertItemModels
{
    NSArray *highlightedPoints = self.highlightedPoints; //highlightedPoints for trend data is an array of DCChartPoint
    NSMutableArray *itemModels = [[NSMutableArray alloc] init];
    
    for(int i=0;i<highlightedPoints.count;i++){
        DCLabelingLabel *point = highlightedPoints[i];
        
        REMChartTooltipItemModel *model = [[REMChartTooltipItemModel alloc] init];
        
        model.title = point.name;
        model.value = REMIsNilOrNull(point) ? nil : point.energyData.dataValue;
        model.color = point.color;
        model.index = i;
        model.uom = point.target.uomName;
        
        [itemModels addObject:model];
    }
    
    return itemModels;
}

-(NSString *)formatTimeText:(NSDate *)time
{
    if([self.parameters isKindOfClass:[REMWidgetStepEnergyModel class]]){
        REMWidgetStepEnergyModel *stepModel = (REMWidgetStepEnergyModel *)self.parameters;
        
        REMEnergyStep step = stepModel.step;
        
        return [REMTimeHelper formatTooltipTime:time byStep:step inRange:nil];
    }
    
    return [REMTimeHelper formatTimeFullHour:time isChangeTo24Hour:YES];
}


@end
