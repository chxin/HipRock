//
//  REMManagedEnergyDataModel.h
//  Blues
//
//  Created by tantan on 3/6/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface REMManagedEnergyDataModel : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * value;

@end
