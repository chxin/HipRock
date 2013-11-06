//
//  REMDatePickerViewController.m
//  Blues
//  ©2013 施耐德电气（中国）有限公司版权所有
//  Created by tantan on 10/24/13.
//
//

#import "REMDatePickerViewController.h"
#import "REMRelativeDateViewController.h"

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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"relativeDateCell"];
    self.cellCount=2;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell = [tableView dequeueReusableCellWithIdentifier:@"relativeDateCell" forIndexPath:indexPath];
    if(cell.contentView.subviews.count>0){
        if(self.timePickerIndex==1){
            if(self.startPicker!=nil){
                [self.startPicker setHidden:NO];
                [self.startHourPicker setHidden:NO];
            }
        }
        else if(self.timePickerIndex==2){
             if(self.endPicker!=nil){
                 [self.endPicker setHidden:NO];
                 [self.endHourPicker setHidden:NO];
             }
        }
        else{
            return cell;
        }
    }
    
    if(indexPath.section==0){
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text= NSLocalizedString(@"Widget_TimePickerTime", @"");// @"时间";
        UILabel *relative=[[UILabel alloc]initWithFrame:cell.contentView.frame];
        relative.backgroundColor=[UIColor clearColor];
        relative.textAlignment=NSTextAlignmentCenter;
        relative.text=self.relativeDate;
        [cell.contentView addSubview:relative];
    }
    else{
        if(indexPath.row==0){
            cell.textLabel.text=NSLocalizedString(@"Widget_TimePickerStart", @"");// @"起始";
            UILabel *start=[[UILabel alloc]initWithFrame:cell.contentView.frame];
            start.text=[REMTimeHelper formatTimeFullHour:self.timeRange.startTime isChangeTo24Hour:NO];
            if(self.showHour==NO){
                start.text=[REMTimeHelper formatTimeFullDay:self.timeRange.startTime];
            }
            start.backgroundColor=[UIColor clearColor];
            start.textAlignment=NSTextAlignmentCenter;
            [cell.contentView addSubview:start];
            //NSLog(@"cell is %@",NSStringFromCGRect(cell.frame));
        }
        else{
            if(self.cellCount==2){
                cell.textLabel.text=NSLocalizedString(@"Widget_TimePickerEnd", @"");// @"终止";
                UILabel *end=[[UILabel alloc]initWithFrame:cell.contentView.frame];
                end.text=[REMTimeHelper formatTimeFullHour:(NSDate *)self.timeRange.endTime isChangeTo24Hour:YES];
                if(self.showHour==NO){
                    end.text=[REMTimeHelper formatTimeFullDay:self.timeRange.endTime];
                }
                end.backgroundColor=[UIColor clearColor];
                end.textAlignment=NSTextAlignmentCenter;

                [cell.contentView addSubview:end];
            }
            else{
                CGFloat hourPickerWidth=0;
                if(self.showHour==YES){
                    hourPickerWidth=80;
                }
                else{
                    hourPickerWidth=0;
                }
                UIDatePicker *picker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width-20-hourPickerWidth, cell.frame.size.height)];
                [picker setDatePickerMode:UIDatePickerModeDate];
                [picker addTarget:self action:@selector(timePickerChanged:) forControlEvents:UIControlEventValueChanged];
                UIPickerView *hourPicker=nil;
                if(self.showHour==YES){
                    hourPicker=[[UIPickerView alloc]initWithFrame:CGRectMake(picker.frame.size.width, picker.frame.origin.y, hourPickerWidth, picker.frame.size.height)];
                    hourPicker.delegate=self;
                    hourPicker.dataSource=self;
                    hourPicker.showsSelectionIndicator=YES;
                }
                
                if(self.timePickerIndex==1){
                    [picker setDate:self.timeRange.startTime];
                    if(self.showHour==YES){
                        NSUInteger hour=[REMTimeHelper getHour:self.timeRange.startTime];
                        [hourPicker selectRow:hour inComponent:0 animated:NO];
                    }
                    self.startPicker=picker;
                    self.startHourPicker=hourPicker;
                }
                else{
                    [picker setDate:self.timeRange.endTime];
                    self.endPicker=picker;
                    NSUInteger hour=[REMTimeHelper getHour:self.timeRange.endTime];
                    hour++;
                    [hourPicker selectRow:hour inComponent:0 animated:NO];
                    self.endHourPicker=hourPicker;
                }
                //UIPickerView *hourPicker=[[UIPickerView alloc]initWithFrame:picker.frame];
                
                [cell.contentView addSubview:picker];
                if(self.showHour==YES){
                    [cell.contentView addSubview:hourPicker];
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
    self.relativeDate=NSLocalizedString(@"Common_CustomTime", @"");//自定义
    
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
    
    if(self.showHour==NO){
        hours=0;
    }
    
    NSDate *newDate=[REMTimeHelper dateFromYear:year Month:month Day:day Hour:hours];
    
    NSString *ret;
    
    if(picker==self.startPicker){
        ret=[REMTimeHelper formatTimeFullHour:newDate isChangeTo24Hour:NO];
        if(self.showHour==NO){
            ret=[REMTimeHelper formatTimeFullDay:newDate];
        }
        REMTimeRange *newRange=[[REMTimeRange alloc]initWithStartTime:newDate EndTime:self.timeRange.endTime];
        self.timeRange=newRange;
    }
    else{
        ret=[REMTimeHelper formatTimeFullHour:newDate isChangeTo24Hour:YES];
        if(self.showHour==NO){
            ret=[REMTimeHelper formatTimeFullDay:newDate];
        }
        REMTimeRange *newRange=[[REMTimeRange alloc]initWithStartTime:self.timeRange.startTime EndTime:newDate];
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
        UILabel *label= cell.contentView.subviews[1];
        label.textColor=[UIColor orangeColor];
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
                label.textColor=[UIColor blackColor];
                
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
            }
        }
    }
}
- (IBAction)okClicked:(UIBarButtonItem *)sender {
    [self.datePickerProtocol setNewTimeRange:self.timeRange withRelativeType:self.relativeDateType withRelativeDateComponent:self.relativeDate];
    [self.popController dismissPopoverAnimated:YES];
}
- (IBAction)cancelClicked:(UIBarButtonItem *)sender {
    [self.popController dismissPopoverAnimated:YES];
}

@end
