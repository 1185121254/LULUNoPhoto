//
//  MassageTableViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/10.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "MassageTableViewController.h"
#import "MassageTableViewCell.h"
#import "MassageInfo.h"
@interface MassageTableViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *view_table;
@property (strong, nonatomic) NSMutableArray *arr_massage;
@end

@implementation MassageTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    _arr_massage = [[NSMutableArray alloc]init];
    
    [self getMassageData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
//    self.view.backgroundColor = kBackgroundColor;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr_massage.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MassageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalStoryBoard"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MassageTableViewCell" owner:self options:nil]lastObject];
    }
    [cell setCell:_arr_massage[indexPath.row]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return -1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //创建新增患者界面
    UIStoryboard *storyboardName=[UIStoryboard storyboardWithName:@"PersonalStoryBoard" bundle:[NSBundle mainBundle]];
    //指定对应的故事版
    MassageInfo *view=[storyboardName instantiateViewControllerWithIdentifier:@"MassageInfo"];
    view.dic = _arr_massage[indexPath.row];
       //推送
    [self.navigationController pushViewController:view animated:YES];

}

#pragma mark - 获取网络数据
-(void)getMassageData
{
    //从NSUserDefaults获取身份验证秘钥
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode;
    verifyCode=[userdefault objectForKey:@"verifyCode"];
//    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    //POST
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    //设置需要上传的字典数据
    //医生ID
    NSString *userID;
    userID = [userdefault objectForKey:@"id"];
    [parameters setObject:userID forKey:@"doctorId"];
    
    //获取需要上传的数据
    //GET
    [RequestManager getWithURLString:GETSTACEMESSAGEBYDOC heads:heads parameters:parameters success:^(id responseObject)
     {
         if (responseObject[@"value"] == nil|| [responseObject[@"value"] count]==0) {
            [self.view addSubview:[NoData singleNoDate:self.view center:YES]];
         }else{
             [[NoData singleNoDate:self.view center:YES] removeFromSuperview];
             _arr_massage = responseObject[@"value"];
             [self.tableView reloadData];
         }
     } failure:^(NSError *error)
     {
         NSLog(@"ERROR%@",error);
     }];
}


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
