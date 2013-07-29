//
//  REMWidgetContentSyntax.m
//  Blues
//
//  Created by TanTan on 7/4/13.
//
//

#import "REMWidgetContentSyntax.h"

@implementation REMWidgetContentSyntax

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    NSDictionary *p = dictionary[@"params"];
    self.params= p[@"submitParams"];
    self.relativeDate=p[@"relativeDate"];
    self.calendar=p[@"calendar"];
    self.config = p[@"config"];
    self.storeType=self.config[@"storeType"];
    self.type=self.config[@"type"];
    
    
    
    NSDictionary *viewOption=self.params[@"viewOption"];
    
    self.step = viewOption[@"Step"];
    
    
    NSArray *origTimeRanges = viewOption[@"TimeRanges"];
    NSMutableArray* newTimeRanges = [[NSMutableArray alloc]initWithCapacity:origTimeRanges.count];
    for(NSDictionary *dic in origTimeRanges)
    {
        [newTimeRanges addObject: [[REMTimeRange alloc]initWithDictionary:dic]];
    }
    
    self.timeRanges = newTimeRanges;

}

@end
