//
//  DCRange.h
//  Test
//
//  Created by Zilong-Oscar.Xu on 11/11/13.
//  Copyright (c) 2013 Zilong-Oscar.Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCRange : NSObject
@property (nonatomic, readonly) double location;
@property (nonatomic, readonly) double length;
@property (nonatomic, readonly) double end;
-(DCRange*)initWithLocation:(double)location length:(double)length;
+(BOOL)isRange:(DCRange*)aRange equalTo:(DCRange*)bRange;
+(BOOL)isRange:(DCRange *)aRange visableIn:(DCRange *)bRange;
-(BOOL)isVisableIn:(DCRange*)bRange;
@end
