/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMBuildingRankingView.h
 * Created      : tantan on 8/6/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMBuildingTitleView.h"
#import "REMRankingDataModel.h"
#import "REMNumberLabel.h"
#import "REMBuildingConstants.h"

@interface REMBuildingRankingView : REMBuildingTitleView

@property (nonatomic,weak) REMRankingDataModel *data;

- (id)initWithFrame:(CGRect)frame;

@end
