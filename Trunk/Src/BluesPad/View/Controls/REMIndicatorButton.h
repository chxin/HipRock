//
//  REMIndicatorButton.h
//  Blues
//
//  Created by 张 锋 on 8/5/13.
//
//

#import "REMColoredButton.h"

@interface REMIndicatorButton : REMColoredButton

//true for loading, false for not loading
@property (nonatomic,readonly) BOOL indicatorStatus;
@property (nonatomic,strong) NSString *loadingText;

-(void)startIndicator;
-(void)stopIndicator;

@end
