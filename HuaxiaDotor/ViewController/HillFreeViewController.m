//
//  HillFreeViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/23.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "HillFreeViewController.h"
#import "FreeDiagnoseHTableViewCell.h"
#import "HillFreeModel.h"
#import "PublishFreeViewController.h"

@interface HillFreeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_arryData;

}

@end

@implementation HillFreeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    [self getData:dic URL:[NSString stringWithFormat:@"%@/api/Share/GetFreeClinicList",NET_URLSTRING]];
}

-(void)getData:(NSDictionary *)dic URL:(NSString *)url{

    
    [RequestManager getWithURLStringALL:url heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
        NSMutableArray *array = [self detailData:(NSArray *)responseObject];

        if (array == nil || array.count == 0) {
            self.noData.frame = CGRectMake(0, (kHeight-60)/2, kWith, 60);
            self.noData.hidden = NO;
        }else
        {
            self.noData.hidden = YES;
        }
        _arryData = [NSMutableArray arrayWithArray:[self setShengXu:array]];
        [_tableView reloadData];
    } failure:^(NSError *error) {

    }];
    
}

-(NSMutableArray *)detailData:(NSArray *)arry{

    NSMutableArray *arryData = [NSMutableArray array];
    for (NSDictionary *dicValue in arry) {
        HillFreeModel *model = [[HillFreeModel alloc]init];
        for (NSString *key in [dicValue allKeys]) {
            [model setValue:[dicValue objectForKey:key] forKey:key];
        }
        [arryData addObject:model];
    }
    return arryData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"义诊发布";
    self.view.backgroundColor = kBackgroundColor;
    
    UIBarButtonItem *btnPublish = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(onPublish)];
    self.navigationItem.rightBarButtonItem = btnPublish;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWith, kHeight- 64)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.rowHeight = 61;
    _tableView.dataSource =self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[FreeDiagnoseHTableViewCell class] forCellReuseIdentifier:@"FreeDiagnose"];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDownHill)];
    [header setTitle:@"正在加载数据" forState:MJRefreshStateRefreshing];
    _tableView.mj_header = header;
}

-(void)dealloc{

}

-(void)pullDownHill{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    [self getData:dic URL:[NSString stringWithFormat:@"%@/api/Share/GetFreeClinicList",NET_URLSTRING]];

    [_tableView.mj_header endRefreshing];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arryData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FreeDiagnoseHTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FreeDiagnose" forIndexPath:indexPath];
    HillFreeModel *model = _arryData[indexPath.row];
    NSArray *arry = [model.openDate componentsSeparatedByString:@" "];
    NSString *str = arry[0];
    cell.lblDate.text = [NSString stringWithFormat:@"义诊日期:%@",str];
    cell.lblCount.attributedText = [self setTextAddODcLFree:[NSString stringWithFormat:@"%ld  个",(long)model.amount]];
    if (model.type == 1) {
        cell.lblType.text = @"图文咨询";
    }
    else
    {
        cell.lblType.text = @"电话咨询";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HillFreeModel *model = _arryData[indexPath.row];
    NSArray *arry = [model.openDate componentsSeparatedByString:@" "];
    NSString *openDate = arry[0];
    NSDateFormatter *fot = [[NSDateFormatter alloc]init];
    [fot setDateFormat:@"yyyy/MM/dd"];
    NSString *nowDate = [fot stringFromDate:[NSDate date]];
    NSDate *nowDateN = [fot dateFromString:nowDate];
    NSDate *openDateN = [fot dateFromString:openDate];
    
    if ([nowDateN compare: openDateN] == NSOrderedSame) {
        kAlter(@"不能编辑今天的数据!");
        return;
    }else
    {
        PublishFreeViewController *publish = [[PublishFreeViewController alloc]init];
        publish.hillModel = model;
        publish.from = @"EditingPublish";
        [self.navigationController pushViewController:publish animated:YES];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{

    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    HillFreeModel *model = _arryData[indexPath.row];
    NSArray *arry = [model.openDate componentsSeparatedByString:@" "];
    NSString *openDate = arry[0];
    NSDateFormatter *fot = [[NSDateFormatter alloc]init];
    [fot setDateFormat:@"yyyy/MM/dd"];
    NSString *nowDate = [fot stringFromDate:[NSDate date]];
    NSDate *nowDateN = [fot dateFromString:nowDate];
    NSDate *openDateN = [fot dateFromString:openDate];
    
    if ([nowDateN timeIntervalSince1970] == [openDateN timeIntervalSince1970]) {
        kAlter(@"不能删除今天的数据!");
    }
    else{
    
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除这一天的数据吗？？" preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:model.Id forKey:@"Id"];


            [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/FreeClinicDelete",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {

                [_arryData removeObjectAtIndex:indexPath.row];
                if (_arryData.count == 0) {
                    self.noData.frame = CGRectMake(0, (kHeight-60)/2, kWith, 60);
                    self.noData.hidden = NO;
                }
                [_tableView reloadData];
            } failure:^(NSError *error) {

            }];
            
        }]];
        [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alter animated:YES completion:nil];
    }
    
}

-(void)onPublish{
    PublishFreeViewController *publish = [[PublishFreeViewController alloc]init];
    [self.navigationController pushViewController:publish animated:YES];
}

-(NSMutableAttributedString *)setTextAddODcLFree:(NSString *)text{
    
    NSArray *arry = [text componentsSeparatedByString:@"  "];
    NSString *strUnit = arry[1];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:text];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor blackColor]} range:[text rangeOfString:strUnit]];
    return medStr;
}

-(NSArray *)setShengXu:(NSMutableArray *)arry{

    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    
    NSArray * array = (NSMutableArray *)[arry sortedArrayUsingComparator:^NSComparisonResult(HillFreeModel *modelM1, HillFreeModel *modelM2) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd"];

        NSArray *arryDate1 = [modelM1.openDate componentsSeparatedByString:@" "];
        NSArray *arryDate2 = [modelM2.openDate componentsSeparatedByString:@" "];
        
        NSDate *date1 = [formatter dateFromString:arryDate1[0]];
        NSDate *date2 = [formatter dateFromString:arryDate2[0]];
        NSComparisonResult result = [date1 compare:date2];
        return result == NSOrderedDescending;
    }];

    return array;
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
