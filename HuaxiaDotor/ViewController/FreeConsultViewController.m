//
//  FreeConsultViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/17.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "FreeConsultViewController.h"
#import "FreeViewController.h"


@interface FreeConsultViewController ()<UIScrollViewDelegate>

{
    NSInteger _selectedBtn;
    UIView *_bottomViewAdd;
    UIScrollView *_scrollviewAdd;
}

@end

@implementation FreeConsultViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBackgroundColor;
    self.title = @"免费咨询";
    
    [self creatScrollViewFreeConsult];
    
    UIButton *btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRefresh.backgroundColor = BLUECOLOR_STYLE;
    btnRefresh.frame = CGRectMake(0, kHeight - 50, kWith, 50);
    btnRefresh.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnRefresh setTitle:@"刷题" forState:UIControlStateNormal];
    [btnRefresh addTarget:self action:@selector(onBtnRefresh) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRefresh];
}

-(void)creatScrollViewFreeConsult{
    NSArray *arry = [[NSArray alloc]initWithObjects:@"新咨询",@"已回复",@"已完成", nil];
    for (NSInteger i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(((kWith-2)/3+1)*i, 60, (kWith-2)/3, 50);
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:arry[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1] forState:UIControlStateSelected];
        btn.tag = i+5000;
        [btn addTarget:self action:@selector(onBtnClickFreeConsult:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        if (i == 0) {
            btn.selected = YES;
            _selectedBtn = 5000;
            _bottomViewAdd  = [[UIView alloc]initWithFrame:CGRectMake(0,btn.frame.origin.y+btn.frame.size.height,btn.frame.size.width,2)];
            _bottomViewAdd.backgroundColor = [UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1];
            [self.view addSubview:_bottomViewAdd];
        }
    }
    
    _scrollviewAdd= [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60+50+2, kWith, kHeight-60-50-2-50)];
    _scrollviewAdd.contentSize = CGSizeMake(kWith*3, 0);
    _scrollviewAdd.pagingEnabled = YES;
    _scrollviewAdd.delegate = self;
    [self.view addSubview:_scrollviewAdd];
    
    for (NSInteger i = 0; i<3; i++) {
        FreeViewController *free = [[FreeViewController alloc]init];
        free.view.frame = CGRectMake(kWith*i, 0, kWith,_scrollviewAdd.frame.size.height);
        free.state = [NSString stringWithFormat:@"%ld",i+1];
        [_scrollviewAdd addSubview:free.view];
        [self addChildViewController:free];
    }
}

-(void)onBtnClickFreeConsult:(UIButton *)btn{
    
    UIButton *selectedBtn = [self.view viewWithTag:_selectedBtn];
    selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn.tag;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    _bottomViewAdd.frame =CGRectMake(btn.frame.origin.x,btn.frame.origin.y+btn.frame.size.height,btn.frame.size.width,2);
    [UIView commitAnimations];
    
    [_scrollviewAdd setContentOffset:CGPointMake((btn.tag-5000)*kWith, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger select = scrollView.contentOffset.x/kWith+5000;
    UIButton *selectedBtn = [self.view viewWithTag:select];
    UIButton *oldBtn= [self.view viewWithTag:_selectedBtn];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    _bottomViewAdd.frame =CGRectMake(selectedBtn.frame.origin.x,selectedBtn.frame.origin.y+selectedBtn.frame.size.height,selectedBtn.frame.size.width,2);
    [UIView commitAnimations];
    selectedBtn.selected = YES;
    oldBtn.selected = NO;
    _selectedBtn = select;
}

#pragma ,ark-----------刷题

-(void)onBtnRefresh{

    NSArray *arryFree = self.childViewControllers;
    FreeViewController *freeNew = arryFree[0];
//    if (freeNew.arryData.count != 0 ) {
//        kAlter(@"有新的咨询，不能刷题");
//        return;
//    }

//    FreeViewController *freeAlready = arryFree[1];
//    for (PatientModel *patet in freeAlready.arryData) {
//        if (patet.newMessage !=0) {
//            kAlter(@"抱歉！您目前存在未读消息，请回复后再刷题。");
//            return;
//        }
//    }
    
    if (_selectedBtn !=5000) {
        UIButton *selectedBtn = [self.view viewWithTag:_selectedBtn];
        selectedBtn.selected = NO;
        UIButton *btn = [self.view viewWithTag:5000];
        btn.selected = YES;
        _selectedBtn = btn.tag;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        _bottomViewAdd.frame =CGRectMake(btn.frame.origin.x,btn.frame.origin.y+btn.frame.size.height,btn.frame.size.width,2);
        [UIView commitAnimations];
        
        [_scrollviewAdd setContentOffset:CGPointMake((btn.tag-5000)*kWith, 0) animated:YES];
    }
    NSDictionary *dicData = @{@"doctorId":[kUserDefatuel objectForKey:@"id"],@"doctorIM":kDoctorIM};

    
    NSDictionary *hearder = @{@"verifyCode":[kUserDefatuel objectForKey:@"verifyCode"]};
    
    [RequestManager getWithURLString:[NSString stringWithFormat:@"%@/api/Share/DocSelectQuestion",NET_URLSTRING] heads:hearder parameters:dicData success:^(id responseObject) {

        if ([[responseObject objectForKey:@"code"] integerValue] == 10000) {
            if (![[responseObject objectForKey:@"value"] isEqualToString:@"刷题成功"]) {
                kAlter([responseObject objectForKey:@"value"]);
            }else
            {
                NSDictionary *dic = @{@"doctorId":[kUserDefatuel objectForKey:@"id"],@"state":@"1",@"doctorIM":kDoctorIM};
                NSDictionary *dicHeader = @{@"verifyCode":[kUserDefatuel objectForKey:@"verifyCode"]};
                [RequestManager getTextOrderListURL:[NSString stringWithFormat:@"%@/api/Share/GetQuestionList",NET_URLSTRING] heads:dicHeader parameters:dic  viewConroller:self Complation:^(NSMutableArray *arry) {
                    if (arry == nil || arry.count == 0) {
                        freeNew.noData.hidden = NO;
                    }else
                    {
                        freeNew.noData.hidden = YES;
                    }
                    freeNew.arryData = arry;
                    [freeNew.freeTable reloadData];

                }Fail:^(NSError *error) {

                    kReuestFaile;
                }];
            }
        }else
        {

            kAlter(@"刷题失败");
        }
    } failure:^(NSError *error) {

        kAlter(@"刷题失败");
    }];
    
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
