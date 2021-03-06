/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMAppConfiguration.h
 * Date Created : 张 锋 on 12/13/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>

@interface REMAppConfiguration : NSObject

@property (nonatomic,strong) NSDictionary *dictionary;

@property (nonatomic) BOOL shouldCleanCache;
@property (nonatomic,strong) NSDictionary *dataSources;
@property (nonatomic,strong) NSString *currentDataSourceKey;
@property (nonatomic,strong) NSDictionary *currentDataSource;
@property (nonatomic,strong) NSDictionary *services;


@property (nonatomic,readonly) NSInteger requestTimeout;
@property (nonatomic,readonly) NSNumber *requestLogMode;

@property (nonatomic,strong) NSString *appStoreUrl;
@property (nonatomic,strong) NSString *qrCodeUrl;


@end
