//
//  REMWidgetCollectionViewController.m
//  Blues
//
//  Created by tantan on 9/27/13.
//
//

#import "REMWidgetCollectionViewController.h"
#import "REMWidgetMaxView.h"
@interface REMWidgetCollectionViewController ()

@property (nonatomic,strong) NSMutableDictionary *widgetLoadedStatus;

@end

@implementation REMWidgetCollectionViewController

static NSString *cellId=@"widgetcell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    
    //[flowlayout setItemSize: CGSizeMake(100, 100)];
    [flowlayout setItemSize:CGSizeMake(250, 160)];
    
    self.collectionView=[[REMDashboardCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowlayout];
    [self.collectionView setFrame:self.viewFrame];
    self.view=self.collectionView;
    [self.collectionView registerClass:[REMDashboardCollectionCellView class] forCellWithReuseIdentifier:cellId];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //return 3;
    return self.widgetArray.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    REMDashboardCollectionCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    REMWidgetObject *widget=self.widgetArray[indexPath.row];
    
    if(self.widgetLoadedStatus==nil){
        self.widgetLoadedStatus = [[NSMutableDictionary alloc]initWithCapacity:self.widgetArray.count];
    }
    
    [cell initWidgetCell:widget ];
    
    
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onWidgetTap:)];
    [cell addGestureRecognizer:tap];
    
    return cell;
    
}
-(void)onWidgetTap:(UITapGestureRecognizer *)sender {
    REMDashboardCollectionCellView *cell = (REMDashboardCollectionCellView*)sender.view;
    REMWidgetMaxView* maxView = [[REMWidgetMaxView alloc]initWithSuperView:self.view widgetCell:cell];
    
    [maxView show:YES];
}


- (void)snapshotChartView:(NSTimer *)timer{
    NSIndexPath *indexPath=timer.userInfo;
    REMDashboardCollectionCellView *cell=(REMDashboardCollectionCellView *)[self collectionView:self.collectionView cellForItemAtIndexPath:indexPath];
    //REMDashboardCollectionCellView *cell=timer.userInfo;
    UIGraphicsBeginImageContextWithOptions(cell.chartContainer.frame.size, NO, 0.0);
    [cell.chartContainer.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //UIImageView *v = [[UIImageView alloc]initWithImage:image];
    
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, cell.chartContainer.frame.size.width, cell.chartContainer.frame.size.height)];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.tag= indexPath.row;
    [button addTarget:self action:@selector(widgetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    if(cell.chartContainer.subviews.count>0){
        UIView *chartView=cell.chartContainer.subviews[0];
        [chartView removeFromSuperview];
        [cell.chartContainer addSubview:button];
    }
    
}

- (void)widgetButtonPressed:(UIButton *)button{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:button.tag inSection:0];
    REMWidgetObject *widget=self.widgetArray[indexPath.row];
    NSLog(@"click widget:%@",widget.name);
}




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
