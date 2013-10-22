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
    [flowlayout setMinimumInteritemSpacing:8];
    [flowlayout setSectionInset:UIEdgeInsetsZero];
    
    //[flowlayout setItemSize: CGSizeMake(100, 100)];
    [flowlayout setItemSize:CGSizeMake(182, 121)];
    
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
    return self.widgetArray.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    REMDashboardCollectionCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    REMWidgetObject *widget=self.widgetArray[indexPath.row];
    
    
    
    [cell initWidgetCell:widget withGroupName:self.groupName];
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onWidgetTap:)];
    [cell addGestureRecognizer:tap];
    
    
    
    return cell;
    
}
-(void)onWidgetTap:(UITapGestureRecognizer *)sender {
    REMDashboardCollectionCellView *cell = (REMDashboardCollectionCellView*)sender.view;
    if (cell.chartLoaded) {
        REMWidgetMaxView* maxView = [[REMWidgetMaxView alloc]initWithSuperView:self.view widgetCell:cell];
        
        [maxView show:YES];
    }
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
