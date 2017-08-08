//
//  EyeCircleViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/3/14.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "EyeCircleViewController.h"
#import "KKCaseController.h"
#import "KTalkController.h"
#import "SelectCityViewController.h"
#import "PublishNewCaseViewController.h"
#import "PhotographyViewController.h"

#import "sendCase.h"
//#import "SendCaseViewController.h"
#import "sendTalk.h"
//#import "sendTalkViewController.h"
#import "MJRefresh.h"
//#import "FriendsListViewController.h"

@interface EyeCircleViewController ()<UIScrollViewDelegate,UINavigationControllerDelegate>

//病例和话题试图和摄影大赛
@property (strong, nonatomic) KKCaseController *caseTableview;
@property (strong, nonatomic) KTalkController *talkTableview;
@property (strong, nonatomic) PhotographyViewController *photoGraphyView;
//滚动试图
@property (strong, nonatomic) UIScrollView *circleScroller;
//区别不同view的tag值
@property (assign, nonatomic)  int viewTag;
//病例按钮
@property (weak, nonatomic) IBOutlet UIButton *btnCase;
//话题按钮
@property (weak, nonatomic) IBOutlet UIButton *gambit;
@property (weak, nonatomic) IBOutlet UIButton *photoGraphy;
//选择指示条
@property (strong, nonatomic) UIView *caseSelectViewSelect;
@property (strong, nonatomic) UIView *gambitViewSelect;
@property (strong, nonatomic) UIView *photoViewSelect;

@property (strong, nonatomic) UITableView *caseTableView;
//病例资料数组
@property (strong, nonatomic) NSMutableArray *caseArrData;
//病例页数
@property (assign, nonatomic) int casePage;
//病例行数
@property (assign, nonatomic) int caseRows;

@property (strong, nonatomic) UITableView *talkTableView;
//话题资料数组
@property (strong, nonatomic) NSMutableArray *talkArrData;
//话题页数
@property (assign, nonatomic) int talkPage;
//话题行数
@property (assign, nonatomic) int talkRows;

//上提刷新数据数组
@property (strong, nonatomic) NSMutableArray *upDataArr;

//页码数
@property (assign, nonatomic) int PageCount;

//设置用户VerifyCode
@property (strong, nonatomic)NSString *verifyCode;

//设置表格的topid数组
@property (strong, nonatomic) NSMutableArray *topIdArr;

@property (nonatomic, strong) UIButton *rightItem;
@end

@implementation EyeCircleViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
       [self.view endEditing:YES];
    //显示导航栏
    self.navigationController.navigationBar.hidden=NO;
    self.tabBarController.tabBar.hidden  = NO;
    self.caseArrData=[[NSMutableArray alloc]init];
    self.talkArrData=[[NSMutableArray alloc]init];
    self.topIdArr=[[NSMutableArray alloc]init];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeCity:) name:@"ChangCityPhoto" object:nil];
    
    [self setNav];
    
    //scroller初始化设置
    self.circleScroller = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 117, SCREEN_W, kHeight-117-49)];
    self.circleScroller.delegate = self;
    self.circleScroller.contentSize=CGSizeMake(SCREEN_W*2, kHeight-117-49);
    self.circleScroller.pagingEnabled=YES;
    [self.view addSubview:self.circleScroller];
    self.circleScroller.bounces=NO;
    self.circleScroller.showsHorizontalScrollIndicator=NO;
    self.circleScroller.showsVerticalScrollIndicator=NO;
    
    //创建摄影大赛tableview
    //_photoGraphyView = [[PhotographyViewController alloc]init];
    //_photoGraphyView.view.frame = CGRectMake(0, 5, kWith, SCREEN_H-64-self.photoGraphy.frame.size.height-27-49);
    //[_circleScroller addSubview:_photoGraphyView.view];
    //[self addChildViewController:_photoGraphyView];
    
    //创建病例tableview
    _caseTableview = [[KKCaseController alloc]init];
    _caseTableview.view.frame = CGRectMake(0, 32, kWith, SCREEN_H-64-self.btnCase.frame.size.height-32-49);
    [_circleScroller addSubview:_caseTableview.view];
    [self addChildViewController:_caseTableview];
    
    //话题tableview
    _talkTableview = [[KTalkController alloc]init];
    _talkTableview.view.frame = CGRectMake(kWith*1, 32, kWith, SCREEN_H-64-self.btnCase.frame.size.height-32-49);
    [_circleScroller addSubview:_talkTableview.view];
    [self addChildViewController:_talkTableview];
    
    //病历和话题的背景色
//    self.view.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
    //导航栏标题的颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //scroller上的view试图
    //发布按钮
    [self creatSendButton];
    
    self.PageCount = 1;
}

-(void)setNav{
    
    //_rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    //_rightItem.frame = CGRectMake(0, 0, 50, 40);
    //_rightItem.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    //[_rightItem setTitle:@"全国" forState:UIControlStateNormal];
    //[_rightItem setTintColor:[UIColor whiteColor]];
    //[_rightItem addTarget:self action:@selector(onSelectedCity) forControlEvents:UIControlEventTouchUpInside];
    //UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_rightItem];
    //self.navigationItem.rightBarButtonItem = item;;
}

-(void)onSelectedCity{
    SelectCityViewController *sel = [[SelectCityViewController alloc]init];
    sel.from = @"SearchCityPhoto";
    [self.navigationController pushViewController:sel animated:YES];
}

#pragma mark------选择城市

-(void)onChangeCity:(NSNotification *)notify{
    
    NSDictionary *dic = notify.object;
    if (dic) {
        [_rightItem setTitle:dic[@"city"] forState:UIControlStateNormal];
    }
}


#pragma mark - 发布按钮
-(void)creatSendButton
{
    //选择指示条
    self.caseSelectViewSelect=[[UIView alloc]initWithFrame:CGRectMake(0, self.btnCase.frame.size.height-2, (kWith-2)/2, 2)];
    self.gambitViewSelect=[[UIView alloc]initWithFrame:CGRectMake(0, self.gambit.frame.size.height-2, (kWith-2)/2, 2)];
    //self.photoViewSelect=[[UIView alloc]initWithFrame:CGRectMake(0, self.photoGraphy.frame.size.height-2, (kWith-4)/3, 2)];

    self.caseSelectViewSelect.backgroundColor=BLUECOLOR_STYLE;
    self.gambitViewSelect.backgroundColor=BLUECOLOR_STYLE;
    //self.photoViewSelect.backgroundColor = BLUECOLOR_STYLE;
    //[self.photoGraphy addSubview:self.photoViewSelect];
    [self.btnCase addSubview:self.caseSelectViewSelect];
    [self.gambit addSubview:self.gambitViewSelect];
    
    //选择器默认状态
    self.caseSelectViewSelect.hidden=NO;
    self.gambitViewSelect.hidden=YES;
    //self.photoViewSelect.hidden = NO;
    //[self.photoGraphy setTitleColor:BLUECOLOR_STYLE forState:UIControlStateNormal];
    
    //发布病例按钮
    sendCase *sendView1=[[[NSBundle mainBundle]loadNibNamed:@"sendCase" owner:self options:nil] lastObject];
    [sendView1 setSendTitle:@"发布病例"];
    sendView1.backgroundColor=[UIColor colorWithWhite:0.000 alpha:0.052];
    sendView1.frame=CGRectMake(0, 0, SCREEN_W, sendView1.frame.size.height);
    [sendView1.sendViewButton addTarget:self action:@selector(sendCase:) forControlEvents:UIControlEventTouchUpInside];
    [self.circleScroller addSubview:sendView1];
    
    //发布话题按钮
    sendCase *sendViwe2=[[[NSBundle mainBundle]loadNibNamed:@"sendCase" owner:self options:nil] lastObject];
    [sendViwe2 setSendTitle:@"发布话题"];
    sendViwe2.backgroundColor=[UIColor colorWithWhite:0.000 alpha:0.049];
    sendViwe2.frame=CGRectMake(SCREEN_W*1, 0, SCREEN_W, sendViwe2.frame.size.height);
    [sendViwe2.sendViewButton addTarget:self action:@selector(sendTalk:) forControlEvents:UIControlEventTouchUpInside];
    [self.circleScroller addSubview:sendViwe2];
}

#pragma mark - 发布病例动作
-(void)sendCase:(UIButton *)sender
{
    NSDictionary *dicLog = [kUserDefatuel objectForKey:@"DoctorDataDic"];
    if ([[dicLog objectForKey:@"state"] integerValue]==2) {
        PublishNewCaseViewController *view=[[PublishNewCaseViewController alloc]init];
        view.title = @"发布病例";
        view.from = @"1";
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }else
    {
        IsCertificateViewController *isCer = [[IsCertificateViewController alloc]init];
        isCer.from = @"眼科圈";
        [self.navigationController pushViewController:isCer animated:YES];
    }
}

#pragma mark - 发布话题动作
-(void)sendTalk:(UIButton *)sender
{
    NSDictionary *dicLog = [kUserDefatuel objectForKey:@"DoctorDataDic"];
    if ([[dicLog objectForKey:@"state"] integerValue]==2) {
        PublishNewCaseViewController *view=[[PublishNewCaseViewController alloc]init];
        view.title = @"发布话题";
        view.from = @"2";
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }else
    {
        IsCertificateViewController *isCer = [[IsCertificateViewController alloc]init];
        isCer.from = @"眼科圈";
        [self.navigationController pushViewController:isCer animated:YES];
    }
}

#pragma mark - 监听scroller目前的位置
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int viewTag = [self calculateScrollPage];
    if (viewTag==1)
    {
        //self.caseSelectViewSelect.hidden=NO;
        //self.gambitViewSelect.hidden=YES;
        //self.photoViewSelect.hidden = YES;
        //_rightItem.hidden = YES;
        
        //[self.btnCase setTitleColor:BLUECOLOR_STYLE forState:UIControlStateNormal];
        //[self.gambit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[self.photoGraphy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        _rightItem.hidden = YES;
        self.gambitViewSelect.hidden=NO;
        self.caseSelectViewSelect.hidden=YES;
        //self.photoViewSelect.hidden = YES;
        
        
        [self.btnCase setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.gambit setTitleColor:BLUECOLOR_STYLE forState:UIControlStateNormal];
        //[self.photoGraphy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else if (viewTag==2)
    {
        _rightItem.hidden = YES;
        self.gambitViewSelect.hidden=NO;
        self.caseSelectViewSelect.hidden=YES;
        //self.photoViewSelect.hidden = YES;

        
        [self.btnCase setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.gambit setTitleColor:BLUECOLOR_STYLE forState:UIControlStateNormal];
        //[self.photoGraphy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    }else if (viewTag==0)
    {
        //_rightItem.hidden = NO;
        
        //self.gambitViewSelect.hidden=YES;
        //self.caseSelectViewSelect.hidden=YES;
        //self.photoViewSelect.hidden = NO;
        
        //[self.btnCase setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[self.photoGraphy setTitleColor:BLUECOLOR_STYLE forState:UIControlStateNormal];
        //[self.gambit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        self.caseSelectViewSelect.hidden=NO;
        self.gambitViewSelect.hidden=YES;
        //self.photoViewSelect.hidden = YES;
        _rightItem.hidden = YES;
        
        [self.btnCase setTitleColor:BLUECOLOR_STYLE forState:UIControlStateNormal];
        [self.gambit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //[self.photoGraphy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

#pragma mark - 病例按钮
- (IBAction)btnCase:(UIButton *)sender
{
    _rightItem.hidden = YES;
    [self.circleScroller setContentOffset:CGPointMake(0,0) animated:YES];
    [self.btnCase setTitleColor:BLUECOLOR_STYLE forState:UIControlStateNormal];
    [self.gambit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   // [self.photoGraphy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    self.caseSelectViewSelect.hidden=NO;
    self.gambitViewSelect.hidden=YES;
    //self.photoViewSelect.hidden=YES;
    
    [self.caseTableView.mj_header beginRefreshing];
}

#pragma mark - 话题按钮
- (IBAction)btnGambit:(UIButton *)sender
{
    _rightItem.hidden = YES;
    
    [self.circleScroller setContentOffset:CGPointMake(SCREEN_W*1, 0) animated:YES];
    [self.btnCase setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.gambit setTitleColor:BLUECOLOR_STYLE forState:UIControlStateNormal];
    //[self.photoGraphy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    self.gambitViewSelect.hidden=NO;
    self.caseSelectViewSelect.hidden=YES;
    //self.photoViewSelect.hidden=YES;
    
    [self.talkTableView.mj_header beginRefreshing];
}

#pragma mark - 摄影大赛
- (IBAction)btnPhotography:(id)sender {
    _rightItem.hidden = NO;
    [self.circleScroller setContentOffset:CGPointMake(0,0) animated:YES];
    //[self.photoGraphy setTitleColor:BLUECOLOR_STYLE forState:UIControlStateNormal];
    [self.gambit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btnCase setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    self.gambitViewSelect.hidden=YES;
    //self.photoViewSelect.hidden=NO;
    self.caseSelectViewSelect.hidden=YES;
    
//    [self.caseTableView.mj_header beginRefreshing];
}


/**
 *  计算滚动试图在当前页面的第几页
 *
 *  @param int 当前的页面
 */
-(int)calculateScrollPage
{
    int page=floor(self.circleScroller.contentOffset.x / SCREEN_W);
    return page;
}

- (void)didReceiveMemoryWarning
{
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