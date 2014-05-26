//
//  REMDataStore-Private.h
//  Blues
//
//  Created by 张 锋 on 3/20/14.
//
//

#import <Foundation/Foundation.h>
#import "REMDataStore.h"
#import "AFNetworking.h"

@interface REMDataStore (Private)

-(NSDictionary *)serviceConfigurationOfType:(REMDataStoreType)type;


@end
