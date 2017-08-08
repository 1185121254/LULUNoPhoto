//
//  SearchPublishViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/22.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "SearchPublishViewController.h"
#import "PatentTableViewCell.h"
#import "ChartViewController.h"


@interface SearchPublishViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITextField *_text;
    NSMutableArray *_arryNew;

    UITableView *_tableViewSear;
}
@end

@implementation SearchPublishViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"图文咨询";
    self.view.backgroundColor = kBackgroundColor;
    
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
    [btnSearch addTarget:self action:@selector(onBtnSearch) forControlEvents:UIControlEventTouchUpInside];
    btnSearch.layer.masksToBounds = YES;
    [self.view addSubview:btnSearch];
    
    _tableViewSear = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, kWith, kHeight - 114)];
    _tableViewSear.dataSource = self;
    _tableViewSear.delegate = self;
    _tableViewSear.backgroundColor = [UIColor clearColor];
    _tableViewSear.rowHeight = 81;
    _tableViewSear.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableViewSear];
    
    [_tableViewSear registerClass:[PatentTableViewCell class] forCellReuseIdentifier:@"SearchCon"];
}

#pragma mark------设置列表


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _arryNew.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    PatentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCon" forIndexPath:indexPath];
    PatientModel *model = _arryNew[indexPath.row];
    if ([model.state integerValue] == 4) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.lblNewMeg.hidden = YES;
        cell.lblTime.text = @"已完成";
    }else if([model.state integerValue] == 5){
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.lblNewMeg.hidden = NO;
        cell.lblTime.text = @"已回复";
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.lblNewMeg.hidden = NO;
        cell.lblTime.text = @"新咨询";
    }
    
    NSString *Sex;
    if ([model.sex isEqualToString:@"1"]) {
        Sex = @"男";
    }else{
        Sex = @"女";
    }
    cell.lblName.attributedText = [self setText:[NSString stringWithFormat:@"%@  %@ %@岁",model.patientName,Sex,model.age]];
    cell.lblText.text = [NSString stringWithFormat:@"症状描述:%@",model.Description];
    if (model.newMessage == 0) {
        cell.lblNewMeg.hidden = YES;
    }else
    {
        cell.lblNewMeg.text = [NSString stringWithFormat:@"%ld",model.newMessage];
    }
    
    [cell.avater sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NET_URLSTRING,model.picFileName]] placeholderImage:[UIImage imageNamed:@"ic_login_account"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PatientModel *model = _arryNew[indexPath.row];
    
    ChartViewController *chat =[[ChartViewController alloc]init];
    chat.patient = model;
    chat.state = model.state;

    [self.navigationController pushViewController:chat animated:YES];
}

-(void)onBtnSearch{
    [_text resignFirstResponder];
    [_arryNew removeAllObjects];
    [_tableViewSear reloadData];
    
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    [parameters setValue:@"1" forKey:@"orderType"];
    [parameters setObject:@"" forKey:@"state"];
    [parameters setObject:_text.text forKey:@"patientName"];
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:[kUserDefatuel objectForKey:@"verifyCode"]};

    [RequestManager getTextOrderListURL:[NSString stringWithFormat:@"%@/api/Share/GetTextOrderList",NET_URLSTRING] heads:heads parameters:parameters   viewConroller:self Complation:^(NSMutableArray *arry) {

        if (arry.count == 0) {
            kAlter(@"无结果");
        }else
        {
            _arryNew = arry;
            [_tableViewSear reloadData];
        }
    }Fail:^(NSError *error) {

        kReuestFaile;
    }];

}

#pragma mark------辅助方法

//富文本
-(NSMutableAttributedString *)setText:(NSString *)text{
    
    NSArray *arry = [text componentsSeparatedByString:@"  "];
    NSString *strUnit = arry[1];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:text];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:[text rangeOfString:strUnit]];
    return medStr;
}

-(NSString *)setSec:(NSString *)mess{
    
    NSString *sex;
    if ([mess isEqualToString:@"1"]) {
        sex = @"男";
    }else
    {
        sex = @"女";
    }
    return sex;
}

-(BOOL)setTime:(NSString *)time{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:time];
    long long AppointUnit = [date timeIntervalSince1970];
    long long nowUnit = [[NSDate date] timeIntervalSince1970];
    
    if (AppointUnit < nowUnit) {
        return NO;
    }
    else
    {
        return YES;
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
