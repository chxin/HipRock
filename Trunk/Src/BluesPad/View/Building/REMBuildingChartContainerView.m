//
//  REMBuildingChartContainerView.m
//  Blues
//
//  Created by tantan on 8/9/13.
//
//

#import "REMBuildingChartContainerView.h"
#import "REMAverageUsageDataModel.h"

@interface REMBuildingChartContainerView()

@property (nonatomic) BOOL hasLoaded;
@property (nonatomic,strong) NSNumber *buildingId;
@property (nonatomic,strong) NSNumber *commodityId;
@end

@implementation REMBuildingChartContainerView

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title andTitleFontSize:(CGFloat)size;
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.hasLoaded=NO;
        //NSLog(@"chart frame:%@",NSStringFromCGRect(frame));
        self.backgroundColor=[UIColor clearColor];
//        self.layer.borderColor=[UIColor redColor].CGColor;
//        self.layer.borderWidth=1;
        [self initTitle:title withSize:size withLeftMargin:0];
        [self initChartViewWithSize:size];
    }
    
    return self;
}


- (void)initChartViewWithSize:(CGFloat)titleSize
{
    self.chartContainer = [[UIView alloc]initWithFrame:CGRectMake(0, titleSize+kBuildingDetailInnerMargin, self.frame.size.width, self.frame.size.height-titleSize-kBuildingDetailInnerMargin)];
    //self.chartContainer.clipsToBounds=YES;
//    self.chartContainer.layer.borderColor=[UIColor greenColor].CGColor;
//    self.chartContainer.layer.borderWidth=1;
    
    [self addSubview:self.chartContainer];
}

- (void)requireChartDataWithBuildingId:(NSNumber *)buildingId withCommodityId:(NSNumber *)commodityId  withEnergyData:(REMAverageUsageDataModel *)averageData complete:(void (^)(BOOL))callback
{
    if(self.hasLoaded == NO){
        [self.chartContainer addSubview:self.controller.view];

        //NSArray *array=@[buildingId,commodityId,averageData,callback];
        //[self performSelector:@selector(loadChartData:) withObject:array afterDelay:0.1];
        //[self performSelector:@selector(loadChartData:) withObject:array afterDelay:0.1];
        
        [self.controller loadData:[buildingId longLongValue] :[commodityId longLongValue] :averageData :^(REMError *error){
            self.hasLoaded=YES;
            callback(YES);
        }];
            }
}

- (void)loadChartData:(NSArray *)array{
    NSNumber *buildingId=array[0];
    NSNumber *commodityId=array[1];
    REMAverageUsageDataModel *averageData=array[2];
    void(^callback)(BOOL)=array[3];
    [self.controller loadData:[buildingId longLongValue] :[commodityId longLongValue] :averageData :^(REMError *error){
        self.hasLoaded=YES;
        callback(YES);
    }];
}

/*
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL inside=    [self pointInside:point withEvent:event];
    if(inside){
        return self;
    }
    return [super hitTest:point withEvent:event];
}*/


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
