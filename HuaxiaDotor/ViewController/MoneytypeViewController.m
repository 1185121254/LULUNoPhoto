//
//  MoneytypeViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/13.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "MoneytypeViewController.h"
#import "MoneyTppeViewController.h"


@interface MoneytypeViewController ()<UIScrollViewDelegate>
{
    NSInteger _selectedBtn;
    UIView *_bottomView;
    UIScrollView *_scrollView;
    
}
@end

@implementation MoneytypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收入明细";
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSArray *arry = [[NSArray alloc]initWithObjects:@"图文咨询",@"电话咨询",@"视频咨询",@"加号预约", nil];
    for (NSInteger i = 0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(((kWith-3)/4+1)*i, 60, (kWith-3)/4, 50);
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:arry[i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont   fontWithName : @"Helvetica-Bold"  size : 15]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:BLUECOLOR_STYLE forState:UIControlStateSelected];
        btn.tag = i+3000;
        [btn addTarget:self action:@selector(onBtnClickMoney:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        if (i == [self.type integerValue] - 1) {
            [self creatBtn:btn Type:[self.type integerValue]];
        }
    }
    
    _scrollView= [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60+50+2, kWith, kHeight-60-50-2)];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(kWith*4, 0);
    _scrollView.contentOffset = CGPointMake(kWith*([self.type integerValue] -1), 0);
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];

    for (NSInteger i = 0; i<4; i++) {
        MoneyTppeViewController *type = [[MoneyTppeViewController alloc]init];
        type.view.frame = CGRectMake(kWith*i, 0, kWith,kHeight-60-50-2);
        if (i == 0) {
            type.type = @"1";
        }
        else if (i == 1){
            type.type = @"2";
        }
        else if (i == 2){
            type.type = @"3";
        }
        else if (i == 3){
            type.type = @"4";
        }
        [_scrollView addSubview:type.view];
        [self addChildViewController:type];
    }
}

-(void)creatBtn:(UIButton *)btn Type:(NSInteger)type{
    btn.selected = YES;
    _selectedBtn = 3000+type-1;
    _bottomView  = [[UIView alloc]initWithFrame:CGRectMake(btn.frame.origin.x,btn.frame.origin.y+btn.frame.size.height,btn.frame.size.width,2)];
    _bottomView.backgroundColor = [UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1];
    [self.view addSubview:_bottomView];
}

-(void)onBtnClickMoney:(UIButton *)btn{
    
    UIButton *selectedBtn = [self.view viewWithTag:_selectedBtn];
    selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn.tag;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    _bottomView.frame =CGRectMake(btn.frame.origin.x,btn.frame.origin.y+btn.frame.size.height,btn.frame.size.width,2);
    [UIView commitAnimations];
    
    [_scrollView setContentOffset:CGPointMake((btn.tag-3000)*kWith, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger select = scrollView.contentOffset.x/kWith+3000;
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





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
