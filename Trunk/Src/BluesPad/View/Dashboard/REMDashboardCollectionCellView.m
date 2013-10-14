//
//  REMDashboardCollectionCellView.m
//  Blues
//
//  Created by tantan on 9/25/13.
//
//

#import "REMDashboardCollectionCellView.h"
#import <QuartzCore/QuartzCore.h>
#import "REMEnergySeacherBase.h"
#import "REMLineWidgetWrapper.h"
#import "REMColumnWidgetWrapper.h"
#import "REMPieChartWrapper.h"

@interface REMDashboardCollectionCellView ()

@property (nonatomic,weak) UIView *chartContainer;

@end

@implementation REMDashboardCollectionCellView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.contentView.layer.borderColor=[UIColor grayColor].CGColor;
        self.contentView.layer.borderWidth=1;
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor clearColor];
        
        self.chartLoaded=NO;
        
    }
    return self;
}

- (void)initWidgetCell:(REMWidgetObject *)widgetInfo withGroupName:(NSString *)groupName
{
    
    if(self.chartContainer==nil){
        _widgetInfo=widgetInfo;
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 20)];
        title.backgroundColor=[UIColor clearColor];
        title.textColor=[UIColor whiteColor];
        title.text=widgetInfo.name;
        [self.contentView addSubview:title];
        
        self.titleLabel=title;
        
        
        UILabel *time=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, self.contentView.frame.size.width, 20)];
        time.backgroundColor=[UIColor clearColor];
        time.textColor=[UIColor whiteColor];
        [self.contentView addSubview:time];
        self.timeLabel=time;
        
        if(widgetInfo.shareInfo!=nil||[widgetInfo.shareInfo isEqual:[NSNull null]]==NO){
            
        }
        
        UIView *chartContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 30, self.contentView.frame.size.width, self.contentView.frame.size.height-40)];
        
        [self.contentView addSubview:chartContainer];
        
        self.chartContainer=chartContainer;
    }
    [self queryEnergyData:widgetInfo.contentSyntax withGroupName:groupName];
}

- (void)queryEnergyData:(REMWidgetContentSyntax *)syntax withGroupName:(NSString *)groupName{
    if(self.chartLoaded==YES)return;
    REMEnergySeacherBase *searcher=[REMEnergySeacherBase querySearcherByType:syntax.dataStoreType];
    [searcher queryEnergyDataByStoreType:syntax.dataStoreType andParameters:syntax.params withMaserContainer:self.chartContainer  andGroupName:groupName callback:^(REMEnergyViewData *data){
        self.chartData = data;
        self.chartLoaded=YES;
        REMWidgetWrapper* widget = nil;
        if ([syntax.type isEqualToString:@"line"]) {
            widget = [[REMLineWidgetWrapper alloc]initWithFrame:self.chartContainer.bounds data:data widgetContext:syntax];
        } else if ([syntax.type isEqualToString:@"column"]) {
            widget = [[REMColumnWidgetWrapper alloc]initWithFrame:self.chartContainer.bounds data:data widgetContext:syntax];
        } else if ([syntax.type isEqualToString:@"pie"]) {
            widget = [[REMPieChartWrapper alloc]initWithFrame:self.chartContainer.bounds data:data widgetContext:syntax];
        }
        if (widget != nil) {
            [self.chartContainer addSubview:widget.view];
            [widget destroyView];
        }
        //[self snapshotChartView];
    }];
}

- (void)snapshotChartView{
    UIGraphicsBeginImageContextWithOptions(self.chartContainer.frame.size, NO, 0.0);
    [self.chartContainer.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //UIImageView *v = [[UIImageView alloc]initWithImage:image];
    
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:self.chartContainer.frame];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.tag=[self.widgetInfo.widgetId integerValue];
    [button addTarget:self action:@selector(widgetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *chartView=self.chartContainer.subviews[0];
    [chartView removeFromSuperview];
    [self.chartContainer addSubview:button];
}

- (void)widgetButtonPressed:(UIButton *)button{
    NSLog(@"click widget:%d",button.tag);
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
