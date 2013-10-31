//
//  REMJSONObject.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by TanTan on 7/4/13.
//
//

#import "REMJSONObject.h"
#import "REMJSONHelper.h"

@interface REMJSONObject()

@end

@implementation REMJSONObject

- (id)initWithJSONString:(NSString *)jsonString
{
    
    NSDictionary *dic=[REMJSONHelper objectByString:jsonString];
    
    return [self initWithDictionary:dic];
    
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if ((self = [super init])) {
        
        self.innerDictionary=dictionary;
        
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
