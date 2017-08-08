//
//  PersonCenterClipViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/6.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "PersonCenterClipViewController.h"
#import "PatientDetailTableViewCell.h"
#import "AdminAdviceViewController.h"
//#import "NewPientClipViewController.h"
#import "NewPatientScViewController.h"

#import "PatienDetailClipViewController.h"
#import "PatientDetailModel.h"
#import "LoginViewController.h"

#import "NewCaseScrollViewController.h"
//#import "AddCaseViewController.h"
//#import "KNewPatientAddCaseViewController.h"
#import "ScDicsussViewController.h"
#import "AddNewWebViewController.h"

@interface PersonCenterClipViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_arryData;
    NSMutableArray *_arryNoData;
    
    PatientDetailModel *_patientModel;
    
    UILabel *_lblCard;
    UILabel *_lblcity;
    UILabel *_lblPhone;
    UILabel *_lblName;
    UILabel *_lblIdCard;
    UIImageView *_imageView;
    
    PublishNav *_publish;
    
    UIView *_viewBottom;
}
@end

@implementation PersonCenterClipViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden= NO;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;

    
    NSDictionary *dic = @{@"patientId":self.group.Id,@"doctorId":[kUserDefatuel objectForKey:@"id"]};
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetVasConsultation",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {

        _patientModel = [self setDataPa:(NSDictionary *)responseObject];

        if (_patientModel.consultationList == nil || _patientModel.consultationList.count == 0) {
            self.noData.hidden = NO;
            self.noData.frame = CGRectMake(0, (_tableView.frame.size.height-60)/2+_tableView.frame.origin.y, kWith, 60);
        }else
        {
            self.noData.hidden = YES;
        }
        [self getData:_patientModel];
        [_tableView reloadData];
        
        _lblName.text = _patientModel.name;
        NSString *str ;
        if ([_patientModel.sex integerValue] == 1) {
            str =@"男";
        }
        else if(_patientModel.sex == nil){
            str= @"未填写";
        }else
        {
            str = @"女";
        }
        _lblIdCard.text = [NSString stringWithFormat:@"%@    %@岁",str,_patientModel.age];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NET_URLSTRING,_patientModel.picfilepatient]] placeholderImage:[UIImage imageNamed:@"chatfrom_doctor_icon"]];
        if ([_patientModel.idCard isEqualToString:@""] || _patientModel.idCard == nil) {
            _lblCard.attributedText  = [self setTextClipIdCard:@"身份证号  未填写"];
        }else
        {
            _lblCard.attributedText = [self setTextClipIdCard:[NSString stringWithFormat:@"身份证号  %@",_patientModel.idCard]];
        }
        if ([_patientModel.city isEqualToString:@""] || _patientModel.city == nil) {
            _lblcity.attributedText  = [self setTextClipIdCard:@"常驻城市  未填写"];
        }else
        {
            _lblcity.attributedText = [self setTextClipIdCard:[NSString stringWithFormat:@"常驻城市  %@",_patientModel.city]];
        }
        if ([_patientModel.tel isEqualToString:@""] || _patientModel.tel == nil) {
            _lblPhone.attributedText  = [self setTextClipIdCard:@"联系电话  未填写"];
        }else
        {
            _lblPhone.attributedText = [self setTextClipIdCard:[NSString stringWithFormat:@"联系电话  %@",_patientModel.tel]];
        }

    } failure:^(NSError *error) {

    }];
}

-(PatientDetailModel *)setDataPa:(NSDictionary *)dicvalue{
    
    PatientDetailModel *model = [[PatientDetailModel alloc]init];
    NSArray *arry = [dicvalue allKeys];
    for (NSString *key in arry) {
        [model setValue:[dicvalue objectForKey:key] forKey:key];
    }
    return model;
}

-(void)getData:(PatientDetailModel *)patient{
    NSDictionary *dicLog = [kUserDefatuel objectForKey:@"DoctorDataDic"];
    if ([[dicLog objectForKey:@"state"] integerValue]!=2) {
        _arryData = [NSMutableArray array];
        for (NSDictionary *dic in patient.consultationList) {
            if ([[dic objectForKey:@"type"] integerValue] !=2) {
                [_arryData addObject:dic];
            }
        }
    }else
    {
        _arryData = [self shengXuPatientJ:patient.consultationList];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self cratHEader];
    [self cratDetailHeader];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 244, kWith, kHeight-244) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource =self;
    _tableView.delegate = self;
    _tableView.rowHeight = 110;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[PatientDetailTableViewCell class] forCellReuseIdentifier:@"aaClip"];

    if ([self.group.isFocus isEqualToString:@"0"]) {
        [_publish.rightBtn setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        _publish.rightBtn.selected = NO;
    }else
    {
        [_publish.rightBtn setImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
        _publish.rightBtn.selected = YES;
    }
}

#pragma mark-----------重点关注病例
-(void)onBtnLoveClip:(UIButton *)btn{


    
    if (btn.selected == YES) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.group.Id forKey:@"patientId"];
        [dic setObject:@"0" forKey:@"isFocus"];
        [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/PatientSetFocus",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {

            kAlter(@"取消关注成功");
            [_publish.rightBtn setImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
            btn.selected = NO;
        } failure:^(NSError *error) {

        }];
    }else
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.group.Id forKey:@"patientId"];
        [dic setObject:@"1" forKey:@"isFocus"];
        [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/PatientSetFocus",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {

            kAlter(@"关注成功");
            [_publish.rightBtn setImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
            btn.selected = YES;
        } failure:^(NSError *error) {

        }];

    }
}

#pragma mark-----------详情
-(void)cratDetailHeader{

    
    UIView *viewBottDetail = [[UIView alloc]initWithFrame:CGRectMake(0, 154, kWith, 90)];
    viewBottDetail.backgroundColor = [UIColor whiteColor];
    
    _lblPhone = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, kWith - 20, 20)];
    _lblPhone.font = [UIFont systemFontOfSize:14];
    [viewBottDetail addSubview:_lblPhone];
    
    _lblcity = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, kWith - 20, 20)];
    _lblcity.font = [UIFont systemFontOfSize:14];
    [viewBottDetail addSubview:_lblcity];
    
    _lblCard = [[UILabel alloc]initWithFrame:CGRectMake(10, 65, kWith - 20, 20)];
    _lblCard.font = [UIFont systemFontOfSize:14];
    [viewBottDetail addSubview:_lblCard];
    
    [self.view addSubview:viewBottDetail];
}

#pragma mark-----------头像
-(void)cratHEader{
    //底层View
    _viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 154)];
    [self.view addSubview:_viewBottom];
    
    [_viewBottom.layer insertSublayer:[NSString shadowAsInverseCGRect:CGRectMake(0, 0, kWith, 154) EndColor:[UIColor colorWithRed:38/255.0 green:199/255.0 blue:205/255.0 alpha:1]] atIndex:0];
    
    //导航栏View
    _publish= [[PublishNav alloc]init];
    _publish.title.text = @"患者中心";
    [_publish.leftBtn addTarget:self action:@selector(onLeftBack) forControlEvents:UIControlEventTouchUpInside];
    
    _publish.rightBtn.frame = CGRectMake(kWith-60, 20, 60, 40);
    [_publish.rightBtn addTarget:self action:@selector(onBtnLoveClip:) forControlEvents:UIControlEventTouchUpInside];
    
    _publish.backgroundColor = [UIColor clearColor];
    [_viewBottom addSubview:_publish];
    
    //下半部View
    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kWith, 90)];
    [_viewBottom addSubview:viewBottom];
    //头像
     _imageView= [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 50, 50)];
    _imageView.image = [UIImage imageNamed:@"chatfrom_doctor_icon"];
    _imageView.layer.cornerRadius = 25;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.borderColor = [kBoradColor CGColor];
    _imageView.layer.borderWidth = 2;
    [viewBottom addSubview:_imageView];
    //姓名
    _lblName = [[UILabel alloc]initWithFrame:CGRectMake(70, 20, kWith-80, 30)];
    _lblName.textColor = [UIColor whiteColor];
    [viewBottom addSubview:_lblName];
    //年龄，性别
    _lblIdCard = [[UILabel alloc]initWithFrame:CGRectMake(70, 50, kWith-80, 20)];
    _lblIdCard.textColor = [UIColor whiteColor];
    _lblIdCard.font = [UIFont systemFontOfSize:15];
    [viewBottom addSubview:_lblIdCard];
    //方向箭头
    UIImageView *image = [[UIImageView alloc]init];
    image.image = [UIImage imageNamed:@"返回"];
    image.transform = CGAffineTransformMakeRotation(M_PI*3);
    image.frame = CGRectMake(kWith - 30, 30, 15, 23);
    [viewBottom addSubview:image];
    
    UIButton *clorn = [UIButton buttonWithType:UIButtonTypeCustom];
    clorn.frame =  CGRectMake(0, 60, kWith, 90);
    [clorn addTarget:self action:@selector(onClornClip) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clorn];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arryData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewB = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 30)];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kWith/2, 30)];
    lbl.font = [UIFont systemFontOfSize:15];
    lbl.text = @"病历记录";
    [viewB addSubview:lbl];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(onBtnAddDocAdvie) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(kWith - 80, 5, 70, 20);
    btn.backgroundColor = BLUECOLOR_STYLE;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"新增病历" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [viewB addSubview:btn];
    
    return viewB;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PatientDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aaClip" forIndexPath:indexPath];
    if (indexPath.row == _arryData.count - 1) {
        cell.roundView.backgroundColor = BLUECOLOR_STYLE;
    }
    else
    {
        cell.roundView.backgroundColor = [UIColor greenColor];
    }

        cell.lblLine.hidden = NO;
        cell.roundView.hidden = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        cell.backgroundColor = [UIColor whiteColor];
        cell.lblDescription.textColor = [UIColor blackColor];
        NSDictionary *dic = _arryData[indexPath.row];
        cell.lblDescription.text = [dic objectForKey:@"description"];
        NSArray *arry = [[dic objectForKey:@"createDate"] componentsSeparatedByString:@" "];
        cell.lblTime.text =arry[1];
        cell.lblDate.text = arry[0];
        if ([[dic objectForKey:@"type"] integerValue] ==1) {
            cell.lblSource.text = @"平台";
        }else if([[dic objectForKey:@"type"] integerValue] ==2)
        {
            cell.lblSource.text = @"医院";
        }else if([[dic objectForKey:@"type"] integerValue] ==3)
        {
            cell.lblSource.text = @"新增";
        }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSDictionary *dic = _arryData[indexPath.row];
    NSMutableDictionary *dicData = [NSMutableDictionary dictionaryWithDictionary:dic];
    if ([self.from isEqualToString:@"importPatient"]) {
        
        for (UIViewController *VC in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[ScDicsussViewController class]]) {
                ScDicsussViewController *import = (ScDicsussViewController *)VC;
                [dicData setObject:_patientModel.name forKey:@"name"];
                if (_patientModel.illness != nil) {
                    [dicData setObject:_patientModel.illness forKey:@"illness"];
                }
                if (_patientModel.sex != nil) {
                    [dicData setObject:_patientModel.sex forKey:@"sex"];
                }
                if (_patientModel.age != nil) {
                    [dicData setObject:_patientModel.age forKey:@"age"];
                }
                import.from = @"import";
                import.dicImport = dicData;
                [self.navigationController popToViewController:import animated:YES];
                return;
            }
        }
    }
    if ([self.from isEqualToString:@"webImport"]){

        for (UIViewController *VC in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[AddNewWebViewController class]]) {
                AddNewWebViewController *import = (AddNewWebViewController *)VC;
                [dicData setObject:_patientModel.name forKey:@"name"];
                if (_patientModel.illness != nil) {
                    [dicData setObject:_patientModel.illness forKey:@"illness"];
                }
                if (_patientModel.sex != nil) {
                    [dicData setObject:_patientModel.sex forKey:@"sex"];
                }
                if (_patientModel.age != nil) {
                    [dicData setObject:_patientModel.age forKey:@"age"];
                }
                import.dicImport = dicData;
                import.from = @"import";
                [self.navigationController popToViewController:import animated:YES];
                return;

            }
        }
    }
    
    if ([[dic objectForKey:@"type"] integerValue] == 1) {
        AdminAdviceViewController *adim = [[AdminAdviceViewController alloc]init];
        adim.patient = _patientModel;
        adim.patientID = [dic objectForKey:@"orderId"];
        [self.navigationController pushViewController:adim animated:YES];
    }else if([[dic objectForKey:@"type"] integerValue] == 2)
    {
        PatienDetailClipViewController *detail =[[PatienDetailClipViewController  alloc]init];
        detail.name = _patientModel.name;
        detail.dicData = (NSMutableDictionary *)dic;
        [self.navigationController pushViewController:detail animated:YES];
    }else if([[dic objectForKey:@"type"] integerValue] == 3)
    {
        AdminAdviceViewController *adim = [[AdminAdviceViewController alloc]init];
        adim.patientID = [dic objectForKey:@"newId"];
        adim.from = @"type3";
        adim.patient = _patientModel;
        [self.navigationController pushViewController:adim animated:YES];
    }
}

#pragma mark-----------个人中心
-(void)onClornClip{

    NewPatientScViewController *new = [[NewPatientScViewController alloc]init];
    new.patientModel = _patientModel;
    new.from= @"ClipCenter";
    [self.navigationController pushViewController:new animated:YES];
    
}

#pragma mark-----------新增病例
-(void)onBtnAddDocAdvie{
    NewCaseScrollViewController *docAssis = [[NewCaseScrollViewController alloc]init];
    docAssis.model= _patientModel;
    [self.navigationController pushViewController:docAssis animated:YES];
}

//富文本
-(NSMutableAttributedString *)setTextClip:(NSString *)text{
    
    NSArray *arry = [text componentsSeparatedByString:@"    "];
    NSString *strUnit = arry[1];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:text];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:[text rangeOfString:strUnit]];
    return medStr;
}

-(NSMutableAttributedString *)setTextClipIdCard:(NSString *)text{
    
    NSArray *arry = [text componentsSeparatedByString:@"  "];
    NSString *strUnit = arry[0];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:text];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:kBoradColor} range:[text rangeOfString:strUnit]];
    return medStr;
}

#pragma mark--------回跳
-(void)onLeftBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark--------升序
-(NSMutableArray *)shengXuPatientJ:(NSArray *)arry{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:[arry sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *modelM1, NSDictionary *modelM2) {
        
        NSDate *date1 = [dateFormatter dateFromString:[modelM1 objectForKey:@"createDate"]];
        NSDate *date2 = [dateFormatter dateFromString:[modelM2 objectForKey:@"createDate"]];
        NSComparisonResult result = [date1 compare:date2];
        return result == NSOrderedAscending;
    }]];
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
