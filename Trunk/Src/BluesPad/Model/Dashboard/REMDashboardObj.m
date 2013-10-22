//
//  REMDashboardObj.m
//  Blues
//
//  Created by TanTan on 7/4/13.
//
//

#import "REMDashboardObj.h"

@implementation REMDashboardObj

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.dashboardId = dictionary[@"Id"];
    self.name=dictionary[@"Name"];
    self.hierarchyId=(NSNumber *)dictionary[@"HierarchyId"];
    self.hierarchyName=(NSString *)dictionary[@"HierarchyName"];
    self.isFavorate=(BOOL)dictionary[@"IsFavorite"];
    self.isRead=(BOOL)dictionary[@"IsRead"];
    
    NSArray *array = (NSArray *) dictionary[@"Widgets"];
    NSMutableArray *widgets=[[NSMutableArray alloc]initWithCapacity:array.count];
    for(NSDictionary *dic in array)
    {
        REMWidgetObject *w = [[REMWidgetObject alloc]initWithDictionary:dic];
        if([w.contentSyntax.type isEqualToString:@"grid"]==NO){
            [widgets addObject:w];
        }
    }
    
    self.widgets=widgets;
    
    NSDictionary *shareInfo = dictionary[@"SimpleShareInfo"];
    
    if(shareInfo!=nil){
        self.shareInfo=[[REMShareInfo alloc]initWithDictionary:shareInfo];
    }
    
}

@end
