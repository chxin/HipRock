//
//  REMToggleButtonGroup.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by Zilong-Oscar.Xu on 8/20/13.
//
//

#import "REMToggleButtonGroup.h"

@implementation REMToggleButtonGroup {
    id toggleChangePerformer;
    SEL toggleChangeSEL;
}

-(id)init {
    self = [super init];
    if (self) {
        buttons = [[NSMutableArray alloc]init];
    }
    return self;
}

-(NSArray*)getAllButtons {
    return buttons;
}
-(REMToggleButton*)getToggledButton {
    REMToggleButton* btn = nil;
    for (int i = 0; i < buttons.count; i++) {
        btn = [buttons objectAtIndex:i];
        if ([btn isOn]) {
            break;
        }
    }
    return btn;
}

- (void)buttonClick:(REMToggleButton *)button {
    if([button isOn]) {
        return;
    } else {
        REMToggleButton* activeBtn = [self getToggledButton];
        if (activeBtn != nil) {
            [activeBtn setOn:false];
        }
        [button setOn:YES];
        [toggleChangePerformer performSelector:toggleChangeSEL withObject:button];
    }
}

-(void)registerButton:(REMToggleButton*)button {
    [buttons addObject:button];
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}


-(void)bindToggleChangeCallback:(id)performer selector:(SEL)selector {
    toggleChangePerformer = performer;
    toggleChangeSEL = selector;
}
@end
