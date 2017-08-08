//
//  PhoneViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/11.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "PhoneViewController.h"
#import "ScheduleTableViewController.h"
#import "PhoneTableViewController.h"
#import "SearchPhoneViewController.h"

@interface PhoneViewController ()<UIScrollViewDelegate>
{
    NSInteger _selectedBtn;
    UIView *_bottomView;
    UIScrollView *_scrollView;
    
    

}
@end

@implementation PhoneViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"电话咨询";
    self.view.backgroundColor = kBackgroundColor;

    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(onSettingn)];
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *btnSearchCon = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearchCon.backgroundColor = [UIColor whiteColor];
    btnSearchCon.frame = CGRectMake(23, 64+10, kWith-23*2, 30);
    [btnSearchCon setTitle:@"🔍请根据患者姓名进行搜索" forState:UIControlStateNormal];
    [btnSearchCon setTitleColor:kBoradColor forState:UIControlStateNormal];
    [btnSearchCon addTarget:self action:@selector(onSearchPhone) forControlEvents:UIControlEventTouchUpInside];
    btnSearchCon.layer.cornerRadius = 3;
    btnSearchCon.layer.masksToBounds = YES;
    [self.view addSubview:btnSearchCon];

    
    NSArray *arry = [[NSArray alloc]initWithObjects:@"待通话",@"已完成", nil];
    for (NSInteger i = 0; i<2; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(((kWith-2)/2+1)*i, btnSearchCon.frame.size.height+btnSearchCon.frame.origin.y+10, (kWith-2)/2, 43);
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:arry[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1] forState:UIControlStateSelected];
        btn.tag = i+30;
        [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        if (i == 0) {
            btn.selected = YES;
            _selectedBtn = 30;
            _bottomView  = [[UIView alloc]initWithFrame:CGRectMake(0,btn.frame.origin.y+btn.frame.size.height,btn.frame.size.width,2)];
            _bottomView.backgroundColor = [UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1];
            [self.view addSubview:_bottomView];
        }
    }
    
    _scrollView= [[UIScrollView alloc]initWithFrame:CGRectMake(0, btnSearchCon.frame.size.height+btnSearchCon.frame.origin.y+10+43+2, kWith, kHeight-btnSearchCon.frame.size.height-btnSearchCon.frame.origin.y-10-43-2)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(kWith*2, 0);
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    for (NSInteger i = 0; i<2; i++) {
        PhoneTableViewController *ptone = [[PhoneTableViewController alloc]init];
        ptone.view.frame = CGRectMake(kWith*i, 0, kWith,_scrollView.frame.size.height );
        if (i == 0) {
            ptone.state = @"1";
            [_scrollView addSubview:ptone.view];
            [self addChildViewController:ptone];
        }
        else if (i == 1){
            ptone.state = @"4";
            [_scrollView addSubview:ptone.view];
            [self addChildViewController:ptone];
        }

    }
}


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
#pragma mark_------设置排班
-(void)onSettingn{
    ScheduleTableViewController *shed = [[ScheduleTableViewController alloc]init];
    [self.navigationController pushViewController:shed animated:YES];
}

#pragma mark--------刷新列表
-(void)recivrNotifyRefreshPhone{
    UIButton *btnNO1 = [self.view viewWithTag:31];
    btnNO1.selected = NO;
    
    UIButton *selectedBtn = [self.view viewWithTag:30];
    selectedBtn.selected = YES;
    _bottomView.frame =CGRectMake(selectedBtn.frame.origin.x,selectedBtn.frame.origin.y+selectedBtn.frame.size.height,selectedBtn.frame.size.width,2);
    if (_scrollView.contentOffset.x != 0) {
        _scrollView.contentOffset = CGPointMake(0, 0);
    }


    
    NSArray *childArry = self.childViewControllers;
    
    PhoneTableViewController *chatPhone = childArry[0];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    [parameters setValue:@"2" forKey:@"orderType"];
    [parameters setObject:@"1" forKey:@"state"];
    [parameters setObject:@"" forKey:@"patientName"];
    
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetTextOrderList",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:parameters viewConroller:self success:^(id responseObject) {
        
        NSMutableArray *arry = [PublicTools setData:(NSArray *)responseObject];

        if (arry == nil || arry.count == 0) {
            chatPhone.noData.hidden = NO;
        }else
        {
            chatPhone.noData.hidden = YES;
        }
        chatPhone.arryPatient = [chatPhone shengXuPatientConPhone:arry];
        [chatPhone.tableVIew reloadData];
        
    } failure:^(NSError *error) {

    }];
}

#pragma mark_------搜索
-(void)onSearchPhone{
    SearchPhoneViewController*search = [[SearchPhoneViewController alloc]init];

    [self.navigationController pushViewController:search animated:YES];
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
