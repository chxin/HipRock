/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMToggleButtonGroup.h
 * Created      : Zilong-Oscar.Xu on 8/20/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <Foundation/Foundation.h>
#import "REMToggleButton.h"

@interface REMToggleButtonGroup : NSObject {
    NSMutableArray* buttons;
}

-(NSArray*)getAllButtons;
-(REMToggleButton*)getToggledButton;
-(void)registerButton:(REMToggleButton*)button;

-(void)bindToggleChangeCallback:(id)performer selector:(SEL)selector;


@property (nonatomic,weak) id toggleChangePerformer;


@end
