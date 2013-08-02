//
//  REMWidgetContentSyntax.h
//  Blues
//
//  Created by TanTan on 7/4/13.
//
//

#import "REMJSONObject.h"
#import "REMTimeRange.h"

@interface REMWidgetContentSyntax : REMJSONObject

@property (nonatomic,strong) NSDictionary *params;
@property (nonatomic,strong) NSDictionary *config;
@property (nonatomic,strong) NSString *calendar;
@property (nonatomic,strong) NSString *relativeDate;
@property (nonatomic,strong) NSString *storeType;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSArray *timeRanges;
@property (nonatomic,strong) NSNumber *step;
@end
