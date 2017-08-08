//
//  ViedoSchedelViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/19.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ViedoSchedelViewController.h"
#import "ViedoSchedulTableViewCell.h"
#import "ViedoAddViewController.h"
#import "OnLineViedo.h"

@interface ViedoSchedelViewController ()<UITableViewDelegate,UITableViewDataSource>

{

    NSMutableArray *_arryHeader;
}

@end

@implementation ViedoSchedelViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开通视频咨询";
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.frame = CGRectMake(0, 209, kWith, kHeight - 209);
    self.view.backgroundColor = kBackgroundColor;

    _arryHeader = [NSMutableArray arrayWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
    _arryWeek = [NSMutableArray array];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, kWith-20, kHeight - 209) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.rowHeight = 50;
    _tableView.delegate = self;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[ViedoSchedulTableViewCell class] forCellReuseIdentifier:@"viedoSchedu"];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40.5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith-20, 40)];
    view.layer.cornerRadius = 3;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 1;
    view.layer.borderColor = [kBoradColor CGColor];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWith-20, 40)];
    lbl.text = _arryHeader[section];
    lbl.font = [UIFont systemFontOfSize:17];
    lbl.textAlignment =  1;
    [view addSubview:lbl];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kWith-20-40, 0, 40, 40);
    btn.tag = section + 880;
    [btn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"l+_h"] forState:UIControlStateNormal];
    [view addSubview:btn];
    
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_arryWeek.count > 0) {
        return [_arryWeek[section] count];
    }
    return 0;
}

-(ViedoSchedulTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ViedoSchedulTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"viedoSchedu" forIndexPath:indexPath];
    
    OnLineViedo *onLine = _arryWeek[indexPath.section][indexPath.row];
    cell.lblDate.text = [NSString stringWithFormat:@"%@",onLine.serviceTime];
    cell.lblCount.text = [NSString stringWithFormat:@"接诊人数\n%@",onLine.serviceAmount];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)onBtn:(UIButton *)btn{

    ViedoAddViewController *viedoAdd = [[ViedoAddViewController alloc]init];
    viedoAdd.week = [NSString stringWithFormat:@"%ld",btn.tag - 880 +1];
    viedoAdd.arryViedo = _arryWeek[btn.tag - 880];
    [self.navigationController pushViewController:viedoAdd animated:YES];
    
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
