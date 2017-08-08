
//
//  HospitalPersonalViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/23.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "HospitalPersonalViewController.h"
#import "HospitalNameTableViewCell.h"

@interface HospitalPersonalViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HospitalPersonalViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.959];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr_hosList.count;
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
    dic = _arr_hosList[indexPath.row];
    [cell setCell:dic type:1 select:_str_hosListName];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
    dic = _arr_hosList[indexPath.row];
    NSString *str_name = [[NSString alloc]init];
    str_name = dic[@"hosName"];
    NSUserDefaults *userDeaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic=[NSMutableDictionary new];
    userDic = [userDeaults objectForKey:@"DoctorDataDic"];
    userDic = [NSMutableDictionary dictionaryWithDictionary:userDic];
    [userDic setObject:str_name forKey:@"licenseHospital"];
    [userDeaults setObject:userDic forKey:@"DoctorDataDic"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSArray *arry = [dic objectForKey:@"deptList"];
    
    if (arry.count == 0 ||arry == nil) {
        //获取登录医生数据字典
        NSMutableDictionary *userDic=[NSMutableDictionary dictionaryWithDictionary:[kUserDefatuel objectForKey:@"DoctorDataDic"]];
        
        [userDic setObject:@"" forKey:@"licenseDept"];
        
        [kUserDefatuel setObject:userDic forKey:@"DoctorDataDic"];
        
        [kUserDefatuel synchronize];
        
    }
    
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
