/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLoginCustomerTableViewController.h
 * Date Created : 张 锋 on 12/3/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>
#import "REMLoginCardController.h"
#import "REMManagedCustomerModel.h"


@protocol REMLoginCustomerSelectionDelegate <NSObject>

-(void)customerSelectionTableView:(UITableView *)table didSelectCustomer:(REMManagedCustomerModel *)customer;
-(void)customerSelectionTableViewdidDismissView;

@end

@protocol REMCustomerSelectionInterface

- (void)customerSelectionTableViewUpdate;

@property (nonatomic,strong) NSArray *customerArray;



@end

@interface REMLoginCustomerTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,REMCustomerSelectionInterface>
@property (nonatomic) BOOL hideCancelButton;
@property (nonatomic,weak) NSObject<REMLoginCustomerSelectionDelegate> *delegate;
@property (nonatomic,strong) id holder;

@end
