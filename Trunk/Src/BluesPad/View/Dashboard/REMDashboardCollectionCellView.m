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
#import "REMRankingWidgetWrapper.h"
#import "REMStackColumnWidgetWrapper.h"

@interface REMDashboardCollectionCellView ()

@property (nonatomic,weak) UIView *chartContainer;

@end

@implementation REMDashboardCollectionCellView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.contentView.layer.borderColor=[UIColor grayColor].CGColor;
        //self.contentView.layer.borderWidth=1;
//        self.backgroundColor=[UIColor whiteColor];
//        self.contentView.backgroundColor=[UIColor whiteColor];
        
        self.chartLoaded=NO;
        
    }
    return self;
}

- (void)initWidgetCell:(REMWidgetObject *)widgetInfo withGroupName:(NSString *)groupName
{
    
    if(self.chartContainer==nil){
        _widgetInfo=widgetInfo;
        UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(5, 6, self.contentView.frame.size.width, 8)];
        title.backgroundColor=[UIColor clearColor];
        title.font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:8];
        title.textColor=[REMColor colorByHexString:@"#4c4c4c"];
        title.text=widgetInfo.name;
        [self.contentView addSubview:title];
        
        self.titleLabel=title;
        
        
        UILabel *time=[[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x, title.frame.origin.y+title.frame.size.height+6, self.contentView.frame.size.width, 7)];
        time.backgroundColor=[UIColor clearColor];
        time.textColor=title.textColor;
        time.font = [UIFont fontWithName:@(kBuildingFontSCRegular) size:7];
        if([widgetInfo.contentSyntax.relativeDate isEqual:[NSNull null]]==NO){
            time.text=widgetInfo.contentSyntax.relativeDateComponent;
        }
        else{
            REMTimeRange *range = widgetInfo.contentSyntax.timeRanges[0];
            NSString *start= [REMTimeHelper formatTimeFullHour:range.startTime isChangeTo24Hour:NO];
            NSString *end= [REMTimeHelper formatTimeFullHour:range.endTime isChangeTo24Hour:YES];
            time.text=[NSString stringWithFormat:@"%@ 到 %@",start,end];
        }
        [self.contentView addSubview:time];
        self.timeLabel=time;
        
        if(widgetInfo.shareInfo!=nil||[widgetInfo.shareInfo isEqual:[NSNull null]]==NO){
            
        }
        
        UIView *chartContainer = [[UIView alloc]initWithFrame:CGRectMake(5, time.frame.origin.y+time.frame.size.height+6, 172, 85)];
        chartContainer.layer.borderColor=[UIColor redColor].CGColor;
        chartContainer.layer.borderWidth=1;
        
        
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
        REMWidgetWrapper* widgetWrapper = nil;
        REMDiagramType widgetType = self.widgetInfo.diagramType;
        CGRect widgetRect = self.chartContainer.bounds;
        if (widgetType == REMDiagramTypeLine) {
            widgetWrapper = [[REMLineWidgetWrapper alloc]initWithFrame:widgetRect data:data widgetContext:self.widgetInfo.contentSyntax];
        } else if (widgetType == REMDiagramTypeColumn) {
            widgetWrapper = [[REMColumnWidgetWrapper alloc]initWithFrame:widgetRect data:data widgetContext:self.widgetInfo.contentSyntax];
        } else if (widgetType == REMDiagramTypePie) {
            widgetWrapper = [[REMPieChartWrapper alloc]initWithFrame:widgetRect data:data widgetContext:self.widgetInfo.contentSyntax];
        } else if (widgetType == REMDiagramTypeRanking) {
            widgetWrapper = [[REMRankingWidgetWrapper alloc]initWithFrame:widgetRect data:data widgetContext:self.widgetInfo.contentSyntax];
        } else if (widgetType == REMDiagramTypeStackColumn) {
            widgetWrapper = [[REMStackColumnWidgetWrapper alloc]initWithFrame:widgetRect data:data widgetContext:self.widgetInfo.contentSyntax];
        }
        if (widgetWrapper != nil) {
            [self.chartContainer addSubview:widgetWrapper.view];
//            [widget destroyView];
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
