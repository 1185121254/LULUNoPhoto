//
//  AddManagerViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/3/22.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AddManagerViewController.h"
#import "AddManagerSetting.h"
#import "AddForManagerCell.h"
#import "MJRefresh.h"

@interface AddManagerViewController ()<UITableViewDataSource,UITableViewDelegate,AddCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *viewForTable;
@property (strong, nonatomic) NSMutableArray *arrData;//表格数组数组
@property (assign, nonatomic) int rows;//行数

@end

@implementation AddManagerViewController


-(NSMutableArray*)arrData
{
    if (_arrData==nil)
    {
        _arrData = [[NSMutableArray alloc]init];
    }
    return _arrData;
}
#pragma mark - cell上的按钮代理方法
-(void)sendCellData:(NSDictionary *)dic and:(NSInteger)visState andCell:(AddForManagerCell *)cell
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    //获取用户秘钥
    NSString *verifyCode;
    verifyCode=[userDefaults objectForKey:@"verifyCode"];
    
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    
    [parameters setObject:[NSString stringWithFormat:@"%@",dic[@"id"]] forKey:@"id"];
    [parameters setObject:[NSString stringWithFormat:@"%ld",(long)visState] forKey:@"visState"];
    
    [RequestManager getWithURLString:TOOL_EYEREVIEW_LIST_UPDATE heads:heads parameters:parameters success:^(id responseObject) {
        NSIndexPath *indexpath = [_viewForTable indexPathForCell:cell];
        NSDictionary *dicData = _arrData[indexpath.section][indexpath.row];
        NSMutableDictionary *dicForCell = [NSMutableDictionary dictionaryWithDictionary:dicData];
        [dicForCell setObject:@(visState) forKey:@"visState"];
        NSMutableArray *arrydata = [NSMutableArray arrayWithArray:_arrData[indexpath.section]];
        [arrydata replaceObjectAtIndex:indexpath.row withObject:dicForCell];
        [_arrData replaceObjectAtIndex:indexpath.section withObject:arrydata];
        //////////
        //        NSMutableArray *arr = [[NSMutableArray alloc]init];
        //        [arr addObjectsFromArray:_arrData];
        //        [arr replaceObjectAtIndex:indexpath.row withObject:dicForCell];
        //        [_arrData removeAllObjects];
        //        _arrData = arr;
        [_viewForTable reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
    } failure:^(NSError *error) {
        
    }];
}

//设置
- (IBAction)BtnSetting:(UIBarButtonItem *)sender
{
    UIStoryboard *AddSetting=[UIStoryboard storyboardWithName:@"AddManager" bundle:[NSBundle mainBundle]];
    //指定对应故事版
    AddManagerSetting *AddManagerSettingView=[AddSetting instantiateViewControllerWithIdentifier:@"AddManagerSetting"];
    [self.navigationController pushViewController:AddManagerSettingView animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    
    self.navigationController.navigationBar.hidden = NO;
    [self getTableviewDataPage:1 andRow:10 andUporDown:YES];
    //导航栏的字体和颜色
    self.title=@"加号管理";
    //导航栏标题的颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    _viewForTable.backgroundColor = [UIColor clearColor];
    
    __weak typeof(self)weakSelf = self;
    weakSelf.viewForTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewTop];
    }];
    weakSelf.viewForTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
}

-(void)dealloc{

}

#pragma mark - 下拉
-(void)loadNewTop
{
    [self getTableviewDataPage:1 andRow:10 andUporDown:YES];
}
#pragma mark - 上提
-(void)loadMoreData
{
    [self getTableviewDataPage:1 andRow:10 andUporDown:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddForManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddForManagerCell"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AddForManagerCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCell:_arrData[indexPath.section][indexPath.row]];
    cell.delegate = self;
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrData[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary *dic = _arrData[section][0];
    return [dic objectForKey:@"appointmentDate"];
}

#pragma mark - 获取加号管理列表数据
-(void)getTableviewDataPage:(int)Page andRow:(int)row andUporDown:(BOOL)Up
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
    
    [parameters setObject:userID forKey:@"doctorId"];
    if (Up==YES)
    {
        page = 1;
        [parameters setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    }
    else
    {
        page ++;
        [parameters setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    }
    [parameters setObject:[NSString stringWithFormat:@"%d",row] forKey:@"rows"];
    
    //获取需要上传的数据
    //POSt
    __weak typeof(self)weakSelf = self;
    [RequestManager postWithURLString:DOCTOR_BESPEAK_LIST heads:heads parameters:parameters success:^(id responseObject)
     {
         if (responseObject[@"rows"] == nil || [responseObject[@"rows"] count]==0) {
             if (Up==NO) {
                 [weakSelf.viewForTable.mj_footer endRefreshingWithNoMoreData];
             }else
             {
                 [weakSelf.viewForTable.mj_header endRefreshing];
                 weakSelf.noData.frame = CGRectMake(0, (kHeight-60)/2, kWith, 60);
                 weakSelf.noData.hidden = NO;
             }
             [weakSelf.viewForTable reloadData];
         }
         else
         {
             weakSelf.noData.hidden = YES;
             NSMutableArray *arrCom = [[NSMutableArray alloc]init];
             if (weakSelf.arrData==nil)
             {
                 NSMutableArray *arr = [NSMutableArray arrayWithArray:responseObject[@"rows"]];
                 weakSelf.arrData = [weakSelf anasinData:arr];
             }
             else
             {
                 if (Up==YES)
                 {
                     [weakSelf.viewForTable.mj_footer resetNoMoreData];
                     NSMutableArray *arr = [NSMutableArray arrayWithArray:responseObject[@"rows"]];
                     weakSelf.arrData = [weakSelf anasinData:arr];
                 }
                 else
                 {
                     arrCom = responseObject[@"rows"];
                     NSMutableArray *add = [NSMutableArray arrayWithArray:arrCom];
                     for (NSMutableDictionary*dic in [weakSelf anasinData:add])
                     {
                         [weakSelf.arrData addObject:dic];
                     }
                 }
             }
             [weakSelf.viewForTable reloadData];
             //是上提还是下拉
             if (Up==YES)
             {
                 [weakSelf.viewForTable.mj_header endRefreshing];
             }
             else
             {
                 [weakSelf.viewForTable.mj_footer endRefreshing];
             }
         }
         
     } failure:^(NSError *error) {
         
     }];
}


-(NSMutableArray *)anasinData:(NSMutableArray *)arry{
    
    NSMutableArray *arryAnasis = [[NSMutableArray alloc]init];
    NSMutableArray *arryCopy = [NSMutableArray arrayWithArray:arry];
    for (NSInteger i =0; i<arryCopy.count; i++) {
        NSString *date = [arryCopy[i] objectForKey:@"appointmentDate"];
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        [tempArray addObject:arryCopy[i]];
        for (NSInteger j=i+1; j<arryCopy.count; j++) {
            NSString *date1 = [arryCopy[j] objectForKey:@"appointmentDate"];
            
            if([date isEqualToString:date1]){
                
                [tempArray addObject:arryCopy[j]];
                
                [arryCopy removeObjectAtIndex:j];
                j -= 1;
                
            }
        }
        [arryAnasis addObject:tempArray];
    }
    return arryAnasis;
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
