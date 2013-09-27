//
//  REMWidgetCollectionViewController.h
//  Blues
//
//  Created by tantan on 9/27/13.
//
//

#import <UIKit/UIKit.h>
#import "REMDashboardCollectionView.h"
#import "REMDashboardCollectionCellView.h"

@interface REMWidgetCollectionViewController : UICollectionViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (nonatomic) CGRect viewFrame;

@property (nonatomic,weak) NSArray *widgetArray;

@end
