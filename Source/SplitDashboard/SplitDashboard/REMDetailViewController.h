//
//  REMDetailViewController.h
//  SplitDashboard
//
//  Created by TanTan on 6/19/13.
//  Copyright (c) 2013 TanTan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REMDetailViewController : UICollectionViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;


@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;



- (void) showChart;

- (void) showLabel;

@end
