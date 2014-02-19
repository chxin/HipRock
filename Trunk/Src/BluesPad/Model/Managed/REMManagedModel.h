//
//  REMManagedModel.h
//  Blues
//
//  Created by tantan on 2/18/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface REMManagedModel : NSManagedObject

@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * comment;

@end
