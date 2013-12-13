/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMAppConfiguration.m
 * Date Created : 张 锋 on 12/13/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMAppConfiguration.h"

@implementation REMAppConfiguration

-(REMAppConfiguration *)init
{
    self = [super init];
    
    if(self){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Configuration" ofType:@"plist"];
        
        self.dictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        self.shouldCleanCache = [self.dictionary[@"ShouldCleanCache"] boolValue];
        
        [self resolveDataSourceSection];
    }
    
    return self;
}


-(void)resolveDataSourceSection
{
    self.dataSources = (NSDictionary *)self.dictionary[@"DataSources"];
    self.currentDataSource = (NSDictionary *)self.dictionary[@"CurrentDataSource"];
}

@end


