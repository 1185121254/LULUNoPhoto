//
//  ViedoAddViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/19.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ViedoAddViewController.h"
#import "viedoAddTableViewCell.h"
#import "DregedViedoViewController.h"
#import "OnLineViedo.h"
@interface ViedoAddViewController ()<UITableViewDelegate,UITableViewDataSource,BaseDatePickerDelegate,BasePickerViewDelegate>
{

    UITableView *_tableView;
    
    NSMutableArray *_arryData;
    NSMutableArray *_pickViewArry;

    BaseDatePickerViewController *_basePicker;
    BasePickerView *_basePickerView;
    NSMutableArray *_arryCount;
    
    NSInteger _selectedRow;
    
    BOOL _isStart;
    BOOL _isModfity;
}
@end

@implementation ViedoAddViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _arryData = [[NSMutableArray alloc]init];
    if (self.arryViedo.count > 0) {
        for (OnLineViedo *onLine in self.arryViedo) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSArray *arryStr = [onLine.serviceTime componentsSeparatedByString:@"-"];
            [dic setObject:arryStr[0] forKey:@"Starttime"];
            [dic setObject:arryStr[1] forKey:@"Endtime"];
            [dic setObject:@([onLine.serviceAmount integerValue]) forKey:@"count"];
            [_arryData addObject:dic];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _pickViewArry = [[NSMutableArray alloc]init];
    for (NSInteger  i = 0; i<10; i++) {
        [_pickViewArry addObject:[NSString stringWithFormat:@"%ld",i+1]];
    }
    
    UIBarButtonItem *leftViedo = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(onVideoRight)];
    self.navigationItem.leftBarButtonItem = leftViedo;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWith, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[viedoAddTableViewCell class] forCellReuseIdentifier:@"addSchedViedo"];

    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        _basePicker = [[BaseDatePickerViewController alloc]initWithModel:0];
        _basePicker.delegate = self;
        [self.view addSubview:_basePicker];
    });

    _basePickerView  = [[BasePickerView alloc]init];
    _basePickerView.delegate = self;
    [self.view addSubview:_basePickerView];
    
    _arryCount = [NSMutableArray array];
    for (NSInteger i=1; i<51; i++) {
        [_arryCount addObject:[NSString stringWithFormat:@"%ld",i]];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNotifyCountViedo:) name:@"viedoCount" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNotifyStatViedo:) name:@"viedoStat" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNotifyViedoReduceViedo:) name:@"viedoReduce" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNotifyEndTimeVideo:) name:@"viedoEnd" object:nil];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arryData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 170;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 20)];
    
    UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
    lblTime.font = [UIFont systemFontOfSize:13];
    lblTime.text = @"开始就诊时间：";
    [view addSubview:lblTime];
    
    UILabel *lblEndTime = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 100, 40)];
    lblEndTime.font = [UIFont systemFontOfSize:13];
    lblEndTime.text = @"结束就诊时间：";
    [view addSubview:lblEndTime];
    
    UILabel *lblCount = [[UILabel alloc]initWithFrame:CGRectMake(kWith - 45-10 -80, 0, 80, 40)];
    lblCount.font = [UIFont systemFontOfSize:13];
    lblCount.text = @"就诊数量：";
    [view addSubview:lblCount];
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 20)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(40, 15, kWith-80, 30);
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [BLUECOLOR_STYLE CGColor];
    [btn addTarget:self action:@selector(onBtnAddViedo) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    [btn setTitle:@"+  添加时间段" forState:UIControlStateNormal];
    [btn setTitleColor:BLUECOLOR_STYLE forState:UIControlStateNormal];
    [view addSubview:btn];
    
    UILabel *lblMess = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, kWith-40, 100)];
    lblMess.font = [UIFont systemFontOfSize:12];
    lblMess.numberOfLines = 0;
    lblMess.text = @"温馨提示：\n 1.每个患者的就诊时间间隔30分钟，设置开始就诊时间、就诊数量后系统会进一步自动计算。\n 2.患者购买成功后会有相应短信提示您，到达预约时间前30分钟，系统会再次发送短信提示，请注意接听。";
    [view addSubview:lblMess];
    return view;
}

-(viedoAddTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    viedoAddTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"addSchedViedo" forIndexPath:indexPath];
    NSDictionary *dic = _arryData[indexPath.row];
    cell.lblStarTtime.text = [dic objectForKey:@"Starttime"];
    cell.lblEndTime.text  =[dic objectForKey:@"Endtime"];
    cell.lblCount.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"count"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark-----------添加时间段
-(void)onBtnAddViedo{
    _isModfity = YES;
    NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
    [dic setObject:@"00:00" forKey:@"Starttime"];
    [dic setObject:@"00:00" forKey:@"Endtime"];
    [dic setObject:@(1) forKey:@"count"];
    [_arryData addObject:dic];
    [_tableView reloadData];
}


#pragma mark-----------提交
-(void)onVideoRight{

    if (_isModfity == YES) {
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认修改" preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self publishViedoPaiban];
        }]];
        [self presentViewController:alter animated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    

}


-(void)publishViedoPaiban{
    //判断是否结束时间是否小于开始时间
    NSDateFormatter *dateFot = [[NSDateFormatter alloc]init];
    [dateFot setDateFormat:@"HH:mm"];
    for (NSDictionary *dic in _arryData) {
        NSString *startTime  = [dic objectForKey:@"Starttime"];
        NSString *endTime = [dic objectForKey:@"Endtime"];
        NSDate *startDate = [dateFot dateFromString:startTime];
        NSDate *endDate = [dateFot dateFromString:endTime];
        if ([startDate timeIntervalSince1970] >= [endDate timeIntervalSince1970]) {
            kAlter(@"结束时间不能小于开始时间");
            return;
        }
    }
    
    //判断是否有时间冲突
    for (NSInteger i = 0; i < _arryData.count; i++) {
        NSDictionary *dic = _arryData[i];
        NSString *startTime  = [dic objectForKey:@"Starttime"];
        NSString *endTime = [dic objectForKey:@"Endtime"];
        NSDate *startDate = [dateFot dateFromString:startTime];
        NSDate *endDate = [dateFot dateFromString:endTime];
        for (NSInteger k = 0; k < _arryData.count; k++) {
            if (k != i) {
                NSDictionary *dicK = _arryData[k];
                NSString *startTimeK  = [dicK objectForKey:@"Starttime"];
                NSDate *startDateK = [dateFot dateFromString:startTimeK];
                if ([startDateK timeIntervalSince1970] <= [endDate timeIntervalSince1970] && [startDateK timeIntervalSince1970] >= [startDate timeIntervalSince1970]) {
                    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"第%ld行与%ld行有冲突",k+1,i+1]preferredStyle:UIAlertControllerStyleAlert];
                    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
                    [self presentViewController:alter animated:YES completion:nil];
                    return;
                }
                
            }
        }
    }
    
    NSMutableArray *arryP = [NSMutableArray array];
    for (NSDictionary *dic in _arryData) {
        NSMutableDictionary *dicArry = [NSMutableDictionary dictionary];
        NSString *startTime  = [dic objectForKey:@"Starttime"];
        NSString *endTime = [dic objectForKey:@"Endtime"];
        NSNumber *count = [dic objectForKey:@"count"];
        NSString *date = [NSString stringWithFormat:@"%@-%@",startTime,endTime];
        [dicArry setObject:count forKey:@"serviceAmount"];
        [dicArry setObject:date forKey:@"serviceTime"];
        [arryP addObject:dicArry];
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:arryP options:NSJSONWritingPrettyPrinted error:nil];
    NSString *Str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dicP = [NSMutableDictionary dictionary];
    [dicP setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    [dicP setObject:self.week forKey:@"week"];
    [dicP setObject:Str forKey:@"annoucementList"];

    
    
    [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/VasAnnoucementSet",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dicP viewConroller:self success:^(id responseObject, BOOL ifTimeout) {

        for (UIViewController *vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[DregedViedoViewController class]]) {
                DregedViedoViewController *Dre = (DregedViedoViewController *)vc;
                Dre.isdreged = YES;
                [self.navigationController popToViewController:Dre animated:YES];
                break;
            }
        }
    } failure:^(NSError *error) {

    }];
}

#pragma mark-----------数量选择器
-(void)onNotifyCountViedo:(NSNotification *)notify{
    _isModfity = YES;
    viedoAddTableViewCell *cell  =  notify.object;
    NSIndexPath *index = [_tableView indexPathForCell:cell];
    if (index.row == _arryData.count) {
        return;
    }

    _selectedRow = index.row + 1240;
    [_basePickerView pickerDelegateShow:@[_arryCount]];

}

-(void)setPicker:(NSString *)count{
    
    NSMutableDictionary *dic = _arryData[_selectedRow - 1240];
    [dic setValue:@([count integerValue]) forKey:@"count"];
    [_tableView reloadData];
    
}

#pragma mark-----------开始时间选择器
-(void)onNotifyStatViedo:(NSNotification *)notify{
    _isModfity = YES;
    _isStart = YES;
    viedoAddTableViewCell *cell  =  notify.object;
    NSIndexPath *index = [_tableView indexPathForCell:cell];
    _selectedRow = index.row + 1240;
    [_basePicker datePickerShow:nil MinDate:nil];
}

-(void)setDateFromDatePicker:(NSDate *)date{

    NSDateFormatter *dataFot = [[NSDateFormatter alloc]init];
    [dataFot setDateFormat:@"HH:mm"];
    NSMutableDictionary *dic = _arryData[_selectedRow - 1240];
    if (_isStart == YES) {
        [dic setObject:[dataFot stringFromDate:date]forKey:@"Starttime"];
    }else
    {
        [dic setObject:[dataFot stringFromDate:date] forKey:@"Endtime"];
    }
    [_tableView reloadData];
}

#pragma mark-----------结束时间选择器
-(void)onNotifyEndTimeVideo:(NSNotification *)notify{
    _isStart = NO;
    _isModfity = YES;
    viedoAddTableViewCell *cell  =  notify.object;
    NSIndexPath *index = [_tableView indexPathForCell:cell];
    _selectedRow = index.row + 1240;
    [_basePicker datePickerShow:nil MinDate:nil];
}

#pragma mark ------删除
-(void)onNotifyViedoReduceViedo:(NSNotification *)notify{
    _isModfity = YES;
    viedoAddTableViewCell *cell = notify.object;
    NSIndexPath *index = [_tableView indexPathForCell:cell];
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"您确定要删除第%ld行",index.row +1] preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_arryData removeObjectAtIndex:index.row];
        [_tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
    }]];
    [self presentViewController:alter animated:YES completion:nil];
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
