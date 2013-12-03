/*------------------------------Summary-------------------------------------
 * Product Name : EMOP iOS Application Software
 * File Name	: REMLoginCustomerTableViewController.m
 * Date Created : 张 锋 on 12/3/13.
 * Description  : IOS Application software based on Energy Management Open Platform
 * Copyright    : Schneider Electric (China) Co., Ltd.
--------------------------------------------------------------------------*/
#import "REMLoginCustomerTableViewController.h"
#import "REMCommonHeaders.h"
#import "REMTrialCardController.h"
#import <QuartzCore/QuartzCore.h>

@interface REMLoginCustomerTableViewController ()

@property (nonatomic,strong) NSArray *customers;

@end

@implementation REMLoginCustomerTableViewController

static NSString *CellIdentifier = @"loginCustomerCell";

-(void)loadView
{
    //load table view container if ios7
    if(REMISIOS7){
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 540, 620)];
        
        UIView *containerView = [self renderRoundCorneredContainer];
        containerView.clipsToBounds = YES;
//        containerView.layer.borderColor = [UIColor orangeColor].CGColor;
//        containerView.layer.borderWidth = 1.0;
        
        UITableView *tableView = [self renderCustomerTableView:containerView.bounds];
//        tableView.backgroundColor = [UIColor yellowColor];
        
        [containerView addSubview:tableView];
        [self.view addSubview:containerView];
    }
    else{
        self.view = [self renderCustomerTableView:CGRectMake(0, 0, 540, 620)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:REMLocalizedString(@"Common_Cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.title = REMLocalizedString(@"Login_CustomerSelectionTitle");
    
    self.customers = (NSArray *)(REMAppCurrentUser.customers);
    
    if(REMISIOS7){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

-(UIView *)renderRoundCorneredContainer
{
    CGFloat offset = 15;
    CGFloat x = offset, y = self.navigationController.navigationBar.frame.size.height;
    CGFloat width = self.view.frame.size.width - 2*offset;
    CGFloat height = self.view.frame.size.height - y;
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(x,y,width,height)];
    //containerView.layer.cornerRadius = 20;
    
    return containerView;
}

-(UITableView *)renderCustomerTableView:(CGRect)frame
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    return tableView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelButtonPressed:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self.loginCardController.loginButton setLoginButtonStatus:REMLoginButtonNormalStatus];
        [self.loginCardController.loginCarouselController.trialCardController.trialButton setLoginButtonStatus:REMLoginButtonNormalStatus];
    }];
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
    return self.customers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    // Configure the cell...
    REMCustomerModel *customer = self.customers[indexPath.row];
    cell.textLabel.text = customer.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    REMCustomerModel *selectedCustomer=nil;
    
    for(REMCustomerModel *customer in self.customers){
        if([customer.name isEqualToString:cell.textLabel.text]){
            selectedCustomer = customer;
            break;
        }
    }
    
    if(selectedCustomer != nil){
        [REMAppContext setCurrentCustomer:selectedCustomer];
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            [self.loginCardController loginSuccess];
        }];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(REMISIOS7 == NO){
        return;
    }
    
    if ([cell respondsToSelector:@selector(tintColor)]) {
        CGFloat cornerRadius = 6.f;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 5, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
        } else if (indexPath.row == 0) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        } else {
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
        
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+5, bounds.size.height-lineHeight, bounds.size.width-5, lineHeight);
            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}

@end
