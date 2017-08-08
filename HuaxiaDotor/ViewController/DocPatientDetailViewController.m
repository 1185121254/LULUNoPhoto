//
//  DocPatientDetailViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/31.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "DocPatientDetailViewController.h"
#import "DocPatientDetailTableViewCell.h"
#import "DocAdviceDetailModel.h"
#import "DocAddViewController.h"
#import "RequestManager.h"
#import "DocAdviceDetailModel.h"

@interface DocPatientDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_arryData;
    NSMutableArray *_arryDataSqlite;
    
    NSInteger _tottal;
    
    NSDateFormatter *_dataFot;

}
@end

@implementation DocPatientDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(1) forKey:@"page"];
    [dic setObject:@(10) forKey:@"rows"];
    [dic setObject:self.docModel.hisHospitalized forKey:@"hisHospitalized"];
    _arryData = [NSMutableArray array];
    [self getData:dic URL:[NSString stringWithFormat:@"%@/api/Doctor/GetAdvice",NET_URLSTRING]];

    [self selecteFromSqlite];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"病人详情";
    UIBarButtonItem *rightDoc = [[UIBarButtonItem alloc]initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(onButtonDoc)];
    self.navigationItem.rightBarButtonItem = rightDoc;
    
    _arryData = [NSMutableArray array];
    
    _dataFot= [[NSDateFormatter alloc]init];
    [_dataFot setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWith, kHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 75;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[DocPatientDetailTableViewCell class] forCellReuseIdentifier:@"DocAdviceDetail"];
    
    __weak DocPatientDetailViewController *weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf updateData:1];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf updateData:2];
    }];
}

-(void)dealloc{

}

-(void)getData:(NSDictionary *)dic URL:(NSString *)url{
    

    
    
    [RequestManager postWithURLStringALL:url heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject, BOOL ifTimeout) {

        
        NSArray *arr = [self detailWithData:(NSDictionary *)responseObject];
        for (DocAdviceDetailModel *model in arr) {
            [_arryData addObject:model];
        }
        [_tableView reloadData];
        
    } failure:^(NSError *error) {

    }];
}

-(NSMutableArray *)detailWithData:(NSDictionary *)dicValue{
    _tottal = [[dicValue objectForKey:@"total"] integerValue];
    NSArray *arryRows = [dicValue objectForKey:@"rows"];
    NSMutableArray *ArryDoc = [NSMutableArray array];
    for (NSDictionary *dciRows in arryRows) {
        DocAdviceDetailModel *doctor = [[DocAdviceDetailModel alloc]init];
        for (NSString *key in [dciRows allKeys]) {
            [doctor setValue:[dciRows objectForKey:key] forKey:key];
        }
        [ArryDoc addObject:doctor];
    }
    return ArryDoc;
}

#pragma mark-------下拉刷新
-(void)updateData:(NSInteger)page{
    
    static NSInteger i = 1;
    if (page == 1) {
        //下拉刷新
        i = 1;
        [_tableView.mj_footer resetNoMoreData];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@(i) forKey:@"page"];
        [dic setObject:@(10) forKey:@"rows"];
        [dic setObject:self.docModel.hisHospitalized forKey:@"hisHospitalized"];
        _arryData = [NSMutableArray array];
        [self getData:dic URL:[NSString stringWithFormat:@"%@/api/Doctor/GetAdvice",NET_URLSTRING]];
        
    }else
    {
        //上推加载
        if (_arryData.count >= _tottal) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        else
        {
            i++;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:@(i) forKey:@"page"];
            [dic setObject:@(10) forKey:@"rows"];
            [dic setObject:self.docModel.hisHospitalized forKey:@"hisHospitalized"];
            [self getData:dic URL:[NSString stringWithFormat:@"%@/api/Doctor/GetAdvice",NET_URLSTRING]];

        }
    }
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return _arryDataSqlite.count;
    }else
    {
        return _arryData.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 160;
    }else if (section == 1){
        return 40;
    }else
    {
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2 || section == 1) {
        return 2;
    }
    else
    {
        return 5;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return [self creatTableHeader];
    }else if (section == 1){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kWith, 40)];
        lbl.text = @"医嘱";
        [view addSubview:lbl];
        return view;
    }
    else
    {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DocPatientDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DocAdviceDetail" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    DocAdviceDetailModel *DetailModel;
    if (indexPath.section == 1) {
        DetailModel = _arryDataSqlite[indexPath.row];
        cell.lblState.text = DetailModel.state;
        NSArray *arry = [DetailModel.adviceName componentsSeparatedByString:@" "];
        cell.lblAdvice.text = arry[0];
        cell.lblTime.text = DetailModel.adviceTime;
        cell.lblType.text = [self setType:DetailModel.type];
    }else if (indexPath.section == 2){
        if (_arryData.count>0) {
            DetailModel = _arryData[indexPath.row];
            cell.lblState.text = [self setState:DetailModel.state];
            cell.lblAdvice.text = DetailModel.adviceName;
            cell.lblTime.text = [DetailModel.adviceTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            cell.lblType.text = [self setType:DetailModel.yzqx];
        }
    }
    cell.lblState.textColor = [self setStateColor:DetailModel.state];
    
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DocAddViewController *dic = [[DocAddViewController alloc]init];
    DocAdviceDetailModel *DetailModel;
    if (indexPath.section == 1) {
        DetailModel = _arryDataSqlite[indexPath.row];
        dic.hispaicalNum = self.docModel.hisHospitalized;
        dic.from = @"SQLiteDoc";
        dic.name = self.docModel.patientName;

    }else if (indexPath.section == 2){
        DetailModel = _arryData[indexPath.row];
         dic.from = @"WebDoc";
    }
    dic.docDeatilModel = DetailModel;
    dic.indexPath = indexPath;
    [self.navigationController pushViewController:dic animated:YES];
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return YES;
    }else
    {
        return NO;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除该行数据吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteSqlite:indexPath];
    }]];
    [self presentViewController:alter animated:YES completion:nil];
}

-(void)deleteSqlite:(NSIndexPath *)indexPath{
//    DocAdviceDetailModel *DetailModel = _arryDataSqlite[indexPath.row];
    FMDatabase *fmdb = [SqliteSingleClass singleClassSqlite:self.docModel.patientName];
    [fmdb open];
    NSString *deleteSql = [NSString stringWithFormat:
                           kDelete,self.docModel.patientName, indexPath.row + 1];
    BOOL isSuecss = [fmdb executeUpdate:deleteSql];
    
    if (isSuecss) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除成功" preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_arryDataSqlite removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }]];
        [self presentViewController:alter animated:YES completion:nil];
    } else {
        kAlter(@"删除失败");
    }
    [fmdb close];
}

-(UIView *)creatTableHeader{

    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 6*75+10)];
    viewBottom.backgroundColor = [UIColor whiteColor];
    
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, (kWith-20)/3, 25)];
    lblName.font = [UIFont systemFontOfSize:14];
    lblName.text = [NSString stringWithFormat:@"姓名：%@",self.docModel.patientName];
    [viewBottom addSubview:lblName];
    
    UILabel *lblSex = [[UILabel alloc]initWithFrame:CGRectMake(10+(kWith - 20)/3, 10, (kWith-20)/3, 25)];
    lblSex.font = [UIFont systemFontOfSize:14];
    lblSex.text = [NSString stringWithFormat:@"性别：%@",self.docModel.patientSex];
    [viewBottom addSubview:lblSex];
    
    UILabel *lblAge = [[UILabel alloc]initWithFrame:CGRectMake(lblSex.frame.origin.x+lblSex.frame.size.width, 10, (kWith-20)/3, 25)];
    lblAge.font = [UIFont systemFontOfSize:14];
    lblAge.text = [NSString stringWithFormat:@"年    龄：%@岁",[self setAge:self.docModel.patientBirt]];
    [viewBottom addSubview:lblAge];
    
    UILabel *lblProperty = [[UILabel alloc]initWithFrame:CGRectMake(lblName.frame.origin.x, 35, (kWith-20)/3, 25)];
    lblProperty.font = [UIFont systemFontOfSize:14];
    lblProperty.text = [NSString stringWithFormat:@"性质：%@",self.docModel.chargeName];
    [viewBottom addSubview:lblProperty];
    
    UILabel *lblBedNum = [[UILabel alloc]initWithFrame:CGRectMake(lblSex.frame.origin.x, 35, (kWith-20)/3, 25)];
    lblBedNum.font = [UIFont systemFontOfSize:14];
    lblBedNum.text = [NSString stringWithFormat:@"床号：%@",self.docModel.bedNumber];
    [viewBottom addSubview:lblBedNum];
    
    UILabel *lblBedHospical = [[UILabel alloc]initWithFrame:CGRectMake(lblAge.frame.origin.x, 35, (kWith-20)/3, 25)];
    lblBedHospical.font = [UIFont systemFontOfSize:14];
    lblBedHospical.text = [NSString stringWithFormat:@"住院号：%@",self.docModel.hisHospitalized];
    [viewBottom addSubview:lblBedHospical];
    
    UILabel *lblArrears = [[UILabel alloc]initWithFrame:CGRectMake(lblName.frame.origin.x, 60, (kWith-20)/3, 25)];
    lblArrears.font = [UIFont systemFontOfSize:14];
    lblArrears.text = [NSString stringWithFormat:@"欠费：%@",[self setDeatailArrears:self.docModel.moneyCost LeftMoney:self.docModel.moneyLeft]];
    [viewBottom addSubview:lblArrears];
    
    UILabel *lblLeftMoney = [[UILabel alloc]initWithFrame:CGRectMake(lblSex.frame.origin.x, 60, (kWith-20)/3, 25)];
    lblLeftMoney.font = [UIFont systemFontOfSize:14];
    lblLeftMoney.text = [NSString stringWithFormat:@"余额：%@",self.docModel.moneyLeft];
    [viewBottom addSubview:lblLeftMoney];
    
    UILabel *lblSection = [[UILabel alloc]initWithFrame:CGRectMake(lblAge.frame.origin.x, 60, (kWith-20)/3, 25)];
    lblSection.font = [UIFont systemFontOfSize:14];
    lblSection.text = [NSString stringWithFormat:@"病    区：%@",self.docModel.ward];
    [viewBottom addSubview:lblSection];
    
    UILabel *lblDoctor = [[UILabel alloc]initWithFrame:CGRectMake(lblName.frame.origin.x, 85, (kWith-20)/2-50, 25)];
    lblDoctor.font = [UIFont systemFontOfSize:14];
    lblDoctor.text = [NSString stringWithFormat:@"主管医生：%@",CheckStr(self.docModel.residents)];
    [viewBottom addSubview:lblDoctor];
    
    UILabel *lblStartTime= [[UILabel alloc]initWithFrame:CGRectMake(lblDoctor.frame.origin.x+lblDoctor.frame.size.width, 85, (kWith-20)/2+50, 25)];
    lblStartTime.font = [UIFont systemFontOfSize:14];
    lblStartTime.text = [NSString stringWithFormat:@"入院时间：%@",self.docModel.admissionDate];
    [viewBottom addSubview:lblStartTime];
    
    UILabel *lblDocCenter = [[UILabel alloc]initWithFrame:CGRectMake(lblName.frame.origin.x, 110, kWith-20, 25)];
    lblDocCenter.font = [UIFont systemFontOfSize:14];
    lblDocCenter.text = [NSString stringWithFormat:@"医保中心："];
    [viewBottom addSubview:lblDocCenter];
    
    UILabel *lblPatientResult = [[UILabel alloc]initWithFrame:CGRectMake(lblName.frame.origin.x, 135, kWith-20, 25)];
    lblPatientResult.font = [UIFont systemFontOfSize:14];
    lblPatientResult.text = [NSString stringWithFormat:@"病人诊断："];
    [viewBottom addSubview:lblPatientResult];
    
    return viewBottom;
}

#pragma mark--------新增
-(void)onButtonDoc{
    DocAddViewController *dic = [[DocAddViewController alloc]init];
    dic.hispaicalNum = self.docModel.hisHospitalized;
    dic.name = self.docModel.patientName;
    [self.navigationController pushViewController:dic animated:YES];
}

#pragma mark--------数据库中取数据
-(void)selecteFromSqlite{
    _arryDataSqlite = [NSMutableArray array];
    FMDatabase *fmdb = [SqliteSingleClass singleClassSqlite:self.docModel.patientName];
    if (fmdb == nil) {
        return;
    }
    [fmdb open];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",self.docModel.patientName];
    FMResultSet *set = [fmdb executeQuery:sql];
    while ([set next]) {
        DocAdviceDetailModel *adviceModel = [[DocAdviceDetailModel alloc]init];
        adviceModel.adviceTime = [set stringForColumn:@"date"];
        adviceModel.adviceName = [set stringForColumn:@"advice"];
        adviceModel.eyes = [set stringForColumn:@"eyes"];
        adviceModel.totalUnit = [set stringForColumn:@"drugUnit"];
        adviceModel.frequency = [set stringForColumn:@"freqence"];
        adviceModel.giveDrugWay = [set stringForColumn:@"user"];
        adviceModel.total = [set stringForColumn:@"totalNum"];
        adviceModel.price = [set stringForColumn:@"price"];
        adviceModel.adviceDoctor = [set stringForColumn:@"doctor"];
        adviceModel.state = [set stringForColumn:@"state"];
        adviceModel.drugWay = [set stringForColumn:@"proprety"];
        adviceModel.dose = [set stringForColumn:@"singNum"];
        adviceModel.originDrug = [set stringForColumn:@"firstDayNum"];
        adviceModel.yzqx = [set stringForColumn:@"yzqx"];
        adviceModel.type = [set stringForColumn:@"type"];
        [_arryDataSqlite addObject:adviceModel];
    }
    [set close];
    [fmdb close];
}

#pragma mark--------辅助方法
-(NSMutableAttributedString *)setText:(NSString *)text{
    
    NSArray *arry = [text componentsSeparatedByString:@"："];
    NSString *strUnit = arry[1];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:text];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:[text rangeOfString:strUnit]];
    return medStr;
}

-(NSString *)setDectailSex:(NSString *)sex{
    if ([sex isEqualToString:@"1"]) {
        return @"男";
    }else
    {
    return @"女";
    }
}

-(NSString *)setAge:(NSString *)birstday{

    NSDate *birdayDate = [_dataFot dateFromString:birstday];
    long long birdayUnit = [birdayDate timeIntervalSince1970];
    long long nowUnit = [[NSDate date] timeIntervalSince1970];
    long long ageUnit = nowUnit - birdayUnit;
    NSInteger age = ageUnit/365/24/60/60;
    
    return [NSString stringWithFormat:@"%ld",age];
}

-(NSString *)setDeatailArrears:(NSString *)moneyCost LeftMoney:(NSString *)moneyLeft{
    
    NSInteger Cost = [moneyCost integerValue];
    NSInteger Lefy = [moneyLeft integerValue];
    if (Cost - Lefy < 0) {
        return @"是";
    }else
    {
        return @"否";
    }
}

-(NSString *)setType:(NSString *)type{

    if ([type isEqualToString:@"1"]) {
        return @"长期";
    } else if ([type isEqualToString:@"2"]) {
        return @"临时";
    } else if ([type isEqualToString:@"3"]) {
        return @"出院";
    }
    return @"";
}

-(NSString *)setState:(NSString *)state{

    if ([state isEqualToString:@"0"]) {
        return @"新开";
    } else if ([state isEqualToString:@"1"]) {
        return @"正常";
    } else if ([state isEqualToString:@"2"]) {
        return @"疑问";
    }else if ([state isEqualToString:@"3"]) {
        return @"作废";
    }else if ([state isEqualToString:@"4"]) {
        return @"停嘱";
    }else if ([state isEqualToString:@"5"]) {
        return @"复核通过";
    }
    return @"";
}

-(UIColor *)setStateColor:(NSString *)state{

    if ([state isEqualToString:@"0"] || [state isEqualToString:@"1"]||[state isEqualToString:@"2"]||[state isEqualToString:@"3"]) {
        return [UIColor greenColor];
    } else if ([state isEqualToString:@"4"]) {
        return [UIColor blackColor];
    }else if ([state isEqualToString:@"5"]) {
        return BLUECOLOR_STYLE;
    }
    return 0;
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
