//
//  REMEnergySeacherBase.h
//  Blues
//
//  Created by tantan on 10/9/13.
//
//

#import <Foundation/Foundation.h>
#import "REMEnum.h"
#import "REMWidgetContentSyntax.h"

@interface REMEnergySeacherBase : NSObject

+ (REMEnergySeacherBase *)querySearcherByType:(REMDataStoreType) storeType;

- (void)queryEnergyDataByStoreType:(REMDataStoreType)storeType andParameters:(NSDictionary *)params withMaserContainer:(UIView *)maskerContainer callback:(void(^)(id))callback;


@end
