//
//  REMWidgetSyntaxObject.m
//  Blues
//
//  Created by TanTan on 7/4/13.
//
//

#import "REMWidgetObject.h"

@implementation REMWidgetObject

- (void)assembleCustomizedObjectByDictionary:(NSDictionary *)dictionary
{
    self.widgetId=dictionary[@"Id"];
    self.dashboardId=dictionary[@"DashboardId"];
    self.name=dictionary[@"Name"];
    self.isRead=(BOOL)dictionary[@"IsRead"];
    self.layoutSyntax=dictionary[@"LayoutSyntax"];
    
    self.contentSyntax = [[REMWidgetContentSyntax alloc]initWithJSONString:dictionary[@"ContentSyntax"]];
    if([self.contentSyntax.type isEqualToString:@"line"] ==YES)
    {
        self.diagramType =REMDiagramTypeLine;
    }
    else if([self.contentSyntax.type isEqualToString:@"column"]== YES)
    {
        self.diagramType =REMDiagramTypeColumn;
    }
    else if([self.contentSyntax.type isEqualToString:@"grid"]== YES)
    {
        self.diagramType =REMDiagramTypeGrid;
    }
    else if([self.contentSyntax.type isEqualToString:@"pie"]== YES)
    {
        self.diagramType =REMDiagramTypePie;
    }
}

@end
