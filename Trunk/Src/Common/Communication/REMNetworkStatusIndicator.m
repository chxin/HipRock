//
//  REMNetworkStatusIndicator.m
//  Blues
//
//  Created by 张 锋 on 10/9/13.
//
//

#import "REMNetworkStatusIndicator.h"

@interface REMNetworkStatusIndicator ()

@property(nonatomic,assign) unsigned int activityCounter;

@end

@implementation REMNetworkStatusIndicator


- (id)init
{
    self = [super init];
    if (self) {
        self.activityCounter = 0;
    }
    return self;
}

-(void)increaseActivity{
    @synchronized(self) {
        self.activityCounter++;
    }
    [self updateActivity];
}
-(void)decreaseActivity{
    @synchronized(self) {
        if (self.activityCounter>0) self.activityCounter--;
    }
    [self updateActivity];
}
-(void)noActivity{
    self.activityCounter = 0;
    [self updateActivity];
}

-(void)updateActivity{
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = (self.activityCounter>0);
}

#pragma mark -
#pragma mark Singleton instance

+(REMNetworkStatusIndicator *)sharedManager {
    static dispatch_once_t pred;
    static REMNetworkStatusIndicator *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[REMNetworkStatusIndicator alloc] init];
    });
    return shared;
}

@end
