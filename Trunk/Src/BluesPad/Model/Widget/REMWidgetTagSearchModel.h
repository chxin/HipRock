//
//  REMWidgetTagSearchModel.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/4/13.
//
//

#import "REMWidgetSearchModelBase.h"

@interface REMWidgetTagSearchModel : REMWidgetSearchModelBase

@property (nonatomic,strong) NSArray *tagIdArray;
@property (nonatomic) REMEnergyStep step;
@property (nonatomic,strong) NSNumber *zoneId;
@property (nonatomic,strong) NSNumber *industryId;

@end
