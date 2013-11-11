//
//  REMWidgetRankingDelegator.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/5/13.
//
//

#import "REMWidgetRankingDelegator.h"

@interface REMWidgetRankingDelegator()

@property (nonatomic,strong) UIPopoverController *datePickerPopoverController;

@property (nonatomic,strong) REMAbstractChartWrapper *chartWrapper;


@end

@implementation REMWidgetRankingDelegator


- (void)initBizView{
    //monthPickerViewController
    [self initModelAndSearcher];
    [self initSearchView];
    [self initChartView];
    
}

- (void)initModelAndSearcher{
    self.model = [REMWidgetSearchModelBase searchModelByDataStoreType:self.widgetInfo.contentSyntax
                  .dataStoreType withParam:self.widgetInfo.contentSyntax.params];
    self.searcher=[REMEnergySeacherBase querySearcherByType:self.widgetInfo.contentSyntax.dataStoreType withWidgetInfo:self.widgetInfo];
}


- (void)initSearchView{
    UIView *searchViewContainer=[[UIView alloc]initWithFrame:kDMChart_ToolbarFrame];
    
    UIButton *timePickerButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [timePickerButton setFrame:CGRectMake(kWidgetDatePickerLeftMargin, 0, kWidgetDatePickerWidth, kWidgetDatePickerHeight)];
    
    [timePickerButton setImage:[UIImage imageNamed:@"Oil_pressed"] forState:UIControlStateNormal];
    [timePickerButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, kWidgetDatePickerWidth-40)];
    [timePickerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [timePickerButton addTarget:self action:@selector(showTimePicker) forControlEvents:UIControlEventTouchUpInside];
    
    
    [searchViewContainer addSubview:timePickerButton];
    
    self.timePickerButton = timePickerButton;
    
    
    [self.view addSubview:searchViewContainer];
    self.searchView=searchViewContainer;
    
    UIButton *orderButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [orderButton setFrame:CGRectMake(900, 0, 32, 32)];
    
    [orderButton setImage:[UIImage imageNamed:@"Up"] forState:UIControlStateNormal];
    orderButton.showsTouchWhenHighlighted=YES;
    orderButton.adjustsImageWhenHighlighted=YES;
    [orderButton setImage:[UIImage imageNamed:@"Down"] forState:UIControlStateSelected];
    [orderButton addTarget:self action:@selector(orderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView addSubview:orderButton];
    
    self.orderButton=orderButton;
    
}

- (void) orderButtonClicked:(UIButton *)button{
    REMRankingWidgetWrapper *rank=(REMRankingWidgetWrapper *)self.chartWrapper;
    if(button.selected==YES){
        [button setSelected:NO];
        rank.sortOrder=NSOrderedAscending;
    }
    else{
        [button setSelected:YES];
        rank.sortOrder=NSOrderedDescending;
    }
}

- (void)initChartView{
    UIView *chartContainer=[[UIView alloc]initWithFrame:CGRectMake(kWidgetChartLeftMargin, kWidgetChartTopMargin, kWidgetChartWidth, kWidgetChartHeight)];
    [self.view addSubview:chartContainer];
    self.chartContainer=chartContainer;
    self.maskerView=self.chartContainer;
    self.chartContainer.layer.borderColor=[UIColor redColor].CGColor;
    self.chartContainer.layer.borderWidth=1;
    //[self showEnergyChart];
    
    
    [self setDatePickerButtonValueNoSearchByTimeRange:self.widgetInfo.contentSyntax.timeRanges[0] withRelative:self.widgetInfo.contentSyntax.relativeDateComponent withRelativeType:self.widgetInfo.contentSyntax.relativeDateType];
}

- (void) setDatePickerButtonValueNoSearchByTimeRange:(REMTimeRange *)range withRelative:(NSString *)relativeDate withRelativeType:(REMRelativeTimeRangeType)relativeType
{
    NSString *text=[REMTimeHelper formatTimeRangeFullDay:range];
    
    
    NSString *text1=[NSString stringWithFormat:@"%@ %@",relativeDate,text];
    
    [self.timePickerButton setTitle:text1 forState:UIControlStateNormal];
    REMWidgetRankingSearchModel *rankingModel=(REMWidgetRankingSearchModel *)self.model;
    [rankingModel setTimeRangeItem:range AtIndex:0];
    rankingModel.relativeDateComponent=relativeDate;
    rankingModel.relativeDateType=relativeType;
}

- (void)setNewTimeRange:(REMTimeRange *)newRange withRelativeType:(REMRelativeTimeRangeType)relativeType withRelativeDateComponent:(NSString *)newDateComponent
{
    [self setDatePickerButtonValueNoSearchByTimeRange:newRange withRelative:newDateComponent withRelativeType:relativeType];
    
    
    [self doSearchWithModel:self.model callback:^(REMEnergyViewData *data,REMBusinessErrorInfo *error){
        if(data!=nil){
            [self reloadChart];
        }
        else{
        }
    }];
    
}

- (void)reloadChart{
    [self.chartWrapper.view removeFromSuperview];
    [self.chartWrapper destroyView];
    self.chartWrapper=nil;
    [self showEnergyChart];
}


- (void)showChart{
    [self showEnergyChart];
}

- (void) showEnergyChart{
    if(self.chartWrapper!=nil){
        return;
    }
    
    
    CGRect widgetRect = self.chartContainer.bounds;
    REMDiagramType widgetType = self.widgetInfo.diagramType;
    
    NSMutableDictionary* style = [[NSMutableDictionary alloc]init];
    //    self.userInteraction = ([dictionary[@"userInteraction"] isEqualToString:@"YES"]) ? YES : NO;
    //    self.series = dictionary[@"series"];
    CPTMutableLineStyle* gridlineStyle = [[CPTMutableLineStyle alloc]init];
    CPTMutableTextStyle* textStyle = [[CPTMutableTextStyle alloc]init];
    gridlineStyle.lineColor = [CPTColor whiteColor];
    gridlineStyle.lineWidth = 1.0;
    textStyle.fontName = @kBuildingFontSCRegular;
    textStyle.fontSize = 16.0;
    textStyle.color = [CPTColor whiteColor];
    textStyle.textAlignment = CPTTextAlignmentCenter;
    
    [style setObject:@"YES" forKey:@"userInteraction"];
    [style setObject:@(0.05) forKey:@"animationDuration"];
    [style setObject:gridlineStyle forKey:@"xLineStyle"];
    [style setObject:textStyle forKey:@"xTextStyle"];
    //    [style setObject:nil forKey:@"xGridlineStyle"];
    //    [style setObject:nil forKey:@"yLineStyle"];
    [style setObject:textStyle forKey:@"yTextStyle"];
    [style setObject:gridlineStyle forKey:@"yGridlineStyle"];
    [style setObject:@(6) forKey:@"horizentalGridLineAmount"];
    REMRankingWidgetWrapper  *widgetWrapper;
    if (widgetType == REMDiagramTypeRanking) {
        widgetWrapper = [[REMRankingWidgetWrapper alloc]initWithFrame:widgetRect data:self.energyData widgetContext:self.widgetInfo.contentSyntax styleDictionary:style];
    }
    if (widgetWrapper != nil) {
        [self.chartContainer addSubview:widgetWrapper.view];
        self.chartWrapper=widgetWrapper;
        
    }
    
}

- (void) showTimePicker{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UINavigationController *nav=[storyboard instantiateViewControllerWithIdentifier:@"datePickerNavigationController"];
    
    UIPopoverController *popoverController=[[UIPopoverController alloc]initWithContentViewController:nav];
    REMDatePickerViewController *dateViewController =nav.childViewControllers[0];
    dateViewController.showHour=NO;
    REMWidgetRankingSearchModel *rankModel=(REMWidgetRankingSearchModel *)self.model;
    
    dateViewController.relativeDate=rankModel.relativeDateComponent;
    dateViewController.timeRange=rankModel.timeRangeArray[0];
    dateViewController.relativeDateType=rankModel.relativeDateType;
    dateViewController.datePickerProtocol=self;
    dateViewController.popController=popoverController;
    [popoverController setPopoverContentSize:CGSizeMake(400, 500)];
    CGRect rect= CGRectMake(self.searchView.frame.origin.x, self.searchView.frame.origin.y+self.timePickerButton.frame.size.height+20, self.timePickerButton.frame.size.width, self.timePickerButton.frame.size.height);
    [popoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown|UIPopoverArrowDirectionUp animated:YES];
    
    self.datePickerPopoverController=popoverController;
}



@end
