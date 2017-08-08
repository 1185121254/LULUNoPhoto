//
//  AdminAdviceViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/10.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AdminAdviceViewController.h"
#import "AdviewDetail.h"
#import "CollectionPicViewController.h"

@interface AdminAdviceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_arrySectionHeader;
    

    AdviewDetail *_adviece;
    CollectionPicViewController *_pic;
    
    //数据数组
    NSMutableArray *_arryData;
}
@end

@implementation AdminAdviceViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden= NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    PublishNav *publish= [[PublishNav alloc]init];
    publish.title.text = @"病历详情";
    [publish.leftBtn addTarget:self action:@selector(onLeftBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publish];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, kWith, 40)];
    lbl.attributedText = [self setText:[NSString stringWithFormat:@"  %@    %@  %@岁",_patient.name,[self sex:_patient.sex],_patient.age]];
    lbl.textColor = [UIColor whiteColor];
    lbl.backgroundColor = BLUECOLOR_STYLE;
    [self.view addSubview:lbl];
    
    _arryData = [NSMutableArray arrayWithObjects:@"",@"" ,@"",@"",nil];
    
    _pic= [[CollectionPicViewController alloc]init];
    [self addChildViewController:_pic];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, kWith, kHeight-100) style:UITableViewStyleGrouped];
    _tableView.dataSource= self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"admin"];

    

    NSString *url;
    NSDictionary *dicPara;
    if ([self.from isEqualToString:@"type3"]) {
        url = [NSString stringWithFormat:@"%@/api/Doctor/GetNewMedicalRecord",NET_URLSTRING];
        dicPara = @{@"newId":self.patientID};
        _arrySectionHeader = [[NSMutableArray alloc]initWithObjects:@"  症状描述",@"  资料图片",@"  疾病诊断",@"  用药记录",@"  检查项目", nil];

    }else
    {
        url =[NSString stringWithFormat:@"%@/api/Share/GetDiagnosisAdvice",NET_URLSTRING];
        dicPara = @{@"orderId":self.patientID};
        _arrySectionHeader = [[NSMutableArray alloc]initWithObjects:@"  症状描述",@"  资料图片",@"  初步预诊",@"  建议用药",@"  建议检查项目",@"  诊断建议", nil];
    }
    [RequestManager getWithURLStringALL:url heads:DICTIONARY_VERIFYCODE parameters:dicPara viewConroller:self success:^(id responseObject) {
        _adviece = [self setDataAd:(NSDictionary *)responseObject];
        if (_adviece.result) {
            [_arryData replaceObjectAtIndex:0 withObject:_adviece.result];
        }
        if (_adviece.drugList) {
            [_arryData replaceObjectAtIndex:1 withObject:_adviece.drugList];
        }
        if (_adviece.checkList) {
            [_arryData replaceObjectAtIndex:2 withObject:_adviece.checkList];
        }
        if (_adviece.advice) {
            [_arryData replaceObjectAtIndex:3 withObject:_adviece.advice];
        }
        [_tableView reloadData];

    } failure:^(NSError *error) {

    }];

}

-(AdviewDetail *)setDataAd:(NSDictionary *)dicValue{
    NSArray *arry = [dicValue allKeys];
    AdviewDetail *adviece = [[AdviewDetail alloc]init];
    for (NSString *key in arry) {
        [adviece setValue:[dicValue objectForKey:key] forKey:key];
    }
    return adviece;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.from isEqualToString:@"type3"]) {
        return 5;
    }else{
        return 6;
    }
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1) {
        NSInteger count = kWith/kItemWidth;
        NSInteger reste = (NSInteger)kWith % kItemWidth;
        float gap = reste/(count + 1);
        if (_adviece.picList.count == 0) {
            return [NSString cellHeight:@"未添加"];
        }else
        {
            if ((_adviece.picList.count) % count == 0) {
                return (kItemWidth+gap)*((_adviece.picList.count+1)/count)+4*gap;
            }else
            {
                return (kItemWidth+gap)*((_adviece.picList.count)/count) + kItemWidth+gap*4;
            }
        }
    }
    else if (indexPath.section == 0){
        if (_adviece.Description == nil) {
            return [NSString cellHeight:@"未填写"];
        }else{
            return [NSString cellHeight:_adviece.Description];
        }
    }
    else
    {
        NSString *str = _arryData[indexPath.section-2];
        if (str==nil||[str isEqualToString:@""]) {
            return [NSString cellHeight:@"无记录"];
        }else
        {
            return [NSString cellHeight:str];
        }
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *blue = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 7, 15)];
    blue.backgroundColor = BLUECOLOR_STYLE;
    [view addSubview:blue];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(17, 0, kWith-20, 30)];
    lbl.backgroundColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:13];
    lbl.text = _arrySectionHeader[section];
    [view addSubview:lbl];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"admin" forIndexPath:indexPath];
    if (indexPath.section == 1) {
        if (_adviece.picList.count == 0 || _adviece.picList == nil) {
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.text = @"未添加";
            return cell;
        }else
        {
            for (UIView *viw in cell.subviews) {
                [viw removeFromSuperview];
            }
            _pic.arryCollData = _adviece.picList;
            [cell addSubview:_pic.view];
            return cell;
        }
    }
    else{

        cell.textLabel.font= [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
        if (indexPath.section == 0) {
            if (_adviece.Description != nil) {
                cell.textLabel.text= _adviece.Description;
            }else
            {
                cell.textLabel.text= @"未填写";
            }
            return cell;
        }else
        {
            if (_arryData[indexPath.section-2]==nil||[_arryData[indexPath.section-2] isEqualToString:@""]) {
                cell.textLabel.text = @"无记录";
            }else
            {
                cell.textLabel.text = _arryData[indexPath.section-2];
            }
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark---------辅助方法

-(NSMutableAttributedString *)setText:(NSString *)name{
    
    NSArray *arry = [name componentsSeparatedByString:@"    "];
    NSString *strUnit = arry[1];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:name];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:[name rangeOfString:strUnit]];
    
    return medStr;
}

-(NSString *)sex:(NSString *)sex{
    NSString *str;
    if ([sex integerValue]==1) {
        str = @"男";
    }
    else
    {
        str = @"女";
    }
    return str;
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