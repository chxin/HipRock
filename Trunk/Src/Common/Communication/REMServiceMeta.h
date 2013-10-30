//
//  REMServiceMeta.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 张 锋 on 8/13/13.
//
//

#import <Foundation/Foundation.h>

typedef enum _REMServiceResponseType
{
    REMServiceResponseJson,
    REMServiceResponseImage,
} REMServiceResponseType;

@interface REMServiceMeta : NSObject

-(REMServiceMeta *)initWithRelativeUrl:(NSString *)relativeUrl andResponseType:(REMServiceResponseType)responseType;
-(REMServiceMeta *)initWithJsonResultRelativeUrl:(NSString *)relativeUrl;
-(REMServiceMeta *)initWithDataResultRelativeUrl:(NSString *)relativeUrl;

@property (nonatomic) REMServiceResponseType responseType;
@property (nonatomic,strong) NSString* url;

@end
