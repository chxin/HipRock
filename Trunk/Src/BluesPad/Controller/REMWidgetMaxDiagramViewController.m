//
//  REMWidgetMaxDiagramViewController.m
//  Blues
//
//  Created by 谭 坦 on 7/17/13.
//
//

#import "REMWidgetMaxDiagramViewController.h"
#import "CorePlot-CocoaTouch.h"

@interface REMWidgetMaxDiagramViewController ()

@end

@implementation REMWidgetMaxDiagramViewController

- (void) initDiagram
{
    
}

- (void)reloadChart
{
    [self.graph reloadData];
}

- (void) hidePlots
{
    for(int i=0;i<self.data.targetEnergyData.count;i++)
    {
        REMEnergyTargetModel *target = ((REMTargetEnergyData *)self.data.targetEnergyData[i]).target;
        
        //NSString *plotIdentifier = [NSString stringWithFormat:@"%d-%d-%llu", i, target.type, target.targetId];
        
        BOOL isHidden = [self.hiddenTargets containsObject:target];
        
        CPTPlot *plot = [self.graph plotAtIndex:i];
        
        [plot setHidden:isHidden];
    }
}

@end
