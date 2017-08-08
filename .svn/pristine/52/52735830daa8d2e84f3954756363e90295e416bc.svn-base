//
//  AddTestDetailDocViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/15.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AddTestDetailDocViewController.h"
#import "PatientReportChatViewController.h"
@interface AddTestDetailDocViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableViewdetailDoc;
    NSMutableArray *_arryData;
    NSMutableArray *_arryHeader;
}
@end

@implementation AddTestDetailDocViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBackgroundColor;
    self.title  =@"基本信息";
 
    _arryHeader = [NSMutableArray arrayWithObjects:@"医院",@"科室",@"职称",@"擅长", nil];
    NSString *licenseHospital;
    NSString *speciality;
    NSString *licenseTitle;
    NSString *licenseLevel;

    if ([self.dicData objectForKey:@"licenseHospital"] == nil) {
        licenseHospital = @"";
    }else
    {
        licenseHospital = [self.dicData objectForKey:@"licenseHospital"];
    }
    if ([self.dicData objectForKey:@"licenseDept"] == nil) {
        speciality = @"";
    }else
    {
        speciality = [self.dicData objectForKey:@"licenseDept"];
    }
    if ([self.dicData objectForKey:@"licenseTitle"] == nil) {
        licenseTitle = @"";
    }else
    {
        licenseTitle = [self.dicData objectForKey:@"licenseTitle"];
    }
    if ([self.dicData objectForKey:@"speciality"] == nil) {
        licenseLevel =@"";
    }else
    {
        licenseLevel = [self.dicData objectForKey:@"speciality"];
    }
    _arryData = [NSMutableArray arrayWithObjects:licenseHospital,speciality,licenseTitle,licenseLevel, nil];
    
    _tableViewdetailDoc = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, kWith, kHeight - 65) style:UITableViewStyleGrouped];
    _tableViewdetailDoc.dataSource = self;
    _tableViewdetailDoc.delegate = self;
    [self.view addSubview:_tableViewdetailDoc];
    

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self.from isEqualToString:@"address"]) {
        return 0;
    }
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *Viewc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 70)];
    Viewc.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imagAvater = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 60, 60)];
    NSString *uyl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,[self.dicData objectForKey:@"picFileName"]];
    NSString *url = [uyl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [imagAvater sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"默认婷婷"]];
    imagAvater.layer.cornerRadius = 25;
    imagAvater.layer.masksToBounds = YES;
    [Viewc addSubview:imagAvater];
   
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, kWith - 90, 30)];
    NSString *sex;
    if ([[self.dicData objectForKey:@"sex"] integerValue] == 1) {
        sex = @"男";
    }else
    {
        sex  =@"女";
    }
    
    lblName.attributedText = [self setNameTextAddressDoc:[NSString stringWithFormat:@"%@    %@ | %@",[self.dicData objectForKey:@"userName"],sex,[self.dicData objectForKey:@"birthDay"]]];
    [Viewc addSubview:lblName];
    
    return Viewc;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *Viewf = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 80)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(20, 20, kWith - 40, 40);
    btn.backgroundColor = [UIColor colorWithRed:141/255.0 green:193/255.0 blue:80/255.0 alpha:1];
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    if ([self.from isEqualToString:@"friends"]) {
        [btn setTitle:@"发消息" forState:UIControlStateNormal];
    }else
    {
        [btn setTitle:@"添加好友" forState:UIControlStateNormal];
    }
    [btn addTarget:self action:@selector(onBTNaddFriends) forControlEvents:UIControlEventTouchUpInside];
    [Viewf addSubview:btn];
    if ([self.from isEqualToString:@"address"]) {
        Viewf.hidden = YES;
    }else
    {
        Viewf.hidden = NO;
    }
    return Viewf;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *str = @"addDetailDoc";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _arryHeader[indexPath.row];
    cell.detailTextLabel.text = _arryData[indexPath.row];
    
    return cell;
}

-(void)onBTNaddFriends{
    
    if ([[kUserDefatuel objectForKey:@"id"] isEqualToString:[self.dicData objectForKey:@"id"]]) {
        kAlter(@"不能添加自己为好友");
        return;
    }
    
    if ([self.from isEqualToString:@"friends"]) {
        
        PatientReportChatViewController *patient = [[PatientReportChatViewController alloc]init];
        patient.from  = @"address";
        patient.patientDoc = self.dicData;
        [self.navigationController pushViewController:patient animated:YES];
        
    }else if ([self.from isEqualToString:@"address"]){
    
    }else{

            NSDictionary *dic = @{@"applyId":[kUserDefatuel objectForKey:@"id"],@"receiveId":[self.dicData objectForKey:@"id"]};
        [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Circle/CircleFriendAdd",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject, BOOL ifTimeout) {
            kAlter(@"发送请求成功!");
        } failure:^(NSError *error) {
            
        }];
    }
}


#pragma mark ---------- 富文本
//富文本
-(NSMutableAttributedString *)setNameTextAddressDoc:(NSString *)text{
    
    NSArray *arry = [text componentsSeparatedByString:@"    "];
    NSString *strUnit = arry[1];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:text];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:kBoradColor} range:[text rangeOfString:strUnit]];
    return medStr;
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
