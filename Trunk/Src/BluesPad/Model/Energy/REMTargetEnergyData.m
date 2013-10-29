//
//  REMTargetEnergyData.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by 谭 坦 on 7/16/13.
//
//

#import "REMTargetEnergyData.h"

@implementation REMTargetEnergyData

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    NSDictionary *targetDic = dictionary[@"Target"];
    
    self.target = [[REMEnergyTargetModel alloc]initWithDictionary:targetDic];
    
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
