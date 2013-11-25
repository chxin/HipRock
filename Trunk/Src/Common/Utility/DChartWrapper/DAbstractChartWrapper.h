//
//  DAbstractChartWrapper.h
//  Blues
//
//  Created by Zilong-Oscar.Xu on 11/21/13.
//
//

#import <Foundation/Foundation.h>
#import "REMChartHeader.h"
#import "REMEnergyViewData.h"

@interface DAbstractChartWrapper : NSObject

@property (nonatomic, weak) id<REMChartDelegate> delegate;
-(void)cancelToolTipStatus;
-(void)redraw:(REMEnergyViewData *)energyViewData;
-(UIView*)getView;
@end
