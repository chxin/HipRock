//
//  REMWidgetTimePickerViewController.h
//  Blues
//
//  Created by 谭 坦 on 7/18/13.
//
//

#import <UIKit/UIKit.h>
#import "REMTimeRange.h"
#import "REMTimeHelper.h"
#import "REMWidgetMaxViewController.h"

@class  REMWidgetMaxViewController;

@interface REMWidgetTimePickerViewController : UIViewController
- (IBAction)datePickerClick:(UIDatePicker *)sender;

@property (nonatomic,strong) NSDate *dateTime;
@property (nonatomic,strong) NSString *type;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,weak) UIPopoverController *popController;
@property (nonatomic,weak) REMWidgetMaxViewController *maxController;
@end
