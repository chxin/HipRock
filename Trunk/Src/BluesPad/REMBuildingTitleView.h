//
//  REMBuildingTitleView.h
//  TestImage
//
//  Created by tantan on 7/31/13.
//  Copyright (c) 2013 demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMBuildingConstants.h"


@interface REMBuildingTitleView : UIView

@property (nonatomic,strong) UILabel *titleLabel;

- (void)initTitle:(NSString *)text withSize:(CGFloat)size;

- (NSString *)addThousandSeparator:(NSNumber *)number;

@end
