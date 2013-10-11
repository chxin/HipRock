//
//  REMDashboardCollectionCellView.m
//  Blues
//
//  Created by tantan on 9/25/13.
//
//

#import "REMDashboardCollectionCellView.h"
#import <QuartzCore/QuartzCore.h>


@interface REMDashboardCollectionCellView ()


@property (nonatomic,weak) REMWidgetObject *widgetInfo;

@property (nonatomic) BOOL chartLoaded;


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

- (void)initWidgetCell:(REMWidgetObject *)widgetInfo
{
    
    if(self.chartContainer==nil){
        self.widgetInfo=widgetInfo;
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
