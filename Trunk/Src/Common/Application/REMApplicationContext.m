/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMApplicationContext.m
 * Created      : 张 锋 on 7/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMApplicationContext.h"
#import "REMAppConfiguration.h"
#import "REMDataStore.h"
#import "REMJSONHelper.h"
#import "REMJSONObject.h"
@implementation REMApplicationContext

@synthesize cacheMode;

static REMApplicationContext *context = nil;
static BOOL CACHEMODE = NO;

+ (REMApplicationContext *)instance
{
    if(context == nil){
        @synchronized(self){
            context = [[REMApplicationContext alloc] init];
        }
    }
    
    return context;
}

+ (void)recover
{
    NSArray *users = [REMDataStore fetchManagedObject:[REMManagedUserModel class]];
    if (users.count>0) {
        REMManagedUserModel *user = users[0];
        for (REMManagedCustomerModel *customer in user.customers.allObjects) {
            if ([customer.isCurrent boolValue]== YES) {
                REMAppContext.currentManagedCustomer = customer;
                REMAppContext.currentManagedUser = user;
                break;
            }
        }
    }
    
    //http operation manager
    REMAppContext.sharedRequestOperationManager = [REMHTTPRequestOperationManager manager];
}

- (void)cleanImage{
//    REMApplicationContext *context=REMAppContext;
//    BOOL shouldCleanImage =context.appConfig.shouldCleanCache;
//    //shouldCleanImage=YES;
//    if(shouldCleanImage == YES){
//        NSString *currentUserName = REMAppContext.currentManagedUser.name;
//        
//        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        
//        //NSString *path = [NSString stringWithFormat:@"%@/building-%@",documents,currentUserName];
//        NSString *buildingName=[NSString stringWithFormat:@"building-%@",currentUserName];
//        
//        NSFileManager *fileManager=[NSFileManager defaultManager];
//        NSError *error;
//        NSArray *array = [fileManager contentsOfDirectoryAtPath:documents error:&error];
//        if (error==nil) {
//            for (NSString *str in array) {
//                if ([str.pathExtension isEqualToString:@"png"] ==YES || [str.pathExtension isEqualToString:@"jpg"] == YES) {
//                    BOOL shouldRemoveImage =[str rangeOfString:buildingName].location==NSNotFound;
//                    //shouldRemoveImage=YES;
//                    if (shouldRemoveImage == YES) {
//                        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",documents,str] error:&error];
//                    }
//                }
//                
//            }
//            NSString *configuration = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
//            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:configuration];
//            dic[@"ShouldCleanCache"] = @(NO);
//            [dic writeToFile:configuration atomically:YES];
//            
//        }
//        
//    }
}

+ (void)destroy
{
    
//    [REMDataStore cleanContext];
    [REMDataStore deleteManagedObject:context.currentManagedUser];
    context.currentManagedCustomer = nil;
    context.currentManagedUser = nil;
    
    [context cleanImage];
    
    
    
    context = nil;
}

-(REMApplicationContext *)init
{
    self = [super init];
    
    if(self){
        self.appConfig = [[REMAppConfiguration alloc] init];
    }
    
    return self;
}


-(BOOL)cacheMode
{
    return CACHEMODE;
}
-(void)setCacheMode:(BOOL)value
{
    @synchronized(self){
        CACHEMODE = value;
    }
}


-(REMHTTPRequestOperationManager *)sharedRequestOperationManager
{
    return [REMHTTPRequestOperationManager manager];
}

-(REMUpdateAllManager *)sharedUpdateManager
{
    return [REMUpdateAllManager defaultManager];
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BluesPad" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"AppData.BluesPad"];
    
    NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    // Allow inferred migration from the original version of the application.
    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @YES, NSInferMappingModelAutomaticallyOption : @YES };
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
    }
    
    return _persistentStoreCoordinator;
}


@end
