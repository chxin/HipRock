/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMJSONObject.m
 * Created      : TanTan on 7/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMJSONObject.h"
#import "REMJSONHelper.h"

@interface REMJSONObject()

@end

@implementation REMJSONObject

@synthesize dataError;

- (id)initWithJSONString:(NSString *)jsonString
{
    
    NSDictionary *dic=[REMJSONHelper objectByString:jsonString];
    
    return [self initWithDictionary:dic];
    
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if ((self = [super init])) {
        
        self.innerDictionary=dictionary;
//        self.dataError = NO;
        
        if(dictionary == nil || [dictionary isEqual:[NSNull null]])
        {
            self = nil;
        }
        else
        {
            [self assembleCustomizedObjectByDictionary:dictionary];
        }
    }
    
    return self;
}

- (id)valueForKey:(NSString *)key
{
    id value=[self.innerDictionary objectForKey:key];
    if(value){
        return value;
    }
    else{
        return [super valueForKey:key];
    }
}


- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    
}

- (NSDictionary *)updateInnerDictionary{
    return self.innerDictionary;
}

- (NSString *)serialize
{
    return [REMJSONHelper stringByObject:[self innerDictionary]];
}

@end
