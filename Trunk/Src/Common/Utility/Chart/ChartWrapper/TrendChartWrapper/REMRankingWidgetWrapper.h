//
//  REMRankingWidgetWrapper.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 10/22/13.
//
//

#import "REMTrendWidgetWrapper.h"

@interface REMRankingWidgetWrapper : REMTrendWidgetWrapper
@property (nonatomic) NSComparisonResult sortOrder;
@property (nonatomic, assign) uint location;
@property (nonatomic, assign) uint length;

-(void)reloadData;
@end
