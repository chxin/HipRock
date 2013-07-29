//
//  REMDashboardObj.h
//  Blues
//
//  Created by TanTan on 7/4/13.
//
//

#import "REMJSONObject.h"
#import "REMWidgetObject.h"

@interface REMDashboardObj : REMJSONObject

@property (nonatomic,strong) NSNumber *dashboardId;
@property (nonatomic,strong) NSNumber *hierarchyId;
@property (nonatomic,strong) NSString *hierarchyName;
@property (nonatomic) BOOL isFavorate;
@property  (nonatomic) BOOL isRead;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSArray *widgets;

@end
