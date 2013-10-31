//
//  REMWidgetMaxViewController.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by TanTan on 7/1/13.
//
//

#import "REMWidgetMaxViewController.h"
#import "REMWidgetDetailViewController.h"
#import "REMWidgetCellViewController.h"
#import "REMScreenEdgetGestureRecognizer.h"


@interface REMWidgetMaxViewController()

@property (nonatomic) CGFloat cumulateX;
@property (nonatomic) NSUInteger currentWidgetIndex;


/*
@property (nonatomic,strong) REMWidgetMaxDiagramViewController *chartController;
@property (nonatomic,strong) NSArray *currentStepList;
*/
@end

@implementation REMWidgetMaxViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setFrame:CGRectMake(0, 0, 1024, 748)];
    self.cumulateX=0;
    for (int i=0; i<self.dashboardInfo.widgets.count; ++i) {
        REMWidgetObject *obj=self.dashboardInfo.widgets[i];
        REMWidgetDetailViewController *sub=[[REMWidgetDetailViewController alloc]init];
        sub.widgetInfo=obj;
        REMWidgetCellViewController *cellController= self.widgetCollectionController.childViewControllers[i];
        sub.energyData=cellController.chartData;
        
        
        [self addChildViewController:sub];
    }
    
    REMWidgetDetailViewController *c=self.childViewControllers[0];
    [self.view addSubview:c.view];
    
    
    REMScreenEdgetGestureRecognizer *rec=[[REMScreenEdgetGestureRecognizer alloc]initWithTarget:self action:@selector(panthis:)];
    [self.view addGestureRecognizer:rec];
}

- (void)panthis:(REMScreenEdgetGestureRecognizer *)pan{
    
    CGPoint trans= [pan translationInView:self.view];
    
    // NSLog(@"state:%d",pan.state);
    
    if(pan.state== UIGestureRecognizerStateChanged)
    {
        
        
        for (int i=0;i<self.childViewControllers.count;++i)
        {
            REMWidgetDetailViewController *vc = self.childViewControllers[i];
            if(self.currentWidgetIndex == 0 && self.cumulateX>0){
                
            }
            else if((self.currentWidgetIndex==(self.dashboardInfo.widgets.count-1)) && self.cumulateX<0){
                
            }
            else{
                
            }
        }
        
        self.cumulateX+=trans.x;
        NSLog(@"cumulate x:%f",self.cumulateX);
    }
    
    if(pan.state == UIGestureRecognizerStateEnded||pan.state == UIGestureRecognizerStateCancelled)
    {
        
        CGPoint p= [pan velocityInView:self.view];
        
        int sign= p.x>0?1:-1;
        
        
        BOOL addIndex=YES;
        
        if((sign<0 && self.currentWidgetIndex==self.dashboardInfo.widgets.count-1)
           || (sign>0 && self.currentWidgetIndex==0) ||
           (ABS(p.x)<100 && ABS(self.cumulateX)<1024/8)){
            addIndex=NO;
        }
        else{
            /*
            NSMutableArray *ar = [[NSMutableArray alloc] initWithCapacity:self.imageArray.count];
            for (int i=0; i<self.imageArray.count; ++i) {
                NSNumber *num = self.originCenterXArray[i];
                float f = [num floatValue];
                f = f+sign*(1024+5);
                NSNumber *num1 = [NSNumber numberWithFloat:f];
                
                [ar addObject:num1];
            }
            
            self.originCenterXArray=ar;*/
            
            //NSLog(@"array:%@",ar);
        }
        self.cumulateX=0;
        [UIView animateWithDuration:0.4 delay:0
            options: UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                /*
                 //NSLog(@"array:%@",self.originCenterXArray);
                 for(int i=0;i<self.imageArray.count;++i)
                 {
                 NSNumber *s = self.originCenterXArray[i];
                 CGFloat x= [s floatValue];
                 REMImageView *image = self.imageArray[i];
                 [image setCenter: CGPointMake( x,image.center.y)];
                 }*/
            } completion:^(BOOL finished){
            
                self.currentWidgetIndex = self.currentWidgetIndex+sign*-1;

            }];
    }
        
}


- (void)popToBuildingCover{
    [self performSegueWithIdentifier:@"exitWidgetSegue" sender:self];
}




/*

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
 
    }
    return self;
}


- (void)initDiagram
{
    switch (self.widgetObj.diagramType) {
        case REMDiagramTypeLine:
            self.chartController= [[REMWidgetMaxLineViewController alloc]init];
            break;
        case REMDiagramTypeColumn:
            self.chartController= [[REMWidgetMaxColumnViewController alloc]init];
            break;
        case REMDiagramTypePie:
            self.chartController= [[REMWidgetMaxPieViewController alloc]init];
            break;
 
        default:
            break;
    }
    self.chartController.maxViewController = self;
 
    //self.chartController = [[REMWidgetMaxPieViewController alloc]init];
    self.chartController.data=self.data;
    self.chartController.chartView=self.chartView;
    self.chartController.widgetModel = self.widgetObj;
 
 
 
    [self.chartController initDiagram];
}

- (void)reloadChart
{
    self.chartController.data=self.data;
 
    [self.chartController reloadChart];
 
 
    [self setStepButtonWithRange:self.viewTimeRange Step:((REMEnergyStep)[self.widgetObj.contentSyntax.step integerValue])];
 
//    [self.stepToolbar setNeedsDisplay];
//    [self.stepToolbar setNeedsLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:16/255.0f green:127/255.0f blue:66/255.0f alpha:1];
 
    if([self.widgetObj.contentSyntax.relativeDate isEqual:[NSNull null]] == NO)
    {
        self.viewRelativeDateString = [NSString stringWithString:self.widgetObj.contentSyntax.relativeDate];
    }
    else
    {
        self.viewRelativeDateString = @"Customize";
        
    }
    //self.viewRelativeDateString = self.widgetObj.contentSyntax.relativeDate;
    
    REMTimeRange *range = self.widgetObj.contentSyntax.timeRanges[0];
    
    
    self.viewTimeRange =[[ REMTimeRange alloc]initWithStartTime:[range.startTime copy]  EndTime:[range.endTime copy]];
    
    //self.viewTimeRange  = self.widgetObj.contentSyntax.timeRanges[0];
    
    
    if([self.viewRelativeDateString isEqualToString:@"Customize"] == YES)
    {
        [self setStartDate:self.viewTimeRange.startTime];
        [self setEndDate:self.viewTimeRange.endTime];
    }
    
        NSString *text=[REMEnergyConstants sharedRelativeDateDictionary][self.viewRelativeDateString];
        [self setRelativeDate:self.viewRelativeDateString WithText:text];
    [self setStepButtonWithRange:self.viewTimeRange Step:((REMEnergyStep)[self.widgetObj.contentSyntax.step integerValue])];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initDiagram];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"relativeDateSegue"] ==YES)
    {
        REMWidgetRelativeDateTableViewController *table= (REMWidgetRelativeDateTableViewController *) segue.destinationViewController;
        
        table.popController = ((UIStoryboardPopoverSegue *)segue).popoverController;
        table.maxController=self;
        table.relativeDataString=self.viewRelativeDateString;
    }
    
    if([segue.identifier isEqualToString:@"endTimeSegue"]==YES)
    {
        REMWidgetTimePickerViewController *timeController =  segue.destinationViewController;
        
        timeController.dateTime=self.viewTimeRange.endTime;
        timeController.popController=((UIStoryboardPopoverSegue *)segue).popoverController;
        timeController.maxController=self;
        timeController.type=@"end";
    }
    
    
    if([segue.identifier isEqualToString:@"startTimeSegue"]==YES)
    {
        REMWidgetTimePickerViewController *timeController =  segue.destinationViewController;
        
        timeController.dateTime=self.viewTimeRange.startTime;
        timeController.popController=((UIStoryboardPopoverSegue *)segue).popoverController;
        timeController.maxController=self;
        timeController.type=@"start";
    }
    if([segue.identifier isEqualToString:@"legendSegue"])
    {
        REMChartLegendTableViewController *legendController = (REMChartLegendTableViewController *)segue.destinationViewController;
        
        legendController.popoverViewController = ((UIStoryboardPopoverSegue *)segue).popoverController;
        legendController.maxViewController = self;
        legendController.chartController = self.chartController;
        legendController.targetEnergyData = self.data.targetEnergyData;
    }
}

- (void)setStepButtonWithRange:(REMTimeRange *)range Step:(REMEnergyStep)step
{
    long diff = [range.endTime timeIntervalSinceDate:range.startTime];
    NSMutableArray *lvs=[[NSMutableArray alloc]initWithCapacity:7];
    [lvs addObject:[NSNumber numberWithLong:REMDAY]];
    [lvs addObject:[NSNumber numberWithLong:REMWEEK]];
    [lvs addObject:[NSNumber numberWithLong:REMDAY*31]];
    [lvs addObject:[NSNumber numberWithLong:REMDAY*31*3]];
    [lvs addObject:[NSNumber numberWithLong:REMYEAR]];
    [lvs addObject:[NSNumber numberWithLong:REMYEAR*2]];
    
    [lvs addObject:[NSNumber numberWithLong:REMYEAR*10]];
    
    //long[ *lvs = @[REMDAY,REMWEEK,31*REMDAY,31*3*REMDAY,REMYEAR,REMYEAR*2,REMYEAR*10];
    int i=0;
    for ( ; i<lvs.count; ++i)
    {
        NSNumber *num = lvs[i];
        if(diff<=[num longValue])
        {
            break;
        }
    }
    NSMutableArray *list=[[NSMutableArray alloc] initWithCapacity:3];
    NSMutableArray *titleList=[[NSMutableArray alloc] initWithCapacity:3];
    switch (i) {
        case 0:
            [list addObject:[NSNumber numberWithInt:1]];
            [titleList addObject:@"H"];
            break;
        case 1:
            [list addObject:[NSNumber numberWithInt:1]];
            [list addObject:[NSNumber numberWithInt:2]];
                        [titleList addObject:@"H"];
                        [titleList addObject:@"D"];
            break;
        case 2:
            [list addObject:[NSNumber numberWithInt:2]];
            [list addObject:[NSNumber numberWithInt:5]];
                        [titleList addObject:@"D"];
                        [titleList addObject:@"W"];
            break;
        case 3:
            [list addObject:[NSNumber numberWithInt:2]];
            [list addObject:[NSNumber numberWithInt:3]];
            [list addObject:[NSNumber numberWithInt:5]];
                        [titleList addObject:@"D"];
                        [titleList addObject:@"W"];
                        [titleList addObject:@"M"];
            break;
        case 4:
            [list addObject:[NSNumber numberWithInt:3]];
            [titleList addObject:@"M"];
            break;
        case 5:
            [list addObject:[NSNumber numberWithInt:3]];
            [list addObject:[NSNumber numberWithInt:4]];
            [titleList addObject:@"M"];
            [titleList addObject:@"Y"];
            break;
        case 6:
            [list addObject:[NSNumber numberWithInt:3]];
            [list addObject:[NSNumber numberWithInt:4]];
            [titleList addObject:@"M"];
            [titleList addObject:@"Y"];
        default:
            break;
    }
    self.currentStepList=list;
    [self.stepButton removeAllSegments];

    [self.stepButton initWithItems:titleList];
    NSNumber *newStep = [NSNumber numberWithInt:((int)step)];
    NSUInteger idx;
    if([list containsObject:newStep] == YES)
    {
        idx= [list indexOfObject:newStep];
    }
    else
    {
        newStep = list[0];
        idx =  [newStep intValue];
    }
    
    [self.stepButton setSelectedSegmentIndex:idx];
    
}

- (void)stepChanged:(UISegmentedControl *)sender
{
    if(sender.selected ==YES)
    {
        
        NSMutableDictionary *newParam = [self.widgetObj.contentSyntax.params copy];
        
        NSMutableDictionary *viewOption = [newParam[@"viewOption"] mutableCopy];
        
        NSInteger idx = sender.selectedSegmentIndex;
        
        NSNumber *step= self.currentStepList[idx];
        
        [viewOption setObject:step forKey: @"Step"];
        
        [self searchData:viewOption];
    }
}

- (void)setStartDate:(NSDate *)date
{
    [self.startDateButton setTitle:[REMTimeHelper formatTimeFullHour:date isChangeTo24Hour:NO] forState:UIControlStateNormal];
    self.viewTimeRange.startTime=date;
    [self setRelativeDate:@"Customize" WithText:nil];
}

- (void)setEndDate:(NSDate *)date
{
    [self.endDateButton setTitle:[REMTimeHelper formatTimeFullHour:date isChangeTo24Hour:YES] forState:UIControlStateNormal];
    self.viewTimeRange.endTime=date;
        [self setRelativeDate:@"Customize" WithText:nil];
}


- (void)setRelativeDate:(NSString *)relativeDateString WithText:(NSString *)text
{
    if(text == nil)
    {
        text = [REMEnergyConstants sharedRelativeDateDictionary][relativeDateString];
    }
    [self.relativeDateButton setTitle:text forState:UIControlStateNormal];
    [self.relativeDateButton setTitle:text forState:UIControlStateHighlighted];
    [self.relativeDateButton setTitle:text forState:UIControlStateSelected];
    
    if([relativeDateString isEqualToString:@"Customize"] == NO)
    {
        REMTimeRange *range=    [REMTimeHelper relativeDateFromString:relativeDateString];
        //NSString *startTime = [REMTimeHelper formatTimeFullHour:range.startTime];
        
        [self.startDateButton setTitle:[REMTimeHelper formatTimeFullHour:range.startTime isChangeTo24Hour:NO] forState:UIControlStateNormal];
        [self.endDateButton setTitle:[REMTimeHelper formatTimeFullHour:range.endTime isChangeTo24Hour:YES] forState:UIControlStateNormal];
        
        self.viewTimeRange = range;
    }
    else
    {
        
    }
    
    self.viewRelativeDateString=relativeDateString;
//     [self setStepButtonWithRange:self.viewTimeRange Step:((REMEnergyStep)[self.widgetObj.contentSyntax.step integerValue])];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) searchData:(NSDictionary *)param
{
    REMDataStore *store = [[REMDataStore alloc] initWithEnergyStore:self.widgetObj.contentSyntax.storeType parameter:param];
    store.maskContainer = self.view;
    store.groupName = nil;
    
    void (^retrieveSuccess)(id data)=^(id data) {
        self.data = [[REMEnergyViewData alloc] initWithDictionary:(NSDictionary *)data];
        
        [self reloadChart];
        
    };
    void (^retrieveError)(NSError *error, id response) = ^(NSError *error, id response) {
        //self.widgetTitle.text = [NSString stringWithFormat:@"Error: %@",error.description];
    };
    
    
    [REMDataAccessor access:store success:retrieveSuccess error:retrieveError];
}

- (IBAction)searchClick:(UIButton *)sender {
    
    NSMutableDictionary *newParam = [self.widgetObj.contentSyntax.params copy];
    
    NSMutableDictionary *viewOption = [newParam[@"viewOption"] mutableCopy];
    [viewOption setObject:@[[self.viewTimeRange toJsonDictionary]] forKey: @"TimeRanges"];
    
    [self searchData:newParam];
    
}

#pragma mark - navigation bar item actions

- (IBAction) legendTap:(id)sender
{
    [self performSegueWithIdentifier:@"legendSegue" sender:self];
}
- (IBAction) renameTap:(UIButton *)sender
{}
- (IBAction) deleteTap:(UIButton *)sender
{}
- (IBAction) favoriteTap:(UIButton *)sender
{}
*/
@end
