//
//  REMGallaryViewController.h
//  Blues
//
//  Created by 张 锋 on 9/30/13.
//
//

#import <UIKit/UIKit.h>
#import "REMGallaryView.h"
#import "REMMapViewController.h"

@interface REMGallaryViewController : UICollectionViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) REMMapViewController *mapViewController;
@property (nonatomic) CGRect viewFrame;
@property (nonatomic) CGRect originalFrame;

@end
