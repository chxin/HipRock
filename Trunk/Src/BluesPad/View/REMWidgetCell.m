//
//  REMWidgetCell.m
//  Blues
//
//  Created by TanTan on 7/1/13.
//
//

#import "REMWidgetCell.h"
#import <QuartzCore/QuartzCore.h>
#import "REMWidgetCellPieViewController.h"
#import "REMDashboardViewController.h"
#import "REMWidgetCellColumnViewController.h"
#import "REMWidgetCellLineViewController.h"


@interface REMWidgetCell()

@property (nonatomic,strong) REMWidgetCellViewController *controller;
@property (nonatomic,strong) REMWidgetObject *widgetObj;

@end

@implementation REMWidgetCell

- (void)initCellByWidget:(REMWidgetObject *)widget
{
    switch (widget.diagramType) {
        case REMDiagramTypeLine:
            self.controller= [[REMWidgetCellLineViewController alloc]init];
            break;
        case REMDiagramTypeColumn:
            self.controller= [[REMWidgetCellColumnViewController alloc]init];
            break;
        case REMDiagramTypePie:
            self.controller= [[REMWidgetCellPieViewController alloc]init];
            break;
            
        default:
            break;
    }
     
    self.controller.view=self.contentView;
    self.controller.widgetTitle=self.title;
    self.controller.chartView=self.chartView;
    self.controller.widgetObject=widget;
    [self.controller initDiagram];
    self.isInitialized=YES;
    
}



- (id)initWithCoder:(NSCoder *)aDecoder
{
    self =  [super initWithCoder:aDecoder];
    
    if(self)
    {
        self.contentView.layer.borderWidth=1.0f;
        self.contentView.layer.borderColor= [UIColor lightGrayColor].CGColor ;
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

- (IBAction)detailButtonClick:(UIButton *)sender {
    [self.dashboardController showMaxWidgetByCell:
                self.controller.widgetObject WithData:self.controller.data];
    
    
}
@end
