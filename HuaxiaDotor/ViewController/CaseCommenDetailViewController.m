//
//  CaseCommenDetailViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/24.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "CaseCommenDetailViewController.h"
#import "CaseDetailNameTableViewCell.h"
#import "CaseDetailComPicTableViewCell.h"
#import "CaseCommentViewController.h"

@interface CaseCommenDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_arryDesp;
    NSMutableArray *_arryNaeme;
    CollectionPicViewController *_pic;

}
@end

@implementation CaseCommenDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@的病历详情",[self.dicData objectForKey:@"patientName"]];
    _arryDesp = [NSMutableArray arrayWithObjects:@"姓名",@"性别",@"年龄",@"疾病诊断",@"症状描述", nil];
    
    NSString *Sex;
    if ([[self.dicData objectForKey:@"sex"] integerValue] == 1) {
        Sex = @"男";
    }else
    {
        Sex = @"女";
    }
    
    NSString *name;
    if ([self.dicData objectForKey:@"patientName"] == nil) {
        name = @"";
    }else
    {
        name =[self.dicData objectForKey:@"patientName"];
    }
    
    NSString *illness;
    if ([self.dicData objectForKey:@"illness"]==nil) {
        illness = @"";
    }else
    {
        illness = [self.dicData objectForKey:@"illness"];
    }
    
    NSString *result;
    if ([self.dicData objectForKey:@"diagnosisResult"] == nil) {
        result = @"";
    }else
    {
        result = [self.dicData objectForKey:@"diagnosisResult"];
    }
    
    NSString *age;
    if ([self.dicData objectForKey:@"age"] == nil) {
        age = @"";
    }else
    {
        age =[NSString stringWithFormat:@"%ld",[[self.dicData objectForKey:@"age"] integerValue]];
    }
    
    _arryNaeme = [NSMutableArray arrayWithObjects:name,Sex,age,result,illness, nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWith, kHeight - 64)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone; 
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[CaseDetailNameTableViewCell class] forCellReuseIdentifier:@"CCommName"];
    [_tableView registerClass:[CaseDetailComPicTableViewCell class] forCellReuseIdentifier:@"CCommPic"];
    
    UIButton *btnleft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnleft.frame = CGRectMake(0, 0, 13, 22);
    [btnleft addTarget:self action:@selector(onLeftCaseComm) forControlEvents:UIControlEventTouchUpInside];
    [btnleft setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    UIBarButtonItem *letf = [[UIBarButtonItem alloc]initWithCustomView:btnleft];
    self.navigationItem.leftBarButtonItem = letf;

}

-(void)onLeftCaseComm{
    
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[CaseCommentViewController class]]) {
            CaseCommentViewController *caseComm = (CaseCommentViewController *)VC;
            caseComm.from = @"CaseNotHistory";
            [self.navigationController popToViewController:caseComm animated:YES];
            break;
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arry = [self.dicData objectForKey:@"picList"];
    if (indexPath.row == 5) {
        NSInteger count = kWith/kItemWidth;
        NSInteger reste = (NSInteger)kWith % kItemWidth;
        float gap = reste/(count + 1);
        if (arry.count == 0) {
            return 0;
        }else
        {
            if ((arry.count) % count == 0) {
                return (kItemWidth+gap)*((arry.count)/count)+4*gap;
            }else
            {
                return (kItemWidth+gap)*((arry.count)/count) + kItemWidth+gap*4;
            }
        }
    }
    else
    {
        return  [self sethegitCell:_arryNaeme[indexPath.row]];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 5) {       
        CaseDetailComPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CCommPic" forIndexPath:indexPath];
        for (UIView *viw in cell.subviews) {
            [viw removeFromSuperview];
        }
        for (UIViewController *vc in self.childViewControllers) {
            [vc removeFromParentViewController];
        }
        _pic= [[CollectionPicViewController alloc]init];
        _pic.arryCollData = [self.dicData objectForKey:@"picList"];
        [self addChildViewController:_pic];
        [cell addSubview:_pic.view];
        return cell;
    }
    else
    {
        CaseDetailNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CCommName" forIndexPath:indexPath];
        cell.lblDespci.text = _arryDesp[indexPath.row];
        [cell setCaseCommHeight:_arryNaeme[indexPath.row]];
        return cell;
    }
    return 0;
}

-(CGFloat)sethegitCell:(NSString *)text{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kWith - 100, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    return rect.size.height+20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
