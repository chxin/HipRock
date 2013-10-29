//
//  REMBuildingRankingView.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
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
