//
//  UserDocViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/2.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "UserDocViewController.h"

@interface UserDocViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_arryUserage;
    UITableView *_tableView;
    
}
@end

@implementation UserDocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatArry];
    self.title = @"药品用法";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWith, kHeight - 64)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DocUserFa"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arryUserage.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DocUserFa" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    NSString *str = _arryUserage[indexPath.row];
    NSArray *arry = [str componentsSeparatedByString:@","];
    cell.textLabel.text = arry[1];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DocUserFa" object:_arryUserage[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)creatArry{
    _arryUserage = kUser;
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
