/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMAppConfiguration.m
 * Date Created : 张 锋 on 12/13/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMAppConfiguration.h"
#import "REMApplicationContext.h"


@implementation REMAppConfiguration

#if defined(DEBUG)
const static NSString *BUILDOPTION = @"Debug";
#elif defined(DailyBuild)
const static NSString *BUILDOPTION = @"DailyBuild";
#else
const static NSString *BUILDOPTION = @"Release";
#endif

-(REMAppConfiguration *)init
{
    self = [super init];
    
    if(self){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
        
        self.dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        self.shouldCleanCache = [self.dictionary[@"ShouldCleanCache"] boolValue];
        
        [self resolveDataSourceSection];
        
        self.services = self.dictionary[@"Services"];
    }
    
    return self;
}


-(void)resolveDataSourceSection
{
    self.dataSources = (NSDictionary *)self.dictionary[@"DataSources"];
    
    NSString *currentDataSourceKey = [self.dictionary[@"CurrentDataSource"] objectForKey:BUILDOPTION];
    
    self.currentDataSource = self.dataSources[currentDataSourceKey];
}

-(NSInteger)getRequestTimeout
{
    return [REMAppConfig.currentDataSource[@"timeout"] integerValue];;
}
-(NSInteger)getRequestLogMode
{
    return [REMAppConfig.currentDataSource[@"logRequest"] integerValue];
}

@end


