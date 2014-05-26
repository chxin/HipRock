/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMToggleButton.h
 * Created      : Zilong-Oscar.Xu on 8/19/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
//#import "REMToggleButtonGroup.h"

@interface REMToggleButton : UIButton

@property (nonatomic, getter=isOn) BOOL on;
@property (nonatomic, strong) id value;

@end
