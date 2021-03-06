//
//  PersonalViewController.m
//  dawnEye
//
//  Created by KockPeter on 16/3/10.
//  Copyright © 2016年 kockPeter. All rights reserved.
//

#import "PersonalViewController.h"
//站内消息
#import "MassageTableViewController.h"
//设置
#import "KockSettingViewController.h"

#import "OnLineViewController.h"

//账户管理
#import "AccountManagerViewController.h"

#import "MoneyPickViewController.h"
//我的收藏
#import "MyStoreViewController.h"
#import "HelpEyeViewController.h"
#import "ShareAppViewController.h"
@interface PersonalViewController ()


@end

@implementation PersonalViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置组头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //第一行,组头为0
    if (section==0)
    {
        return 0.1;
    }
    //其他行数,组头为最小值
    return CGFLOAT_MIN;
    return tableView.sectionHeaderHeight;
}

// 设置组尾的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicLog = [kUserDefatuel objectForKey:@"DoctorDataDic"];

    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            //站内消息页面
            [self pushMassgeView];
        }
        else if (indexPath.row==1)
        {
            //我的收藏
            MyStoreViewController *collect = [[MyStoreViewController alloc]init];
            [self.navigationController pushViewController:collect animated:YES];
            
        }
        else if (indexPath.row==2)
        {
            if ([[dicLog objectForKey:@"state"] integerValue]==2) {
                //我的钱包
                MoneyPickViewController *money = [[MoneyPickViewController alloc]init];
                [self.navigationController pushViewController:money animated:YES];
            }else
            {
                IsCertificateViewController *isCer = [[IsCertificateViewController alloc]init];
                isCer.from = @"我的钱包";
                [self.navigationController pushViewController:isCer animated:YES];
            }
        }
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            if([[dicLog objectForKey:@"state"] integerValue]==2){
                //账户管理
                [self AccountManager];
            }else
            {
                IsCertificateViewController *isCer = [[IsCertificateViewController alloc]init];
                isCer.from = @"账户管理";
                [self.navigationController pushViewController:isCer animated:YES];
            }
        }
        else if (indexPath.row==1)
        {
            if ([[dicLog objectForKey:@"state"] integerValue]==2) {
                //在线服务
                OnLineViewController *onLine = [[OnLineViewController alloc]init];
                [self.navigationController pushViewController:onLine animated:YES];
            }else
            {
                IsCertificateViewController *isCer = [[IsCertificateViewController alloc]init];
                isCer.from = @"在线服务";
                [self.navigationController pushViewController:isCer animated:YES];
            }

        }
    }
    else if (indexPath.section==2)
    {
        if (indexPath.row == 0){
            
            ShareAppViewController *share = [[ShareAppViewController alloc]init];
            [self.navigationController pushViewController:share animated:YES];
        }else if(indexPath.row ==1){
            HelpEyeViewController *help = [[HelpEyeViewController alloc]init];
            [self.navigationController pushViewController:help animated:YES];
        }else
        {
            //设置页面
            [self settingForDoctorInfoData];
        }
    }
}

#pragma mark - 站内消息页面
-(void)pushMassgeView
{
    //创建新增患者界面
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"PersonalStoryBoard" bundle:[NSBundle mainBundle]];
    //指定对应的故事版
    MassageTableViewController *massageTable=[storyboard instantiateViewControllerWithIdentifier:@"MassageTableView"];
    //推送
    [self.navigationController pushViewController:massageTable animated:YES];
}

#pragma mark - 设置页面
-(void)settingForDoctorInfoData
{
    //创建新增患者界面
    UIStoryboard *settingStoryBoard=[UIStoryboard storyboardWithName:@"PersonalStoryBoard" bundle:[NSBundle mainBundle]];
    //指定对应的故事版
    KockSettingViewController *SettingView=[settingStoryBoard instantiateViewControllerWithIdentifier:@"settingStoryBoard"];
    //推送
    [self.navigationController pushViewController:SettingView animated:YES];
}

#pragma mark - 账号管理
-(void)AccountManager
{
    //创建新增患者界面
    UIStoryboard *storyboardName=[UIStoryboard storyboardWithName:@"AccountManager" bundle:[NSBundle mainBundle]];
    //指定对应的故事版
    AccountManagerViewController *AcountView=[storyboardName instantiateViewControllerWithIdentifier:@"AccountManager"];
    //推送
    [self.navigationController pushViewController:AcountView animated:YES];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
