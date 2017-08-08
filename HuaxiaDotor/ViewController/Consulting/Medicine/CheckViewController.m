//
//  MediconeViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/9.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "CheckViewController.h"
#import "SearchCheckViewController.h"


@interface CheckViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_arryData;
    UITableView *_tableVIew;
    MBProgressHUD *_HUD;
}
@end

@implementation CheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arryData = [[NSMutableArray alloc]init];
    
    self.title = @"检查列表";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBackgroundColor;
    
    UIButton *btnSearchCon = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearchCon.backgroundColor = [UIColor whiteColor];
    btnSearchCon.frame = CGRectMake(20, 70, kWith-40, 30);
    [btnSearchCon setTitle:@"🔍输入患者相关信息" forState:UIControlStateNormal];
    [btnSearchCon setTitleColor:kBoradColor forState:UIControlStateNormal];
    [btnSearchCon addTarget:self action:@selector(onSearchCheck) forControlEvents:UIControlEventTouchUpInside];
    btnSearchCon.layer.cornerRadius = 3;
    btnSearchCon.layer.masksToBounds = YES;
    [self.view addSubview:btnSearchCon];
    
    _tableVIew = [[UITableView alloc]initWithFrame:CGRectMake(0, 110, kWith, kHeight - 110)];
    _tableVIew.dataSource = self;
    _tableVIew.delegate = self;
    _tableVIew.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableVIew];
    
    //上下拉刷新
    _tableVIew.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTop)];
    //上提
    _tableVIew.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    
    [self getNetConsultationListFindAndPage:@(1) andRow:@(20) andUPorDown:YES];
}

#pragma mark - 下拉
-(void)loadNewTop
{
    [self getNetConsultationListFindAndPage:@(1) andRow:@(20) andUPorDown:YES];
}

#pragma mark - 上提
-(void)loadMoreData
{
    [self getNetConsultationListFindAndPage:@(1) andRow:@(20) andUPorDown:NO];
}

#pragma mark - 获取病例表格数据
-(void)getNetConsultationListFindAndPage:(NSNumber*)Page andRow:(NSNumber*)Row andUPorDown:(BOOL)Up
{
    static NSInteger page = 1;
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"正在加载";
    _HUD.hidden = NO;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (Up==YES)
    {
        page = 1;
        [_tableVIew.mj_footer resetNoMoreData];
        [dic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
        _arryData = [[NSMutableArray alloc]init];
    }
    else
    {
        page ++;
        [dic setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    }
    
    [dic setObject:[NSString stringWithFormat:@"%@",Row] forKey:@"rows"];
    [dic setObject:@"" forKey:@"fuzzyName"];
//    [RequestManager checkProgram:[NSString stringWithFormat:@"%@/api/Share/GetShareCheck",NET_URLSTRING] parameters:dic Complation:^(NSMutableArray *arry) {
//         _HUD.hidden = YES;
//         
//         if (arry==nil||arry.count==0)
//         {
//             if (Up==NO)
//             {
//                 [_tableVIew.mj_footer endRefreshingWithNoMoreData];
//             }else
//             {
//                 [_tableVIew.mj_header endRefreshing];
//             }
//             [_tableVIew reloadData];
//         }else
//         {
//             NSMutableArray *arrCom = [[NSMutableArray alloc]init];
//             //初始数据书否为空
//             if (_arryData==nil)
//             {
//                 _arryData= arry;
//             }
//             else
//             {
//                 if (Up==YES)
//                 {
//                     _arryData= arry;
//                 }
//                 else
//                 {
//                     arrCom = arry;
//                     NSMutableArray *add = [NSMutableArray arrayWithArray:_arryData];
//                     for (NSMutableDictionary*dic in arrCom)
//                     {
//                         [add addObject:dic];
//                     }
//                     _arryData = [NSMutableArray arrayWithArray:add];
//                 }
//             }
//             //是否最后一条数据
//             [_tableVIew reloadData];
//             //是上提还是下拉
//             if (Up==YES)
//             {
//                 [_tableVIew.mj_header endRefreshing];
//             }
//             else
//             {
//                 [_tableVIew.mj_footer endRefreshing];
//             }
//         }
//         
//     } Fail:^(NSError *error) {
//         _HUD.hidden = YES;
//         kAlter(@"数据请求失败");
//         if (Up==YES)
//         {
//             [_tableVIew.mj_header endRefreshing];
//         }
//         else
//         {
//             [_tableVIew.mj_footer endRefreshing];
//         }
//     }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arryData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *reuse  =@"med";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    CheckModel *model  = _arryData[indexPath.row];
    cell.textLabel.text = model.name;
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableVIew deselectRowAtIndexPath:indexPath animated:YES];
    CheckModel *model  = _arryData[indexPath.row];
    NSDictionary *dic = @{@"checkId":model.Id,@"checkName":model.name};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"check" object:nil userInfo:dic];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onSearchCheck{
    SearchCheckViewController *search = [[SearchCheckViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
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