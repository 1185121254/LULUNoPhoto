//
//  HelpDetailViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/12/8.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "HelpDetailViewController.h"
#import "ShowElectronViewController.h"

@interface HelpDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{

    __weak IBOutlet UITableView *helpDetailtable;
    NSMutableArray *arr;

}
@end

@implementation HelpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arr = [NSMutableArray arrayWithArray:@[@"sad",@"sdsd",@"we",@"fc"]];
    
    helpDetailtable.rowHeight = UITableViewAutomaticDimension;
    helpDetailtable.estimatedRowHeight = 300;
    [helpDetailtable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"helpCell"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"helpCell" forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = arr[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return -1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShowElectronViewController *showWeb = [[ShowElectronViewController alloc]init];
    showWeb.strURL = @"http://wx.yanketong.com/h5/Default.aspx";
    showWeb.electronTitle = @"眼科帮助";
    [self.navigationController pushViewController:showWeb animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
