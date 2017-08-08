//
//  CommonlyUsedDrugsViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/4/11.
//  Copyright © 2016年 kock. All rights reserved.
//  眼科常用药物

#import "CommonlyUsedDrugsViewController.h"
#import "CommonlyUsedDrugsGound.h"
#import "GrugModel.h"
#import "EyeDrugSearchViewController.h"

@interface CommonlyUsedDrugsViewController ()<UITableViewDataSource,UITableViewDelegate>

//设置用户的ID和VerifyCode
@property (strong, nonatomic)NSString *verifyCode,*userID;

//用户数组数据
@property (strong, nonatomic) NSMutableArray *DataArr;

@property(nonatomic,strong) NSMutableArray *arrySearch;

@property (nonatomic,strong) NSMutableArray *arryName;

@property (strong, nonatomic) UITableView *tableview;

@end

@implementation CommonlyUsedDrugsViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    [self getTableviewData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //创建tableView
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBackgroundColor;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(onLefybacK)];
    self.navigationItem.leftBarButtonItem = left;
    
    [self createTableView];
    [self search];
}

-(void)search{
    
    UIButton *btnSearchCon       = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearchCon.backgroundColor = [UIColor whiteColor];
    btnSearchCon.frame           = CGRectMake(10, 64+7, kWith-20*2, 30);
    [btnSearchCon setTitle:@"🔍输入患者相关信息" forState:UIControlStateNormal];
    [btnSearchCon setTitleColor:kBoradColor forState:UIControlStateNormal];
    [btnSearchCon addTarget:self action:@selector(onSearchComMenly) forControlEvents:UIControlEventTouchUpInside];
    btnSearchCon.layer.cornerRadius = 3;
    btnSearchCon.layer.masksToBounds = YES;
    [self.view addSubview:btnSearchCon];
    
}

-(void)onSearchComMenly{
    EyeDrugSearchViewController *eye = [[EyeDrugSearchViewController alloc]init];
    [self.navigationController pushViewController:eye animated:YES];
}

#pragma mark - 创建tableview
-(void)createTableView
{
    self.tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+44, kWith, kHeight-64-44)style:UITableViewStylePlain];
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - tableview data
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    
    GrugModel *dru = _DataArr[indexPath.row];
    cell.textLabel.text = dru.channelName;
    return cell;
}

#pragma mark - 获取常用药物数据
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
    [RequestManager getWithURLString:COMMONLY_USED_DRUGS heads:heads parameters:nil success:^(id responseObject)
     {
         NSMutableDictionary *DataDic=(NSMutableDictionary *)responseObject;

         self.DataArr = [NSMutableArray array];
         for (NSDictionary *dic in DataDic[@"value"]) {
             GrugModel  *dru = [[GrugModel alloc]init];
             NSArray*arryKey = [dic allKeys];
             for (NSString *key in arryKey) {
                 [dru setValue:[dic objectForKey:key] forKey:key];
             }
             [self.DataArr addObject:dru];
         }
         [self.tableview reloadData];
         
     } failure:^(NSError *error)
     {
         NSLog(@"ERROR%@",error);
     }];
}

#pragma mark - 点击跳转到对应页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{

    [self.view endEditing:YES];
    
    GrugModel *dru = _DataArr[indexPath.row];

    CommonlyUsedDrugsGound *Viewcontroller=[[CommonlyUsedDrugsGound alloc]init];
    Viewcontroller.channelID = dru.channelId;
    [self.navigationController pushViewController:Viewcontroller animated:YES];
}

-(void)onLefybacK{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
