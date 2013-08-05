//
//  REMBuildingTitleView.h
//  TestImage
//
//  Created by tantan on 7/31/13.
//  Copyright (c) 2013 demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REMBuildingTitleViewData.h"
@interface REMBuildingTitleView : UIView

@property (nonatomic) CGFloat titleFontSize;

- (id)initWithFrame:(CGRect)frame ByData:(REMBuildingTitleViewData *)data;

@end
