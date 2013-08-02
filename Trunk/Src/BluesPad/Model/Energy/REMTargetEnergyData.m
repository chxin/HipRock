//
//  REMTargetEnergyData.m
//  Blues
//
//  Created by 谭 坦 on 7/16/13.
//
//

#import "REMTargetEnergyData.h"

@implementation REMTargetEnergyData

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    NSDictionary *targetDic = dictionary[@"Target"];
    
    self.target = [[REMEnergyTargetModel alloc]initWithDictionary:targetDic];
    
    NSArray *dataArray=dictionary[@"EnergyData"];
    
    NSMutableArray *dataMArray=[[NSMutableArray alloc]initWithCapacity:dataArray.count];
    
    for(NSDictionary *dataDic in dataArray)
    {
        [dataMArray addObject:[[REMEnergyData alloc]initWithDictionary:dataDic]];
    }
    
    self.energyData = dataMArray;
}

@end
