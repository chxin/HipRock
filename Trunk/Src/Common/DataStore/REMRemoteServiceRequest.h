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

/**
 *  Back pointer to owner data store
 */
@property (nonatomic,weak) REMDataStore *dataStore;

#pragma mark - Methods
/**
 *  Request for the service
 *
 *  @param success Block that will be called when server responds as expected
 *  @param failure Block that will be called if there is any error
 */
- (void) request:(REMDataAccessSuccessBlock)success failure:(REMDataAccessFailureBlock)failure;

/**
 *  Cancel the request
 */
- (void) cancel;


@end

