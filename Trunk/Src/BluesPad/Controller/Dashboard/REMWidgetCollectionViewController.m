//
//  REMWidgetCollectionViewController.m
//  Blues
//
//  Created by tantan on 9/27/13.
//
//

#import "REMWidgetCollectionViewController.h"
#import "REMWidgetMaxView.h"
#import "REMWidgetCellViewController.h"
#import "REMMaxWidgetSegue.h"

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




- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)flowlayout
{
    if(self = [super initWithCollectionViewLayout:flowlayout]){
        
        //[flowlayout setMinimumInteritemSpacing:8];
        
        [flowlayout setSectionInset:UIEdgeInsetsZero];
        
        //[flowlayout setItemSize: CGSizeMake(100, 100)];
        [flowlayout setItemSize:CGSizeMake(233, 157)];
        
    }
    
    return self;
}




- (void)viewDidLoad{
    [super viewDidLoad];
    [self.collectionView setFrame:self.viewFrame];
    self.view=self.collectionView;
    //        NSLog(@"colletion view1:%@",NSStringFromCGRect(self.view.frame));
    [self.collectionView registerClass:[REMDashboardCollectionCellView class] forCellWithReuseIdentifier:cellId];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setScrollEnabled:NO];
    [self.collectionView setContentInset:UIEdgeInsetsZero];
    self.collectionView.layer.borderColor=[UIColor yellowColor].CGColor;
    self.collectionView.layer.borderWidth=1;
}





- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dashboardInfo.widgets.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 14, 0);
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    REMDashboardCollectionCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    if(cell.contentView.subviews.count>0)return cell;
    
    REMWidgetCellViewController *controller=[[REMWidgetCellViewController alloc]init];
    controller.viewFrame=cell.contentView.bounds;
    REMWidgetObject *widget=self.dashboardInfo.widgets[indexPath.row];
    
    controller.widgetInfo=widget;
    
    controller.currentIndex=indexPath.row;
    
    [self addChildViewController:controller];
    
    [cell.contentView addSubview:controller.view];
    
    
    
    return cell;
    
}


- (void)maxWidget{

    
    REMWidgetObject *obj=self.dashboardInfo.widgets[self.currentMaxWidgetIndex];
    
    self.currentMaxWidgetId=obj.widgetId;
    
    REMDashboardController *parent=(REMDashboardController *)self.parentViewController;
    
    parent.currentMaxDashboardIndex=self.currentDashboardIndex;
    parent.currentMaxDashboardId=self.dashboardInfo.dashboardId;
    
    [parent maxWidget];
    
    //[self.buildingController performSegueWithIdentifier:@"maxWidgetSegue" sender:self];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
