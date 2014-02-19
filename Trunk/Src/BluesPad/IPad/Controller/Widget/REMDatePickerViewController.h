/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDatePickerViewController.h
 * Created      : tantan on 10/24/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

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

@property (nonatomic,weak) id<REMWidgetDatePickerViewProtocol> datePickerProtocol;
@property (nonatomic,weak) UIPopoverController *popController;

@property (nonatomic) BOOL showHour;

- (void)setTimeRangeByDateRelative:(NSString *)relative withTimeRange:(REMRelativeTimeRangeType )timeRangeType;

@end
