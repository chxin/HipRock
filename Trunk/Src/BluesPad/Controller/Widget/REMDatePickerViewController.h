//
//  REMDatePickerViewController.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 10/24/13.
//
//

#import <UIKit/UIKit.h>
#import "REMWidgetObject.h"
#import "REMWidgetDetailViewController.h"

@protocol REMWidgetDatePickerViewProtocol <NSObject>

- (void) setNewTimeRange:(REMTimeRange *)newRange withRelativeType:(REMRelativeTimeRangeType)relativeType withRelativeDateComponent:(NSString *)newDateComponent;

@end

@interface REMDatePickerViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) REMTimeRange *timeRange;
@property (nonatomic,strong) NSString *relativeDate;
@property (nonatomic) REMRelativeTimeRangeType relativeDateType;

@property (nonatomic,weak) NSObject<REMWidgetDatePickerViewProtocol> *datePickerProtocol;
@property (nonatomic,weak) UIPopoverController *popController;

@property (nonatomic) BOOL showHour;


- (void)setTimeRangeByDateRelative:(NSString *)relative withTimeRange:(REMRelativeTimeRangeType )timeRangeType;

@end
