//
//  REMSqliteStorage.m
//  Blues
//
//  Created by Xu Zilong on 7/1/13.
//
//

#import "REMSqliteStorage.h"
#import "REMApplicationInfo.h"
#import "REMServiceUrl.h"
#import "sqlite3.h"
#import "REMStorage.h"



@implementation REMSqliteStorage

- (void)set:(NSString*)sourceName key:(NSString*)key value:(NSString*)value expired:(int)expired
{
    NSString* sqlCmd = [NSString stringWithFormat:STORAGE_NETWORK_SOURCE_SQL_SET, STORAGE_NETWORK_SOURCE_NAME, STORAGE_NETWORK_SOURCE_FIELDS_NAME_KEY, STORAGE_NETWORK_SOURCE_FIELDS_NAME_PARAMS, STORAGE_NETWORK_SOURCE_FIELDS_NAME_DATA, STORAGE_NETWORK_SOURCE_FIELDS_NAME_EXPIREDTIME, STORAGE_NETWORK_SOURCE_FIELDS_NAME_VERSION];
    sqlite3_stmt* statement;
    
    [self openDatabase];
    int sqlStatus = sqlite3_prepare_v2(db, [sqlCmd UTF8String], -1, &statement, NULL);
    NSLog(@"INSERT SQL STATEMENT PREPARATION CODE - %d", sqlStatus);
    if (sqlStatus == SQLITE_OK)
    {
        sqlite3_bind_text(statement, 1, [sourceName UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 2, [key UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 3, [value UTF8String], -1, NULL);
        sqlite3_bind_int(statement, 4, expired);
        sqlite3_bind_text(statement, 5, [REMApplicationInfo getVersion], -1, NULL);
        sqlStatus = sqlite3_step(statement);
        if (sqlStatus != SQLITE_DONE) {
            NSAssert(NO, @"INSERT ERROR");
            NSLog(@"INSERT SQL STATEMENT RUN ERROR. DB CODE - %d", sqlStatus);
        }
    }    
    sqlite3_finalize(statement);
    [self closeDatabase];
}

- (NSDictionary*)get:(NSString*)sourceName key:(NSString*)key minVersion:(NSString*)minVersion
{
    
    NSString* sqlCmd = [NSString stringWithFormat:STORAGE_NETWORK_SOURCE_SQL_GET, STORAGE_NETWORK_SOURCE_FIELDS_NAME_DATA, STORAGE_NETWORK_SOURCE_FIELDS_NAME_EXPIREDTIME, STORAGE_NETWORK_SOURCE_FIELDS_NAME_VERSION, STORAGE_NETWORK_SOURCE_NAME, STORAGE_NETWORK_SOURCE_FIELDS_NAME_VERSION, STORAGE_NETWORK_SOURCE_FIELDS_NAME_PARAMS, STORAGE_NETWORK_SOURCE_FIELDS_NAME_KEY];
    sqlite3_stmt* statement;
    
    [self openDatabase];
    int sqlStatus = sqlite3_prepare_v2(db, [sqlCmd UTF8String], -1, &statement, NULL);
    NSLog(@"QUERY SQL STATEMENT PREPARATION CODE - %d", sqlStatus);
    NSDictionary *dictionary = nil;
    if (sqlStatus == SQLITE_OK)
    {
        NSString* fVersion = [REMApplicationInfo formatVersion:minVersion];
        sqlite3_bind_text(statement, 1, [fVersion UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 2, [key UTF8String], -1, NULL);
        sqlite3_bind_text(statement, 3, [sourceName UTF8String], -1, NULL);
        sqlStatus = sqlite3_step(statement);
        if (sqlStatus == SQLITE_ROW) {
            NSString* data = nil;
            if ((char*)sqlite3_column_text(statement, 0) != nil) {
                data = [[NSString alloc]initWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
            }
            int expiredTime = sqlite3_column_int(statement, 1);
            int build = sqlite3_column_int(statement, 2);
            dictionary = [NSDictionary dictionaryWithObjectsAndKeys:data, STORAGE_NETWORK_SOURCE_FIELDS_NAME_DATA, [NSNumber numberWithInt:expiredTime], STORAGE_NETWORK_SOURCE_FIELDS_NAME_EXPIREDTIME, [NSNumber numberWithInt:build], STORAGE_NETWORK_SOURCE_FIELDS_NAME_VERSION, nil];
        }
    }
    /*else
    {
        NSString* errorMsg = [[NSString alloc]initWithUTF8String:sqlite3_errmsg(db)];
    }*/
    sqlite3_finalize(statement);
    [self closeDatabase];
    return dictionary;
}

-(BOOL)checkSourceName:(NSString*)sourceName
{    
    sqlite3_stmt* statement;
    [self openDatabase];
    int sqlStatus = sqlite3_prepare_v2(db, [[NSString stringWithFormat:@"SELECT * FROM %@", sourceName] UTF8String], -1, &statement, NULL);
    BOOL result = NO;
    if (sqlStatus == SQLITE_OK)
    {
        sqlStatus = sqlite3_step(statement);
        if (sqlStatus != SQLITE_ERROR) {
            result = YES;
        }
    }
    else
    {
        NSLog(@"%@",[[NSString alloc]initWithUTF8String:sqlite3_errmsg(db)]);
    }
    sqlite3_finalize(statement);
    [self closeDatabase];
    return result;
}

-(void)createSource:(NSString *)name
{
    [self runSQL:[NSString stringWithFormat:STORAGE_NETWORK_SOURCE_SQL_CREATE_SOURCE, name, STORAGE_NETWORK_SOURCE_FIELDS_NAME_KEY, STORAGE_NETWORK_SOURCE_FIELDS_NAME_PARAMS, STORAGE_NETWORK_SOURCE_FIELDS_NAME_DATA, STORAGE_NETWORK_SOURCE_FIELDS_NAME_EXPIREDTIME, STORAGE_NETWORK_SOURCE_FIELDS_NAME_VERSION, STORAGE_NETWORK_SOURCE_NAME, STORAGE_NETWORK_SOURCE_FIELDS_NAME_KEY, STORAGE_NETWORK_SOURCE_FIELDS_NAME_PARAMS]];
}

-(void)dropSource:(NSString *)name
{
    [self runSQL:[NSString stringWithFormat:STORAGE_NETWORK_SOURCE_SQL_DROP_SOURCE, name]];
}

-(void)runSQL: (NSString*)sql
{
    [self openDatabase];
    
    char* error;
    
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error))
    {
        [self closeDatabase];
        NSAssert(NO, ([NSString stringWithFormat:@"LocalStorage: FAIL TO RUN SQL - %@", sql]), error);
    }
    else
    {
        [self closeDatabase];
    }
}

-(NSString*)getFileAddress
{
    if (_fileAddress == nil)
    {
        NSArray* myPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString* myDocPath = myPaths[0];
        NSString* fileName = [myDocPath stringByAppendingFormat:DATA_FILE];
        _fileAddress = fileName;
    }
    return _fileAddress;
}

-(BOOL) openDatabase
{
    NSString* fileName = [self getFileAddress];
    
    if (sqlite3_open([fileName UTF8String], &db) != SQLITE_OK)
    {
        [self closeDatabase];
        NSAssert(NO, @"FAILURE TO CONNECT TO SQLITE.");
        return NO;
    }
    return YES;
}
-(void) closeDatabase
{
    sqlite3_close(db);
}
+(REMSqliteStorage*)getInstance
{
    static dispatch_once_t pred;
    static REMSqliteStorage *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[REMSqliteStorage alloc] init];
    });
    return shared;
}
-(void)clearSessionStorage
{
    [self runSQL:[NSString stringWithFormat:STORAGE_NETWORK_SOURCE_SQL_CLEAR_SESSION, STORAGE_NETWORK_SOURCE_NAME, STORAGE_NETWORK_SOURCE_FIELDS_NAME_EXPIREDTIME, REMSessionExpired]];
}
/*
-(void) initURLCategory {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"APIList" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSLog(@"%@", data);
}*/
@end
