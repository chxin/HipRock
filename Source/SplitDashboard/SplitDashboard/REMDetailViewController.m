//
//  REMDetailViewController.m
//  SplitDashboard
//
//  Created by TanTan on 6/19/13.
//  Copyright (c) 2013 TanTan. All rights reserved.
//

#import "REMDetailViewController.h"
#import "REMMasterViewController.h"
#import "REMCell.h"

@interface REMDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation REMDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void) showLabel
{
    
}

- (void)showChart
{
  
}

- (void)configureView
{
    // Update the user interface for the detail item.

    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    REMMasterViewController *master= (REMMasterViewController *)[ [self.splitViewController.viewControllers objectAtIndex:0] topViewController];
    NSLog(@"source:%@",segue.sourceViewController);
    [master hideMaster:YES];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"detail appear");
    REMMasterViewController *master= (REMMasterViewController *)[ [self.splitViewController.viewControllers objectAtIndex:0] topViewController];
    [master hideMaster:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    NSLog(@"view loaded");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row:%d", indexPath.row );
    
    REMCell *cell;
    int ret = indexPath.row % 4;
    if(ret == 0)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"widgetCellID" forIndexPath:indexPath];
    }
    else if (ret == 1)
    {
        cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"widgetPieCellID" forIndexPath:indexPath];
    }
    else if(ret==2)
    {
        cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"widgetStackCellID" forIndexPath:indexPath];
    }
    else {
        cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"widgetBarCellID" forIndexPath:indexPath];
    }
    cell.layer.borderWidth=1;
    cell.layer.borderColor=[UIColor grayColor].CGColor;
    if ([cell isInitialized] == NO) {
        [cell initChart];
    }
    return cell;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
    
    
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
    
}

@end
