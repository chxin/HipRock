/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMToggleButtonGroup.h
 * Created      : Zilong-Oscar.Xu on 8/20/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMToggleButton.h"

@protocol REMToggleButtonGroupDelegate <NSObject>

-(void)activedButtonChanged:(UIButton*)newButton;

@end

@interface REMToggleButtonGroup : NSObject {
    NSMutableArray* buttons;
}

-(NSArray*)getAllButtons;
-(REMToggleButton*)getToggledButton;
-(void)registerButton:(REMToggleButton*)button;

@property (nonatomic,weak)id<REMToggleButtonGroupDelegate> delegate;
@end

