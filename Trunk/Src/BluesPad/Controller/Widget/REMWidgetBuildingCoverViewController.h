/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMWidgetBuildingCoverViewController.h
 * Date Created : tantan on 12/27/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import <UIKit/UIKit.h>

@interface REMWidgetBuildingCoverViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,weak) UIPopoverController *popController;
@property (nonatomic,strong) NSArray *data;
@end
