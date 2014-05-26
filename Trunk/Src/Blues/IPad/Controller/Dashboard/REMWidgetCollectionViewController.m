/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetCollectionViewController.m
 * Created      : tantan on 9/27/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMWidgetCollectionViewController.h"
#import "REMWidgetCellViewController.h"
#import "REMMaxWidgetSegue.h"

@interface REMWidgetCollectionViewController ()

@property (nonatomic,strong) NSArray *widgets;

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

-(NSArray *)widgets
{
    if(_widgets == nil){
        _widgets = [self.dashboardInfo.widgets.allObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 id] compare:[obj2 id]];
        }];
    }
    
    return _widgets;
}


- (id)initWithCollectionViewLayout:(UICollectionViewFlowLayout *)flowlayout
{
    if(self = [super initWithCollectionViewLayout:flowlayout]){
        
        [flowlayout setMinimumInteritemSpacing:kDashboardWidgetInnerHorizonalMargin];
        [flowlayout setMinimumLineSpacing:kDashboardWidgetInnerVerticalMargin];
        [flowlayout setSectionInset:UIEdgeInsetsZero];
        
        [flowlayout setItemSize:CGSizeMake(kDashboardWidgetWidth, kDashboardWidgetHeight)];
        
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
    //self.collectionView.layer.borderColor=[UIColor yellowColor].CGColor;
    //self.collectionView.layer.borderWidth=1;
}





- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.widgets.count;
}

- (void)releaseContentView{
    self.view=nil;
    for (UIViewController *vc in self.childViewControllers) {
        vc.view=nil;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    REMDashboardCollectionCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    if(cell.contentView.subviews.count>0)return cell;
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    REMWidgetCellViewController *controller;
    if(self.childViewControllers.count>indexPath.row){
        controller=self.childViewControllers[indexPath.row];
    }
    else{
        controller=[[REMWidgetCellViewController alloc]init];
        controller.viewFrame=cell.contentView.bounds;
        REMManagedWidgetModel *widget=self.widgets[indexPath.row];
        
        controller.widgetInfo=widget;
        
        controller.currentIndex=indexPath.row;
        controller.groupName=self.groupName;
        [self addChildViewController:controller];
    }
    
    
    [cell.contentView addSubview:controller.view];
    
    
    
    return cell;
    
}


- (void)maxWidget{

    
    REMManagedWidgetModel *obj=self.widgets[self.currentMaxWidgetIndex];
    
    self.currentMaxWidgetId=obj.id;
    
    REMDashboardController *parent=(REMDashboardController *)self.parentViewController;
    
    parent.currentMaxDashboardIndex=self.currentDashboardIndex;
    parent.currentMaxDashboardId=self.dashboardInfo.id;
    
    [parent maxWidget];
    
    //[self.buildingController performSegueWithIdentifier:@"maxWidgetSegue" sender:self];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //NSLog(@"didReceiveMemoryWarning :%@",[self class]);
}

@end
