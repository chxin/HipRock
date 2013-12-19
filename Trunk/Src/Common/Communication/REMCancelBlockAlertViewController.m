/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMCancelBlockAlertView.m
 * Date Created : 张 锋 on 12/19/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMCancelBlockAlertViewController.h"

@interface REMCancelBlockAlertViewController ()

@property (nonatomic,strong) UIAlertView *alertView;
@property (nonatomic,weak) NSError *errorInfo;

@end

@implementation REMCancelBlockAlertViewController

- (id)initWithMessage:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelBlock:(REMServiceCallErrorBlock)cancelBlock andError:(NSError *)errorInfo;
{
    self = [super init];
    
    if(self){
        self.alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil, nil];
        self.cancelBlock = cancelBlock;
        self.errorInfo = errorInfo;
    }
    
    return self;
}

-(void)show
{
    [self.alertView show];
}


- (void)alertViewCancel:(UIAlertView *)alertView
{
    if(self.cancelBlock!=nil){
        self.cancelBlock(self.errorInfo,nil);
    }
}

@end
