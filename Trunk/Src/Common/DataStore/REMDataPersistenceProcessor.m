//
//  REMPersistentManager.m
//  Blues
//
//  Created by 张 锋 on 3/14/14.
//
//

#import "REMDataPersistenceProcessor.h"

@implementation REMDataPersistenceProcessor

/**
 *  <#Description#>
 *
 *  @param data <#data description#>
 *
 *  @return <#return value description#>
 */
- (id) persist:(id)data
{
    return nil;
}

/**
 *  <#Description#>
 *
 *  @return <#return value description#>
 */
- (id) fetch
{
    return nil;
}

/**
 *  <#Description#>
 *
 *  @param objectType <#objectType description#>
 *
 *  @return <#return value description#>
 */
- (id)newObject:(NSString *)objectType
{
    return nil;
}

/**
 *  <#Description#>
 *
 *  @param error    <#error description#>
 *  @param status   <#status description#>
 *  @param response <#response description#>
 */
- (void) processError:(NSError *)error withStatus:(REMDataAccessStatus) status andResponse:(id) response
{
}

@end
