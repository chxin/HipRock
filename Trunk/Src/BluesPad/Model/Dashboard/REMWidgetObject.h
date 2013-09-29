//
//  REMWidgetSyntaxObject.h
//  Blues
//
//  Created by TanTan on 7/4/13.
//
//

#import "REMJSONObject.h"
#import "REMWidgetContentSyntax.h"
#import "REMShareInfo.h"
#import "REMEnum.h"


@interface REMWidgetObject : REMJSONObject

@property (nonatomic,strong) NSNumber *widgetId;
@property (nonatomic,strong) NSNumber *dashboardId;
@property (nonatomic) BOOL isRead;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *layoutSyntax;
@property (nonatomic,strong) REMWidgetContentSyntax *contentSyntax;
@property (nonatomic) REMDiagramType diagramType;
@property (nonatomic,strong) REMShareInfo *shareInfo;

@end
