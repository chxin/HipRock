//
//  REMRankingWidgetWrapper.h
//  Blues
//
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
