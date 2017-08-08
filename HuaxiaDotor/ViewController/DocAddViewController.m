//
//  DocAddViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/31.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "DocAddViewController.h"
#import "DrugViewController.h"
#import "UserDocViewController.h"
#import "BaseDatePickerViewController.h"

#define kContent @"connect"
#define kPro @"pro"
#define kSelect @"请选择"
#define kLong @"长期医嘱"
#define kCount @"请填写数量"
#define kPrice @"单价"
#define kOneCount @"单量"
#define kStatTime @"开始时间"
#define kPlaseTimes @"请填写次数"
#define kDoctorName @"开嘱医生"
#define kTotal @"总量"
#define kEye @"眼别"
#define kState @"状态"
#define kUnit @"药品规格"
#define kTimes @"频次"
#define kFirstTime @"首日次数"
#define kFunc @"用法"
#define kDrugPro @"发药属性"
#define kArryDrug [NSMutableArray arrayWithObjects:@"qd",@"bid",@"tid",@"qod",@"qh",@"qn",@"hs",@"ac",@"am",@"pm",@"prn",@"sos",@"st",@"biw",@"qon",@"q12h",@"q1h",@"q2h",@"q0.5h",@"q5m",@"q10m",@"q30m",@"q15m",@"q90m",@"q3h",@"q4h",@"q5h",@"q6h",@"q8h",@"5id", nil]

@interface DocAddViewController ()<UITableViewDelegate,UITableViewDataSource,BaseDatePickerDelegate,BasePickerViewDelegate>

{    
    UITableView *_tableView;
    NSMutableArray *_arryData;
    NSMutableArray *_arryPicker;
    
    NSArray *_arryHeaderType;
    NSInteger _selectedBtnDoc;
    NSInteger _selectedRowDoc;
    
    NSMutableArray *_aryyDrug;
    NSMutableArray *_arryDia;
    NSMutableArray *_arryEyes;
    NSMutableArray *_arryRate;
    NSMutableArray *_arryDataDrug;
    NSMutableArray *_arryDataDia;
    
    UIButton *_itemBtnRightDoc;
    
    NSDateFormatter *_formatter;
    
    UIView *_webAddView;
    BaseDatePickerViewController *_basePicker;
    BasePickerView *_basePickerView;
}

@end

@implementation DocAddViewController

-(void)creatData{
    
    _selectedBtnDoc = 0;
    _arryData = [NSMutableArray array];
    [self creatArry];
    
    if ([self.from isEqualToString:@"WebDoc"]) {
        _itemBtnRightDoc.hidden = YES;
        [self fromWebDocOrSQlite];
    }
    else if ([self.from isEqualToString:@"SQLiteDoc"]){
        _itemBtnRightDoc.hidden = NO;
        [self fromWebDocOrSQlite];
    }
    else{
        [_arryData addObjectsFromArray:_aryyDrug];
    }
}

-(void)fromWebDocOrSQlite{
    if ([self.docDeatilModel.yzqx isEqualToString:@"1"] && [self.docDeatilModel.type isEqualToString:@"1"]) {
        [_arryData addObjectsFromArray:_arryDataDrug];
        _selectedBtnDoc = 1250;
    }
    else if ([self.docDeatilModel.yzqx isEqualToString:@"2"] && [self.docDeatilModel.type isEqualToString:@"1"]){
        _selectedBtnDoc = 1251;
        [_arryData addObjectsFromArray:_arryDataDrug];
        
    }else if ([self.docDeatilModel.yzqx isEqualToString:@"3"] && [self.docDeatilModel.type isEqualToString:@"1"]){
        _selectedBtnDoc = 1254;
        [_arryData addObjectsFromArray:_arryDataDrug];
        
    }
    else if ([self.docDeatilModel.yzqx isEqualToString:@"1"] && [self.docDeatilModel.type isEqualToString:@"2"]){
        _selectedBtnDoc = 1253;
        [_arryData addObjectsFromArray:_arryDataDia];
        
    }else if ([self.docDeatilModel.yzqx isEqualToString:@"2"] && [self.docDeatilModel.type isEqualToString:@"2"]){
        _selectedBtnDoc = 1252;
        [_arryData addObjectsFromArray:_arryDataDia];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新增医嘱";
    self.automaticallyAdjustsScrollViewInsets = NO;

    
    _arryHeaderType = [NSArray arrayWithObjects:@"长期医嘱\n(药品)",@"临时医嘱\n(药品)",@"临时医嘱\n(诊疗)",@"长期医嘱\n(诊疗)",@"出院医嘱\n(药品)", nil];
    
    _itemBtnRightDoc = [UIButton buttonWithType:UIButtonTypeCustom];
    _itemBtnRightDoc.frame = CGRectMake(0, 0, 40, 40);
    [_itemBtnRightDoc setTitle:@"+" forState:UIControlStateNormal];
    _itemBtnRightDoc.titleLabel.font = [UIFont systemFontOfSize:37];
    [_itemBtnRightDoc addTarget:self action:@selector(onBtnRightDoc) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *ite = [[UIBarButtonItem alloc]initWithCustomView:_itemBtnRightDoc];
    self.navigationItem.rightBarButtonItem = ite;
    
    [self creatData];
    [self creatHeaderType];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 200, kWith, kHeight - 200)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self creatWebDoc];

    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        _basePicker = [[BaseDatePickerViewController alloc]initWithModel:2];
        _basePicker.delegate = self;
        [self.view addSubview:_basePicker];
    });
        
    _basePickerView  = [[BasePickerView alloc]init];
    _basePickerView.delegate = self;
    [self.view addSubview:_basePickerView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNotifyDocDrug:) name:@"DocDrug" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNotifyDocUser:) name:@"DocUserFa" object:nil];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arryData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *str = @"DocAddDrug";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    if (_arryData.count == 13) {
        NSDictionary *dic = _arryData[indexPath.row];
        if (indexPath.row == 1) {
            NSArray *arry = [[dic objectForKey:kContent] componentsSeparatedByString:@"  "];
            cell.detailTextLabel.text = arry[0];
        }else if (indexPath.row == 7){
            NSArray *arry = [[dic objectForKey:kContent] componentsSeparatedByString:@","];
            if (arry.count != 1) {
                cell.detailTextLabel.text = arry[1];
            }else
            {
                cell.detailTextLabel.text = [dic objectForKey:kContent];
            }
        }else
        {
            cell.detailTextLabel.text = [dic objectForKey:kContent];
        }
        cell.textLabel.text = [dic objectForKey:kPro];
    }
    else{
        NSDictionary *dic = _arryData[indexPath.row];
        if (indexPath.row == 1) {
            NSArray *arry = [[dic objectForKey:kContent] componentsSeparatedByString:@"  "];
            cell.detailTextLabel.text = arry[0];
        }
        else
        {
            cell.detailTextLabel.text = [dic objectForKey:kContent];
        }
        cell.textLabel.text = [dic objectForKey:kPro];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _webAddView.hidden = YES;

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.from isEqualToString:@"WebDoc"]) {
        return;
    }
    
    _selectedRowDoc = indexPath.row + 1260;
    if (_arryData.count == 13) {
        switch (indexPath.row) {
            case 0:
            {
                [_basePicker datePickerShow:nil MinDate:nil];
            }
                break;
            case 1:
            {
                DrugViewController *drug = [[DrugViewController alloc]init];
                drug.from = @"drug";
                [self.navigationController pushViewController:drug animated:YES];
            }
                break;
            case 2:
            case 5:
            {
                [self creatPickerView:indexPath];
            }
                break;
            case 4:
            case 6:
            case 8:
            {
                [self alterCustom];
            }
                break;
            case 7:
            {
                UserDocViewController *user = [[UserDocViewController alloc]init];
                [self.navigationController pushViewController:user animated:YES];
            }
                break;
            default:
                break;
        }
    }
    else{
        switch (indexPath.row) {
            case 0:
            {
                [_basePicker datePickerShow:nil MinDate:nil];
            }
                break;
            case 1:
            {
                DrugViewController *drug = [[DrugViewController alloc]init];
                drug.from = @"dia";
                [self.navigationController pushViewController:drug animated:YES];
            }
                break;
            case 2:
            {
                [self creatPickerView:indexPath];
            }
                break;
            case 3:
            case 4:
            {
                [self alterCustom];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark -------存入本地
-(void)setDataFile{
    //判断是否为空
    for (NSDictionary *dic in _arryData) {
        NSString *str = [dic objectForKey:kContent];
        if ([str containsString:@"请"] || [str isEqualToString:@""]) {
            [self alter:@"所有选项为必填选项"];
            return;
        }
    }
    FMDatabase *fmdb = [SqliteSingleClass singleClassSqlite:self.name];
    [fmdb open];
    BOOL isSuccess;
    NSString *str;
    NSString *type;
    if (_selectedBtnDoc == 1250 || _selectedBtnDoc == 1253) {
        str = @"1";
    }else if (_selectedBtnDoc == 1251 || _selectedBtnDoc == 1252){
        str = @"2";
    }else{
        str = @"3";
    }
    if (_selectedBtnDoc == 1252 || _selectedBtnDoc == 1253) {
        type = @"2";
    } else{
        type = @"1";
    }
    if (![self.from isEqualToString:@"SQLiteDoc"]) {
        if (_arryData.count == 13) {
            NSString *sqlite = [NSString stringWithFormat:kInsertSqlite,self.name,[_arryData[0] objectForKey:kContent],[_arryData[1] objectForKey:kContent],[_arryData[2] objectForKey:kContent],[_arryData[3] objectForKey:kContent],[_arryData[4] objectForKey:kContent],[_arryData[5] objectForKey:kContent],[_arryData[6] objectForKey:kContent],[_arryData[7] objectForKey:kContent],[_arryData[8] objectForKey:kContent],[_arryData[9] objectForKey:kContent],[_arryData[10] objectForKey:kContent],[_arryData[11] objectForKey:kContent],[_arryData[12] objectForKey:kContent],str,type];
            isSuccess = [fmdb executeUpdate:sqlite];
        }else
        {
            NSString *spliteInsert = [NSString stringWithFormat:kInsertSqlite,self.name,[_arryData[0] objectForKey:kContent],[_arryData[1] objectForKey:kContent],[_arryData[2] objectForKey:kContent],@" ",[_arryData[3] objectForKey:kContent],@" ",@" ",@" ",[_arryData[4] objectForKey:kContent],[_arryData[5] objectForKey:kContent],@" ",[_arryData[6] objectForKey:kContent],[_arryData[7] objectForKey:kContent],str,type];
            isSuccess = [fmdb executeUpdate:spliteInsert];
        }
    }
    else{
        if (_arryData.count == 13) {
            NSString *sqlite = [NSString stringWithFormat:kUpdate,self.name,[_arryData[0] objectForKey:kContent],[_arryData[1] objectForKey:kContent],[_arryData[2] objectForKey:kContent],[_arryData[3] objectForKey:kContent],[_arryData[4] objectForKey:kContent],[_arryData[5] objectForKey:kContent],[_arryData[6] objectForKey:kContent],[_arryData[7] objectForKey:kContent],[_arryData[8] objectForKey:kContent],[_arryData[9] objectForKey:kContent],[_arryData[10] objectForKey:kContent],[_arryData[11] objectForKey:kContent],[_arryData[12] objectForKey:kContent],str,type,@(self.indexPath.row +1)];
            isSuccess = [fmdb executeUpdate:sqlite];
        }else
        {
            NSString *sqlite = [NSString stringWithFormat:kUpdate,self.name,[_arryData[0] objectForKey:kContent],[_arryData[1] objectForKey:kContent],[_arryData[2] objectForKey:kContent],@" ",[_arryData[3] objectForKey:kContent],@" ",@" ",@" ",[_arryData[4] objectForKey:kContent],[_arryData[5] objectForKey:kContent],@" ",[_arryData[6] objectForKey:kContent],[_arryData[7] objectForKey:kContent],str,type,@(self.indexPath.row +1)];
            isSuccess = [fmdb executeUpdate:sqlite];
        }

    }
    if (isSuccess == YES) {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alter animated:YES completion:nil];
    }
    [fmdb close];

}

#pragma mark -------存入服务器
-(void)creatWebDoc{
    _webAddView = [[UIView alloc]initWithFrame:CGRectMake(kWith - 110, 65, 100, 62)];
    _webAddView.backgroundColor = [UIColor whiteColor];
    _webAddView.hidden = YES;
    [self.view addSubview:_webAddView];
    NSArray *arry = [NSMutableArray arrayWithObjects:@"保存到本地",@"保存到服务器", nil];
    for (NSInteger i = 0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, (30+2)*i, 100, 30);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(onBtnWebDoc:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1290+i;
        [btn setTitle:arry[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:BLUECOLOR_STYLE forState:UIControlStateHighlighted];
        btn.backgroundColor = BLUECOLOR_STYLE;
        [_webAddView addSubview:btn];
    }
}

-(void)onBtnRightDoc{
    if (_webAddView.hidden == YES) {
        _webAddView.hidden = NO;
    }
    else
    {
        _webAddView.hidden = YES;
    }
}

-(void)onBtnWebDoc:(UIButton *)btn{

    if (btn.tag == 1290) {
        [self setDataFile];
    }
    else
    {
        //判断是否为空
        for (NSDictionary *dic in _arryData) {
            NSString *str = [dic objectForKey:kContent];
            if ([str containsString:@"请"]) {
                [self alter:@"所有选项为必填选项"];
                return;
            }
        }
        //发起请求
        NSMutableDictionary *dicWeb = [NSMutableDictionary dictionary];
        [dicWeb setObject:self.hispaicalNum forKey:@"HisHospitalized"];
        
        NSArray *arryId = [[_arryData[1] objectForKey:kContent] componentsSeparatedByString:@"  "];
        [dicWeb setObject:arryId[1] forKey:@"Id"];
        
        [dicWeb setObject:[_arryData[2] objectForKey:kContent] forKey:@"Eyes"];
        
        if (_arryData.count == 13) {
            NSString *str = [_arryData[7] objectForKey:kContent];
            NSArray *arry = [str componentsSeparatedByString:@","];
            [dicWeb setObject:arry[0] forKey:@"GiveDrugWay"];
            
            [dicWeb setObject:[_arryData[5] objectForKey:kContent] forKey:@"Frequency"];
            
            NSString *strCount = [_arryData[4] objectForKey:kContent];
            NSArray *arryCount = [strCount componentsSeparatedByString:@"  "];
            [dicWeb setObject:arryCount[0] forKey:@"Amount"];
        }else
        {
            [dicWeb setObject:@" " forKey:@"GiveDrugWay"];
            [dicWeb setObject:@" " forKey:@"Frequency"];
            
            NSString *strCount = [_arryData[3] objectForKey:kContent];
            NSArray *arryCount = [strCount componentsSeparatedByString:@"  "];
            [dicWeb setObject:arryCount[0] forKey:@"Amount"];
        }


        if (_selectedBtnDoc == 1250 || _selectedBtnDoc == 1253) {
            [dicWeb setObject:@"1" forKey:@"Yzqx"];
        }else if (_selectedBtnDoc == 1251 || _selectedBtnDoc == 1252){
            [dicWeb setObject:@"2" forKey:@"Yzqx"];
        }else{
            [dicWeb setObject:@"4" forKey:@"Yzqx"];
        }
        
        if (_selectedBtnDoc == 1252 || _selectedBtnDoc == 1253) {
            [dicWeb setObject:@"2" forKey:@"Type"];
        } else{
            [dicWeb setObject:@"1" forKey:@"Type"];
        }

        

        [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/AddAdvice",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dicWeb viewConroller:self success:^(id responseObject, BOOL ifTimeout) {

            if ([self.from isEqualToString:@"SQLiteDoc"]) {
                FMDatabase *fmdb = [SqliteSingleClass singleClassSqlite:self.name];
                [fmdb open];
                NSString *deleteSql = [NSString stringWithFormat:
                                       @"delete from %@ where Advice_id = '%ld'",self.name, self.indexPath.row + 1];
                BOOL isSuecss = [fmdb executeUpdate:deleteSql];
                
                if (isSuecss) {
                    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交成功" preferredStyle:UIAlertControllerStyleAlert];
                    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }]];
                    [self presentViewController:alter animated:YES completion:nil];
                } else {
                    [self alter:@"从本地删除失败"];
                }
                [fmdb close];
            }else
            {
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交成功" preferredStyle:UIAlertControllerStyleAlert];
                [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
                [self presentViewController:alter animated:YES completion:nil];
            }
            
        } failure:^(NSError *error) {

        }];
    }
}

-(void)alter:(NSString *)message{
    kAlter(message);
}

#pragma mark -------弹出框
-(void)alterCustom{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:@"请输数字" preferredStyle:UIAlertControllerStyleAlert];
    [alter addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textAlignment  =1;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"请输数字";
    }];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        for (UITextField *tf in alter.textFields) {
            [self sureDocAlterdefault:tf.text];
        }
    }]];
    [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alter animated:YES completion:nil
     ];

}

-(void)sureDocAlterdefault:(NSString *)text{
    
    NSString *unit;
    NSMutableDictionary *dic = _arryData[_selectedRowDoc - 1260];
    NSString *str = [dic objectForKey:kContent];
    
    NSArray *arry = [str componentsSeparatedByString:@"  "];
    if (arry.count > 1) {
        unit = arry[1];
    }else
    {
        unit = str;
    }
    NSMutableDictionary *dicMu = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dicMu setObject:@"" forKey:kContent];
    if (_arryData.count == 13) {
        if (_selectedRowDoc - 1260 == 4) {
            if ([unit isEqualToString:kCount]) {
                [dicMu setObject:text forKey:kContent];
            }else
            {
                [dicMu setObject:[NSString stringWithFormat:@"%@  %@",text,unit] forKey:kContent];
            }
        }else
        {
            [dicMu setObject:text forKey:kContent];
        }
    }else
    {
        if (_selectedRowDoc - 1260 == 3) {
            [dicMu setObject:[NSString stringWithFormat:@"%@  %@",text,unit] forKey:kContent];
        }else
        {
            [dicMu setObject:text forKey:kContent];
        }
    }
    [_arryData replaceObjectAtIndex:_selectedRowDoc - 1260 withObject:dicMu];
    NSIndexPath *index =[NSIndexPath indexPathForRow:_selectedRowDoc - 1260 inSection:0];
    [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -------数量选择器
-(void)creatPickerView:(NSIndexPath *)index{
    [_arryPicker removeAllObjects];
    if (_selectedRowDoc - 1260 == 2) {
        [_arryPicker addObjectsFromArray: _arryEyes];
    }else if (_selectedRowDoc - 1260 == 5){
        [_arryPicker addObjectsFromArray: _arryRate];
    }
    NSMutableArray *arry = [NSMutableArray array];
    [arry addObject:_arryPicker];
    [_basePickerView pickerDelegateShow:arry];
}

-(void)setPicker:(NSString *)count{
    NSMutableDictionary *dic = _arryData[_selectedRowDoc - 1260];
    NSMutableDictionary *dicMu = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dicMu setObject:count forKey:kContent];
    [_arryData replaceObjectAtIndex:_selectedRowDoc - 1260 withObject:dicMu];
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_selectedRowDoc - 1260 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -------时间选择器
-(void)setDateFromDatePicker:(NSDate *)date{
    NSMutableDictionary *dic = _arryData[_selectedRowDoc - 1260];
    NSMutableDictionary *dicMu = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dicMu setObject:[_formatter stringFromDate:date] forKey:kContent];
    [_arryData replaceObjectAtIndex:_selectedRowDoc - 1260 withObject:dicMu];
    [_tableView reloadData];
}

#pragma mark -------药品用法
-(void)onNotifyDocUser:(NSNotification *)notify{
    NSString *str = notify.object;
    NSMutableDictionary *dic = _arryData[_selectedRowDoc - 1260];
    NSMutableDictionary *dicMu = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dicMu setObject:str forKey:kContent];
    [_arryData replaceObjectAtIndex:_selectedRowDoc - 1260 withObject:dicMu];
    [_tableView reloadData];
}

#pragma mark -------长期医嘱
-(void)onNotifyDocDrug:(NSNotification *)notify{
    NSDictionary *dicUserInfo = notify.userInfo;
    if (_selectedBtnDoc == 1250 || _selectedBtnDoc == 1251 || _selectedBtnDoc == 1254) {
        NSMutableDictionary *dic = _arryData[1];
        NSMutableDictionary *dicMu = [NSMutableDictionary dictionaryWithDictionary:dic];
        [dicMu setObject:[NSString stringWithFormat:@"%@  %@",[dicUserInfo objectForKey:@"drugName"],[dicUserInfo objectForKey:@"drugNumber"]] forKey:kContent];
        [_arryData replaceObjectAtIndex:1 withObject:dicMu];
        
        NSMutableDictionary *dicUnit = _arryData[3];
        NSMutableDictionary *dicMuUnit = [NSMutableDictionary dictionaryWithDictionary:dicUnit];
        [dicMuUnit setObject:[dicUserInfo objectForKey:@"drugStandard"] forKey:kContent];
        [_arryData replaceObjectAtIndex:3 withObject:dicMuUnit];
        
        NSMutableDictionary *dicSing = _arryData[4];
        NSMutableDictionary *dicMuSing = [NSMutableDictionary dictionaryWithDictionary:dicSing];
        [dicMuSing setObject:[dicUserInfo objectForKey:@"pharmacyUnit"] forKey:kContent];
        [_arryData replaceObjectAtIndex:4 withObject:dicMuSing];
        
        NSMutableDictionary *dicPeice = _arryData[9];
        NSMutableDictionary *dicMuPrice = [NSMutableDictionary dictionaryWithDictionary:dicPeice];
        [dicMuPrice setObject:[NSString stringWithFormat:@"¥%.2f",[[dicUserInfo objectForKey:@"price"] floatValue]] forKey:kContent];
        [_arryData replaceObjectAtIndex:9 withObject:dicMuPrice];
    }
    else
    {
        NSMutableDictionary *dic = _arryData[1];
        NSMutableDictionary *dicMu = [NSMutableDictionary dictionaryWithDictionary:dic];
        [dicMu setObject:[NSString stringWithFormat:@"%@  %@",[dicUserInfo objectForKey:@"drugName"],[dicUserInfo objectForKey:@"drugNumber"]] forKey:kContent];
        [_arryData replaceObjectAtIndex:1 withObject:dicMu];
        
        NSMutableDictionary *dicSing = _arryData[3];
        NSMutableDictionary *dicMuSing = [NSMutableDictionary dictionaryWithDictionary:dicSing];
        [dicMuSing setObject:[dicUserInfo objectForKey:@"pharmacyUnit"] forKey:kContent];
        [_arryData replaceObjectAtIndex:3 withObject:dicMuSing];
        
        NSMutableDictionary *dicPeice = _arryData[5];
        NSMutableDictionary *dicMuPrice = [NSMutableDictionary dictionaryWithDictionary:dicPeice];
        [dicMuPrice setObject:[NSString stringWithFormat:@"¥%.2f",[[dicUserInfo objectForKey:@"price"] floatValue]] forKey:kContent];
        [_arryData replaceObjectAtIndex:5 withObject:dicMuPrice];
    }

    [_tableView reloadData];
}

#pragma mark -------门诊类型
-(void)creatHeaderType{

    _formatter = [[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 60, kWith, 150)];
    viewBottom.backgroundColor = [UIColor whiteColor];
    UILabel *lblHeader = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, kWith - 40, 30)];
    lblHeader.text = @"请选择门诊类型";
    lblHeader.font = [UIFont systemFontOfSize:14];
    [viewBottom addSubview:lblHeader];
    
    float width = (kWith-40)/3;
    for (NSInteger i= 0; i<5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10+(width +10)*(i%3), 40+(40+10)*(i/3), width, 40);
        btn.layer.borderWidth = 1;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.numberOfLines = 0;
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        [btn setTitle:_arryHeaderType[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.layer.borderColor = [kBoradColor CGColor];
        [btn setBackgroundImage:[UIImage imageNamed:@"icon_cell_blue_normal"] forState:UIControlStateSelected];
        btn.tag = i + 1250;
        [btn addTarget:self action:@selector(onBtnDocAddDetail:) forControlEvents:UIControlEventTouchUpInside];
        [viewBottom addSubview:btn];
        
        if ([self.from isEqualToString:@"WebDoc"]|| [self.from isEqualToString:@"SQLiteDoc"]) {
            btn.userInteractionEnabled = NO;
            if (i == _selectedBtnDoc - 1250) {
                btn.selected = YES;
            }
        }else
        {
            if (i == 0) {
                btn.selected = YES;
                _selectedBtnDoc = 1250;
            }
        }
    }
    [self.view addSubview:viewBottom];
}

-(void)onBtnDocAddDetail:(UIButton *)btn{
    UIButton *btnSelected = [self.view viewWithTag:_selectedBtnDoc];
    btnSelected.selected = NO;
    btn.selected = YES;
    _selectedBtnDoc = btn.tag;
    
    if (btn.tag == 1252 || btn.tag == 1253) {
        [_arryData removeAllObjects];
        [_arryData  addObjectsFromArray: _arryDia];
        [_tableView reloadData];
    }
    else
    {
        [_arryData removeAllObjects];
        [_arryData  addObjectsFromArray: _aryyDrug];
        [_tableView reloadData];
    }
}

-(void)creatArry{
    _arryPicker = [NSMutableArray array];
    _arryEyes = [NSMutableArray arrayWithObjects:@"左",@"右",@"双", nil];
    NSString *name = [[kUserDefatuel objectForKey:@"DoctorDataDic"] objectForKey:@"userName"];
    _aryyDrug = [NSMutableArray arrayWithObjects:@{kPro:kStatTime,kContent:kSelect},@{kPro:kLong,kContent:kSelect},@{kPro:kEye,kContent:kSelect},@{kPro:kUnit,kContent:@""},@{kPro:kOneCount,kContent:kCount},@{kPro:kTimes,kContent:kSelect},@{kPro:kFirstTime,kContent:kPlaseTimes},@{kPro:kFunc,kContent:kSelect},@{kPro:kTotal,kContent:kPlaseTimes},@{kPro:kPrice,kContent:kSelect},@{kPro:kDrugPro,kContent:@"不发"},@{kPro:kDoctorName,kContent:name},@{kPro:kState,kContent:@"新增"}, nil];
    
    _arryDia = [NSMutableArray arrayWithObjects:@{kPro:kStatTime,kContent:kSelect},@{kPro:kLong,kContent:kSelect},@{kPro:kEye,kContent:kSelect},@{kPro:kOneCount,kContent:kCount},@{kPro:kTotal,kContent:kPlaseTimes},@{kPro:kPrice,kContent:kSelect},@{kPro:kDoctorName,kContent:name},@{kPro:kState,kContent:@"新增"}, nil];
    
    NSString *strState;
    if ([self.from isEqualToString:@"WebDoc"]) {
        strState = [self setSateDoc:self.docDeatilModel.state];
        [self fromArry:strState];
    }else if ([self.from isEqualToString:@"SQLiteDoc"]){
        strState = self.docDeatilModel.state;
        [self fromArry:strState];
    }
    
    _arryRate  = kArryDrug;
}

-(void)fromArry:(NSString *)strState{
    _arryDataDrug = [NSMutableArray arrayWithObjects:@{kPro:kStatTime,kContent:self.docDeatilModel.adviceTime},@{kPro:kLong,kContent:self.docDeatilModel.adviceName},@{kPro:kEye,kContent:self.docDeatilModel.eyes},@{kPro:kUnit,kContent:self.docDeatilModel.totalUnit},@{kPro:kOneCount,kContent:self.docDeatilModel.dose},@{kPro:kTimes,kContent:self.docDeatilModel.frequency},@{kPro:kFirstTime,kContent:self.docDeatilModel.originDrug},@{kPro:kFunc,kContent:self.docDeatilModel.giveDrugWay},@{kPro:kTotal,kContent:self.docDeatilModel.total},@{kPro:kPrice,kContent:[NSString stringWithFormat:@"%.2f",[self.docDeatilModel.price floatValue]]},@{kPro:kDrugPro,kContent:self.docDeatilModel.drugWay},@{kPro:kDoctorName,kContent:self.docDeatilModel.adviceDoctor},@{kPro:kState,kContent:strState}, nil];
    
    _arryDataDia = [NSMutableArray arrayWithObjects:@{kPro:kStatTime,kContent:self.docDeatilModel.adviceTime},@{kPro:kLong,kContent:self.docDeatilModel.adviceName},@{kPro:kEye,kContent:self.docDeatilModel.eyes}, @{kPro:kOneCount,kContent:self.docDeatilModel.dose},@{kPro:kTotal,kContent:self.docDeatilModel.total},@{kPro:kPrice,kContent:[NSString stringWithFormat:@"%.2f",[self.docDeatilModel.price floatValue]]},@{kPro:kDoctorName,kContent:self.docDeatilModel.adviceDoctor},@{kPro:kState,kContent:strState}, nil];
}

#pragma mark -------辅助方法
-(NSString *)setSateDoc:(NSString *)stateDoc{

    if ([stateDoc isEqualToString:@"0"]) {
        return @"新开";
    }else if ([stateDoc isEqualToString:@"1"]){
        return @"正常";
    }else if ([stateDoc isEqualToString:@"2"]){
        return @"疑问";
    }else if ([stateDoc isEqualToString:@"3"]){
        return @"作废";
    }else if ([stateDoc isEqualToString:@"4"]){
        return @"停嘱";
    }else if ([stateDoc isEqualToString:@"5"]){
        return @"复核通过";
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
