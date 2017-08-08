//
//  CommonlyUsedDrugsGound.m
//  HuaxiaDotor
//
//  Created by kock on 16/4/11.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "CommonlyUsedDrugsGound.h"
#import "CommonlyUsedDrugsViewController.h"
#import "ShowElectronViewController.h"
@interface CommonlyUsedDrugsGound ()<UITableViewDataSource,UITableViewDelegate>

//设置用户的ID和VerifyCode
@property (strong, nonatomic)NSString *verifyCode,*userID;

//用户数组数据
@property (strong, nonatomic) NSMutableArray *DataArr;
@property (strong, nonatomic) UITableView *tableview;

@end

@implementation CommonlyUsedDrugsGound

-(void)viewWillAppear:(BOOL)animated
{
    [self getTableviewData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //创建tableView
    [self createTableView];

}

#pragma mark - 创建tableview
-(void)createTableView
{
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)style:UITableViewStyleGrouped];
    self.tableview.dataSource=self;
    self.tableview.delegate=self;
    [self.view addSubview:self.tableview];
}

#pragma mark - tableview代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.DataArr.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - tableview data
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=NO;
    
    NSDictionary *dic = self.DataArr[indexPath.row];
    cell.textLabel.text=[dic objectForKey:@"name"];
    return cell;
}

#pragma mark - 获取常用具体分组信息
-(void)getTableviewData
{
    //获取verifyCode 和 ID
    //获取已添加页面的数据
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    self.verifyCode=[userDefaults objectForKey:@"verifyCode"];
    
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:self.verifyCode};
    
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    NSString *idTag=[NSString stringWithFormat:@"%@",self.channelID];
    [parameters setObject:idTag forKey:@"channelId"];
    
    //获取需要上传的数据
    //GET
    [RequestManager getWithURLString:COMMONLY_USED_DRUGS_GOUND heads:heads parameters:parameters success:^(id responseObject)
     {
         NSMutableDictionary *DataDic=(NSMutableDictionary *)responseObject;
         self.DataArr=[NSMutableArray new];
         self.DataArr = DataDic[@"value"];
         
         [self.tableview reloadData];
         
     } failure:^(NSError *error)
     {
         NSLog(@"ERROR%@",error);
     }];
}

#pragma mark - 点击跳转到对应页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSDictionary *Urldic = _DataArr[indexPath.row];

    ShowElectronViewController *webViewcontroller=[[ShowElectronViewController alloc]init];
    webViewcontroller.electronTitle = Urldic[@"name"];
    webViewcontroller.strURL = Urldic[@"webUrl"];
    [self.navigationController pushViewController:webViewcontroller animated:YES];
}

- (void)didReceiveMemoryWarning
{
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
