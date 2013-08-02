//
//  REMWidgetTimePickerViewController.m
//  Blues
//
//  Created by 谭 坦 on 7/18/13.
//
//

#import "REMWidgetTimePickerViewController.h"

@interface REMWidgetTimePickerViewController ()

@end

@implementation REMWidgetTimePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];
    
    if(self.dateTime != nil)
    {
        [self.datePicker setDate:self.dateTime animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)datePickerClick:(UIDatePicker *)sender {
    NSDate *date = [sender date];
    
    if([self.type isEqualToString:@"start"] == YES)
    {
        [self.maxController setStartDate:date];
    }
    else
    {
        [self.maxController setEndDate:date];
    }
    
    [self.popController dismissPopoverAnimated:YES];
    
}
@end
