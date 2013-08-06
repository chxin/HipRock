//
//  REMBuildingRankingView.h
//  Blues
//
//  Created by tantan on 8/6/13.
//
//

#import "REMBuildingTitleView.h"
#import "REMRankingDataModel.h"
#import "REMNumberLabel.h"
#import "REMBuildingConstants.h"

@interface REMBuildingRankingView : REMBuildingTitleView


- (id)initWithFrame:(CGRect)frame
           withData:(REMRankingDataModel *)data
          withTitle:(NSString *)title andTitleFontSize:(CGFloat)size;

@end
