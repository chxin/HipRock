/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMRelativeDateViewController.h
 * Created      : tantan on 10/24/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import <UIKit/UIKit.h>
#import "REMEnum.h"
#import "REMDatePickerViewController.h"


@interface REMRelativeDateViewController : UITableViewController


@property (nonatomic) REMRelativeTimeRangeType relativeDate;

@property (nonatomic,weak) REMDatePickerViewController *datePickerController;


@end
