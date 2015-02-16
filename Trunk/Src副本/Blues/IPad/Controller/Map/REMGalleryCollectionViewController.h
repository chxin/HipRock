//
//  REMGalleryCollectionViewController.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//
//  Created by 张 锋 on 10/29/13.
//
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "REMMapKitViewController.h"
@class REMGalleryCollectionCell;

@interface REMGalleryCollectionViewController : UICollectionViewController<UICollectionViewDataSource>

@property (nonatomic,strong) NSString *collectionKey;
@property (nonatomic,strong) NSArray *buildingInfoArray;
@property (nonatomic,weak) REMMapKitViewController *mapViewController;


- (void)galleryCellTapped:(REMGalleryCollectionCell *)cell;
-(void)galleryCellPinched:(REMGalleryCollectionCell *)cell :(UIPinchGestureRecognizer *)pinch;



-(id)initWithKey:(NSString *)key andBuildingInfoArray:(NSArray *)buildingInfoArray;

-(REMGalleryCollectionCell *)cellForBuilding:(NSNumber *)buildingId;

@end

