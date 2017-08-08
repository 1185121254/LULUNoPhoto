//
//  WebLineViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/26.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "WebLineViewController.h"
//最新
#import "KNewSelect.h"
//我参与的
#import "KMyCare.h"
//我的会诊
#import "KMyConsultation.h"
#import "SearchViewController.h"

//#import "AddCaseViewController.h"
#import "AddNewWebViewController.h"

@interface WebLineViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *viewScrollerView;
@property (weak, nonatomic) IBOutlet UIButton *btnNew;
@property (weak, nonatomic) IBOutlet UIButton *btnMycare;
@property (weak, nonatomic) IBOutlet UIButton *btnMyconsultation;
@property (strong, nonatomic) UIView *viewNewSelect;
@property (strong, nonatomic) UIView *viewMycareSelect;
@property (strong, nonatomic) UIView *viewMyconsultationSelect;

//最新
@property (strong, nonatomic) KNewSelect *viewNew;
//我参与的
@property (strong, nonatomic) KMyCare *viewMycare;
//我的会诊
@property (strong, nonatomic) KMyConsultation *viewMyconsultation;
@end

@implementation WebLineViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = kBackgroundColor;

    UIView *ViewB = [[UIView alloc]initWithFrame:CGRectMake(0, 60, kWith, 44)];
    [self.view addSubview:ViewB];
    
    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearch.frame = CGRectMake(20, 10, kWith-40, 30);
    btnSearch.backgroundColor = [UIColor whiteColor];
    [btnSearch setTitle:@"🔍输入患者相关信息" forState:UIControlStateNormal];
    [btnSearch setTitleColor:kBoradColor forState:UIControlStateNormal];
    [btnSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    btnSearch.layer.cornerRadius = 3;
    [btnSearch addTarget:self action:@selector(onBtnSearch) forControlEvents:UIControlEventTouchUpInside];
    btnSearch.layer.masksToBounds = YES;
    [ViewB addSubview:btnSearch];
    
    _viewScrollerView.delegate = self;
    _viewScrollerView.pagingEnabled = YES;
    _viewScrollerView.contentSize = CGSizeMake(SCREEN_W*3, SCREEN_H-154);
    _viewNew = [[KNewSelect alloc]init];
    _viewNew.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H-154);
    _viewMycare = [[KMyCare alloc]init];
    _viewMycare.view.frame = CGRectMake(SCREEN_W, 0, SCREEN_W, SCREEN_H-154);
    _viewMyconsultation = [[KMyConsultation alloc]init];
    _viewMyconsultation.view.frame = CGRectMake(SCREEN_W*2, 0, SCREEN_W, SCREEN_H-154);
    
    [_viewScrollerView addSubview:_viewNew.view];
    [_viewScrollerView addSubview:_viewMycare.view];
    [_viewScrollerView addSubview:_viewMyconsultation.view];
    
    [self addChildViewController:_viewNew];
    [self addChildViewController:_viewMycare];
    [self addChildViewController:_viewMyconsultation];
    
    _viewNewSelect = [[UIView alloc]initWithFrame:CGRectMake(0, _btnNew.frame.size.height-2, SCREEN_W/3-1, 2)];
    _viewMycareSelect = [[UIView alloc]initWithFrame:CGRectMake(0, _btnMycare.frame.size.height-2, SCREEN_W/3-1, 2)];
    _viewMyconsultationSelect = [[UIView alloc]initWithFrame:CGRectMake(0, _btnMyconsultation.frame.size.height-2, SCREEN_W/3-1, 2)];
    _viewNewSelect.backgroundColor = BLUECOLOR_STYLE;
    _viewMycareSelect.backgroundColor = BLUECOLOR_STYLE;
    _viewMyconsultationSelect.backgroundColor = BLUECOLOR_STYLE;
    
    [_btnNew addSubview:_viewNewSelect];
    [_btnMycare addSubview:_viewMycareSelect];
    [_btnMyconsultation addSubview:_viewMyconsultationSelect];
    
    _viewNewSelect.hidden = NO;
    _viewMycareSelect.hidden = YES;
    _viewMyconsultationSelect.hidden = YES;
}

#pragma mark - 新增患者
- (IBAction)addPatient:(UIBarButtonItem *)sender
{
    AddNewWebViewController *addCase = [[AddNewWebViewController alloc]init];
    [self.navigationController pushViewController:addCase animated:YES];
}


#pragma mark - 互联网会诊按钮类型 最新10000 参与10002 我的10003
- (IBAction)btnActionChangeForType:(UIButton *)sender
{
    if (sender.tag==10000)
    {
        _viewNewSelect.hidden = NO;
        _viewMycareSelect.hidden = YES;
        _viewMyconsultationSelect.hidden = YES;
        [_viewScrollerView setContentOffset:CGPointMake(0,0) animated:YES];
    }
    else if(sender.tag == 10002)
    {
        _viewNewSelect.hidden = YES;
        _viewMycareSelect.hidden = NO;
        _viewMyconsultationSelect.hidden = YES;
        [_viewScrollerView setContentOffset:CGPointMake(SCREEN_W,0) animated:YES];
    }
    else if (sender.tag == 10003)
    {
        _viewNewSelect.hidden = YES;
        _viewMycareSelect.hidden = YES;
        _viewMyconsultationSelect.hidden = NO;
        [_viewScrollerView setContentOffset:CGPointMake(SCREEN_W*2,0) animated:YES];
    }
}

#pragma mark - 监听scroller目前的位置
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int viewTag = [self calculateScrollPage];
    if (viewTag==0)
    {
        _viewNewSelect.hidden = NO;
        _viewMycareSelect.hidden = YES;
        _viewMyconsultationSelect.hidden = YES;
    }
    if (viewTag==1)
    {
        _viewNewSelect.hidden = YES;
        _viewMycareSelect.hidden = NO;
        _viewMyconsultationSelect.hidden = YES;
    }
    if (viewTag==2)
    {
        _viewNewSelect.hidden = YES;
        _viewMycareSelect.hidden = YES;
        _viewMyconsultationSelect.hidden = NO;
    }
}

/**
 *  计算滚动试图在当前页面的第几页
 *
 *  @param int 当前的页面
 */
-(int)calculateScrollPage
{
    int page=floor((_viewScrollerView.contentOffset.x - SCREEN_W/3)/SCREEN_W)+1;
    return page;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)onBtnSearch
{

    SearchViewController *search =[[SearchViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];

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
