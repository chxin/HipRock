//
//  REMManagedImageModel.h
//  Blues
//
//  Created by 张 锋 on 5/19/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface REMManagedImageModel : NSManagedObject

@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSString * path;

@end