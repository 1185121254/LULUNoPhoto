//
//  PatientRepotViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/14.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "PatientRepotViewController.h"
#import "ReportTableViewController.h"
#import "SearcReportViewController.h"

@interface PatientRepotViewController ()<UIScrollViewDelegate>

{
    NSInteger _selectedBtn;
    UIScrollView *_scrollView;
    UIView *_bottomView;
}

@end

@implementation PatientRepotViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"患者报到";
    self.view.backgroundColor = kBackgroundColor;
    
    UIButton *btnSearchCon = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearchCon.backgroundColor = [UIColor whiteColor];
    btnSearchCon.frame = CGRectMake(20, 60+13, kWith-40, 30);
    [btnSearchCon setTitle:@"🔍输入患者相关信息" forState:UIControlStateNormal];
    [btnSearchCon setTitleColor:kBoradColor forState:UIControlStateNormal];
    [btnSearchCon addTarget:self action:@selector(onSearchReport) forControlEvents:UIControlEventTouchUpInside];
    btnSearchCon.layer.cornerRadius = 3;
    btnSearchCon.layer.masksToBounds = YES;
    [self.view addSubview:btnSearchCon];

    [self creatScrollView];
}

-(void)creatScrollView{
    NSArray *arry = [[NSArray alloc]initWithObjects:@"申请报到",@"已报到", nil];
    for (NSInteger i = 0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(((kWith-2)/2+1)*i, 110, (kWith-2)/2, 43);
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:arry[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1] forState:UIControlStateSelected];
        btn.tag = i+3333;
        [btn addTarget:self action:@selector(onBtnClickReport:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        if (i == 0) {
            btn.selected = YES;
            _selectedBtn = 3333;
            _bottomView  = [[UIView alloc]initWithFrame:CGRectMake(0,btn.frame.origin.y+btn.frame.size.height,btn.frame.size.width,2)];
            _bottomView.backgroundColor = [UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1];
            [self.view addSubview:_bottomView];
        }
    }
    
    _scrollView= [[UIScrollView alloc]initWithFrame:CGRectMake(0, 110+43+2, kWith, kHeight-110-43-2)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(kWith*2, 0);
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    for (NSInteger i = 0; i<2; i++) {
        ReportTableViewController *report = [[ReportTableViewController alloc]init];
        report.view.frame = CGRectMake(kWith*i, 0, kWith,_scrollView.frame.size.height);
        report.tag = 3400+i;
        report.statee = [NSString stringWithFormat:@"%ld",(long)i];
        [_scrollView addSubview:report.view];
        [self addChildViewController:report];
    }
//    [self cratDataReportUnfinish:3333];
}

-(void)onBtnClickReport:(UIButton *)btn{
    
    UIButton *selectedBtn = [self.view viewWithTag:_selectedBtn];
    selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn.tag;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    _bottomView.frame =CGRectMake(btn.frame.origin.x,btn.frame.origin.y+btn.frame.size.height,btn.frame.size.width,2);
    [UIView commitAnimations];

    [_scrollView setContentOffset:CGPointMake((btn.tag-3333)*kWith, 0) animated:YES];
    
    [self cratDataReportUnfinish:btn.tag];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger select = scrollView.contentOffset.x/kWith+3333;
    UIButton *selectedBtn = [self.view viewWithTag:select];
    UIButton *oldBtn= [self.view viewWithTag:_selectedBtn];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    _bottomView.frame =CGRectMake(selectedBtn.frame.origin.x,selectedBtn.frame.origin.y+selectedBtn.frame.size.height,selectedBtn.frame.size.width,2);
    [UIView commitAnimations];
    selectedBtn.selected = YES;
    oldBtn.selected = NO;
    _selectedBtn = select;
    
    [self cratDataReportUnfinish:select];
}

-(void)cratDataReportUnfinish:(NSInteger)selected{
    
    ReportTableViewController *report;
    NSArray *aryy = self.childViewControllers;
    for (UIViewController *vc in aryy) {
        if ([vc isKindOfClass:[ReportTableViewController class]]) {
            report = (ReportTableViewController *)vc;
            if (selected-3333 == 0 && report.tag-3400 == 0) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[kUserDefatuel objectForKey:@"id"],@"doctorId",@"0",@"visState",@"",@"patientName", nil];

                
                //未报到
                [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetPDValidateList",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
                    NSMutableArray *arry = [NSMutableArray arrayWithArray:(NSArray *)responseObject];

                    if (arry == nil || arry.count == 0) {
                        report.noData.hidden = NO;
                    }else
                    {
                        report.noData.hidden = YES;
                    }
                    report.arryData = [report shengXuPatientConReport:arry];
                    [report.tableReport reloadData];

                    
                } failure:^(NSError *error) {

                }];

            }
            if (selected-3333 == 1 && report.tag-3400 == 1) {
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[kUserDefatuel objectForKey:@"id"],@"doctorId",@"",@"patientName", nil];
         
                
                //已报到
                [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetPDFriendList",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
                    NSMutableArray *arry = [NSMutableArray arrayWithArray:(NSArray *)responseObject];

                    if (arry == nil || arry.count == 0) {
                        report.noData.hidden = NO;
                    }else
                    {
                        report.noData.hidden = YES;
                    }
                    report.arryData = [report shengXuPatientConReport:arry];
                    [report.tableReport reloadData];

                } failure:^(NSError *error) {

                }];
            }
        }
    }
}

#pragma mark-----搜索
-(void)onSearchReport{

    SearcReportViewController *sea = [[SearcReportViewController alloc]init];
    if (_selectedBtn == 3333) {
       sea.state = @"0";
    }else
    {
       sea.state = @"1";
    }
    [self.navigationController pushViewController:sea animated:YES];
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
