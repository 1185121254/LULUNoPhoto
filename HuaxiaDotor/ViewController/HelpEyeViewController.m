//
//  HelpEyeViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/12/8.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "HelpEyeViewController.h"
#import "ShowElectronViewController.h"

@interface HelpEyeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UITableViewCell *telCell;
    __weak IBOutlet UITableView *helpTable;
    NSMutableArray *cellArray;
    NSInteger currenPage;
}
@end

@implementation HelpEyeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    cellArray = [NSMutableArray arrayWithArray:@[telCell,@"使用帮助"]];
    [self setNavigationBar];
    
    helpTable.rowHeight = UITableViewAutomaticDimension;
    helpTable.estimatedRowHeight = 300;
    [helpTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"helpCell"];
    
    currenPage = 1;
    [self getData];
    __weak typeof(self) weakSelf = self;
    helpTable.mj_header = [MJRefreshStateHeader headerWithRefreshingBlock:^{
        currenPage  = 1;
        cellArray = [NSMutableArray arrayWithArray:@[telCell,@"使用帮助"]];
        [weakSelf getData];
        [helpTable.mj_header endRefreshing];
    }];
    
    helpTable.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
        currenPage++;
        [weakSelf getData];
        [helpTable.mj_footer endRefreshing];
    }];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)setNavigationBar
{
    self.title = @"帮助与反馈";
}


#pragma mark - 列表设置
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return cellArray[indexPath.row];
    }else
    {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"helpCell" forIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.numberOfLines = 0;

        if (indexPath.row ==1) {
            cell.textLabel.text = cellArray[indexPath.row];
        }else
        {
            NSDictionary *dic = cellArray[indexPath.row];
            cell.textLabel.text = dic[@"title"];

        }
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return -1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row <= 1) {
        return;
    }else
    {
        NSDictionary *dic = cellArray[indexPath.row];
        ShowElectronViewController *showWeb = [[ShowElectronViewController alloc]init];
        showWeb.strURL = dic[@"url"];
        showWeb.electronTitle = dic[@"title"];
        [self.navigationController pushViewController:showWeb animated:YES];
    }
}


- (IBAction)btnTel:(id)sender {
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定拨打客服电话：18906020939" preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://18906020939"]];
    }]];
    [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alter animated:YES completion:nil];
}

-(void)getData{

    NSDictionary *para = @{@"type":@(1),@"page":@(currenPage),@"rows":@(10),};
    
    [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Hospital/GetPlatformHelp",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:para viewConroller:self success:^(id responseObject, BOOL ifTimeout) {
       
        NSArray *arr = [(NSDictionary *)responseObject objectForKey:@"rows"];
        helpTable.mj_footer.hidden = YES;
        [self setData:arr];
        
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)setData:(NSArray *)arrar{

    for (NSDictionary *dic in arrar) {
        [cellArray addObject:dic];
    }
    [helpTable reloadData];
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