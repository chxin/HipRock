//
//  REMSettingCustomerDetailViewController.m
//  Blues
//
//  Created by tantan on 9/29/13.
//
//

#import "REMSettingCustomerDetailViewController.h"

@interface REMSettingCustomerDetailViewController ()

@end

@implementation REMSettingCustomerDetailViewController

static NSString * cellId=@"cell";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    
    
    if(indexPath.row==0){
        cell.textLabel.text=@"名称";
    }
    else if(indexPath.row==1){
        
    }
    else if(indexPath.row==2){
        
    }
    else if(indexPath.row==3){
        
    }
    else if(indexPath.row==4){
        
    }
    else if(indexPath.row==5){
        
    }
    else if(indexPath.row==6){
        
    }
    else if(indexPath.row==7){
        
    }
    else if(indexPath.row==8){
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
