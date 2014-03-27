//
//  REMPersistentManager.m
//  Blues
//
//  Created by 张 锋 on 3/14/14.
//
//

#import "REMDataPersistenceProcessor.h"
#import "REMAppDelegate.h"
#import "REMApplicationContext.h"
#import "REMManagedEnergyDataModel.h"

@implementation REMDataPersistenceProcessor


#pragma mark - @protected

- (id)create:(Class)objectType{
    
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(objectType) inManagedObjectContext:REMAppContext.managedObjectContext];
}

- (void)remove:(NSManagedObject *)object{
    [REMAppContext.managedObjectContext deleteObject:object];
    [self save];
}

- (void)save{
    NSError *error = nil;
    [REMAppContext.managedObjectContext save:&error];
}


- (id)fetch:(Class)objectType{
    return [self fetch:objectType withPredicate:nil];
}

- (id)fetch:(Class)objectType withPredicate:(NSPredicate *)predicate{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass(objectType)];
    
    if(objectType!=[REMManagedEnergyDataModel class]){
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
        [request setSortDescriptors:@[sortDescriptor]];
    }
    
    if(predicate!=nil){
        [request setPredicate:predicate];
    }
    
    NSError *error = nil;
    //执行获取数据请求，返回数组
    NSMutableArray *mutableFetchResult = [[REMAppContext.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    }
    
    return mutableFetchResult;
}

#pragma mark - @public

- (id)persist:(id)data
{
    return nil;
}

- (id)fetch
{
    return nil;
}

//- (id)new:(Class *)objectType
//{
//    return nil;
//}

//- (void) processError:(NSError *)error withStatus:(REMDataAccessStatus) status andResponse:(id) response
//{
//}

@end
