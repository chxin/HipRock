/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMContactViewController.m
 * Date Created : 张 锋 on 7/4/14.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMSettingContactViewController.h"
#import "REMSettingContactSendMailController.h"
#import "REMFont.h"

@interface REMSettingContactViewController ()

@property (nonatomic,strong) NSArray *items;
@property (nonatomic,strong) NSArray *segues;

@end

@implementation REMSettingContactViewController


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
    
    self.items = @[REMIPadLocalizedString(@"Setting_ContactItemSendMail"),REMIPadLocalizedString(@"Setting_ContactItemContactPhone"),REMIPadLocalizedString(@"Setting_ContactItemWeSite")];
    self.segues = @[@"settingContactMailSegue",@"settingContactPhoneSegue",@"settingContactWeSiteSegue",];
    
    
    self.title = REMIPadLocalizedString(@"Setting_ContactUs");
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:REMIPadLocalizedString(@"Common_Done") style:UIBarButtonItemStylePlain target:self action:@selector(okButtonClicked:)];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.navigationItem.rightBarButtonItem = doneButton;
    
    
}

- (IBAction)okButtonClicked:(id)sender {
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
    
    NSString *text = self.items[indexPath.row];
    cell.textLabel.text = text;
    cell.textLabel.font = [REMFont defaultFontSystemSize];
    
    if(indexPath.row !=0){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if(indexPath.row == 2){
        UIImageView *codeIcon = [[UIImageView alloc] initWithImage:REMIMG_QRCodeIcon];
        codeIcon.frame = CGRectMake(0, 0, 32, 32);
        codeIcon.translatesAutoresizingMaskIntoConstraints = NO;
        
        [cell.contentView addSubview:codeIcon];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:codeIcon attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:codeIcon attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        REMSettingContactSendMailController *mailController = [[REMSettingContactSendMailController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mailController];
        navigationController.modalInPopover = YES;
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [self presentViewController:navigationController animated:YES completion:nil];
        
        return;
    }
    
    NSString *segue = self.segues[indexPath.row];
    [self performSegueWithIdentifier:segue sender:self];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return REMIPadLocalizedString(@"Setting_ContactHeader");
    }
    return @"";
}


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
