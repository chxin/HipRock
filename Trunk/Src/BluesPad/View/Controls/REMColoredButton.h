//
//  REMColoredButton.h
//  Blues
//
//  Created by 张 锋 on 8/2/13.
//
//

#import <UIKit/UIKit.h>

typedef enum _REMColoredButtonColor
{
    REMColoredButtonGreen,
    REMColoredButtonBlack,
    REMColoredButtonBlue,
    REMColoredButtonOrage,
    REMColoredButtonWhite,
    REMColoredButtonTan,
} REMColoredButtonColor;

@interface REMColoredButton : UIButton

@property (nonatomic) REMColoredButtonColor buttonColor;

@end
