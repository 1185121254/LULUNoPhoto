//
//  ElectronDetailViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/7/29.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ElectronDetailViewController.h"
#import "DoctorAdvieTableViewCell.h"
#import "ShowElectronViewController.h"

@interface ElectronDetailViewController ()
<UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_arryDataSource;

    NSMutableDictionary *_dicProgress;
    

}

@end

@implementation ElectronDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"病人详情";
    self.view.backgroundColor = kBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dicProgress = [NSMutableDictionary dictionary];
    

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWith, kHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight = 75;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"electronDetail"];
    
    [self getDataPullDown:1];
    
    
    __weak ElectronDetailViewController *weakSelf = self;
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getDataPullDown:2];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getDataPullDown:3];
    }];
    
}

#pragma mark------列表
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else
    {
        return _arryDataSource.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 4*25+20;
    }else
    {
        return 30;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return [self creatTableHeader];
    }else
    {
        return [self creatSecondHeader];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"electronDetail" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    NSDictionary *dic = _arryDataSource[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"title"];
    cell.textLabel.textColor = BLUECOLOR_STYLE;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self downLoadFile:indexPath];

}

#pragma mark------获取数据
-(void)getDataPullDown:(NSInteger)pullDown{

    
    //1  进入页面  2  下拉    3  上推
    if (pullDown == 1) {

    }else
    {

    }
    
    static NSInteger page = 1;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[self.dicData objectForKey:@"eventNo"] forKey:@"eventNo"];
    [dic setObject:@(15) forKey:@"pageSize"];
    if (pullDown != 3) {
        [_tableView.mj_footer resetNoMoreData];
        page = 1;
    }else
    {
        page++;
    }

    [dic setObject:@(page) forKey:@"pageNumber"];
    [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/GetPubliceList",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject, BOOL ifTimeout) {

        NSDictionary *diValue = (NSDictionary *)responseObject;
        if (diValue==nil) {
            return ;
        }
        NSArray *arry = [diValue objectForKey:@"rows"];
        if (arry==nil||arry.count == 0) {
            if (pullDown==3) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }else
            {
                [_tableView.mj_header endRefreshing];
                self.noData.frame = CGRectMake(0, (kHeight-60)/3*2, kWith, 60);
                self.noData.hidden = NO;
            }
        }
        else
        {
            self.noData.hidden = YES;
            if (pullDown != 3) {
                _arryDataSource = [NSMutableArray arrayWithArray:arry];
            }
            else
            {
                for (NSDictionary *dic in arry) {
                    [_arryDataSource addObject:dic];
                }
            }
        }
        if (pullDown == 2) {
            [_tableView.mj_header endRefreshing];
        }
        else if (pullDown == 3){
            [_tableView.mj_footer endRefreshing];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {

        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    }];

}

-(void)downLoadFile:(NSIndexPath *)index{

    if (_arryDataSource==nil ||_arryDataSource.count==0) {
        kAlter(@"无数据");
        return;
    }
    NSDictionary *dic = _arryDataSource[index.row];
    NSDictionary *dicparament = @{@"patientId":[dic objectForKey:@"patientId"],@"emrId":[dic objectForKey:@"emrId"],@"eventNo":[dic objectForKey:@"eventNo"],@"name":[dic objectForKey:@"title"]};

    [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/GetPubliceContent",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dicparament viewConroller:self success:^(id responseObject, BOOL ifTimeout) {

        NSString *url = (NSString *)responseObject;
        if (url) {
            NSString *urlStr  = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,url];
            NSString *newUrl = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            ShowElectronViewController *show = [[ShowElectronViewController alloc]init];
            show.strURL = newUrl;
            show.electronTitle = [dic objectForKey:@"title"];
            [self.navigationController pushViewController:show animated:YES];
        }else
        {
            kAlter(@"获取资源失败");
        }
    } failure:^(NSError *error) {

    }];

}

-(void)dealloc{

}

//-(void)downLoadElectron:(NSString *)url FileName:(NSString *)title NSIndexPath:(NSIndexPath *)index{
//
//    
//    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//    manager.responseSerializer =[AFHTTPResponseSerializer serializer];
//    [manager.requestSerializer setValue:[kUserDefatuel objectForKey:@"verifyCode"] forHTTPHeaderField:@"verifyCode"];
//    
//    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//        [_dicProgress setObject:@(downloadProgress.fractionCompleted) forKey:title];
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            // 处理耗时操作的代码块...
//            
//            //通知主线程刷新
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //回调或者说是通知主线程刷新，
//                [_tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
//
//            });
//            
//        });
//        
//    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        
//        return [NSString downLoadFile:[_dicData objectForKey:@"patientName"] FileNmae:title];
//        
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        
//        if (error) {
//            
//            NSLog(@"失败：：：：：：：%@",error);
//            
//            [[NSFileManager defaultManager] removeItemAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@/%@.docx",[_dicData objectForKey:@"patientName"],title]] error:nil];
//            kAlter(@"下载失败");
//            
//        }
//    }];
//    
//    [task resume];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--------详情
-(UIView *)creatTableHeader{
    
    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 4*25+20)];
    viewBottom.backgroundColor = [UIColor whiteColor];
    
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, (kWith-20)/3, 25)];
    lblName.font = [UIFont systemFontOfSize:14];
    lblName.text = [NSString stringWithFormat:@"姓名：%@",[_dicData objectForKey:@"patientName"]];
    [viewBottom addSubview:lblName];
    
    UILabel *lblAge = [[UILabel alloc]initWithFrame:CGRectMake(10+(kWith - 20)/3, 10, (kWith-20)/3, 25)];
    lblAge.font = [UIFont systemFontOfSize:14];
    lblAge.text = [NSString stringWithFormat:@"年龄：%@岁",[_dicData objectForKey:@"age"]];
    [viewBottom addSubview:lblAge];
    
    //就诊号
    UILabel *lblNum = [[UILabel alloc]initWithFrame:CGRectMake(lblAge.frame.origin.x+lblAge.frame.size.width, 10, (kWith-20)/3, 25)];
    lblNum.font = [UIFont systemFontOfSize:14];
    lblNum.text = [NSString stringWithFormat:@"就诊号：%@",[_dicData objectForKey:@"eventNo"]];
    [viewBottom addSubview:lblNum];
    
    //床号
    UILabel *lblBedNum = [[UILabel alloc]initWithFrame:CGRectMake(lblName.frame.origin.x, 35, (kWith-20)/3, 25)];
    lblBedNum.font = [UIFont systemFontOfSize:14];
    lblBedNum.text = [NSString stringWithFormat:@"床号：%@",[_dicData objectForKey:@"bedNo"]];
    [viewBottom addSubview:lblBedNum];
    
    //编号
    UILabel *lblPaNum = [[UILabel alloc]initWithFrame:CGRectMake(lblAge.frame.origin.x, 35, (kWith-20)/3, 25)];
    lblPaNum.font = [UIFont systemFontOfSize:14];
    lblPaNum.text = [NSString stringWithFormat:@"编号：%@",[_dicData objectForKey:@"patientId"]];
    [viewBottom addSubview:lblPaNum];
    
    //科室名称
    UILabel *lblArrears = [[UILabel alloc]initWithFrame:CGRectMake(lblName.frame.origin.x, 60, (kWith-20)/2+20, 25)];
    lblArrears.font = [UIFont systemFontOfSize:14];
    lblArrears.text = [NSString stringWithFormat:@"科室名称：%@",[_dicData objectForKey:@"deptName"]];
    [viewBottom addSubview:lblArrears];
    
    //楼层名称
    UILabel *wardName = [[UILabel alloc]initWithFrame:CGRectMake(kWith/2+20, 60, (kWith-20)/2-20, 25)];
    wardName.font = [UIFont systemFontOfSize:14];
    wardName.textAlignment = 2;
    wardName.text = [NSString stringWithFormat:@"楼层名称：%@",[_dicData objectForKey:@"wardName"]];
    [viewBottom addSubview:wardName];
    
    //住院时间
    UILabel *admissionTime = [[UILabel alloc]initWithFrame:CGRectMake(lblName.frame.origin.x, 85, kWith-20, 25)];
    admissionTime.font = [UIFont systemFontOfSize:14];
    admissionTime.text = [NSString stringWithFormat:@"住院时间：%@",[_dicData objectForKey:@"admissionTime"]];
    [viewBottom addSubview:admissionTime];
    
    return viewBottom;
}

-(UIView *)creatSecondHeader{

    UIView *viewsec = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 30)];
    viewsec.backgroundColor = [UIColor whiteColor];
    
    UILabel *lblHeader =  [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kWith-20, 30)];
    lblHeader.text = @"电子病历列表";
    lblHeader.font = [UIFont systemFontOfSize:15];
    [viewsec addSubview:lblHeader];
    
    return viewsec;
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
