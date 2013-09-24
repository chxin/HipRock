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
typedef enum _REMDiagramType
{
    REMDiagramTypePie,           
    REMDiagramTypeLine,
    REMDiagramTypeColumn,
    REMDiagramTypeGrid
}
REMDiagramType;

typedef enum _REMEnergyStep:NSUInteger
{
    REMEnergyStepHour=1,
    REMEnergyStepDay=2,
    REMEnergyStepWeek=5,
    REMEnergyStepMonth=3,
    REMEnergyStepYear=4
} REMEnergyStep;


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
