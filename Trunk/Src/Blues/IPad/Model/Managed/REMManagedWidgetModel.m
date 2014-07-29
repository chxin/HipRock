//
//  REMManagedWidgetModel.m
//  Blues
//
//  Created by 张 锋 on 7/29/14.
//
//

#import "REMManagedWidgetModel.h"
#import "REMManagedDashboardModel.h"
#import "REMManagedSharedModel.h"


@implementation REMManagedWidgetModel

@dynamic code;
@dynamic comment;
@dynamic contentSyntax;
@dynamic id;
@dynamic isRead;
@dynamic name;
@dynamic syntaxVersion;
@dynamic dashboard;
@dynamic sharedInfo;


-(REMWidgetContentSyntax*)getSyntax {
    NSDictionary *dic=[REMJSONHelper objectByString:self.contentSyntax];
    if (self.syntaxVersion.integerValue == 0) {
        NSMutableDictionary* mutableDic = [dic mutableCopy];
        NSMutableDictionary* params = [mutableDic[@"params"] mutableCopy];
        
        // Move relativeDate attribute into params.viewOption.TimeRanges[0]
        NSMutableDictionary* submitParams = [params[@"submitParams"] mutableCopy];
        NSMutableDictionary* viewOption = [submitParams[@"viewOption"] mutableCopy];
        NSMutableArray* timeRanges = [viewOption[@"TimeRanges"] mutableCopy];
        NSMutableDictionary* timeRange0 = [timeRanges[0] mutableCopy];
        NSString *relativeDate = params[@"relativeDate"];
        if (!REMIsNilOrNull(relativeDate)) {
            [params removeObjectForKey:@"relativeDate"];
            [timeRange0 setObject:relativeDate forKey:@"relativeDate"];
            [timeRanges replaceObjectAtIndex:0 withObject:timeRange0];
            [viewOption setObject:timeRanges forKey:@"TimeRanges"];
            [submitParams setObject:viewOption forKey:@"viewOption"];
            [params setObject:submitParams forKey:@"submitParams"];
        }
        
        NSString* xtype = params[@"config"][@"xtype"];
        if ([xtype isEqualToString:@"stackchartcomponent"]) {
            NSMutableDictionary* config = [params[@"config"] mutableCopy];
            [config setObject:@"stack" forKey:@"type"];
            [params setObject:config forKey:@"config"];
        }
        
        [mutableDic setValue:params forKey:@"params"];
        dic = mutableDic;
    }
    return [[REMWidgetContentSyntax alloc]initWithDictionary:dic];
}

@end
