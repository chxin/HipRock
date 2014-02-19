//
//  REMManagedModel.h
//  Blues
//
//  Created by tantan on 2/19/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface REMManagedModel : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;

@end
