//
//  SeachFriendViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/9.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "SeachFriendViewController.h"
#import "SeachFriendTableViewCell.h"
#import "DoctorInfoTableViewController.h"
@interface SeachFriendViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *view_table;
@property (weak, nonatomic) IBOutlet UILabel *lbl_seachTitle;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSString *verifyCode;
@property (strong, nonatomic)  UITextField *txtSeach;
@property (strong, nonatomic) NSMutableArray *arrSeachInfoData;

@end

@implementation SeachFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    _arrSeachInfoData = [[NSMutableArray alloc]init];
    
    _txtSeach = [[UITextField alloc]initWithFrame:CGRectMake(30, 8, SCREEN_W-30-50, 30)];
    _txtSeach.borderStyle = UITextBorderStyleRoundedRect;
    _txtSeach.placeholder = @"🔍请输入医生姓名或电话";
    [self.navigationController.navigationBar addSubview:_txtSeach];
}

#pragma mark - 搜索按钮
- (IBAction)btnActionSeach:(UIBarButtonItem *)sender
{
    //从NSUserDefaults获取身份验证秘钥
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    self.verifyCode=[userdefault objectForKey:@"verifyCode"];
    
    //获取verifyCode 和 ID
    //获取已添加页面的数据
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    self.verifyCode=[userDefaults objectForKey:@"verifyCode"];
    
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:self.verifyCode};
    
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    
    NSString *strSeachInfo = _txtSeach.text;
    if ([strSeachInfo isEqualToString:@""])
    {
        [showAlertView showAlertViewWithOnlyMessage:@"搜索内容不能为空"];
    }
    else
    {
        [parameters setObject:strSeachInfo forKey:@"value"];
        
        //获取需要上传的数据
        //GET
        [RequestManager getWithURLString:SEACHFRIENDDATA heads:heads parameters:parameters success:^(id responseObject)
         {
             
             NSLog(@"%@",responseObject);
             _arrSeachInfoData = responseObject[@"value"];
             if (_arrSeachInfoData.count!=0)
             {
                 _lbl_seachTitle.text = [NSString stringWithFormat:@"搜索到%lu个结果",(unsigned long)_arrSeachInfoData.count];
                 [_view_table reloadData];
             }
             else
             {
                 _lbl_seachTitle.text = [NSString stringWithFormat:@"搜索到0个结果"];
             }
         } failure:^(NSError *error)
         {
             NSLog(@"ERROR%@",error);
         }];
    }
}

#pragma mark - tableiview datasouse delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrSeachInfoData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeachFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SeachFriendTableViewCell"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SeachFriendTableViewCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCell:_arrSeachInfoData[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *storyView =[UIStoryboard storyboardWithName:@"EYECIRCLE" bundle:[NSBundle mainBundle]];
    DoctorInfoTableViewController *doctorView =[storyView instantiateViewControllerWithIdentifier:@"doctorView"];
    self.delegate = doctorView;
    [self.delegate sendDoctorDicData:_arrSeachInfoData[indexPath.row]];
    
    [self.navigationController pushViewController:doctorView animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_txtSeach removeFromSuperview];
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
