//
//  DrugViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/31.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "DrugViewController.h"
#import "DocAddviceSearchViewController.h"

@interface DrugViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    NSMutableArray *_arryData;
    NSInteger _tottal;

}
@end

@implementation DrugViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"药品选择";
    self.view.backgroundColor = kBackgroundColor;
    
    UIButton *btnSearchCon = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearchCon.backgroundColor = [UIColor whiteColor];
    btnSearchCon.frame = CGRectMake(20, 60+13, kWith-40, 30);
    [btnSearchCon setTitle:@"🔍输入患者相关信息" forState:UIControlStateNormal];
    [btnSearchCon setTitleColor:kBoradColor forState:UIControlStateNormal];
    [btnSearchCon addTarget:self action:@selector(onSearchDrug) forControlEvents:UIControlEventTouchUpInside];
    btnSearchCon.layer.cornerRadius = 3;
    btnSearchCon.layer.masksToBounds = YES;
    [self.view addSubview:btnSearchCon];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 110, kWith, kHeight - 110)];
    _tableView.dataSource= self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];

    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DocDrug"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@(1) forKey:@"page"];
    [dic setObject:@(20) forKey:@"rows"];
    [dic setObject:@"" forKey:@"FuzzyName"];
    if ([self.from isEqualToString:@"drug"]) {

        [self beginView:dic URL:[NSString stringWithFormat:@"%@/api/Doctor/GetAdviceDrug",NET_URLSTRING]];

    }else
    {
        [self beginView:dic URL:[NSString stringWithFormat:@"%@/api/Doctor/GetAdviceCheck",NET_URLSTRING]];
    }
    __weak DrugViewController *weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf updateDataDrug:1];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf updateDataDrug:2];
    }];
}

-(NSMutableArray *)getData:(NSDictionary *)dicValue{

    NSNumber *number = [dicValue objectForKey:@"total"];
    NSArray *arryRows = [dicValue objectForKey:@"rows"];
    NSMutableArray *ArryDoc = [NSMutableArray array];
    for (NSDictionary *dciRows in arryRows) {
        NSMutableDictionary *doctor = [[NSMutableDictionary alloc]init];
        for (NSString *key in [dciRows allKeys]) {
            [doctor setObject:[dciRows objectForKey:key] forKey:key];
        }
        [ArryDoc addObject:doctor];
    }
    _tottal = [number integerValue];
    return ArryDoc;
    
}

-(void)beginView:(NSDictionary *)dic URL:(NSString *)url{

    
    [RequestManager postWithURLStringALL:url heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject, BOOL ifTimeout) {
         
         _arryData = [self getData:(NSDictionary *)responseObject];
         [_tableView reloadData];

        
    } failure:^(NSError *error) {

    }];
}

-(void)endView:(NSDictionary *)dic URL:(NSString *)url{

    [RequestManager postWithURLStringALL:url heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject, BOOL ifTimeout) {
        NSMutableArray *array = [self getData:(NSDictionary *)responseObject];
        for (NSDictionary *dicV in array) {
            [_arryData addObject:dicV];
        }
        [_tableView reloadData];

    } failure:^(NSError *error) {

    }];
}

-(void)dealloc{

}

#pragma mark-------下拉刷新
-(void)updateDataDrug:(NSInteger)state{

    static NSInteger i = 1;
    if (state == 1) {
        //下拉刷新
        i = 1;
        [_tableView.mj_footer resetNoMoreData];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:@(i) forKey:@"page"];
        [dic setObject:@(20) forKey:@"rows"];
        [dic setObject:@"" forKey:@"FuzzyName"];
        if ([self.from isEqualToString:@"drug"]) {
            [self beginView:dic URL:[NSString stringWithFormat:@"%@/api/Doctor/GetAdviceDrug",NET_URLSTRING]];
        
        }else
        {
            [self beginView:dic URL:[NSString stringWithFormat:@"%@/api/Doctor/GetAdviceCheck",NET_URLSTRING]];
        }
    }
    else
    {
        if (_arryData.count >= _tottal) {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        else
        {
            i++;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:@(i) forKey:@"page"];
            [dic setObject:@(20) forKey:@"rows"];
            [dic setObject:@"" forKey:@"FuzzyName"];
            if ([self.from isEqualToString:@"drug"]) {
                
                [self endView:dic URL:[NSString stringWithFormat:@"%@/api/Doctor/GetAdviceDrug",NET_URLSTRING]];
           
            }else
            {
                [self endView:dic URL:[NSString stringWithFormat:@"%@/api/Doctor/GetAdviceCheck",NET_URLSTRING]];
            }
        }
    }
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arryData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DocDrug" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSDictionary *dic = _arryData[indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.numberOfLines = 0;
    if ([self.from isEqualToString:@"drug"]) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@    %@  %@  %@",[dic objectForKey:@"drugName"],[dic objectForKey:@"drugStandard"],[dic objectForKey:@"pharmacyUnit"],[dic objectForKey:@"price"]];
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%@    %@",[dic objectForKey:@"itemName"],[dic objectForKey:@"dosageUnit"]];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _arryData[indexPath.row];
    if ([self.from isEqualToString:@"drug"]) {
        NSMutableDictionary *dicUsfo = [NSMutableDictionary dictionary];
        [dicUsfo setObject:[dic objectForKey:@"drugName"] forKey:@"drugName"];
        [dicUsfo setObject:[dic objectForKey:@"drugStandard"] forKey:@"drugStandard"];
        [dicUsfo setObject:[dic objectForKey:@"pharmacyUnit"] forKey:@"pharmacyUnit"];
        [dicUsfo setObject:[dic objectForKey:@"price"] forKey:@"price"];
        [dicUsfo setObject:[dic objectForKey:@"drugNumber"] forKey:@"drugNumber"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DocDrug" object:nil userInfo:dicUsfo];
    }else
    {
        NSMutableDictionary *dicUsfo = [NSMutableDictionary dictionary];
        [dicUsfo setObject:[dic objectForKey:@"itemName"] forKey:@"drugName"];
        [dicUsfo setObject:[dic objectForKey:@"dosageQuantity"] forKey:@"drugStandard"];
        [dicUsfo setObject:[dic objectForKey:@"dosageUnit"] forKey:@"pharmacyUnit"];
        [dicUsfo setObject:[dic objectForKey:@"price"] forKey:@"price"];
        [dicUsfo setObject:[dic objectForKey:@"itemCode"] forKey:@"drugNumber"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DocDrug" object:nil userInfo:dicUsfo];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onSearchDrug{
    
    DocAddviceSearchViewController *add = [[DocAddviceSearchViewController alloc]init];
    add.from = self.from;
    [self.navigationController pushViewController:add animated:YES];
    
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
