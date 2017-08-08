//
//  AddTestSearchViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/15.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AddTestSearchViewController.h"
#import "AddTestDetailDocViewController.h"
#import "PatientReportChatViewController.h"
#import "AddressTableViewCell.h"

@interface AddTestSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableSearch;
    NSMutableArray  *_arryData;
    
    UITextField *_textSearch;
    
}
@end

@implementation AddTestSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBackgroundColor;
    self.title  =@"通讯录";
    
     _textSearch= [[UITextField alloc]initWithFrame:CGRectMake(10, 60+10, kWith-90, 30)];
    _textSearch.placeholder = @"限名字或手机号搜索";
    _textSearch.font = [UIFont systemFontOfSize:14];
    _textSearch.borderStyle = UITextBorderStyleRoundedRect;
    _textSearch.textAlignment = 1;
    [self.view addSubview:_textSearch];
    
    UIButton *search = [UIButton buttonWithType:UIButtonTypeCustom];
    search.frame = CGRectMake(kWith-70, 70, 60, 30);
    search.backgroundColor = BLUECOLOR_STYLE;
    search.layer.cornerRadius= 3;
    search.layer.masksToBounds = YES;
    search.titleLabel.font = [UIFont systemFontOfSize:15];
    [search setTitle:@"搜索" forState:UIControlStateNormal];
    [search setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [search addTarget:self action:@selector(onSearchBtnaddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:search];

    _tableSearch  = [[UITableView alloc]initWithFrame:CGRectMake(0, 110, kWith, kHeight - 110)];
    _tableSearch.dataSource = self;
    _tableSearch.backgroundColor = [UIColor clearColor];
    _tableSearch.delegate =self;
    _tableSearch.rowHeight = 71;
    _tableSearch.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableSearch];
    
    [_tableSearch registerClass:[AddressTableViewCell class] forCellReuseIdentifier:@"searchAddressC"];
}

-(void)onSearchBtnaddress{
    [_arryData removeAllObjects];
    [_tableSearch reloadData];
    [self.view endEditing:YES];

    
    if ([self.from isEqualToString:@"new"]) {
        NSDictionary *dic = @{@"value":_textSearch.text};
        [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Circle/CircleFriendFind",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
            NSMutableArray *arry = [NSMutableArray arrayWithArray:(NSArray *)responseObject];

            if (arry.count == 0) {
                kAlter(@"无结果！");
                return ;
            }else
            {
                _arryData = arry;
                [_tableSearch reloadData];
            }
        } failure:^(NSError *error) {

        }];

    }else
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[kUserDefatuel objectForKey:@"id"],@"doctorId",_textSearch.text,@"doctorName", nil];
        [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Circle/CircleFriendListFind",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
            NSMutableArray *arry = [NSMutableArray arrayWithArray:(NSArray *)responseObject];


            if (arry.count == 0) {
                kAlter(@"无结果！");
                return ;
            }else
            {
                NSMutableArray *arryNew = [NSMutableArray array];
                for (NSDictionary *dicNew in arry) {
                    if ([dicNew objectForKey:@"userName"]!=nil) {
                        [arryNew addObject:dicNew];
                    }
                }
                _arryData = arryNew;
                [_tableSearch reloadData];
            }

        } failure:^(NSError *error) {

        }];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arryData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchAddressC" forIndexPath:indexPath];
    NSDictionary *dic = _arryData[indexPath.row];
    NSString *licenseTitle;
    NSString *licenseHospital;
    NSString *speciality;
    if ([dic objectForKey:@"licenseTitle"] == nil) {
        licenseTitle  =@"";
    }else
    {
        licenseTitle = [dic objectForKey:@"licenseTitle"];
    }
    if ([dic objectForKey:@"licenseHospital"]==nil) {
        licenseHospital = @"";
    }else
    {
        licenseHospital = [dic objectForKey:@"licenseHospital"];
    }
    if ([dic objectForKey:@"speciality"] == nil) {
        speciality = @"";
    }else
    {
        speciality= [dic objectForKey:@"speciality"];
    }
    NSString *uyl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,[dic objectForKey:@"picFileName"]];
    NSString *url = [uyl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [cell.imageAvater sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"默认婷婷"]];
    cell.lblName.attributedText = [self setNameTextAddress:[NSString stringWithFormat:@"%@    %@",[dic objectForKey:@"userName"],licenseTitle]];
    cell.lblIllness.text = [NSString stringWithFormat:@"%@ | %@",licenseHospital,speciality];
    if ([[dic objectForKey:@"newMessage"] integerValue]==0) {
        cell.lblNewMeg.hidden = YES;
    }else
    {
        cell.lblNewMeg.hidden = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dicdData = _arryData[indexPath.row];
    if ([self.from isEqualToString:@"new"]) {
        NSDictionary *dic = @{@"userId":[kUserDefatuel objectForKey:@"id"],@"doctorId":[dicdData objectForKey:@"id"]};

        [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Circle/CheckFriendIsExist",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {


            if ([(NSString *)responseObject isEqualToString:@"yes"]) {
                
                AddTestDetailDocViewController *doc = [[AddTestDetailDocViewController alloc]init];
                doc.dicData = dicdData;
                doc.from = @"friends";
                [self.navigationController pushViewController:doc animated:YES];
            }else
            {
                AddTestDetailDocViewController *doc = [[AddTestDetailDocViewController alloc]init];
                doc.dicData = dicdData;
                [self.navigationController pushViewController:doc animated:YES];
            }
        } failure:^(NSError *error) {

        }];
    }else
    {
        PatientReportChatViewController *patient = [[PatientReportChatViewController alloc]init];
        patient.from  = @"address";
        patient.patientDoc = dicdData;
        [self.navigationController pushViewController:patient animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---------- 富文本
//富文本
-(NSMutableAttributedString *)setNameTextAddress:(NSString *)text{
    
    NSArray *arry = [text componentsSeparatedByString:@"    "];
    NSString *strUnit = arry[1];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:text];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:kBoradColor} range:[text rangeOfString:strUnit]];
    return medStr;
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
