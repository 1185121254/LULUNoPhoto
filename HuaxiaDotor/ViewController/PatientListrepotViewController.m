//
//  PatientListrepotViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/14.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "PatientListrepotViewController.h"

@interface PatientListrepotViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableList;
    NSMutableArray *_arryHeader;
    NSMutableArray *_arryData;
    
    UILabel *_lblName;
    CollectionPicViewController *_pic;
    UIImageView*_imageNav;
}
@end

@implementation PatientListrepotViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBackgroundColor;
    
    PublishNav *publish = [[PublishNav alloc]init];
    publish.title.text = @"患者报到单";
    [publish.leftBtn addTarget:self action:@selector(onLeftBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publish];
    
    [self cratLableName];
    
    _arryHeader = [NSMutableArray arrayWithObjects:@"就诊日期",@"初步预诊",@"病情与治疗",@"资料图片", nil];
    
    _tableList = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, kWith, kHeight - 104) style:UITableViewStyleGrouped];
    _tableList.dataSource =self;
    _tableList.delegate = self;
    [self.view addSubview:_tableList];
    
    _pic= [[CollectionPicViewController alloc]init];
    [self addChildViewController:_pic];
    
    [_tableList registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reportTableList"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.patientID,@"patientId",[kUserDefatuel objectForKey:@"id"],@"doctorId", nil];
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetPDApplyForm",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
        [self cratDataList:(NSDictionary *)responseObject];
        [_tableList reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arryData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewb= [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 30)];
    viewb.backgroundColor = [UIColor whiteColor];
    
    UILabel *blue = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 7, 15)];
    blue.backgroundColor = BLUECOLOR_STYLE;
    [viewb addSubview:blue];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kWith - 20, 30)];
    lbl.font = [UIFont systemFontOfSize:13];
    lbl.text = _arryHeader[section];
    [viewb addSubview:lbl];
    
    return viewb;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        float width = (kWith-15)/4;
        if ([_arryData[indexPath.section] isKindOfClass:[NSString class]]) {
            return 40;
        }else
        {
            if ([_arryData[indexPath.section] count] == 0) {
                return [NSString cellHeight:@"未添加"];
            }else
            {
                if ([_arryData[indexPath.section] count] % 4 == 0) {
                    return 5+(width+10)*([_arryData[indexPath.section] count]%4) + width+5;
                }else
                {
                    return 5+(width+10)*([_arryData[indexPath.section] count]/4) + width+5;
                }
            }

        }
    }else
    {
        return [NSString cellHeight:_arryData[indexPath.section]];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reportTableList" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 0;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 3) {
        if ([_arryData[indexPath.section] isKindOfClass:[NSString class]]) {
            cell.textLabel.text =_arryData[indexPath.section];
        }else
        {
            for (UIView *viw in cell.subviews) {
                [viw removeFromSuperview];
            }
            _pic.arryCollData = _arryData[indexPath.section];
            [cell addSubview:_pic.view];
        }
    }else
    {
        cell.textLabel.text= _arryData[indexPath.section];
    }
    return cell;
}

//富文本
-(NSMutableAttributedString *)setNameTextList:(NSString *)text{
    
    NSArray *arry = [text componentsSeparatedByString:@"    "];
    NSString *strUnit = arry[1];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:text];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:[text rangeOfString:strUnit]];
    return medStr;
}

-(void)cratLableName{
    _lblName = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, kWith, 40)];
    _lblName.font = [UIFont systemFontOfSize:19];
    _lblName.backgroundColor = BLUECOLOR_STYLE;
    _lblName.textColor = [UIColor whiteColor];
    [self.view addSubview:_lblName];
}

-(void)cratDataList:(NSDictionary *)dic{
    NSString *sex;
    if ([[dic objectForKey:@"sex"] integerValue] == 1) {
        sex = @"男";
    }else
    {
        sex = @"女";
    }
    NSString *age;
    if ([dic objectForKey:@"age"] == nil) {
        age = @"未填写";
    }else
    {
        age = [dic objectForKey:@"age"];
    }
    _lblName.attributedText = [self setNameTextList:[NSString stringWithFormat:@"  %@    %@  %@岁",[dic objectForKey:@"name"],sex,age]];
    NSString *date;
    NSString *result;
    NSString *illness;
    if ([dic objectForKey:@"treatmentDate"]==nil) {
        date = @"未填写";
    }else
    {
        NSArray *arryDate =[[dic objectForKey:@"treatmentDate"] componentsSeparatedByString:@" "];
        date = arryDate[0];
    }
    if ([dic objectForKey:@"diagnosisResult"]==nil) {
        result = @"未填写";
    }else
    {
        result = [dic objectForKey:@"diagnosisResult"];
    }
    if ([dic objectForKey:@"illness"]==nil) {
        illness = @"未填写";
    }else
    {
        illness = [dic objectForKey:@"illness"];
    }
    if ([dic objectForKey:@"picList"]==nil) {
        _arryData = [NSMutableArray arrayWithObjects:date,result,illness,@"未添加", nil];
    }else{
         _arryData = [NSMutableArray arrayWithObjects:date,result,illness,[dic objectForKey:@"picList"], nil];
    }
}

#pragma mark--------回跳
-(void)onLeftBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
