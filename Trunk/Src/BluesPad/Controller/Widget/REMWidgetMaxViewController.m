/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetMaxViewController.m
 * Created      : TanTan on 7/1/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMWidgetMaxViewController.h"
#import "REMWidgetDetailViewController.h"
#import "REMWidgetCellViewController.h"
#import "REMScreenEdgetGestureRecognizer.h"


const static CGFloat widgetGap=10;


@interface REMWidgetMaxViewController()

@property (nonatomic) CGFloat cumulateX;


@property (nonatomic) CGFloat speed;
@property (nonatomic,weak) NSTimer *timer;
@property (nonatomic,weak) NSTimer *stopTimer;

@property (nonatomic) CGFloat delta;

@property (nonatomic) CGFloat speedBase;

@property (nonatomic,weak) UIView *bloodView;
@property (nonatomic,weak) UIView *bloodWhiteView;
@property (nonatomic,weak) UIImageView *srcBg;
@property (nonatomic) CGRect origSrcBgFrame;

@property (nonatomic) BOOL readyToClose;

@property (nonatomic,weak) UIView *glassView;

@property (nonatomic,strong) NSString *groupName;

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
    [self.view setBackgroundColor:[UIColor blackColor]];
    self.cumulateX=0;
    self.speedBase=1280;
    self.readyToClose=NO;
    self.groupName=[NSString stringWithFormat:@"widget-%@",self.dashboardInfo.dashboardId];
    [self addDashboardBg];
    for (int i=0; i<self.dashboardInfo.widgets.count; ++i) {
        REMWidgetObject *obj=self.dashboardInfo.widgets[i];
        
        REMWidgetDetailViewController *sub=[[REMWidgetDetailViewController alloc]init];
        sub.widgetInfo=obj;
        sub.groupName=self.groupName;
        REMWidgetCellViewController *cellController= self.widgetCollectionController.childViewControllers[i];
        sub.energyData=cellController.chartData;
        
        
        [self addChildViewController:sub];
        
        UIView *view = sub.view;
        [view setFrame:CGRectMake(i*self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
        
        
        NSInteger gap=i-self.currentWidgetIndex;
        [sub.view setCenter:CGPointMake(gap*(self.view.frame.size.width+widgetGap)+self.view.frame.size.width/2, self.view.center.y)];
        
        [self.view addSubview:sub.view];
        
        if(i==self.currentWidgetIndex || i==(self.currentWidgetIndex-1) || i == (self.currentWidgetIndex+1)){
            [sub showChart];
        }
    }
    
    [self addBloodCell];
    
    REMScreenEdgetGestureRecognizer *rec=[[REMScreenEdgetGestureRecognizer alloc]initWithTarget:self action:@selector(panthis:)];
    [self.view addGestureRecognizer:rec];
    
    
}

- (void) addBloodCell{
    NSBundle* mb = [NSBundle mainBundle];
    UIImageView *whiteView= [[UIImageView alloc]initWithImage:[[UIImage alloc]initWithContentsOfFile:[mb pathForResource:@"Oil_normal" ofType:@"png"]]];
    //whiteView.clipsToBounds = YES;
    CGFloat bloodCellX=self.view.frame.size.width-45-30;
    CGFloat bloodCellY=self.view.frame.size.height/2+whiteView.frame.size.height/2;
    [whiteView setFrame:CGRectMake(bloodCellX, bloodCellY, 45,45)];
    UIImageView* greenView = [[UIImageView alloc]initWithImage:[[UIImage alloc]initWithContentsOfFile:[mb pathForResource:@"Oil_pressed" ofType:@"png"]]];
    greenView.clipsToBounds=YES;
    greenView.contentMode=UIViewContentModeBottomRight;
    
    [greenView setFrame:CGRectMake(whiteView.frame.origin.x+whiteView.frame.size.width, whiteView.frame.origin.y, 0, whiteView.frame.size.height)];
    
    whiteView.backgroundColor=[UIColor clearColor];
    greenView.backgroundColor=[UIColor clearColor];
    UIViewController *vc= self.childViewControllers[0];
    [self.view insertSubview:greenView belowSubview:vc.view];
    [self.view insertSubview:whiteView belowSubview:greenView];
    self.bloodView=greenView;
    self.bloodWhiteView=whiteView;
    [self.bloodWhiteView setHidden:YES];
    [self.bloodView setHidden:YES];
    
    //NSLog(@"blood white view:%@",NSStringFromCGRect(self.bloodWhiteView.frame));
    
}

- (void) addDashboardBg{
    REMDashboardController *srcController=(REMDashboardController *) self.widgetCollectionController.parentViewController;
    
    UIImage *image=[REMImageHelper imageWithView:srcController.buildingController.view];
    UIImageView *view = [[UIImageView alloc]initWithImage:image];
    [view setFrame:self.view.frame];
    [view setFrame:CGRectMake(200, 200, view.frame.size.width-400, view.frame.size.height-400)];
    self.origSrcBgFrame=view.frame;
    
    [self.view addSubview:view];
    self.srcBg=view;
    [self.srcBg setHidden:YES];
    
    UIView *glassView = [[UIView alloc]initWithFrame:self.view.frame];
    glassView.alpha=0;
    glassView.contentMode=UIViewContentModeScaleToFill;
    glassView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    [self.view addSubview:glassView];
    
    self.glassView=glassView;
}


- (void) readyToComplete{
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(stopCoverPage:) userInfo:nil repeats:NO];
    
    NSRunLoop *current=[NSRunLoop currentRunLoop];
    [current addTimer:timer forMode:NSDefaultRunLoopMode];
    self.stopTimer = timer;
}

- (void) moveAllViews{
    for (int i=0; i<self.childViewControllers.count; ++i) {
        REMWidgetDetailViewController *vc = self.childViewControllers[i];
        NSInteger gap=i-self.currentWidgetIndex;
        [vc.view setCenter:CGPointMake(gap*(self.view.frame.size.width+widgetGap)+self.view.frame.size.width/2, vc.view.center.y)];
        //NSLog(@"view center:%@",NSStringFromCGRect(vc.view.frame));
        
    }
}

- (void)cancelAllRequest{
    [REMDataAccessor cancelAccess:self.groupName];
}

- (void)panthis:(REMScreenEdgetGestureRecognizer *)pan{
    
    [self cancelAllRequest];
    
    if(self.timer!=nil){
        [self.timer invalidate];
        [self readyToComplete];
    }
    
    
    CGPoint trans= [pan translationInView:self.view];
    
    
    if(pan.state== UIGestureRecognizerStateChanged)
    {
        
        
        for (int i=0;i<self.childViewControllers.count;++i)
        {
            REMWidgetDetailViewController *vc = self.childViewControllers[i];
            if(self.currentWidgetIndex == 0 && self.cumulateX>0){
                //NSLog(@"src bg:%@",NSStringFromCGRect(self.srcBg.frame));
                [self.srcBg setHidden:NO];
                if(ABS(self.cumulateX)<300 && self.srcBg.frame.origin.x>=0){
                    CGFloat rate=200.0f/160.0f;
                    CGFloat delta=self.cumulateX*rate;
                    CGFloat x=self.origSrcBgFrame.origin.x- delta;
                    if(x<0){
                        [self.srcBg setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                    }
                    else{
                        [self.srcBg setFrame:CGRectMake(x, self.origSrcBgFrame.origin.y- delta, self.origSrcBgFrame.size.width+ 2*delta, self.origSrcBgFrame.size.height+ 2*delta)];
                        CGFloat blurLevel=0.8*self.cumulateX/160.0f;
                        self.glassView.alpha=MAX(0,MIN(blurLevel,0.8));
                    }
                    [self.bloodWhiteView setHidden:YES];
                    [self.bloodView setHidden:YES];
                }
                //NSLog(@"bg frame:%@",NSStringFromCGRect(self.srcBg.frame));
                if(self.srcBg.frame.origin.x>0){
                    
                    self.readyToClose=NO;
                }
                else{
                    self.readyToClose=YES;
                }
                
            }
            else if((self.currentWidgetIndex==(self.dashboardInfo.widgets.count-1)) && self.cumulateX<0){
                [self.bloodView setHidden:NO];
                [self.bloodWhiteView setHidden:NO];
                if(ABS(self.cumulateX)<160 && self.bloodView.frame.size.width<=self.bloodWhiteView.frame.size.width){
                    [self.bloodView setFrame:CGRectMake(self.bloodWhiteView.frame.origin.x+self.bloodWhiteView.frame.size.width+self.cumulateX/3,self.bloodWhiteView.frame.origin.y, -self.cumulateX/3, self.bloodWhiteView.frame.size.height)];
                    [self.srcBg setHidden:YES];
                }
                else{
                    self.bloodView.frame=self.bloodWhiteView.frame;
                }
                if (self.bloodView.frame.origin.x>self.bloodWhiteView.frame.origin.x) {
                    self.readyToClose=NO;
                    //NSLog(@"blood view:%@",NSStringFromCGRect(self.bloodView.frame));
                }
                else{
                    
                    self.readyToClose=YES;
                }
                

            }
            
            [vc.view setCenter:CGPointMake(vc.view.center.x+trans.x, vc.view.center.y)];
            
        }
        
        self.cumulateX+=trans.x;
        //NSLog(@"cumulate x:%f",self.cumulateX);
    }
    
    if(pan.state == UIGestureRecognizerStateEnded||pan.state == UIGestureRecognizerStateCancelled)
    {
        if(self.readyToClose==YES){
            [self popToBuildingCover];
            return;
        }
        
        CGPoint p= [pan velocityInView:self.view];
        
        int sign= p.x>0?1:-1;
        
        
        BOOL addIndex=YES;
        
        if((sign<0 && self.currentWidgetIndex==self.dashboardInfo.widgets.count-1)
           || (sign>0 && self.currentWidgetIndex==0) ||
           (ABS(p.x)<200 && ABS(self.cumulateX)<self.view.frame.size.width/8)){
            addIndex=NO;
        }
        else{
            [self.stopTimer invalidate];
            addIndex=YES;
        }
        self.cumulateX=0;
        if(addIndex == NO){
            [UIView animateWithDuration:0.4 delay:0
                                options: UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                                    
                                    [self moveAllViews];
                                } completion:^(BOOL finished){}];
            
        }
        else{
            self.currentWidgetIndex = self.currentWidgetIndex+sign*-1;
            
            if(ABS(p.x)<200){
                [UIView animateWithDuration:0.4 delay:0
                                    options: UIViewAnimationOptionCurveEaseInOut animations:^(void) {
                                        
                                        [self moveAllViews];
                                    } completion:^(BOOL finished){
                                        //[self stopCoverPage:nil];
                                    }];
            }
            else{
                self.delta=M_PI_4/128.0f;
                self.speed=self.speedBase*sign*self.delta;
                
                NSTimer *timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(switchCoverPage:) userInfo:nil repeats:YES];
                self.timer=timer;
                [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            }
            
        }
    }
    [pan setTranslation:CGPointZero inView:self.view];
}


- (void)stopCoverPage:(NSTimer *)timer{
    //NSLog(@"currentIndex:%d",self.currentIndex);
    REMWidgetDetailViewController *current=self.childViewControllers[self.currentWidgetIndex];
    [current showChart];
    
    if(self.currentWidgetIndex<self.childViewControllers.count){
        CGFloat sign=self.speed<0?-1:1;
        NSNumber *willIndex= @(self.currentWidgetIndex-1*sign);
        if(willIndex.intValue>=self.childViewControllers.count || willIndex.intValue<0){
            return;
        }
        REMWidgetDetailViewController *vc= self.childViewControllers[willIndex.intValue];
       
        [vc showChart];
        
    }
    
}

- (void)switchCoverPage:(NSTimer *)timer{
    
    if (ABS(self.speed)<0.1) {
        [timer invalidate];
        [self readyToComplete];
        return;
    }
    
    CGFloat sign=self.speed<0?-1:1;
    CGFloat distance=self.speed;
    
    self.delta+=M_PI_4/128.0f;
    if(self.delta>M_PI)self.delta=M_PI;
    
    self.speed=self.speedBase*sin(self.delta)*sign;
    
    for(int i=0;i<self.childViewControllers.count;++i)
    {
        REMWidgetDetailViewController *vc=self.childViewControllers[i];
        UIView *v=vc.view;
        //NSLog(@"image:%@",NSStringFromCGRect(image.frame));
        CGFloat readyDis=v.center.x+distance;
        CGFloat gap=i-(int)self.currentWidgetIndex;
        NSLog(@"gap is %f",gap);
        CGFloat page=self.view.frame.size.width+widgetGap;
        NSLog(@"page is %f",page);
        CGFloat x=gap*page+self.view.frame.size.width/2;
        NSLog(@"x:%f,readyDis:%f",x,readyDis);
        if((distance < 0 &&readyDis<x) || (distance>0 && readyDis>x)){
            self.speed=sign*0.01;
            readyDis=x;
        }
        
        [v setCenter: CGPointMake(readyDis,v.center.y)];
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
