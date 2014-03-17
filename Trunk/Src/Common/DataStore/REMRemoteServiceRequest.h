//
//  REMRemoteService.h
//  Blues
//
//  Created by 张 锋 on 3/14/14.
//
//

#import <Foundation/Foundation.h>
#import "REMDataStore.h"
#import "AFNetworking.h"

@interface REMRemoteServiceRequest : NSObject

@property (nonatomic,weak) REMDataStore *dataStore;

- (void) request:(REMDataAccessSuccessBlock)success failure:(REMDataAccessErrorBlock)failure;
- (void) cancel;


@end

