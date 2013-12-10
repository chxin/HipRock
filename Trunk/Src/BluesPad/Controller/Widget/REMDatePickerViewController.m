/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMDatePickerViewController.m
 * Created      : tantan on 10/24/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
 --------------------------------------------------------------------------*///

#import "REMDatePickerViewController.h"
#import "REMRelativeDateViewController.h"
#import "REMColor.h"
#import "REMBuildingConstants.h"
@interface REMDatePickerViewController ()

@property (nonatomic,weak) UIDatePicker *startPicker;
@property (nonatomic,weak) UIPickerView *startHourPicker;
@property (nonatomic,weak) UIDatePicker *endPicker;
@property (nonatomic,weak) UIPickerView *endHourPicker;

@property (nonatomic) NSUInteger cellCount;
@property (nonatomic) NSUInteger timePickerIndex;

@end

@implementation REMDatePickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.showHour=YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"relativeDateCell"];
    self.cellCount=2;
    [self.tableView setScrollEnabled:NO];
    self.navigationController.navigationBar.backItem.title=NSLocalizedString(@"Common_Cancel", @""); //@"取消";
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    REMRelativeDateViewController *vc= segue.destinationViewController;
    vc.datePickerController=self;
    vc.relativeDate=self.relativeDateType;
}

- (void)setTimeRangeByDateRelative:(NSString *)relative withTimeRange:(REMRelativeTimeRangeType )timeRangeType
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *relativeDateCell= [self.tableView cellForRowAtIndexPath:indexPath];
    UILabel *label= relativeDateCell.contentView.subviews[1];
    label.text=relative;
    self.relativeDateType=timeRangeType;
    self.relativeDate=relative;
    REMTimeRange *range=[REMTimeHelper relativeDateFromType:self.relativeDateType];
    self.timeRange=range;
    
    
    
    [self.startPicker setDate:range.startTime];
    [self.startHourPicker selectRow:[REMTimeHelper getHour:range.startTime] inComponent:0 animated:NO];
    int hour=[REMTimeHelper getHour:range.endTime];
    if(hour==0){
        NSDate *newEndDate=[REMTimeHelper add:-1 onPart:REMDateTimePartDay ofDate:range.endTime];
        [self.endPicker setDate:newEndDate];
        [self.endHourPicker selectRow:24 inComponent:0 animated:NO];
    }
    else{
        [self.endPicker setDate:range.endTime];
        [self.endHourPicker selectRow:hour inComponent:0 animated:NO];
    }
    
    indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
    UITableViewCell *startCell= [self.tableView cellForRowAtIndexPath:indexPath];
     label= startCell.contentView.subviews[1];
    label.text=[REMTimeHelper formatTimeFullHour:range.startTime isChangeTo24Hour:NO];
    if(self.showHour==NO){
        label.text=[REMTimeHelper formatTimeFullDay:range.startTime];
    }
    
    if(self.timePickerIndex==1){
        indexPath=[NSIndexPath indexPathForRow:2 inSection:1];
        UITableViewCell *endCell= [self.tableView cellForRowAtIndexPath:indexPath];
        label= endCell.contentView.subviews[1];
        label.text=[REMTimeHelper formatTimeFullHour:range.endTime isChangeTo24Hour:YES];
        if(self.showHour == NO){
            label.text=[REMTimeHelper formatTimeFullDay:range.endTime];
        }
    }
    else{
        indexPath=[NSIndexPath indexPathForRow:1 inSection:1];
        UITableViewCell *endCell= [self.tableView cellForRowAtIndexPath:indexPath];
        label= endCell.contentView.subviews[1];
        label.text=[REMTimeHelper formatTimeFullHour:range.endTime isChangeTo24Hour:YES];
        if(self.showHour == NO){
            label.text=[REMTimeHelper formatTimeFullDay:range.endTime];
        }
    }

    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)return 1;
    return self.cellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if(indexPath.section==0){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"datePickerCell"];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text= NSLocalizedString(@"Widget_TimePickerTime", @"");// @"时间";
        cell.detailTextLabel.text=self.relativeDate;
    }
    else{
        if(indexPath.row==0){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"datePickerCell"];
            cell.textLabel.text=NSLocalizedString(@"Widget_TimePickerStart", @"");// @"起始";
            NSString *text;
            text=[REMTimeHelper formatTimeFullHour:self.timeRange.startTime isChangeTo24Hour:NO];
            if(self.showHour==NO){
                text=[REMTimeHelper formatTimeFullDay:self.timeRange.startTime];
            }
            cell.detailTextLabel.text=text;
            [self setDateTimeColor:cell.detailTextLabel withIsActive:NO];
        }
        else{
            if(self.cellCount==2){
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"datePickerCell"];
                cell.textLabel.text=NSLocalizedString(@"Widget_TimePickerEnd", @"");// @"终止";
                NSString *text=[REMTimeHelper formatTimeFullHour:(NSDate *)self.timeRange.endTime isChangeTo24Hour:YES];
                if(self.showHour==NO){
                    text=[REMTimeHelper formatTimeFullDay:self.timeRange.endTime];
                }
                cell.detailTextLabel.text=text;
                [self setDateTimeColor:cell.detailTextLabel withIsActive:NO];
            }
            else{
                if(cell==nil){
                    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"datePickerScrollerCell"];
                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                    
                    
                }
                CGFloat hourPickerWidth=0;
                if(self.showHour==YES){
                    hourPickerWidth=80;
                }
                else{
                    hourPickerWidth=0;
                }
                UIDatePicker *picker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width+60-hourPickerWidth, cell.frame.size.height)];
                [picker setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
                [picker setCalendar:[REMTimeHelper currentCalendar]];
                [picker setDatePickerMode:UIDatePickerModeDate];
                [picker addTarget:self action:@selector(timePickerChanged:) forControlEvents:UIControlEventValueChanged];
                
                
                if(self.timePickerIndex==1){
                    [picker setDate:self.timeRange.startTime];
                    
                    self.startPicker=picker;
                   
                }
                else{
                    [picker setDate:self.timeRange.endTime];
                    self.endPicker=picker;
                   
                }
                
                [cell.contentView addSubview:picker];
                
                
                if(self.showHour==YES){
                    UIPickerView *hourPicker=nil;
                    hourPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(picker.frame.size.width, picker.frame.origin.y, hourPickerWidth, picker.frame.size.height)];
                    hourPicker.delegate=self;
                    hourPicker.dataSource=self;
                    hourPicker.showsSelectionIndicator=YES;
                    
                    if(self.timePickerIndex==1){
                        self.startHourPicker=hourPicker;
                        [cell.contentView addSubview:hourPicker];
                        NSUInteger hour=[REMTimeHelper getHour:self.timeRange.startTime];
                        [hourPicker selectRow:hour inComponent:0 animated:NO];
                        
                    }
                    else{
                        self.endHourPicker=hourPicker;
                        [cell.contentView addSubview:hourPicker];
                        NSUInteger hour=[REMTimeHelper getHour:self.timeRange.endTime];
                        if (hour==0) {
                            hour=23;
                            [self.endPicker setDate:[REMTimeHelper add:-1 onPart:REMDateTimePartDay ofDate:self.timeRange.endTime]];
                        }
                        else{
                            hour--;
                        }
                        [hourPicker selectRow:hour inComponent:0 animated:NO];
                        
                    }
                }
            }
        }
    }
    
    return cell;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self hourPickerChanaged:pickerView];
}

- (void) hourPickerChanaged:(UIPickerView *)picker{
    if (picker == self.startHourPicker) {
        [self timePickerChanged:self.startPicker];
    }
    else{
        [self timePickerChanged:self.endPicker];
    }
    
    
}

- (void) timePickerChanged:(UIDatePicker *)picker{
    
    self.relativeDateType=REMRelativeTimeRangeTypeNone;
    self.relativeDate=[REMTimeHelper relativeDateComponentFromType:self.relativeDateType];
    
    int year=[REMTimeHelper getYear:picker.date];
    int month=[REMTimeHelper getMonth:picker.date];
    int day=[REMTimeHelper getDay:picker.date];
    
    UIPickerView *hourPicker;
    
    if(picker==self.startPicker){
        hourPicker=self.startHourPicker;
        
    }
    else{
        hourPicker=self.endHourPicker;
    }
    
    NSUInteger hours= [hourPicker selectedRowInComponent:0];
    
    if(hourPicker==self.endHourPicker){
        hours++;
    }
    
    if(self.showHour==NO){
        hours=0;
    }
    NSDate *newDate;
    if (hours==24) {
        hours=0;
        newDate=[REMTimeHelper dateFromYear:year Month:month Day:day Hour:hours];
        newDate=[REMTimeHelper add:1 onPart:REMDateTimePartDay ofDate:newDate];
    }
    else{
        newDate=[REMTimeHelper dateFromYear:year Month:month Day:day Hour:hours];
    }
    
    NSString *ret;
    
    if(picker==self.startPicker){
        NSDate *endTime=self.timeRange.endTime;
        if ([[REMTimeHelper convertToUtc:newDate] timeIntervalSinceDate:[NSDate date]]>=0) {//greater than now
            REMTimeRange *range = [REMTimeHelper relativeDateFromType:REMRelativeTimeRangeTypeToday];
            newDate=[REMTimeHelper add:-1 onPart:REMDateTimePartHour ofDate:range.endTime];
        }
        
        ret=[REMTimeHelper formatTimeFullHour:newDate isChangeTo24Hour:NO];
        if(self.showHour==NO){
            ret=[REMTimeHelper formatTimeFullDay:newDate];
        }
        REMTimeRange *newRange=[[REMTimeRange alloc]initWithStartTime:newDate EndTime:endTime];
        self.timeRange=newRange;
    }
    else{
        NSDate *startTime=self.timeRange.startTime;
        
        if ([[REMTimeHelper convertToUtc:newDate] timeIntervalSinceDate:[NSDate date]]>=0) {//greater than now
            REMTimeRange *range = [REMTimeHelper relativeDateFromType:REMRelativeTimeRangeTypeToday];
            newDate=range.endTime;
        }
        ret=[REMTimeHelper formatTimeFullHour:newDate isChangeTo24Hour:YES];
        if(self.showHour==NO){
            ret=[REMTimeHelper formatTimeFullDay:newDate];
        }
        REMTimeRange *newRange=[[REMTimeRange alloc]initWithStartTime:startTime EndTime:newDate];
        self.timeRange=newRange;
    }
    NSIndexPath *path;
    if(picker==self.startPicker){
        path=[NSIndexPath indexPathForRow:0 inSection:1];
    }
    else{
        path=[NSIndexPath indexPathForRow:1 inSection:1];
    }
    UITableViewCell *cell= [self.tableView cellForRowAtIndexPath:path];
    UILabel *text= cell.contentView.subviews[1];
    text.text=ret;
    
    NSIndexPath *path1=[NSIndexPath indexPathForRow:path.row==0?2:1 inSection:1];
    UITableViewCell *endCell= [self.tableView cellForRowAtIndexPath:path1];
    UILabel *endText= endCell.contentView.subviews[1];
    
    if ([self.timeRange.startTime timeIntervalSinceDate:self.timeRange.endTime]>=0) {//greater than end time
        
        [self setMiddleLine:endText];
    }
    else{
        [self removeMiddleLine:endText withIsActive:self.timePickerIndex==2];
        
        
    }
    
}

- (void)setMiddleLine:(UILabel *)label{
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:label.text];
    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                            value:[NSNumber numberWithInt:2]
                            range:(NSRange){0,[attributeString length]}];
    [label setTextColor:[UIColor redColor]];
    label.attributedText=attributeString;
}

- (void)removeMiddleLine:(UILabel *)label withIsActive:(BOOL)isActive{
    
    NSString *text=label.text;
    label.attributedText=nil;
    label.text=text;
    if (isActive == YES) {
        [label setTextColor:[REMColor colorByHexString:@"#37ab3c"]];
    }
    else{
        [label setTextColor:[UIColor blackColor]];
    }
    
    
}

- (void)setDateTimeColor:(UILabel *)label withIsActive:(BOOL)isActive{
    if ([label.textColor isEqual:[UIColor redColor]]==YES) {
        return;
    }
    if (isActive == YES) {
        [label setTextColor:[REMColor colorByHexString:@"#37ab3c"]];
    }
    else{
        [label setTextColor:[UIColor blackColor]];
    }
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}



- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 24;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSUInteger ret=row;
    if(pickerView==self.endHourPicker){
        ret++;
    }
    return [NSString stringWithFormat:@"%d",ret];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.cellCount!=2){
        if(indexPath.section==1){
            if(indexPath.row == self.timePickerIndex){
                return 160;
            }
        }
        else{
            return 45;
        }
    }
    else{
        return 45;
    }
    
    return 45;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==0){
        [self performSegueWithIdentifier:@"relativeDateSegue" sender:self];
        
    }
    else{
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        if ([cell.reuseIdentifier isEqualToString:@"datePickerScrollerCell"]==YES) {
            return;
        }
        UILabel *label= cell.contentView.subviews[1];
        [self setDateTimeColor:label withIsActive:YES];
        if(indexPath.row==0){
            if(self.timePickerIndex == 1){
                NSArray* deletePaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]];
                self.cellCount--;
                self.timePickerIndex=NSNotFound;
                [self.tableView beginUpdates];
                [self.startPicker setHidden:YES];
                [self.startHourPicker setHidden:YES];
                [self.tableView deleteRowsAtIndexPaths:deletePaths withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                label.textColor=[UIColor blackColor];
                
            }
            else {
                NSArray* paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]];
                
                if(self.cellCount==2) self.cellCount++;
                NSIndexPath *endPath=[NSIndexPath indexPathForRow:1 inSection:1];
                UITableViewCell *cell=[tableView cellForRowAtIndexPath:endPath];
                UILabel *label= cell.contentView.subviews[1];
                [self setDateTimeColor:label withIsActive:NO];
                [self.tableView beginUpdates];
                if(self.timePickerIndex==2){
                    NSArray* deletePaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:1]];
                    [self.tableView deleteRowsAtIndexPaths:deletePaths withRowAnimation:UITableViewRowAnimationTop];
                }
                self.timePickerIndex=1;
                [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop ];
                
                [self.tableView endUpdates];
                
            }
            
        }
        else{
            if(self.timePickerIndex == 2){
                NSArray* deletePaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:1]];
                self.cellCount--;
                self.timePickerIndex=NSNotFound;
                [self.tableView beginUpdates];
                [self.endPicker setHidden:YES];
                [self.endHourPicker setHidden:YES];
                [self.tableView deleteRowsAtIndexPaths:deletePaths withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                [self setDateTimeColor:label withIsActive:NO];
                
            }
            else {
                NSArray* paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:2 inSection:1]];
                
                if(self.cellCount==2) self.cellCount++;
                
                [self.tableView beginUpdates];
                if(self.timePickerIndex==1){
                    NSArray* deletePaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:1]];
                    [self.tableView deleteRowsAtIndexPaths:deletePaths withRowAnimation:UITableViewRowAnimationTop];
                }
                self.timePickerIndex=2;
                [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop ];
                
                [self.tableView endUpdates];
                NSIndexPath *startPath=[NSIndexPath indexPathForRow:0 inSection:1];
                UITableViewCell *cell=[tableView cellForRowAtIndexPath:startPath];
                UILabel *label= cell.contentView.subviews[1];
                [self setDateTimeColor:label withIsActive:NO];
            }
        }
    }
}
- (IBAction)okClicked:(UIBarButtonItem *)sender {
    
    NSDate *endTime=self.timeRange.endTime;
    NSDate *startTime=self.timeRange.startTime;
    
    if([startTime timeIntervalSinceDate:endTime]>=0){
        //开始日期必须早于结束日期。
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"Widget_TimePickerError", @"") delegate:nil cancelButtonTitle:NSLocalizedString(@"Common_OK", @"") otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    [self.datePickerProtocol setNewTimeRange:self.timeRange withRelativeType:self.relativeDateType withRelativeDateComponent:self.relativeDate];
    [self.popController dismissPopoverAnimated:YES];
}
- (IBAction)cancelClicked:(UIBarButtonItem *)sender {
    [self.popController dismissPopoverAnimated:YES];
}

@end
