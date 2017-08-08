//
//  PatienDetailClipViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/7.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "PatienDetailClipViewController.h"

@interface PatienDetailClipViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_arryHeader;
    
    NSArray *_arryPharmacyList;
    NSArray *_arryDrugstoreList;
    NSArray *_arryDiagnosisList;
    
}
@end

@implementation PatienDetailClipViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kBackgroundColor;
    self.title = @"病历详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _arryHeader = [NSMutableArray arrayWithObjects:self.name,@"检查项目",@"用药记录",@"药店",@"药房", nil];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWith, kHeight - 64) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ClipPersonDetailA"];

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[self.dicData objectForKey:@"outpatientCard"] forKey:@"OutpatientCard"];
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/GetMedicalDetails",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
        NSDictionary *dicV = (NSDictionary *)responseObject;
        if ([dicV objectForKey:@"diagnosisList"] == nil) {
            _arryDiagnosisList = [NSMutableArray array];
        }else
        {
            //检查记录
            _arryDiagnosisList = [dicV objectForKey:@"diagnosisList"];
        }
        if ([dicV objectForKey:@"drugstoreList"] == nil) {
            _arryDrugstoreList = [NSMutableArray array];
        }else{
            //药店厨房
            _arryDrugstoreList = [dicV objectForKey:@"drugstoreList"];
        }
        if ([dicV objectForKey:@"pharmacyList"] == nil) {
            _arryPharmacyList = [NSMutableArray array];
        }else{
            //药房处方
            _arryPharmacyList = [dicV objectForKey:@"pharmacyList"];
        }
        [_tableView reloadData];

    } failure:^(NSError *error) {

    }];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arryHeader.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        if (_arryDiagnosisList.count == 0) {
            return 1;
        }else
        {
            return _arryDiagnosisList.count;
        }
    }else if(section == 3){
        if (_arryPharmacyList.count == 0) {
            return 1;
        }else
        {
            return _arryPharmacyList.count;
        }
    }else if(section == 4){
        if (_arryDrugstoreList.count == 0) {
            return 1;
        }else
        {
            return _arryDrugstoreList.count;
        }
    }else
    {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 41;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2||section == 3||section == 4) {
        return 0.0001;
    }
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 41)];
    viewBottom.backgroundColor = [UIColor whiteColor];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kWith - 20, 40)];
    lbl.text = _arryHeader[section];
    lbl.font = [UIFont systemFontOfSize:16];
    [viewBottom addSubview:lbl];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, kWith-20, 1)];
    line.backgroundColor = kBoradColor;
    [viewBottom addSubview:line];
    
    UIView *viewBlue = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 10, 20)];
    viewBlue.hidden = YES;
    viewBlue.backgroundColor = BLUECOLOR_STYLE;
    [viewBottom addSubview:viewBlue];
    
    if (section == 3||section ==4) {
        line.hidden = YES;
        lbl.font = [UIFont systemFontOfSize:15];
        lbl.frame = CGRectMake(30, 0, kWith-30, 40);
        viewBlue.hidden = NO;
    }
    return viewBottom;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClipPersonDetailA" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.8];
    
    if (indexPath.section ==0) {
        NSString *desp;
        if ([self.dicData objectForKey:@"illDetail"] == nil) {
            desp = @"无记录";
        }else
        {
            desp = [self.dicData objectForKey:@"illDetail"];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"症状：%@",desp];
        cell.textLabel.textColor = kBoradColor;
    }else if (indexPath.section == 1){
        if (_arryDiagnosisList.count == 0) {
            cell.textLabel.text = @"无记录";
        }else
        {
            NSDictionary *dic = _arryDiagnosisList[indexPath.row];
            cell.textLabel.text = [dic objectForKey:@"costName"];
        }
    }else if (indexPath.section ==3){
        if (_arryPharmacyList.count == 0) {
            cell.textLabel.text = @"无记录";
        }else
        {
            NSDictionary *dic = _arryPharmacyList[indexPath.row];
            cell.textLabel.text = [dic objectForKey:@"drugName"];
        }
    }else if (indexPath.section ==4){
        if (_arryDrugstoreList.count == 0) {
            cell.textLabel.text = @"无记录";
        }else
        {
            NSDictionary *dic = _arryDrugstoreList[indexPath.row];
            cell.textLabel.text = [dic objectForKey:@"drugName"];
        }
    }
    return cell;
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
