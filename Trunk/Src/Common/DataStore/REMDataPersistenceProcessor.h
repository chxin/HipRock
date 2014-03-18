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

@property (nonatomic,weak) REMDataStore *dataStore;

- (id) persist:(id)data;
- (id) fetch;

- (id)newObject:(NSString *)objectType;

- (void) processError:(NSError *)error withStatus:(REMDataAccessStatus) status andResponse:(id) response;


@end
