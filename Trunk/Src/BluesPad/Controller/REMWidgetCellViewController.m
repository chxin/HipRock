//
//  REMWidgetCellViewController.m
//  Blues
//
//  Created by TanTan on 7/1/13.
//
//

#import "REMWidgetCellViewController.h"
#import "REMDataStore.h"



@interface REMWidgetCellViewController ()

@end

@implementation REMWidgetCellViewController


- (void) retrieveEnergyData
{
    REMDataStore *store = [[REMDataStore alloc] initWithEnergyStore:self.widgetObject.contentSyntax.storeType parameter:self.widgetObject.contentSyntax.params];
    store.isAccessLocal = YES;
    store.isStoreLocal = YES;
    store.maskContainer = self.chartView;
    store.groupName = nil;
    
    void (^retrieveSuccess)(id data)=^(id data) {
        self.data = [[REMEnergyViewData alloc] initWithDictionary:(NSDictionary *)data];

        [self initChart];
    };
    void (^retrieveError)(NSError *error, id response) = ^(NSError *error, id response) {
        //self.widgetTitle.text = [NSString stringWithFormat:@"Error: %@",error.description];
    };

    
    [REMDataAccessor access:store success:retrieveSuccess error:retrieveError];
}

- (void)initTitle
{
    self.widgetTitle.text=self.widgetObject.name;
}

- (void)initChart
{
    
}

- (void)initDiagram
{
    [self initTitle];
    [self retrieveEnergyData];
}


@end
