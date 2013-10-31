//
//  REMToggleButtonGroup.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 8/20/13.
//
//

#import <Foundation/Foundation.h>
#import "REMToggleButton.h"

@interface REMToggleButtonGroup : NSObject {
    NSMutableArray* buttons;
}

-(NSArray*)getAllButtons;
-(REMToggleButton*)getToggledButton;
-(void)registerButton:(REMToggleButton*)button;

-(void)bindToggleChangeCallback:(id)performer selector:(SEL)selector;
@end
