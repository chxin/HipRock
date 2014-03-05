//
//  REMWidgetMonthPickerViewController.h
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/5/13.
//
//

#import <UIKit/UIKit.h>
#import "REMDatePickerViewController.h"

@protocol REMWidgetMonthPickerViewProtocol <NSObject>

- (void) setNewDate:(NSDate *)date withStep:(REMEnergyStep)step;

@end

@interface REMWidgetMonthPickerViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,strong) REMTimeRange *timeRange;
@property (nonatomic) REMEnergyStep step;
@property (nonatomic,weak) UIPopoverController *popController;
@property (nonatomic) CGSize popSize;
@property (nonatomic) id<REMWidgetMonthPickerViewProtocol> datePickerProtocol;
@end
