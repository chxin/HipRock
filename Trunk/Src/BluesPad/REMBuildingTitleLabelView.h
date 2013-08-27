//
//  REMBuildingTitleLabelView.h
//  TestImage
//
//  Created by tantan on 7/31/13.
//  Copyright (c) 2013 demo. All rights reserved.
//

#import "REMBuildingTitleView.h"
#import "REMEnergyUsageDataModel.h"
#import "REMNumberLabel.h"
#import "REMBuildingConstants.h"
#import <CoreText/CoreText.h>

@interface REMBuildingTitleLabelView : REMBuildingTitleView

- (id)initWithFrame:(CGRect)frame
           withData:(REMEnergyUsageDataModel *)data
           withTitle:(NSString *)title andTitleFontSize:(CGFloat)size
            withTitleMargin:(CGFloat)margin
            withLeftMargin:(CGFloat)leftMargin
            withValueFontSize:(CGFloat)size withUomFontSize:(CGFloat) size;



@end
