//
//  REMToggleButtonGroup.h
//  Blues
//
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
