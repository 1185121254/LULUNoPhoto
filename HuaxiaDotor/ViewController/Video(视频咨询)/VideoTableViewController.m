//
//  VideoTableViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/16.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "VideoTableViewController.h"
#import "ChatViedoViewController.h"
#import "AddViedoViewController.h"
#import "HomeViewController.h"
#import "SearchViedoViewController.h"

@interface VideoTableViewController ()<UIScrollViewDelegate>
{
    NSInteger _selectedBtn;
    UIView *_bottomView;
    UIScrollView *_scrollView;
    
    MBProgressHUD *_HUD;
    
}
@end

@implementation VideoTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.from isEqualToString:@"appdelete"]) {
        
    }
    
    self.title = @"视频咨询";
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    UIBarButtonItem *rightCloseDia = [[UIBarButtonItem alloc]initWithTitle:@"关诊" style:UIBarButtonItemStylePlain target:self action:@selector(onRightClose)];
    self.navigationItem.rightBarButtonItem = rightCloseDia;
    
    UIButton *btnleft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnleft.frame = CGRectMake(0, 0, 13, 22);
    [btnleft addTarget:self action:@selector(onLefyHome) forControlEvents:UIControlEventTouchUpInside];
    [btnleft setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    UIBarButtonItem *letf = [[UIBarButtonItem alloc]initWithCustomView:btnleft];
    self.navigationItem.leftBarButtonItem = letf;
    
    UIButton *btnSearchCon = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearchCon.backgroundColor = [UIColor whiteColor];
    btnSearchCon.frame = CGRectMake(23, 60+14, kWith-23*2, 30);
    [btnSearchCon setTitle:@"🔍请根据患者姓名进行搜索" forState:UIControlStateNormal];
    [btnSearchCon setTitleColor:kBoradColor forState:UIControlStateNormal];
    [btnSearchCon addTarget:self action:@selector(onSearchViedo) forControlEvents:UIControlEventTouchUpInside];
    btnSearchCon.layer.cornerRadius = 3;
    btnSearchCon.layer.masksToBounds = YES;
    [self.view addSubview:btnSearchCon];
    
    NSArray *arryHeader = [[NSArray alloc]initWithObjects:@"加号",@"待视频",@"已完成", nil];
    for (NSInteger i = 0; i<3; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(((kWith-2)/3+1)*i, btnSearchCon.frame.size.height+btnSearchCon.frame.origin.y+10, (kWith-2)/3, 43);
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:arryHeader[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1] forState:UIControlStateSelected];
        btn.tag = i+30;
        [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        if (i == 1) {
            btn.selected = YES;
            _selectedBtn = 31;
            _bottomView  = [[UIView alloc]initWithFrame:CGRectMake(btn.frame.origin.x,btn.frame.origin.y+btn.frame.size.height,btn.frame.size.width,2)];
            _bottomView.backgroundColor = [UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1];
            [self.view addSubview:_bottomView];
        }
    }
    
    _scrollView= [[UIScrollView alloc]initWithFrame:CGRectMake(0, btnSearchCon.frame.size.height+btnSearchCon.frame.origin.y+10+43+2, kWith, kHeight-btnSearchCon.frame.size.height-btnSearchCon.frame.origin.y-10-43-2)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(kWith*3, 0);
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    for (NSInteger i = 0; i<3; i++) {
        if (i == 0) {
            AddViedoViewController *add = [[AddViedoViewController alloc]init];
            add.view.frame = CGRectMake(kWith*i, 0, kWith,_scrollView.frame.size.height );
            add.xtstr = self.xtrID;
            [_scrollView addSubview:add.view];
            [self addChildViewController:add];
        }
        else if(i == 1)
        {
            ChatViedoViewController *chat = [[ChatViedoViewController alloc]init];
            chat.view.frame = CGRectMake(kWith*i, 0, kWith,_scrollView.frame.size.height );
            chat.state = @"1";
            [_scrollView addSubview:chat.view];
            [self addChildViewController:chat];
        }
        else
        {
            ChatViedoViewController *chat = [[ChatViedoViewController alloc]init];
            chat.view.frame = CGRectMake(kWith*i, 0, kWith,_scrollView.frame.size.height );
            chat.state = @"4";
            [_scrollView addSubview:chat.view];
            [self addChildViewController:chat];
        }
    }
    _scrollView.contentOffset = CGPointMake(kWith, 0);
}

#pragma mark-----按钮
-(void)onBtnClick:(UIButton *)btn{
    
    UIButton *selectedBtn = [self.view viewWithTag:_selectedBtn];
    selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn.tag;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    _bottomView.frame =CGRectMake(btn.frame.origin.x,btn.frame.origin.y+btn.frame.size.height,btn.frame.size.width,2);
    [UIView commitAnimations];
    [_scrollView setContentOffset:CGPointMake((btn.tag-30)*kWith, 0) animated:YES];
    
}

#pragma mark-----滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger select = scrollView.contentOffset.x/kWith+30;
    UIButton *selectedBtn = [self.view viewWithTag:select];
    UIButton *oldBtn= [self.view viewWithTag:_selectedBtn];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    _bottomView.frame =CGRectMake(selectedBtn.frame.origin.x,selectedBtn.frame.origin.y+selectedBtn.frame.size.height,selectedBtn.frame.size.width,2);
    [UIView commitAnimations];
    selectedBtn.selected = YES;
    oldBtn.selected = NO;
    _selectedBtn = select;
}

#pragma mark-----关诊

-(void)onRightClose{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"若您存在未完成问诊，关诊后将全部关闭，是否确定现在关诊？" preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
        
        [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/ServiceRecordClose",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {

            NSArray *arry = self.navigationController.viewControllers;
            HomeViewController *hoem = arry[0];
            [self.navigationController popToViewController:hoem animated:YES];
        } failure:^(NSError *error) {

        }];
        
    }]];
    [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alter animated:YES completion:nil];
    
}

-(void)onLefyHome{
    NSArray *arry = self.navigationController.viewControllers;
    HomeViewController *home = arry[0];
    [self.navigationController popToViewController:home animated:YES];
}

#pragma mark-------搜索
-(void)onSearchViedo{
    SearchViedoViewController*search = [[SearchViedoViewController alloc]init];

    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark-------刷新
-(void)reciveNotifyToRefresh{
    
    UIButton *btnNO2 = [self.view viewWithTag:32];
    UIButton *btnNO0 = [self.view viewWithTag:30];
    btnNO0.selected = NO;
    btnNO2.selected = NO;
    
    UIButton *selectedBtn = [self.view viewWithTag:31];
    selectedBtn.selected = YES;
    _bottomView.frame =CGRectMake(selectedBtn.frame.origin.x,selectedBtn.frame.origin.y+selectedBtn.frame.size.height,selectedBtn.frame.size.width,2);
    if (_scrollView.contentOffset.x!=kWith) {
        _scrollView.contentOffset = CGPointMake(kWith, 0);
    }

    

    
    NSArray *childArry = self.childViewControllers;
    
    ChatViedoViewController *chatViedo = childArry[1];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    [parameters setValue:@"3" forKey:@"orderType"];
    [parameters setObject:@"1" forKey:@"state"];
    [parameters setObject:@"" forKey:@"patientName"];
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetTextOrderList",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:parameters viewConroller:self success:^(id responseObject) {

        NSMutableArray *arry = [PublicTools setData:(NSArray *)responseObject];
        if (arry == nil || arry.count == 0) {
            chatViedo.noData.hidden = NO;
        }else
        {
            chatViedo.noData.hidden = YES;
        }
        chatViedo.arryViedo = [self shengXuPatientViedo:arry];
        [chatViedo.tableVIew reloadData];
    } failure:^(NSError *error) {

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--------升序
-(NSMutableArray *)shengXuPatientViedo:(NSArray *)arry{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
    
    NSMutableArray * array = [NSMutableArray arrayWithArray:[arry sortedArrayUsingComparator:^NSComparisonResult(PatientModel *modelM1, PatientModel *modelM2) {
        NSDate *date1 = [dateFormatter dateFromString:modelM1.createDate];
        NSDate *date2 = [dateFormatter dateFromString:modelM2.createDate];
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
