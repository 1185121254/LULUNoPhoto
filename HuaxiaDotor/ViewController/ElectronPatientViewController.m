//
//  ElectronViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/14.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ElectronPatientViewController.h"
#import "DoctorAdvieTableViewCell.h"
#import "ElectronDetailViewController.h"
#import "ElePatSearchViewController.h"

#define DefineWeakSelf __weak __typeof(self) weakSelf = self

@interface ElectronPatientViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_electronTable;
    NSMutableArray *_arryDataSource;
}
@end

@implementation ElectronPatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"电子病历";
    self.view.backgroundColor = kBackgroundColor;
    
    [self getDataPullDown:1];
    
    [self setTableViewAndSearch];
    
    
    DefineWeakSelf;
    _electronTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDataPullDown:2];
    }];
    
    _electronTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getDataPullDown:3];
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arryDataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 40)];
    view.backgroundColor = [UIColor  whiteColor];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kWith - 40, 40)];
    NSDictionary *dic = _arryDataSource[section];
    lbl.attributedText = [NSString richTextOldStr:[NSString stringWithFormat:@"%@  %@岁",[dic objectForKey:@"patientName"],[dic objectForKey:@"age"]] SeparatedByString:@"  " strUnit:1 textFont:[UIFont systemFontOfSize:13] textForgColor:[UIColor blackColor]];
    [view addSubview:lbl];

    UIControl *control =[[UIControl alloc]initWithFrame:view.frame];
    [control addTarget:self action:@selector(onConTron:) forControlEvents:UIControlEventTouchUpInside];
    control.tag = section+700;
    [view addSubview:control];
    
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DoctorAdvieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"electronCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = _arryDataSource[indexPath.section];
    cell.lblBedNum.text = @"患者编号:";
    cell.lblArrears.text = @"科室名称:";
    cell.lblHospicalNum.text = @"就诊编号:";
    cell.lblPropertyNum.text = @"床号:";
    if ([dic objectForKey:@"patientId"]) {
        cell.lblMuBedNum.text =[dic objectForKey:@"patientId"];
    }
    if ([dic objectForKey:@"eventNo"]) {
        cell.lblMuHospicalNum.text = [dic objectForKey:@"eventNo"];
    }
    if ([dic objectForKey:@"deptName"]) {
        cell.lblMuArrears.text = [dic objectForKey:@"deptName"];
    }
    if ([dic objectForKey:@"bedNo"]) {
        cell.lblMuPropertyNum.text = [dic objectForKey:@"bedNo"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = _arryDataSource[indexPath.section];
    ElectronDetailViewController *elecreon = [[ElectronDetailViewController alloc]init];
    elecreon.dicData=  dic;
    [self.navigationController pushViewController:elecreon animated:YES];
}

-(void)onConTron:(UIControl *)control{

    NSDictionary *dic = _arryDataSource[control.tag-700];
    ElectronDetailViewController *elecreon = [[ElectronDetailViewController alloc]init];
    elecreon.dicData=  dic;
    [self.navigationController pushViewController:elecreon animated:YES];
    
}


-(void)setTableViewAndSearch{

    UIButton *btnSearchCon       = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearchCon.backgroundColor = [UIColor whiteColor];
    btnSearchCon.frame           = CGRectMake(23, 64+10, kWith-23*2, 30);
    [btnSearchCon setTitle:@"🔍请根据患者姓名进行搜索" forState:UIControlStateNormal];
    [btnSearchCon setTitleColor:kBoradColor forState:UIControlStateNormal];
    [btnSearchCon addTarget:self action:@selector(onSearchForPaEle) forControlEvents:UIControlEventTouchUpInside];
    btnSearchCon.layer.cornerRadius = 3;
    btnSearchCon.layer.masksToBounds = YES;
    [self.view addSubview:btnSearchCon];
    
    _electronTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btnSearchCon.frame)+10, kWith, kHeight - CGRectGetMaxY(btnSearchCon.frame)) style:UITableViewStyleGrouped];
    _electronTable.backgroundColor = [UIColor clearColor];
    _electronTable.delegate = self;
    _electronTable.rowHeight = 65;
    _electronTable.dataSource = self;
    [self.view addSubview:_electronTable];
    
    [_electronTable registerClass:[DoctorAdvieTableViewCell class] forCellReuseIdentifier:@"electronCell"];
    
}

-(void)onSearchForPaEle{
    
    ElePatSearchViewController *ele = [[ElePatSearchViewController alloc]init];
    [self.navigationController pushViewController:ele animated:YES];
    
}

#pragma mark---获取数据
-(void)getDataPullDown:(NSInteger)pullDown{
    

    
    //1  进入页面  2  下拉    3  上推
    if (pullDown == 1) {

    }else
    {

    }
    
    static NSInteger page = 1;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"" forKey:@"doctorId"];
    [dic setObject:@(15) forKey:@"pageSize"];
    [dic setObject:@"" forKey:@"name"];
    if (pullDown != 3) {
        [_electronTable.mj_footer resetNoMoreData];
        page = 1;
    }else
    {
        page++;
    }
    [dic setObject:@(page) forKey:@"pageNumber"];
    [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/GetNowPubliceEvent",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject, BOOL ifTimeout) {

        NSArray *arry = (NSArray *)responseObject;
        if (arry==nil||arry.count == 0) {
            
            if (pullDown==3) {
                [_electronTable.mj_footer endRefreshingWithNoMoreData];
                return;
            }else
            {
                [_electronTable.mj_header endRefreshing];
                self.noData.frame = CGRectMake(0, (kHeight-60)/2, kWith, 60);
                self.noData.hidden = NO;
            }
        }
        else
        {
            self.noData.hidden = YES;
            if (pullDown != 3) {
                _arryDataSource = [NSMutableArray arrayWithArray:arry];
            }
            else
            {
                for (NSDictionary *dic in arry) {
                    [_arryDataSource addObject:dic];
                }
            }
            
        }
        if (pullDown == 2) {
            [_electronTable.mj_header endRefreshing];
        }
        else if (pullDown == 3){
            [_electronTable.mj_footer endRefreshing];
        }
        [_electronTable reloadData];

    } failure:^(NSError *error) {

        [_electronTable.mj_header endRefreshing];
        [_electronTable.mj_footer endRefreshing];
    }];
}

-(void)dealloc{
    
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
