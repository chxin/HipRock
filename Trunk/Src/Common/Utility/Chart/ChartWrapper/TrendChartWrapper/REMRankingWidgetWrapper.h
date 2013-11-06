/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMRankingWidgetWrapper.h
 * Created      : Zilong-Oscar.Xu on 10/22/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMTrendWidgetWrapper.h"

@interface REMRankingWidgetWrapper : REMTrendWidgetWrapper
@property (nonatomic) NSComparisonResult sortOrder;
@property (nonatomic, assign) uint location;
@property (nonatomic, assign) uint length;

-(void)reloadData;
@end
