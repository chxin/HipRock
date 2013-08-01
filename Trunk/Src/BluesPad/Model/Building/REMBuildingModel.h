//
//  REMBuildingModel.h
//  Blues
//
//  Created by 张 锋 on 8/1/13.
//
//

#import <Foundation/Foundation.h>
#import "REMCommonHeaders.h"

@interface REMBuildingModel : REMJSONObject

@property (nonatomic,strong) NSNumber *buildingId, *parentId, *timezoneId, *customerId;
@property (nonatomic,strong) NSString *name,*code,*comment, *path;
@property (nonatomic) NSInteger pathLevel;
@property (nonatomic) BOOL hasDataPrivilege;

@end
