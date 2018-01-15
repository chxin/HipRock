//
//  ViewController.m
//  TestRock
//
//  Created by SamuelMac on 2017/4/26.
//  Copyright © 2017年 SamuelMac. All rights reserved.
//

#import "ViewController.h"

//#import "TestLibrary/TestLibrary.h"

//#import <TestFramework/CustomerObject.h>

//#import <TestFramework/TestFramework.h>

#define FYColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define FYRandomColor FYColor(arc4random_uniform(255),arc4random_uniform(255),arc4random_uniform(255))


@interface ViewController ()

@property(strong,nonatomic) UITableView *MyTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    TestLibrary*library=[[TestLibrary alloc]init];
//    [library printObject];
//
//    CustomerObject *object=[[CustomerObject alloc]init];
//    [object printObject];
    
    
    self.MyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 300,self.view.frame.size.width) style:UITableViewStylePlain];
    self.MyTableView.dataSource=self;
    self.MyTableView.delegate=self;
    //对TableView要做的设置
    self.MyTableView.transform=CGAffineTransformMakeRotation(-M_PI / 2);
    self.MyTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.MyTableView];
    
//    [[[CustomerObject alloc]init] printObject];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FyCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FyCell"];
    }
    //对Cell要做的设置
    cell.backgroundColor=FYRandomColor;
    cell.textLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
    cell.textLabel.text= @"tableview竖向滚动";
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
