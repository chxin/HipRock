/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMRankingTooltipView.m
 * Date Created : 张 锋 on 11/26/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMRankingTooltipView.h"
#import "DCDataPoint.h"
#import "REMChartTooltipItem.h"
#import "REMCommonHeaders.h"

@interface REMRankingTooltipView()

@property (nonatomic,weak) NSArray *serieses;

@end

@implementation REMRankingTooltipView


-(REMTooltipViewBase *)initWithHighlightedPoints:(NSArray *)points inSerieses:(NSArray *)serieses widget:(REMManagedWidgetModel *)widget andParameters:(REMWidgetSearchModelBase *)parameters
{
    self = [super initWithDefaults];
    if(self){
        self.serieses = serieses;
        self.highlightedPoints = points;
        self.data = nil;
        self.widget = widget;
        self.parameters = parameters;
        
        self.itemModels = [self convertItemModels];
        
        UIScrollView *scrollView = [super renderScrollView];
        
        [self.contentView addSubview:scrollView];
        self.scrollView = scrollView;
    }
    
    return self;
}


- (NSArray *)convertItemModels
{
    NSArray *highlightedPoints = self.highlightedPoints; //highlightedPoints for trend data is an array of DCChartPoint
    NSMutableArray *itemModels = [[NSMutableArray alloc] init];
    
    for(int i=0;i<highlightedPoints.count;i++){
        DCDataPoint *point = highlightedPoints[i];
        
        REMRankingTooltipItemModel *model = [[REMRankingTooltipItemModel alloc] init];
        
        model.title = point.target.name;
        model.value = point.value;
        model.color = point.series.color;
        model.index = i;
        model.numerator = (int)[[self.serieses[0] datas] indexOfObject:point] + 1;
        model.denominator = (int)[[self.serieses[0] datas] count];
        model.uom = point.target.uomName;
        
        [itemModels addObject:model];
    }
    
    return itemModels;
}

@end
