//
//  REMFavoriteDashboardObj.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by TanTan on 7/4/13.
//
//

#import "REMFavoriteDashboardObj.h"

@implementation REMFavoriteDashboardObj

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.dashboard=dictionary[@"Dashboard"];
    NSArray *array = (NSArray *) dictionary[@"Widgets"];
    NSMutableArray *widgets=[[NSMutableArray alloc]initWithCapacity:array.count];
    for(NSDictionary *dic in array)
    {
        REMWidgetObject *w = [[REMWidgetObject alloc]initWithDictionary:dic];
        [widgets addObject:w];
    }
    
    self.widgets=widgets;
}

@end
