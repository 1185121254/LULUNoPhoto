//
//  SendDetailViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/28.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "SendDetailViewController.h"
#import "DetailReaflyTableViewCell.h"

@interface SendDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableDetail;
}

@end

@implementation SendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableDetail = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, kWith, kHeight-65)];
    _tableDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableDetail.dataSource = self;
    _tableDetail.delegate = self;
    [self.view addSubview:_tableDetail];
    
    [_tableDetail registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DetailReaflyTableV"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return [self setHeightCell:[self.dicData objectForKey:@"messageTitle"] Font:18];
    }else if (indexPath.row == 1) {
        return [self setHeightCell:[self.dicData objectForKey:@"createDate"] Font:13];
    }else if (indexPath.row == 2){
         return [self setHeightCell:[self setLblrecive:[self.dicData objectForKey:@"receiverList"]] Font:13];
    }else
    {
        return [self setHeightCell:[self.dicData objectForKey:@"messageDetail"] Font:16];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailReaflyTableV" forIndexPath:indexPath];
    cell.textLabel.numberOfLines = 0;
    if (indexPath.row == 0) {
        cell.textLabel.text = [self.dicData objectForKey:@"messageTitle"];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.textColor = [UIColor blackColor];
    }else if (indexPath.row == 1){
        cell.textLabel.text = [self.dicData objectForKey:@"createDate"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    }else if (indexPath.row == 2){
        cell.textLabel.text = [NSString stringWithFormat:@"收件人:%@",[self setLblrecive:[self.dicData objectForKey:@"receiverList"]]];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
    }else if (indexPath.row == 3){
        cell.textLabel.text = [self.dicData objectForKey:@"messageDetail"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableString *)setLblrecive:(NSArray *)arry{
    
    NSMutableString *strName = [[NSMutableString alloc]init];;
    for (NSDictionary *dic in arry) {
        if ([dic objectForKey:@"receiverName"] != nil) {
            NSString *name=  [dic objectForKey:@"receiverName"];
            [strName appendString:[NSString stringWithFormat:@"%@、",name]];
        }
    }
    if (strName.length>0) {
        [strName deleteCharactersInRange:NSMakeRange(strName.length-1, 1)];
    }
    return strName;
}

-(CGFloat)setHeightCell:(NSString *)text Font:(NSInteger)font{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kWith-50, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.height+5;
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
