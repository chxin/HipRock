/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDataPersistenceProcessor.h
 * Date Created : tantan on 2/18/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>
#import "REMDataStore.h"

@class REMDataStore;

@interface REMDataPersistenceProcessor : NSObject

- (id) persistData:(id)data;

- (id) fetchData;


- (void) processError:(NSError *)error withStatus:(REMDataAccessErrorStatus) status andResponse:(id) response;

@property (nonatomic,weak) REMDataStore *dataStore;

@end
