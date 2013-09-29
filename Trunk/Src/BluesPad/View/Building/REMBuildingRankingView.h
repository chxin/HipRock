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

@property (nonatomic,weak) REMRankingDataModel *data;

- (id)initWithFrame:(CGRect)frame;

@end
