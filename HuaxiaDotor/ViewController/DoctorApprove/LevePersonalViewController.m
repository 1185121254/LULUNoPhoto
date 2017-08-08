//
//  LevePersonalViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/23.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "LevePersonalViewController.h"
#import "HospitalNameTableViewCell.h"

@interface LevePersonalViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LevePersonalViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.959];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr_leaveList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"hospitalName";
    HospitalNameTableViewCell *cell = (HospitalNameTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = (HospitalNameTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"HospitalNameTableViewCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
    dic = _arr_leaveList[indexPath.row];
    [cell setCell:dic type:3 select:_str_name];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic_leve =[[NSMutableDictionary alloc]init];
    dic_leve = _arr_leaveList[indexPath.row];
    NSString *str_leve = [[NSString alloc]init];
    str_leve = dic_leve[@"name"];
    
    NSUserDefaults *userDeaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[userDeaults objectForKey:@"DoctorDataDic"]];
    dic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dic setObject:str_leve forKey:@"licenseLevel"];
    [userDeaults setObject:dic forKey:@"DoctorDataDic"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
