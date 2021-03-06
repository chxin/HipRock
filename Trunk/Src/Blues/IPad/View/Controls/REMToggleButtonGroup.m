/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMToggleButtonGroup.m
 * Created      : Zilong-Oscar.Xu on 8/20/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMToggleButtonGroup.h"

@implementation REMToggleButtonGroup

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
        if (self.delegate && [self.delegate respondsToSelector:@selector(activedButtonChanged:)]) {
            [self.delegate activedButtonChanged:button];
        }
    }
}

-(void)registerButton:(REMToggleButton*)button {
    [buttons addObject:button];
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}
@end
