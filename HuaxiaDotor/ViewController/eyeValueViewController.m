//
//  eyeValueViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/4/11.
//  Copyright © 2016年 kock. All rights reserved.
//  

#import "eyeValueViewController.h"
#import "ShowElectronViewController.h"

@interface eyeValueViewController ()<UITableViewDataSource,UITableViewDelegate>

//设置用户的ID和VerifyCode
@property (strong, nonatomic)NSString *verifyCode,*userID;

//用户数组数据
@property (strong, nonatomic) NSMutableArray *DataArr;
@property (strong, nonatomic) UITableView *tableview;

@end

@implementation eyeValueViewController

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
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStyleGrouped];
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

    NSMutableArray *cellnameArr=[NSMutableArray new];
    for (int i=0; i<self.DataArr.count; i++)
    {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=NO;
        
        NSDictionary *dic=[NSDictionary new];
        dic=self.DataArr[i];
        NSString *table_name=dic[@"name"];
        
        [cellnameArr addObject:table_name];
    }
    cell.textLabel.text=[cellnameArr objectAtIndex:indexPath.row];
    
    return cell;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 获取眼科常用正常值列表数据
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
    //    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    
    //获取需要上传的数据
    //GET
    [RequestManager getWithURLString:TOOL_EYEVALUE heads:heads parameters:nil success:^(id responseObject)
     {
         NSMutableDictionary *DataDic=(NSMutableDictionary *)responseObject;
         self.DataArr=[NSMutableArray new];
         self.DataArr = DataDic[@"value"];
//                  NSLog(@"%@",self.DataArr);
         
         [self.tableview reloadData];
         
     } failure:^(NSError *error)
     {
         NSLog(@"ERROR%@",error);
     }];
}

#pragma mark - 点击跳转到对应页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    NSDictionary *Urldic=[NSDictionary new];
    Urldic = self.DataArr[indexPath.row];
    
    ShowElectronViewController *webViewcontroller=[[ShowElectronViewController alloc]init];
    webViewcontroller.electronTitle = Urldic[@"name"];
    webViewcontroller.strURL = Urldic[@"webUrl"];
    [self.navigationController pushViewController:webViewcontroller animated:YES];
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