//
//  MyStoreViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/21.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "MyStoreViewController.h"
#import "MyStoreTableViewCell.h"
#import "WebLineInfoVIew.h"
#import "WebDetailViewController.h"
#import "CircleInfoViewController.h"
#import "WebViewController.h"

@interface MyStoreViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_myTable;
    NSMutableArray *_arryData;
}
@end

@implementation MyStoreViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    NSDictionary *dic = @{@"userId":[kUserDefatuel objectForKey:@"id"]};

    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetCollectionList",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
        NSMutableArray *arry = [NSMutableArray arrayWithArray:(NSArray *)responseObject];

        if (arry.count == 0||arry == nil) {
            self.noData.hidden = NO;
            self.noData.frame = CGRectMake(0, (kHeight-60)/2, kWith, 60);
        }else
        {
            self.noData.hidden = YES;
        }
        _arryData = [self shengXuPatientViedo:arry];
        [_myTable reloadData];
    } failure:^(NSError *error) {

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBackgroundColor;
    self.title = @"我的收藏";
    
    _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWith, kHeight - 64) style:UITableViewStyleGrouped];
    _myTable.backgroundColor =[UIColor clearColor];
    _myTable.dataSource = self;
    _myTable.delegate = self;
    _myTable.rowHeight = 111;
    [self.view addSubview:_myTable];
    
    [_myTable registerClass:[MyStoreTableViewCell class] forCellReuseIdentifier:@"myStore"];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arryData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = _arryData[indexPath.section];
    if ([dic objectForKey:@"picUrl"] == nil) {
        return 40;
    }else
    {
        return 70;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *dic = _arryData[section];
    UIView *viewb = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 30)];
    viewb.backgroundColor = [UIColor whiteColor];
    
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, (kWith-40)/2, 30)];
    NSString *type;
    if ([[dic objectForKey:@"sourceType"] integerValue]==1) {
        type = @"学术前沿";
    }else if ([[dic objectForKey:@"sourceType"] integerValue]==2){
        type = @"互联网会诊";
    }else if ([[dic objectForKey:@"sourceType"] integerValue]==3){
        type = @"眼科圈";
    }
    lblName.text = type;
    lblName.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.8];
    lblName.font = [UIFont systemFontOfSize:15];
    [viewb addSubview:lblName];
        
    UILabel *lblCon = [[UILabel alloc]initWithFrame:CGRectMake(kWith/2, 0, (kWith-40)/2, 30)];
    lblCon.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.8];
    lblCon.textAlignment = 2;
    lblCon.font = [UIFont systemFontOfSize:13];
    lblCon.text = [dic objectForKey:@"createDate"];
    [viewb addSubview:lblCon];
    
    return viewb;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyStoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myStore" forIndexPath:indexPath];
    NSDictionary *dic = _arryData[indexPath.section];
    if ([dic objectForKey:@"picUrl"]!= nil)
    {
        cell.image.hidden = NO;
        NSString *urlOld = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,[dic objectForKey:@"picUrl"]];
        NSString *ulrNew = [urlOld stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        [cell.image sd_setImageWithURL:[NSURL URLWithString:ulrNew] placeholderImage:[UIImage imageNamed:@"ad1"]];
    }else
    {
        cell.image.hidden = YES;
    }
    [cell setcellHeight:dic];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *dicS = _arryData[indexPath.section];
    //学术前沿
    if ([[dicS objectForKey:@"sourceType"] integerValue] == 1) {
        WebViewController *webViewcontroller=[[WebViewController alloc]init];
        webViewcontroller.urlStr = dicS[@"webUrl"];
        webViewcontroller.title = dicS[@"title"];
         webViewcontroller.isCollectisShow = YES;
        webViewcontroller.CollectID = dicS[@"id"];
        webViewcontroller.CollectTitle = dicS[@"title"];
        [self.navigationController pushViewController:webViewcontroller animated:YES];
        
    }else if ([[dicS objectForKey:@"sourceType"] integerValue] == 2){
        //互联网会诊
        UIStoryboard *storyboardName=[UIStoryboard storyboardWithName:@"WebLine" bundle:[NSBundle mainBundle]];
        WebLineInfoVIew *webView=[storyboardName instantiateViewControllerWithIdentifier:@"WebLineInfoVIew"];
        webView.isCircle = NO;
        webView.str_topID = [dicS objectForKey:@"sourceID"];
        [self.navigationController pushViewController:webView animated:YES];
    }else if ([[dicS objectForKey:@"sourceType"] integerValue] == 3){
        //眼科圈
        UIStoryboard *storyboardName=[UIStoryboard storyboardWithName:@"WebLine" bundle:[NSBundle mainBundle]];
        WebLineInfoVIew *webView=[storyboardName instantiateViewControllerWithIdentifier:@"WebLineInfoVIew"];
        webView.str_topID = [dicS objectForKey:@"sourceID"];
        webView.isCircle = YES;
        [self.navigationController pushViewController:webView animated:YES];
    }
}

#pragma mark--------升序
-(NSMutableArray *)shengXuPatientViedo:(NSArray *)arry{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:[arry sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *modelM1, NSDictionary *modelM2) {
        
        NSDate *date1 = [dateFormatter dateFromString:[modelM1 objectForKey:@"createDate"]];
        NSDate *date2 = [dateFormatter dateFromString:[modelM2 objectForKey:@"createDate"]];
        NSComparisonResult result = [date1 compare:date2];
        return result == NSOrderedAscending;
    }]];
    return array;
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
