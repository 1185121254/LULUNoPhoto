//
//  ClipDeatilTableViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/7.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ClipDeatilTableViewController.h"

@interface ClipDeatilTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableViewC;
}
@end

@implementation ClipDeatilTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableViewC = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableViewC.dataSource = self;
    _tableViewC.delegate = self;
    _tableViewC.userInteractionEnabled = NO;
    _tableViewC.rowHeight = 30;
    [self.view addSubview:_tableViewC];
    [_tableViewC registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ClipDrug"];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (_arryDrug.count == 0) {
            return 1;
        }else
        {
            return _arryDrug.count;
        }
    }else
    {
        if (_arryPH.count == 0) {
            return 1;
        }else
        {
            return _arryPH.count;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewA = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 30)];
    viewA.backgroundColor = [UIColor whiteColor];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kWith -40, 30)];
    lbl.font = [UIFont systemFontOfSize:14];
    if (section == 0) {
        lbl.text = @"药品";
    }else
    {
        lbl.text = @"药房";
    }
    [viewA addSubview:lbl];
    return viewA;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClipDrug" forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section ==0 ) {
//        NSDictionary *dic = _arryDrug[indexPath.row];
        if (_arryDrug.count == 0) {
            cell.textLabel.text = @"无记录";
        }else
        {
            cell.textLabel.text = @"无字段";
        }
    }else
    {
        NSDictionary *dic = _arryPH[indexPath.row];
        if (_arryPH.count == 0) {
            cell.textLabel.text = @"无记录";
        }else
        {
           cell.textLabel.text = [dic objectForKey:@"drugName"];
        }
    }
    return cell;
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
