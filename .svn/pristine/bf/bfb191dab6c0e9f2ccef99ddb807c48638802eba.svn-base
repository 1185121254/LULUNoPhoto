
//
//  SearchDugViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/28.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "SearchDugViewController.h"
#import "MedicineTableViewCell.h"
#import "DiagnosticAdviceViewController.h"

@interface SearchDugViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    UITextField *_text;
    NSMutableArray *_arryNew;
    
    UITableView *_tableViewSear;
}
@end

@implementation SearchDugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"搜索";
    self.view.backgroundColor = kBackgroundColor;
    
    _text= [[UITextField alloc]initWithFrame:CGRectMake(10, 64+10, kWith-20-70, 30)];
    _text.placeholder = @"请根据患者姓名进行搜索";
    _text.borderStyle = UITextBorderStyleRoundedRect;
    _text.textAlignment = 1;
    _text.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_text];
    
    UIButton  *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(kWith - 70, 64+10, 50, 30);
    [btnSearch setTitle:@"搜索" forState:UIControlStateNormal];
    btnSearch.backgroundColor = BLUECOLOR_STYLE;
    btnSearch.layer.cornerRadius = 3;
    [btnSearch addTarget:self action:@selector(onBtnSearchDrug) forControlEvents:UIControlEventTouchUpInside];
    btnSearch.layer.masksToBounds = YES;
    [self.view addSubview:btnSearch];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onRightDurgSearch)];
    self.navigationItem.rightBarButtonItem = right;
    
    _tableViewSear = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, kWith, kHeight - 114)];
    _tableViewSear.backgroundColor = [UIColor clearColor];
    _tableViewSear.dataSource = self;
    _tableViewSear.delegate = self;
    _tableViewSear.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableViewSear];

    [_tableViewSear registerClass:[MedicineTableViewCell class] forCellReuseIdentifier:@"med"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotifyDrug:) name:@"addCount" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotifyTxtDrug:) name:@"TextAddCount" object:nil];
    
}

#pragma mark----搜索
-(void)onBtnSearchDrug{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"正在加载";
    HUD.hidden = NO;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"20" forKey:@"rows"];
    [dic setObject:_text.text forKey:@"fuzzyName"];
//    [RequestManager useMedic:[NSString stringWithFormat:@"%@/api/Share/GetShareDrug",NET_URLSTRING] parameters:dic Complation:^(NSMutableArray *arry) {
//        HUD.hidden = YES;
//        _arryNew = [self setMedChoose:self.arryDataDrug requsetArry:arry];
//        [_tableViewSear reloadData];
//    } Fail:^(NSError *error) {
//        HUD.hidden = YES;
//        kAlter(@"数据请求失败");
//    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arryNew.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MedicineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"med" forIndexPath:indexPath];
    
    MedicModel *model = _arryNew[indexPath.row];
    [cell setText:[NSString stringWithFormat:@"%@    %@%@/盒",model.name,model.standard,model.unit] Unit:[NSString stringWithFormat:@"%@%@/盒",model.standard,model.unit]];
    cell.count.text = model.countDrug;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark----搜索
-(void)onNotifyDrug:(NSNotification *)notify{
    MedicineTableViewCell *cell = notify.object;
    NSIndexPath *index = [_tableViewSear indexPathForCell:cell];
    MedicModel *model = _arryNew[index.row];
    NSInteger i = [model.countDrug integerValue];
    i++;
    model.countDrug = [NSString stringWithFormat:@"%ld",i];
    [_tableViewSear reloadData];
}

#pragma mark----搜索
-(void)onNotifyTxtDrug:(NSNotification *)notify{
    
    NSDictionary *dic = notify.userInfo;
    MedicineTableViewCell *cell = [dic objectForKey:@"self"];
    NSIndexPath *index = [_tableViewSear indexPathForCell:cell];
    MedicModel *model = _arryNew[index.row];
    model.countDrug = [dic objectForKey:@"text"];
    [_tableViewSear reloadData];
}

-(void)onRightDurgSearch{

    NSMutableArray *aryy = [[NSMutableArray alloc]init];
    for (MedicModel *model in _arryNew) {
        NSString *ageStr = model.countDrug;
        if (model.countDrug != nil) {
            NSString *regex = @"^[0-9]*$";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if (![pred evaluateWithObject:ageStr]) {
                kAlter(@"数量只能是数字");
                return;
            }
        }
        
        if ([model.countDrug isEqualToString:@"0"]) {
            kAlter(@"数量不能为0！");
            return;
        }
        if (![model.countDrug isEqualToString:@"0"] && model.countDrug != nil) {
            NSMutableDictionary *dicMed = [[NSMutableDictionary alloc]init];
            [dicMed setObject:model.countDrug forKey:@"drugCount"];
            [dicMed setObject:model.Id forKey:@"drugId"];
            [dicMed setObject:model.name forKey:@"drugName"];
            [dicMed setObject:model.unit forKey:@"drugUnit"];
            [aryy addObject:dicMed];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dic" object:aryy];
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[DiagnosticAdviceViewController class]]) {
            DiagnosticAdviceViewController *diagno = (DiagnosticAdviceViewController *)vc;
            [self.navigationController popToViewController:diagno animated:YES];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)setMedChoose:(NSMutableArray *)arryChoose requsetArry:(NSMutableArray *)arryrequset{
    for (MedicModel *model in arryrequset) {
        for (NSDictionary *dicChoose in arryChoose) {
            if ([model.Id isEqualToString:[dicChoose objectForKey:@"drugId"]]) {
                model.countDrug = [dicChoose objectForKey:@"drugCount"];
            }
        }
    }
    return arryrequset;
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
