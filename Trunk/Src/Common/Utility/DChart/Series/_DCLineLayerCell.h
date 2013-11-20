//
//  _DCLineLayerCell.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/19/13.
//
//

#import "_DCLayer.h"

@interface _DCLineLayerCell : _DCLayer
@property (nonatomic, strong) DCRange* xRange;  //Cell绘制的线条代表的xRange

-(void)updateNeedsdisplayAndFrame:(CGRect)frame;
@end
