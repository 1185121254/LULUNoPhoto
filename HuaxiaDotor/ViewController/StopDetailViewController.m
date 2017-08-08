//
//  StopDetailViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/29.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "StopDetailViewController.h"
#import "StopReadlyTableViewCell.h"

@interface StopDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableViewStop;
    NSMutableArray *_arryData;
}

@end

@implementation StopDetailViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    NSDictionary *dic= @{@"doctorId":[kUserDefatuel objectForKey:@"id"]};

    
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetStopNotice",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
        NSMutableArray *arry = [NSMutableArray arrayWithArray:(NSArray *)responseObject];

        if (arry.count == 0 || arry == nil) {
            self.noData.frame = CGRectMake(0, (kHeight-60)/2, kWith, 60);
            self.noData.hidden = NO;
        }else
        {
            self.noData.hidden = YES;
        }
        _arryData = arry;
        [_tableViewStop reloadData];

    } failure:^(NSError *error) {

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"已停诊";
    
    _tableViewStop = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, kWith, kHeight-65) style:UITableViewStyleGrouped];
    _tableViewStop.backgroundColor = [UIColor clearColor];
    _tableViewStop.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewStop.dataSource = self;
    _tableViewStop.delegate = self;
    [self.view addSubview:_tableViewStop];
    
    [_tableViewStop registerClass:[UITableViewCell class] forCellReuseIdentifier:@"StopAlreadly"];
    [_tableViewStop registerClass:[StopReadlyTableViewCell class ] forCellReuseIdentifier:@"StopReadlyTableV"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return _arryData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_arryData.count == 0) {
        return 0;
    }else
    {
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _arryData[indexPath.section];
    if (indexPath.row == 1) {
        return  [self setHeightCel:[NSString stringWithFormat:@"%@~%@",[dic objectForKey:@"startDate"],[dic objectForKey:@"endDate"]]];
    }else if (indexPath.row == 2){
        return  [self setHeightCel:[NSString stringWithFormat:@"%@~%@",[dic objectForKey:@"startSpan"],[dic objectForKey:@"endSpan"]]];
    }else if (indexPath.row == 3){
        return  [self setHeightCel:[NSString stringWithFormat:@"%@",[self setStopType:[dic objectForKey:@"typeList"]]]];
    }else if (indexPath.row == 4){
        return  [self setHeightCel:[NSString stringWithFormat:@"%@",[dic objectForKey:@"stopReason"]]];
    }else
    {
        return 20;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = _arryData[indexPath.section];
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StopAlreadly" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.8];
        cell.textLabel.text = [dic objectForKey:@"createDate"];
        return cell;
    }else
    {
        StopReadlyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StopReadlyTableV" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row == 1){
            cell.lblDesp.text = @"停诊日期        ";
            [cell setHeightCellStop:[NSString stringWithFormat:@"%@~%@",[dic objectForKey:@"startDate"],[dic objectForKey:@"endDate"]]];
        }else if(indexPath.row == 2){
            cell.lblDesp.text = @"停诊时段        ";
            [cell setHeightCellStop:[NSString stringWithFormat:@"%@~%@",[dic objectForKey:@"startSpan"],[dic objectForKey:@"endSpan"]]];
        }else if(indexPath.row == 3){
            cell.lblDesp.text = @"停诊类型        ";
            [cell setHeightCellStop:[NSString stringWithFormat:@"%@",[self setStopType:[dic objectForKey:@"typeList"]]]];
        }
        else{
            cell.lblDesp.text = @"停诊原因        ";
            [cell setHeightCellStop:[NSString stringWithFormat:@"%@",[dic objectForKey:@"stopReason"]]];
        }
        return cell;
    }

}


-(NSMutableString *)setStopType:(NSString *)typeNum{

    NSMutableString *string = [[NSMutableString alloc]init];
    if (typeNum != nil) {
        NSArray *arry = [typeNum componentsSeparatedByString:@","];
        if (arry.count>0) {
            for (NSString *type in arry) {
                if ([type isEqualToString:@"1"]) {
                    [string appendString:@"图文问诊、"];
                }else if ([type isEqualToString:@"2"]){
                    [string appendString:@"电话问诊、"];
                }else if ([type isEqualToString:@"3"]){
                    [string appendString:@"视频问诊、"];
                }else if ([type isEqualToString:@"4"]){
                    [string appendString:@"加号问诊、"];
                }
            }
        }
        if (string.length > 0) {
            [string deleteCharactersInRange:NSMakeRange(string.length-1, 1)];
        }
    }
    return string;
}

-(CGFloat)setHeightCel:(NSString *)text{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kWith-140, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    return rect.size.height+10;
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
