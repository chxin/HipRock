/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMApplicationContext.m
 * Created      : 张 锋 on 7/29/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMApplicationContext.h"
#import "REMAppConfiguration.h"
#import "REMStorage.h"
#import "REMDataStore.h"

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
    REMUserModel *storedUser = [REMUserModel getCached];
    REMCustomerModel *storedCustomer = [REMCustomerModel getCached];
    
    [REMAppContext setCurrentUser:storedUser];
    [REMAppContext setCurrentCustomer:storedCustomer];
}

+ (void)cleanImage{
    REMApplicationContext *context=REMAppContext;
    BOOL shouldCleanImage =context.appConfig.shouldCleanCache;
    //shouldCleanImage=YES;
    if(shouldCleanImage == YES){
        NSString *currentUserName = REMAppCurrentUser.name;
        
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        //NSString *path = [NSString stringWithFormat:@"%@/building-%@",documents,currentUserName];
        NSString *buildingName=[NSString stringWithFormat:@"building-%@",currentUserName];
        
        NSFileManager *fileManager=[NSFileManager defaultManager];
        NSError *error;
        NSArray *array = [fileManager contentsOfDirectoryAtPath:documents error:&error];
        if (error==nil) {
            for (NSString *str in array) {
                BOOL shouldRemoveImage =[str rangeOfString:buildingName].location==NSNotFound;
                //shouldRemoveImage=YES;
                if (shouldRemoveImage == YES) {
                    [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",documents,str] error:&error];
                }
            }
            NSString *configuration = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:configuration];
            dic[@"ShouldCleanCache"] = @(NO);
            [dic writeToFile:configuration atomically:YES];
            
        }
        
    }
}

+ (void)destroy
{
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

+ (void)updateBuildingInfoArrayToStorage
{
    REMDataStore *store=[[REMDataStore alloc]initWithName:REMDSBuildingInfoUpdate parameter:nil accessCache:NO andMessageMap:nil];
    REMApplicationContext *context= REMAppContext;
    
    NSString *origCachedContent = [REMStorage get:store.serviceMeta.url key:context.buildingInfoArrayStorageKey];
    NSMutableDictionary *result = [[REMJSONHelper objectByString:origCachedContent] mutableCopy] ;
    
    NSArray *buildingArray=context.buildingInfoArray;
    NSMutableArray *dicArray=[NSMutableArray array];
    for (int i=0; i<buildingArray.count; ++i) {
        REMJSONObject *obj=buildingArray[i];
        [dicArray addObject: obj.innerDictionary];
    }
    result[@"BuildingInfo"]=dicArray;
    
    [REMStorage set:store.serviceMeta.url key:context.buildingInfoArrayStorageKey value:[REMJSONHelper stringByObject:result] expired:REMWindowActiated];
}

-(BOOL)getCacheMode
{
    return CACHEMODE;
}
-(void)setCacheMode:(BOOL)value
{
    @synchronized(self){
        CACHEMODE = value;
    }
}



@end
