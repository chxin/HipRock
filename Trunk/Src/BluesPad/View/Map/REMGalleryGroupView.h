//
//  REMGalleryGroupCell.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 10/29/13.
//
//

#import <UIKit/UIKit.h>

@interface REMGalleryGroupView : UITableViewCell

//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andFrame:(CGRect)frame;

-(void)setGroupTitle:(NSString *)title;
-(void)setCollectionView:(UICollectionView *)collectionView;

@end