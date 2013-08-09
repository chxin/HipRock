//
//  REMBuildingChartContainerView.h
//  Blues
//
//  Created by tantan on 8/9/13.
//
//

#import "REMBuildingTitleView.h"
#import "REMBuildingConstants.h"

@interface REMBuildingChartContainerView : REMBuildingTitleView

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title andTitleFontSize:(CGFloat)size;

- (void)requireChartDataWithBuildingId:(NSNumber *)buildingId withCommodityId:(NSNumber *)commodityId;

@end
