/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMTargetAssociationModel.h
 * Date Created : 张 锋 on 6/3/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <Foundation/Foundation.h>

@interface REMTargetAssociationModel : NSObject

@property (nonatomic,strong) NSNumber *hierarchyId;
@property (nonatomic,strong) NSNumber *areaDimensionId;
@property (nonatomic,strong) NSNumber *systemDimensionId;

@end
