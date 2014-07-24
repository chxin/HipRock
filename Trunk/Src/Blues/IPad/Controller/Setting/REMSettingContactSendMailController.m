/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMContactSendMailController.m
 * Date Created : 张 锋 on 7/4/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMSettingContactSendMailController.h"
#import "REMCommonHeaders.h"
#import <AudioToolbox/AudioToolbox.h>

@interface REMSettingContactSendMailController ()

@property (nonatomic,strong) NSArray *items;

@property (nonatomic,weak) UITextField *nameField;
@property (nonatomic,weak) UITextField *phoneField;
@property (nonatomic,weak) UITextField *companyField;
@property (nonatomic,weak) UITextField *titleField;
@property (nonatomic,weak) UITextField *descriptionField;

@property (nonatomic,weak) UIBarButtonItem *submitButton;

@end

@implementation REMSettingContactSendMailController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = REMIPadLocalizedString(@"Setting_ContactItemSendMail");
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:REMIPadLocalizedString(@"Common_Cancel") style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked:)];
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:REMIPadLocalizedString(@"Common_Submit") style:UIBarButtonItemStylePlain target:self action:@selector(submitButtonClicked:)];
    submitButton.enabled = NO;
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = submitButton;
    
    self.submitButton = submitButton;
    
    self.items = @[REMIPadLocalizedString(@"Setting_MailFieldName"), REMIPadLocalizedString(@"Setting_MailFieldPhone"), REMIPadLocalizedString(@"Setting_MailFieldCompany"), REMIPadLocalizedString(@"Setting_MailFieldTitle"), REMIPadLocalizedString(@"Setting_MailFieldDescription")];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitButtonClicked:(id)sender {
    //嗖
    NSURL *fileURL = [NSURL URLWithString:@"/System/Library/Audio/UISounds/mail-sent.caf"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)fileURL,&soundID);
    AudioServicesPlaySystemSound(soundID);
    
    NSString *name = REMStringTrim(self.nameField.text);
    NSString *phone = REMStringTrim(self.phoneField.text);
    NSString *company = REMStringTrim(self.companyField.text);
    NSString *title = REMStringTrim(self.titleField.text);
    NSString *description = REMStringTrim(self.descriptionField.text);
    
    NSDictionary *parameter = @{@"dto":@{@"Name":name,@"Telephone":phone,@"CustomerName":company,@"Title":title,@"Comment":description,}};
    REMDataStore *store = [[REMDataStore alloc] initWithName:REMDSUserSendContactMail parameter:parameter accessCache:NO andMessageMap:nil];
    store.isDisableAlert = YES;
    
    [store access:nil];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    // Configure the cell...
    UITextField *field = [[UITextField alloc] init];
    field.placeholder = self.items[indexPath.row];
    if(REMISIOS7){
        field.frame = CGRectMake(15, 5, cell.bounds.size.width - 30, cell.bounds.size.height - 10);
    }
    else{
        field.frame = CGRectMake(38, 10, cell.bounds.size.width - 30, cell.bounds.size.height - 10);
    }
    [field addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [cell addSubview:field];
    
    if(indexPath.row == 0){
        [field becomeFirstResponder];
    }
    
    switch (indexPath.row) {
        case 0:
            self.nameField = field;
            break;
        case 1:
            self.phoneField = field;
            break;
        case 2:
            self.companyField = field;
            break;
        case 3:
            self.titleField = field;
            break;
        case 4:
            self.descriptionField = field;
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void)textFieldChanged:(UITextField *)sender
{
    NSString *name = [self.nameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *phone = [self.phoneField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *company = [self.companyField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //NSTextCheckingResult *phoneRegMatch = [[NSRegularExpression regularExpressionWithPattern:REMREGEX_Telephone options:NSRegularExpressionCaseInsensitive error:NULL] firstMatchInString:phone options:0 range:NSMakeRange(0, phone.length)];
    
    if(REMStringNilOrEmpty(name) || REMStringNilOrEmpty(phone) || REMStringNilOrEmpty(company)/* || phoneRegMatch == nil*/){
        self.submitButton.enabled = NO;
    }
    else{
        self.submitButton.enabled = YES;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
