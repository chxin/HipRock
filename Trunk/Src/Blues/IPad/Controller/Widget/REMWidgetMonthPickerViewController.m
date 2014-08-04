//
//  REMWidgetMonthPickerViewController.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 11/5/13.
//
//

#import "REMWidgetMonthPickerViewController.h"

@interface REMWidgetMonthPickerViewController ()
@property (nonatomic,weak) UIPickerView *datePicker;
@end

@implementation REMWidgetMonthPickerViewController


- (IBAction)okClicked:(UIBarButtonItem *)sender {
    int year= [self.datePicker selectedRowInComponent:0];
    int month=[self.datePicker selectedRowInComponent:1];
    NSDate *date;
    if (month==0) {
        NSDateComponents *comp=[[NSDateComponents alloc]init];
        [comp setYear:(year+1)];
        [comp setMonth:1];
        [comp setDay:1];
        date= [[REMTimeHelper currentCalendar] dateFromComponents:comp];
        [self.datePickerProtocol setNewDate: date withStep:REMEnergyStepYear];
    }
    else{
        NSDateComponents *comp=[[NSDateComponents alloc]init];
        [comp setYear:(year+1)];
        [comp setMonth:month];
        [comp setDay:1];
        date= [[REMTimeHelper currentCalendar] dateFromComponents:comp];
        [self.datePickerProtocol setNewDate: date withStep:REMEnergyStepMonth];
    }
    [self cancelClicked:nil];
}


- (IBAction)cancelClicked:(UIBarButtonItem *)sender {
    [self.popController dismissPopoverAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.view setBackgroundColor:[UIColor lightGrayColor]];
	// Do any additional setup after loading the view.
    
    self.title = REMIPadLocalizedString(@"Widget_MonthPickerViewTitle");
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:REMIPadLocalizedString(@"Common_Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancelClicked:)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:REMIPadLocalizedString(@"Common_Done") style:UIBarButtonItemStylePlain target:self action:@selector(okClicked:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIPickerView *datePicker=[[UIPickerView alloc]init];
    [self.view addSubview:datePicker];
    datePicker.showsSelectionIndicator=YES;
    self.datePicker=datePicker;
    self.datePicker.dataSource=self;
    self.datePicker.delegate=self;
    
}

- (void)setPopSize:(CGSize)popSize{
    _popSize=popSize;
    [self.datePicker setFrame:CGRectMake(0, 0, popSize.width, self.datePicker.frame.size.height)];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return 9999;
    }
    else{
        return 13;
    }
}


- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDate *date=[NSDate date];
    NSUInteger year=[REMTimeHelper getYear:date withCalendar:[NSCalendar currentCalendar]];
    NSUInteger month=[REMTimeHelper getMonth:date withCalendar:[NSCalendar currentCalendar]];
    if (component==0) {
        NSDate *date = [REMTimeHelper dateFromYear:row+1 Month:1 Day:1];
        NSString *yearString = [REMTimeHelper formatTime:date withFormat:REMIPadLocalizedString(@"Chart_X_Axis_Format_Year")]; //[NSString stringWithFormat:@"%d%@",row+1,REMIPadLocalizedString(@"Common_Year")];
        NSMutableAttributedString *attrString=[[NSMutableAttributedString alloc]initWithString:yearString];
        if (row == (year-1)) {
            NSRange range=NSMakeRange(0, yearString.length);
            [attrString setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:range];
        }
        return attrString;
    }
    else{
        if (row == 0) {
            NSString *wholeYear=REMIPadLocalizedString(@"Common_WholeYear");
            return [[NSAttributedString alloc]initWithString:wholeYear];
        }
        
        NSDate *date = [REMTimeHelper dateFromYear:year Month:row Day:1];
        NSString *monthString = [REMTimeHelper formatTime:date withFormat:REMIPadLocalizedString(@"Chart_X_Axis_Format_Month")];//[NSString stringWithFormat:@"%d%@",row,REMIPadLocalizedString(@"Common_Month")];
        NSMutableAttributedString *attrString=[[NSMutableAttributedString alloc]initWithString:monthString];
        NSRange range=NSMakeRange(0, monthString.length);
        if (row == month) {
            [attrString setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:range];
        }
        return attrString;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSDate *date=self.timeRange.startTime;
    if (self.step == REMEnergyStepYear) {
       NSUInteger year = [REMTimeHelper getYear:date withCalendar:[NSCalendar currentCalendar]];
        [self.datePicker selectRow:(year-1) inComponent:0 animated:NO];
        [self.datePicker selectRow:0 inComponent:1 animated:NO];
    }
    else{
        NSUInteger year = [REMTimeHelper getYear:date withCalendar:[NSCalendar currentCalendar]];
        NSUInteger month = [REMTimeHelper getMonth:date withCalendar:[NSCalendar currentCalendar]];
        [self.datePicker selectRow:(year-1) inComponent:0 animated:NO];
        [self.datePicker selectRow:month inComponent:1 animated:NO];

    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self timePickerChanged:pickerView];
}

- (void) timePickerChanged:(UIPickerView *)picker{
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
