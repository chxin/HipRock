/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMGalleryGroupCell.h
 * Created      : 张 锋 on 10/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>

@interface REMGalleryGroupView : UITableViewCell

//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andFrame:(CGRect)frame;

-(void)setGroupTitle:(NSString *)title;
-(void)setCollectionView:(UIView *)collectionView;

@end
