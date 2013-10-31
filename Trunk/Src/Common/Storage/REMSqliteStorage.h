//
//  REMSqliteStorage.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Xu Zilong on 7/1/13.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#define DATA_FILE @"/localcache.sqlite3"
#define STORAGE_NETWORK_SOURCE_NAME @"NETWORK_STORAGE"

#define STORAGE_NETWORK_SOURCE_FIELDS_NAME_KEY @"KEY_SOURCE"
#define STORAGE_NETWORK_SOURCE_FIELDS_NAME_PARAMS @"Params"
#define STORAGE_NETWORK_SOURCE_FIELDS_NAME_DATA @"Data"
#define STORAGE_NETWORK_SOURCE_FIELDS_NAME_EXPIREDTIME @"Expired"
#define STORAGE_NETWORK_SOURCE_FIELDS_NAME_VERSION @"Version"
#define STORAGE_NETWORK_SOURCE_SQL_CREATE_SOURCE @"CREATE TABLE %@(%@ TEXT, %@ TEXT, %@ TEXT, %@ INTEGER, %@ TEXT, CONSTRAINT pk_%@ PRIMARY KEY (%@, %@))"
#define STORAGE_NETWORK_SOURCE_SQL_DROP_SOURCE @"DROP TABLE %@"
#define STORAGE_NETWORK_SOURCE_SQL_SET @"INSERT OR REPLACE INTO %@ (%@, %@, %@, %@, %@) VALUES (?, ?, ?, ?, ?)"
#define STORAGE_NETWORK_SOURCE_SQL_GET @"SELECT %@, %@, %@ FROM %@ WHERE %@ > ? AND %@ = ? AND %@ = ?"
#define STORAGE_NETWORK_SOURCE_SQL_CLEAR_SESSION @"DELETE FROM %@ WHERE %@=%d"

#define STORAGE_NETWORK_SOURCE_FIELDS_NAME_ID @"ID"
#define STORAGE_FILE_SOURCE_NAME @"FILE_STORAGE"
#define STORAGE_FILE_SOURCE_SQL_CREATE_SOURCE @"CREATE TABLE %@(%@ integer PRIMARY KEY autoincrement, %@ TEXT, %@ TEXT, %@ INTEGER)"


@interface REMSqliteStorage : NSObject {
    sqlite3* db;
}

@property (nonatomic) NSString* fileAddress;
@property (nonatomic) NSString* cacheAddress;

-(void)createSource: (NSString*)name;
-(void)dropSource: (NSString*)name;
-(void)set:(NSString*)sourceName key:(NSString*)key value:(NSString*)value expired:(int)expired;
-(NSDictionary*)get:(NSString*)sourceName key:(NSString*)key minVersion:(NSString*)minVersion;
-(BOOL)checkSourceName:(NSString*)sourceName;
-(void)clearSessionStorage;
-(void)clearWindowActivateStorage;
-(void)clearFileCache;
+(REMSqliteStorage*)getInstance;


- (NSDictionary*)getFile:(NSString*)key key:(NSString*)params;
-(void)createFileSource;
-(void)setFile:(NSString *)key params:(NSString*)params version:(long)version imageData:(NSData*)imageData;
@end
