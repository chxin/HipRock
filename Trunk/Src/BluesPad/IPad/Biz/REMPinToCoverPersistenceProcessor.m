/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMPinToCoverPersistenceProcessor.m
 * Date Created : tantan on 3/4/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMPinToCoverPersistenceProcessor.h"

@implementation REMPinToCoverPersistenceProcessor

- (id)fetchData{
    return self.commodityInfo.pinnedWidgets;
}

- (id)persistData:(id)data{
    
}

@end
