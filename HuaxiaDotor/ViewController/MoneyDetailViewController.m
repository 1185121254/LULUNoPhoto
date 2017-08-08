//
//  MoneyDetailViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/13.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "MoneyDetailViewController.h"
#import "MoneyDetailTableViewCell.h"
#import "Anasisy.h"

@interface MoneyDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_moneyTable;
    NSMutableArray *_arryDateMoney;
    NSMutableArray *_arryHeader;
}
@end

@implementation MoneyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收入明细";
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _arryHeader = [self setMonth];
    
    _moneyTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, kWith, kHeight - 65) style:UITableViewStyleGrouped];
    _moneyTable.dataSource = self;
    _moneyTable.delegate = self;
    _moneyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _moneyTable.rowHeight = 61;
    [self.view addSubview:_moneyTable];
    
    [_moneyTable registerClass:[MoneyDetailTableViewCell class] forCellReuseIdentifier:@"moneyCell"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[kUserDefatuel objectForKey:@"id"],@"doctorId",@"",@"orderType", nil];

    NSLog(@"%@",DICTIONARY_VERIFYCODE);
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetOrderList",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
        NSMutableArray *arry = [Anasisy setDateMonth:(NSArray *)responseObject];
        _arryDateMoney = arry;
        [_moneyTable reloadData];

    } failure:^(NSError *error) {

    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arryDateMoney.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_arryDateMoney[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 40)];

    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 40)];
    lbl.font =[UIFont systemFontOfSize:16];
    lbl.text = _arryHeader[section];
    [viewBottom addSubview:lbl];
    
    UILabel *lblTotal = [[UILabel alloc]initWithFrame:CGRectMake(kWith - 200, 0, 190, 40)];
    lblTotal.text = [NSString stringWithFormat:@"合计：%.2f元",[self setTotalMonth:_arryDateMoney[section]]];
    lblTotal.textAlignment =2;
    lblTotal.font =[UIFont systemFontOfSize:16];
    [viewBottom addSubview:lblTotal];
    
    return viewBottom;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MoneyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moneyCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = _arryDateMoney[indexPath.section][indexPath.row];
    cell.lblTime.text = [dic  objectForKey:@"createDate"];
    NSString *str;
    if ([[dic  objectForKey:@"orderType"] integerValue]==1) {
        str = @"图文咨询";
    }else if ([[dic  objectForKey:@"orderType"] integerValue]==2){
        str = @"电话咨询";
    }else if ([[dic  objectForKey:@"orderType"] integerValue]==3){
        str = @"视频咨询";
    }else if ([[dic  objectForKey:@"orderType"] integerValue]==4){
        str = @"加号预约";
    }
    
    cell.lblType.text = [NSString stringWithFormat:@"%@ - %@",[dic  objectForKey:@"patientName"],str];
    cell.lblMoney.text = [NSString stringWithFormat:@"+ %@",[dic objectForKey:@"orderAmount"]];
    
    return cell;
}

-(CGFloat)setTotalMonth:(NSArray *)arry{
    CGFloat total = 0;;
    for (NSDictionary *dic in arry) {
        total = total + [[dic objectForKey:@"orderAmount"] floatValue];
    }
    return total;
}

-(NSMutableArray *)setMonth{
    NSMutableArray *arryHeader = [NSMutableArray arrayWithObjects:@"本月", nil];

    NSDateFormatter *dataFormat  =[[NSDateFormatter alloc]init];
    [dataFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *nowS = [dataFormat stringFromDate:[NSDate date]];
    NSArray *arryDic = [nowS componentsSeparatedByString:@"-"];
    if ([arryDic[1] isEqualToString:@"01"]) {
        [arryHeader addObject:@"十二月"];
        [arryHeader addObject:@"十一月"];
    }
    else if ([arryDic[1] isEqualToString:@"02"]){
        [arryHeader addObject:@"一月"];
        [arryHeader addObject:@"十二月"];
    }
    else if ([arryDic[1] isEqualToString:@"03"]){
        [arryHeader addObject:@"二月"];
        [arryHeader addObject:@"一月"];
    }
    else if ([arryDic[1] isEqualToString:@"04"]){
        [arryHeader addObject:@"三月"];
        [arryHeader addObject:@"二月"];
    }
    else if ([arryDic[1] isEqualToString:@"05"]){
        [arryHeader addObject:@"四月"];
        [arryHeader addObject:@"三月"];
    }
    else if ([arryDic[1] isEqualToString:@"06"]){
        [arryHeader addObject:@"五月"];
        [arryHeader addObject:@"四月"];
    }
    else if ([arryDic[1] isEqualToString:@"07"]){
        [arryHeader addObject:@"六月"];
        [arryHeader addObject:@"五月"];
    }
    else if ([arryDic[1] isEqualToString:@"08"]){
        [arryHeader addObject:@"七月"];
        [arryHeader addObject:@"六月"];
    }
    else if ([arryDic[1] isEqualToString:@"09"]){
        [arryHeader addObject:@"八月"];
        [arryHeader addObject:@"七月"];
    }
    else if ([arryDic[1] isEqualToString:@"10"]){
        [arryHeader addObject:@"九月"];
        [arryHeader addObject:@"八月"];
    }
    else if ([arryDic[1] isEqualToString:@"11"]){
        [arryHeader addObject:@"十月"];
        [arryHeader addObject:@"九月"];
    }
    else if ([arryDic[1] isEqualToString:@"12"]){
        [arryHeader addObject:@"十一月"];
        [arryHeader addObject:@"十月"];
    }
    return arryHeader;
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
