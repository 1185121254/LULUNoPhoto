//
//  SearchViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/24.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "SearchViewController.h"
#import "PatientShowInTableViewCell.h"
#import "WebLineInfoVIew.h"

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITextField *_text;
    NSMutableArray *_arryData;
    UITableView *_tableViewSear;
    NSInteger _page;
}

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"互联网会诊";
    self.view.backgroundColor = kBackgroundColor;
    _page =1;
    _arryData = [NSMutableArray array];
    
    _text= [[UITextField alloc]initWithFrame:CGRectMake(10, 64+10, kWith-20-70, 30)];
    _text.placeholder = @"请根据患者姓名进行搜索";
    _text.borderStyle = UITextBorderStyleRoundedRect;
    _text.textAlignment = 1;
    _text.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_text];
    
    UIButton  *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(kWith - 70, 64+10, 60, 30);
    [btnSearch setTitle:@"搜索" forState:UIControlStateNormal];
    btnSearch.backgroundColor = BLUECOLOR_STYLE;
    btnSearch.layer.cornerRadius = 3;
    [btnSearch addTarget:self action:@selector(onBtnSearchWeb) forControlEvents:UIControlEventTouchUpInside];
    btnSearch.layer.masksToBounds = YES;
    [self.view addSubview:btnSearch];
    
    _tableViewSear = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, kWith, kHeight - 114)];
    _tableViewSear.dataSource = self;
    _tableViewSear.delegate = self;
    _tableViewSear.backgroundColor = [UIColor clearColor];
    _tableViewSear.rowHeight = UITableViewAutomaticDimension;
    _tableViewSear.estimatedRowHeight = kHeight;
    _tableViewSear.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableViewSear];
    
    [_tableViewSear registerNib:[UINib nibWithNibName:@"PatientShowInTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchNibWeb"];
    
    //下拉
    _tableViewSear.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTop)];
    _tableViewSear.mj_header.automaticallyChangeAlpha = YES;
    
    //上提
    _tableViewSear.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arryData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic = _arryData[indexPath.row];
    
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

-(void)loadNewTop
{
    [self getNetConsultationListFindAndPage:@(1) andRow:@(10) andUPorDown:YES Search:NO];
}

#pragma mark - 上提
-(void)loadMoreData
{
    [self getNetConsultationListFindAndPage:@(1) andRow:@(10) andUPorDown:NO Search:NO];
}

-(void)getNetConsultationListFindAndPage:(NSNumber*)Page andRow:(NSNumber*)Row andUPorDown:(BOOL)Up Search:(BOOL)search{
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
        [parameters setObject:Page forKey:@"page"];
        _arryData = [[NSMutableArray alloc]init];
    }
    else
    {
        _page += _page;
        [parameters setObject:[NSNumber numberWithInteger:_page] forKey:@"page"];
    }
    
    [parameters setObject:Row forKey:@"rows"];
    [parameters setObject:@"" forKey:@"doctorId"];
    [parameters setObject:_text.text forKey:@"title"];
    //GET
    [RequestManager getWithURLString:NETCONSULTATIONLISTFIND heads:heads parameters:parameters success:^(id responseObject)
     {
         NSMutableArray *arrCom = [[NSMutableArray alloc]init];

         //初始数据书否为空
         if (search == YES) {
             if ( [responseObject[@"value"] count]==0) {
                 kAlter(@"无结果");
                 return ;
             }
         }
         
         if (_arryData==nil)
         {
             _arryData = [NSMutableArray arrayWithArray:responseObject[@"value"]];
         }
         else
         {
             if (Up==YES)
             {
                _arryData = [NSMutableArray arrayWithArray:responseObject[@"value"]];
             }
             else
             {
                 arrCom = responseObject[@"value"];
                 NSMutableArray *add = [NSMutableArray arrayWithArray:_arryData];
                 for (NSMutableDictionary*dic in arrCom)
                 {
                     [add addObject:dic];
                 }
                 _arryData = [NSMutableArray arrayWithArray:add];
             }
         }
         //是否最后一条数据
         if (arrCom.count==0)
         {
             if (_page!=1)
             {
                 if (Up==YES)
                 {
                     [showAlertView showAlertViewWithMessage:@"没有新数据"];
                 }
                 else
                 {
                     [showAlertView showAlertViewWithMessage:@"最后一条数据了"];
                 }
             }
             [_tableViewSear reloadData];
         }
         else
         {
             [_tableViewSear reloadData];
         }
         //是上提还是下拉
         if (Up==YES)
         {
             [_tableViewSear.mj_header endRefreshing];
         }
         else
         {
             [_tableViewSear.mj_footer endRefreshing];
         }
         
     } failure:^(NSError *error)
     {
         NSLog(@"ERROR%@",error);
         if (Up==YES)
         {
             [_tableViewSear.mj_header endRefreshing];
         }
         else
         {
             [_tableViewSear.mj_footer endRefreshing];
         }
     }];
}

-(void)onBtnSearchWeb{
    if (_arryData.count >0 ) {
        [_arryData removeAllObjects];
        [_tableViewSear reloadData];
    }
    [_text resignFirstResponder];
    _page = 1;
    [self getNetConsultationListFindAndPage:@(1) andRow:@(10) andUPorDown:YES Search:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    UIStoryboard *storyboardName=[UIStoryboard storyboardWithName:@"WebLine" bundle:[NSBundle mainBundle]];
    //指定对应的故事版
    WebLineInfoVIew *webView=[storyboardName instantiateViewControllerWithIdentifier:@"WebLineInfoVIew"];
    webView.str_topID = [_arryData[indexPath.row] objectForKey:@"id"];
    webView.isCircle = NO;
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
