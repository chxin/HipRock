/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMCancelBlockAlertView.h
 * Date Created : 张 锋 on 12/19/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "REMServiceAgent.h"


@interface REMCancelBlockAlertViewController : UIViewController<UIAlertViewDelegate>

@property (nonatomic,strong) REMServiceCallErrorBlock cancelBlock;

- (id)initWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(REMServiceCallErrorBlock)cancelBlock andError:(NSError *)errorInfo;

-(void)show;

@end
