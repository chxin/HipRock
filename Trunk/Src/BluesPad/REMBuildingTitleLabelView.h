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

@interface REMBuildingTitleLabelView : REMBuildingTitleView

- (id)initWithFrame:(CGRect)frame withData:(REMEnergyUsageDataModel *)data withTitle:(NSString *)title andTitleFontSize:(CGFloat)size;

@end
