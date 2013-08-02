//
//  REMDashboardViewController.m
//  Blues
//
//  Created by TanTan on 7/1/13.
//
//

#import "REMCommonHeaders.h"
#import "REMDashboardViewController.h"
#import "REMWidgetMaxViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface REMDashboardViewController ()

@property  (nonatomic,weak) REMEnergyViewData *currentMaxData;
@property (nonatomic,weak) REMWidgetObject *currentWidgetObj;

@end

@implementation REMDashboardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
	// Do any additional setup after loading the view.
    //self.favoriteDashboards = @[@"First",@"Second",@"Third"];
    self.navigationItem.hidesBackButton=YES;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:16/255.0f green:127/255.0f blue:66/255.0f alpha:1];
    
    //send to server to get dashboard metadata
    //[self loadAllDashboard];
}

- (void) loadAllDashboard
{
    NSNumber *customerId=[REMApplicationContext instance].currentCustomer.customerId; //[REMAppDelegate app].currentCustomer[@"Id"];
    REMLogVerbose(@"customerId:%@",customerId);
    NSDictionary *param=@{@"customerId":customerId};
    
    
    /*[REMDataAccessor access:SVC_DASHBORAD_FAVORITE withParameter:param mask:self.view store:NO success:^(id data){
        [self renderDashboard:data];
    }];*/
}

- (void) renderDashboard:(id)data
{
    NSArray *dashboardList = (NSArray *)data;
    
    REMLogVerbose(@"dashboards:%@",dashboardList);
    
    NSMutableArray *array= [[NSMutableArray alloc] initWithCapacity:dashboardList.count];
    
    for(NSDictionary *dic in dashboardList)
    {
        [array addObject:[[REMDashboardObj alloc]initWithDictionary:dic]];
    }
    
    

    //self.favoriteDashboards=array;
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Segue





- (void) showMaxWidgetByCell:(REMWidgetObject *)widget WithData:(REMEnergyViewData *)data
{
    self.mainController.currentMaxData=data;
    self.mainController.currentWidgetObj=widget;
    [self.mainController performSegueWithIdentifier:@"detailSegue" sender:self.mainController];
    
}


#pragma mark -
#pragma mark UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //NSLog(@"numberOfItems");
    //return 2;
    return self.dashboard.widgets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    REMWidgetCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:@"widgetCell" forIndexPath:indexPath];
    cell.dashboardController=self;
    //REMDashboardObj *info=self.favoriteDashboards[0];
    [cell initCellByWidget:self.dashboard.widgets[indexPath.item]];
    //cell.title.text=@"123";
    //[cell initCellByWidgetTest:self.favoriteDashboards[indexPath.item]];
    return cell;
}

@end
