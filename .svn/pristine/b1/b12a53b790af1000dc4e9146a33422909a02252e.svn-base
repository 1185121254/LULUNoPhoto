//
//  CompanyPersonalViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/23.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "CompanyPersonalViewController.h"

@interface CompanyPersonalViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CompanyPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWith, kHeight-64) style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate =self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];

    [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellDept"];
    

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arryData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellDept" forIndexPath:indexPath];
    NSDictionary *dic = _arryData[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"deptName"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dic = _arryData[indexPath.row];
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取登录医生数据字典
    NSMutableDictionary *userDic=[NSMutableDictionary dictionaryWithDictionary:[userDefaults objectForKey:@"DoctorDataDic"]];

    if ([dic objectForKey:@"deptName"]) {

        [userDic setObject:[dic objectForKey:@"deptName"] forKey:@"licenseDept"];
    }
    [kUserDefatuel setObject:userDic forKey:@"DoctorDataDic"];

    [kUserDefatuel synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
