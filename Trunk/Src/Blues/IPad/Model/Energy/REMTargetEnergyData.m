/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTargetEnergyData.m
 * Created      : 谭 坦 on 7/16/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMTargetEnergyData.h"

@implementation REMTargetEnergyData

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    NSDictionary *targetDic = dictionary[@"Target"];
    
    self.target = [[REMEnergyTargetModel alloc]initWithDictionary:targetDic];
    
    self.dataError = self.target.dataError;
    
    NSArray *dataArray=dictionary[@"EnergyDataArray"];
    
    NSMutableArray *dataMArray=[[NSMutableArray alloc]initWithCapacity:dataArray.count];
    
    for(NSArray *array in dataArray)
    {
        REMEnergyData *d = [[REMEnergyData alloc]initWithArray:array];
        
        
        [dataMArray addObject:d];
    }
    
    self.energyData = dataMArray;
}

@end
