//
//  KTalkController.m
//  HuaxiaDotor
//
//  Created by kock on 16/6/2.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "KTalkController.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "PatientShowInTableViewCell.h"
#import "WebLineInfoVIew.h"
@interface KTalkController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)NSString *verifyCode;
@property (strong, nonatomic) UITableView *viewFortableView;
//获取到的数组数据
@property (strong, nonatomic) NSMutableArray *ListData;
@end

@implementation KTalkController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _arrNewData = [[NSMutableArray alloc]init];
    [self getNetConsultationListFindAndPage:@(1) andRow:@(10) andUPorDown:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    _arrNewData = [[NSMutableArray alloc]init];
//    [self getNetConsultationListFindAndPage:@(1) andRow:@(10) andUPorDown:YES];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.view.frame = CGRectMake(0, 32, kWith, kHeight-117-49-64);
    
    _viewFortableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _viewFortableView.backgroundColor = [UIColor clearColor];
    _viewFortableView.delegate = self;
    _viewFortableView.dataSource = self;
    _viewFortableView.rowHeight = UITableViewAutomaticDimension;
    _viewFortableView.estimatedRowHeight = 10;
    [self.view addSubview:_viewFortableView];
    
    //上下拉刷新
    _viewFortableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTop)];
    //上提
    _viewFortableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
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

#pragma mark - tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrNewData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (_arrNewData.count>0) {
        dic = _arrNewData[indexPath.row];
    }
    
    PatientShowInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatientShowInTableViewCell"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PatientShowInTableViewCell" owner:self options:nil]lastObject];
    }
    cell.heightForImageView.constant = 0;
    cell.viewForShowCount.hidden = YES;
    [cell setCell:dic];
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

#pragma mark - 跳转详情
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建新增患者界面
    UIStoryboard *storyboardName=[UIStoryboard storyboardWithName:@"WebLine" bundle:[NSBundle mainBundle]];
    //指定对应的故事版
    WebLineInfoVIew *webView=[storyboardName instantiateViewControllerWithIdentifier:@"WebLineInfoVIew"];
    if (_arrNewData.count>0) {
        NSDictionary *dic = _arrNewData[indexPath.row];
        webView.str_topID = dic[@"topicId"];
        webView.isCircle = YES;
        webView.title = @"话题详情";
        webView.hidesBottomBarWhenPushed = YES;
        //推送
        [self.navigationController pushViewController:webView animated:YES];
    }

}

#pragma mark - 获取病例表格数据
-(void)getNetConsultationListFindAndPage:(NSNumber*)Page andRow:(NSNumber*)Row andUPorDown:(BOOL)Up
{
    static NSInteger page = 1;
    //获取verifyCode
    //获取已添加页面的数据
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    self.verifyCode=[userDefaults objectForKey:@"verifyCode"];
    
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:self.verifyCode};
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    if (Up==YES)
    {
        page = 1;
        [_viewFortableView.mj_footer resetNoMoreData];
        [parameters setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
        _arrNewData = [[NSMutableArray alloc]init];
    }
    else
    {
        page ++;
        [parameters setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    }
    
    [parameters setObject:Row forKey:@"rows"];
    //类型(1:病例|2：话题)
    [parameters setObject:@"2" forKey:@"type"];
    
    //GET
    [RequestManager getWithURLString:CASE_TABLEVIEW_DATA heads:heads parameters:parameters success:^(id responseObject)
     {
         if (responseObject[@"value"]==nil||[responseObject[@"value"] count]==0) {
             if (Up==NO) {
                 [_viewFortableView.mj_footer endRefreshingWithNoMoreData];
             }else
             {
                 [_viewFortableView.mj_header endRefreshing];
                 self.noData.hidden = NO;
             }
             [_viewFortableView reloadData];
         }else
         {
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
             [_viewFortableView reloadData];
             //是上提还是下拉
             if (Up==YES)
             {
                 [_viewFortableView.mj_header endRefreshing];
             }
             else
             {
                 [_viewFortableView.mj_footer endRefreshing];
             }
         }

        } failure:^(NSError *error) {
         NSLog(@"错误哦%@",error);
         if (Up==YES)
         {
             [_viewFortableView.mj_header endRefreshing];
         }
         else
         {
             [_viewFortableView.mj_footer endRefreshing];
         }
     }];
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
