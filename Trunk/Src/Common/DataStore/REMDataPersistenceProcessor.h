//
//  REMPersistentManager.h
//  Blues
//
//  Created by 张 锋 on 3/14/14.
//
//

#import <Foundation/Foundation.h>
#import "REMDataStore.h"

@interface REMDataPersistenceProcessor : NSObject

/**
 *  Back pointer to owner data store
 */
@property (nonatomic,weak) REMDataStore *dataStore;

- (id)new:(Class)objectType;
- (id)fetch:(Class)objectType;
- (id)fetch:(Class)objectType withPredicate:(NSPredicate *)predicate;
- (void)delete:(NSManagedObject *)object;
- (void)save;

#pragma mark - Methods
/**
 *  Persists data into database
 *
 *  @param data
 *
 *  @return The persisted data
 */
- (id)persist:(id)data;

/**
 *  Fetches data from database
 *
 *  @return The fetched data
 */
- (id)fetch;

///**
// *  Make new managed object of the specified type
// *
// *  @param type The specified type
// *
// *  @return Managed object instance of the specified type
// */
//- (id)new:(Class *)type;

///**
// *  Process error
// *
// *  @param error    Error info
// *  @param status   Data access status
// *  @param response Server response
// */
//- (void)processError:(NSError *)error withStatus:(REMDataAccessStatus)status andResponse:(id)response;


@end
