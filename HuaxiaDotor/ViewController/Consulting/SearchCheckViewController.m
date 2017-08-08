//
//  SearchCheckViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/28.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "SearchCheckViewController.h"
#import "DiagnosticAdviceViewController.h"


@interface SearchCheckViewController ()
<UITableViewDelegate,UITableViewDataSource>
{
    UITextField *_text;
    NSMutableArray *_arryNew;
    
    UITableView *_tableViewSear;
}
@end

@implementation SearchCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"搜索";
    self.view.backgroundColor = kBackgroundColor;
    
    _text= [[UITextField alloc]initWithFrame:CGRectMake(10, 64+10, kWith-20-70, 30)];
    _text.placeholder = @"请根据患者姓名进行搜索";
    _text.borderStyle = UITextBorderStyleRoundedRect;
    _text.textAlignment = 1;
    _text.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:_text];
    
    UIButton  *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(kWith - 70, 64+10, 50, 30);
    [btnSearch setTitle:@"搜索" forState:UIControlStateNormal];
    btnSearch.backgroundColor = BLUECOLOR_STYLE;
    btnSearch.layer.cornerRadius = 3;
    [btnSearch addTarget:self action:@selector(onBtnSearchCheck) forControlEvents:UIControlEventTouchUpInside];
    btnSearch.layer.masksToBounds = YES;
    [self.view addSubview:btnSearch];
    
    _tableViewSear = [[UITableView alloc]initWithFrame:CGRectMake(0, 114, kWith, kHeight - 114)];
    _tableViewSear.dataSource = self;
    _tableViewSear.backgroundColor = [UIColor clearColor];
    _tableViewSear.delegate = self;
    _tableViewSear.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableViewSear];
    
    [_tableViewSear registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SearchCheck"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arryNew.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuse  =@"med";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    CheckModel *model  = _arryNew[indexPath.row];
    cell.textLabel.text = model.name;
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CheckModel *model  = _arryNew[indexPath.row];
    NSDictionary *dic = @{@"checkId":model.Id,@"checkName":model.name};
    [[NSNotificationCenter defaultCenter]postNotificationName:@"check" object:nil userInfo:dic];
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[DiagnosticAdviceViewController class]]) {
            DiagnosticAdviceViewController *diagno = (DiagnosticAdviceViewController *)vc;
            [self.navigationController popToViewController:diagno animated:YES];
            break;
        }
    }
}


-(void)onBtnSearchCheck{

    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"正在加载";
    HUD.hidden = NO;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:@"1" forKey:@"page"];
    [dic setObject:@"20" forKey:@"rows"];
    [dic setObject:_text.text forKey:@"fuzzyName"];
//    [RequestManager checkProgram:[NSString stringWithFormat:@"%@/api/Share/GetShareCheck",NET_URLSTRING] parameters:dic Complation:^(NSMutableArray *arry) {
//        _arryNew= arry;
//        [_tableViewSear reloadData];
//        HUD.hidden = YES;
//    } Fail:^(NSError *error) {
//        HUD.hidden = YES;
//        kAlter(kFail);
//    }];
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
