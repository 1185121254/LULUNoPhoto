//
//  KMyConsultation.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/27.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "KMyConsultation.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "WebLineInfoVIew.h"
#import "PatientShowInTableViewCell.h"

@interface KMyConsultation ()<UITableViewDataSource,UITableViewDelegate>
@end

@implementation KMyConsultation

-(void)viewWillAppear:(BOOL)animated
{
    _arrNewData = [[NSMutableArray alloc]init];
    [self getNetConsultationListFindAndPage:@(1) andRow:@(10) andUPorDown:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _arrNewData = [[NSMutableArray alloc]init];
    [self getNetConsultationListFindAndPage:@(1) andRow:@(10) andUPorDown:YES];
    self.view.backgroundColor = kBackgroundColor;
    
    _TableViewNew = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-154) style:UITableViewStyleGrouped];
    _TableViewNew.delegate = self;
    _TableViewNew.backgroundColor = [UIColor clearColor];
    _TableViewNew.dataSource = self;
    _TableViewNew.rowHeight = UITableViewAutomaticDimension;
    _TableViewNew.estimatedRowHeight = kHeight;
    [self.view addSubview:_TableViewNew];
    
    //下拉
    _TableViewNew.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTop)];
    _TableViewNew.mj_header.automaticallyChangeAlpha = YES;
    
    //上提
    _TableViewNew.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return -1;
}

#pragma mark - 下拉
-(void)loadNewTop
{
    [self getNetConsultationListFindAndPage:@(1) andRow:@(10) andUPorDown:YES];
}

#pragma mark - 上提
-(void)loadMoreData
{
    [self getNetConsultationListFindAndPage:@(1) andRow:@(10) andUPorDown:NO];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrNewData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    PatientShowInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatientShowInTableViewCell"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PatientShowInTableViewCell" owner:self options:nil]lastObject];
    }
    cell.heightForImageView.constant = 0;
    cell.viewForShowCount.hidden = YES;
    if (_arrNewData.count>0) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        dic = _arrNewData[indexPath.row];
        [cell setCell:dic];
    }

    cell.selectionStyle = NO;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(void)getNetConsultationListFindAndPage:(NSNumber*)Page andRow:(NSNumber*)Row andUPorDown:(BOOL)Up
{
    static NSInteger page = 1;
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode;
    verifyCode=[userDefaults objectForKey:@"verifyCode"];
    NSString *userID;
    userID = [userDefaults objectForKey:@"id"];
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    if (Up==YES)
    {
        page = 1;
        [_TableViewNew.mj_footer resetNoMoreData];
        [parameters setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
        _arrNewData = [[NSMutableArray alloc]init];
    }
    else
    {
        page ++;
        [parameters setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    }
    
    [parameters setObject:Row forKey:@"rows"];
    [parameters setObject:userID forKey:@"doctorId"];
    [parameters setObject:@"" forKey:@"title"];
    //GET
    [RequestManager getWithURLString:NETCONSULTATIONLISTFIND heads:heads parameters:parameters success:^(id responseObject)
     {
         //                  NSLog(@"%@",responseObject);
         if (responseObject[@"value"] == nil|| [responseObject[@"value"] count]==0) {
             if (Up==NO) {
                 [_TableViewNew.mj_footer endRefreshingWithNoMoreData];
             }else
             {
                 [_TableViewNew.mj_header endRefreshing];
                 self.noData.hidden = NO;
             }
             [_TableViewNew reloadData];
         }else{
             self.noData.hidden = YES;
             NSMutableArray *arrCom = [[NSMutableArray alloc]init];
             //初始数据书否为空
             if (_arrNewData==nil)
             {
                 _arrNewData = responseObject[@"value"];
             }
             else
             {
                 if (Up==YES)
                 {
                     _arrNewData = responseObject[@"value"];
                 }
                 else
                 {
                     arrCom = responseObject[@"value"];
                     NSMutableArray *add = [NSMutableArray arrayWithArray:_arrNewData];
                     for (NSMutableDictionary*dic in arrCom)
                     {
                         [add addObject:dic];
                     }
                     _arrNewData = [NSMutableArray arrayWithArray:add];
                 }
                 
             }
             //是否最后一条数据
             [_TableViewNew reloadData];
             //是上提还是下拉
             if (Up==YES)
             {
                 [_TableViewNew.mj_header endRefreshing];
             }
             else
             {
                 [_TableViewNew.mj_footer endRefreshing];
             }
         }

     } failure:^(NSError *error)
     {
         NSLog(@"ERROR%@",error);
         if (Up==YES)
         {
             [_TableViewNew.mj_header endRefreshing];
         }
         else
         {
             [_TableViewNew.mj_footer endRefreshing];
         }
     }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"%@",_arrNewData[indexPath.row]);
    //创建新增患者界面
    UIStoryboard *storyboardName=[UIStoryboard storyboardWithName:@"WebLine" bundle:[NSBundle mainBundle]];
    //指定对应的故事版
    WebLineInfoVIew *webView=[storyboardName instantiateViewControllerWithIdentifier:@"WebLineInfoVIew"];
    NSDictionary *dic = _arrNewData[indexPath.row];
    webView.str_topID = dic[@"id"];
    //推送
    [self.navigationController pushViewController:webView animated:YES];
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
