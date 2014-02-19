/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetSyntaxObject.m
 * Created      : TanTan on 7/4/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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
    if([self.contentSyntax.xtype isEqualToString:@"linechartcomponent"] ==YES ||
       [self.contentSyntax.xtype isEqualToString:@"multitimespanlinechartcomponent"]==YES)
    {
        self.diagramType =REMDiagramTypeLine;
    }
    else if([self.contentSyntax.xtype isEqualToString:@"columnchartcomponent"]== YES ||
            [self.contentSyntax.xtype isEqualToString:@"multitimespancolumnchartcomponent"]==YES)
    {
        self.diagramType =REMDiagramTypeColumn;
    }
    else if([self.contentSyntax.xtype rangeOfString:@"grid"].location!=NSNotFound)
    {
        self.diagramType =REMDiagramTypeGrid;
    }
    else if([self.contentSyntax.xtype isEqualToString:@"piechartcomponent"]== YES)
    {
        self.diagramType =REMDiagramTypePie;
    }
    else if([self.contentSyntax.xtype isEqualToString:@"rankcolumnchartcomponent"]== YES)
    {
        self.diagramType =REMDiagramTypeRanking;
    }
    else if([self.contentSyntax.xtype isEqualToString:@"stackchartcomponent"]== YES)
    {
        self.diagramType =REMDiagramTypeStackColumn;
    }
    else if([self.contentSyntax.xtype isEqualToString:@"labelingchartcomponent"]==YES){
        self.diagramType=REMDiagramTypeLabelling;
    }
    
    NSDictionary *shareInfo = dictionary[@"SimpleShareInfo"];
    
    if(shareInfo!=nil && [shareInfo isEqual:[NSNull null]]==NO){
        self.shareInfo=[[REMShareInfo alloc]initWithDictionary:shareInfo];
    }
}

@end
