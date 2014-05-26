/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDataStoreTests.m
 * Date Created : 张 锋 on 3/20/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <XCTest/XCTest.h>
#import "REMDataStore-Private.h"

@interface REMDataStoreTests : XCTestCase

@end

@implementation REMDataStoreTests

#define ID @"ID"

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)test_datastore_configuration
{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    NSString *errorMessage = @"service config error";
    
    REMDataStore *store = [[REMDataStore alloc] init];
    
    NSDictionary *userValidateStore = [store serviceConfigurationOfType:REMDSUserValidate];
    NSDictionary *buildingInfoStore = [store serviceConfigurationOfType:REMDSBuildingInfo];
    NSDictionary *energyUsageStore = [store serviceConfigurationOfType:REMDSEnergyTagsTrend];
    
    
    NSAssert([userValidateStore[ID] unsignedIntegerValue] == (NSUInteger)REMDSUserValidate, errorMessage);
    NSAssert([buildingInfoStore[ID] unsignedIntegerValue] == (NSUInteger)REMDSBuildingInfo, errorMessage);
    NSAssert([energyUsageStore[ID] unsignedIntegerValue] == (NSUInteger)REMDSEnergyTagsTrend, errorMessage);
}

@end
