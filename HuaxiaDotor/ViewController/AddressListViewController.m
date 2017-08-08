//
//  AddressListViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/15.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressTableViewController.h"
#import "AddTestSearchViewController.h"

@interface AddressListViewController ()
{
    UIView *_bottomViewAdd;
    UIScrollView *_scrollviewAdd;
    NSInteger _selectedBtn;
}
@end

@implementation AddressListViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kBackgroundColor;
    self.title = @"通讯录";

    UIButton *btnSearchCon = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearchCon.backgroundColor = [UIColor whiteColor];
    btnSearchCon.frame = CGRectMake(20, 64+10, kWith-40, 30);
    [btnSearchCon setTitle:@"🔍输入患者相关信息" forState:UIControlStateNormal];
    [btnSearchCon setTitleColor:kBoradColor forState:UIControlStateNormal];
    [btnSearchCon addTarget:self action:@selector(onSearchAddress) forControlEvents:UIControlEventTouchUpInside];
    btnSearchCon.layer.cornerRadius = 3;
    btnSearchCon.layer.masksToBounds = YES;
    [self.view addSubview:btnSearchCon];
    
    [self creatScrollViewAddress];

}

-(void)creatScrollViewAddress{
    NSArray *arry = [[NSArray alloc]initWithObjects:@"我的好友",@"我的医院", nil];
    for (NSInteger i = 0; i<2; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(((kWith-2)/2+1)*i, 110, (kWith-2)/2, 43);
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:arry[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1] forState:UIControlStateSelected];
        btn.tag = i+4000;
        [btn addTarget:self action:@selector(onBtnClickAddress:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        if (i == 0) {
            btn.selected = YES;
            _selectedBtn = 4000;
            _bottomViewAdd  = [[UIView alloc]initWithFrame:CGRectMake(0,btn.frame.origin.y+btn.frame.size.height,btn.frame.size.width,2)];
            _bottomViewAdd.backgroundColor = [UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1];
            [self.view addSubview:_bottomViewAdd];
        }
    }
    
    _scrollviewAdd= [[UIScrollView alloc]initWithFrame:CGRectMake(0, 110+43+2, kWith, kHeight-110-43-2)];
    _scrollviewAdd.contentSize = CGSizeMake(kWith*2, 0);
    _scrollviewAdd.pagingEnabled = YES;
    _scrollviewAdd.scrollEnabled = NO;
    [self.view addSubview:_scrollviewAdd];
    
    for (NSInteger i = 0; i<2; i++) {
        AddressTableViewController *address = [[AddressTableViewController alloc]init];
        address.view.frame = CGRectMake(kWith*i, 0, kWith,_scrollviewAdd.frame.size.height);
        address.state = [NSString stringWithFormat:@"%ld",i];
        [_scrollviewAdd addSubview:address.view];
        [self addChildViewController:address];
    }
}

-(void)onBtnClickAddress:(UIButton *)btn{
    
    UIButton *selectedBtn = [self.view viewWithTag:_selectedBtn];
    selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn.tag;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    _bottomViewAdd.frame =CGRectMake(btn.frame.origin.x,btn.frame.origin.y+btn.frame.size.height,btn.frame.size.width,2);
    [UIView commitAnimations];
    
    [_scrollviewAdd setContentOffset:CGPointMake((btn.tag-4000)*kWith, 0) animated:YES];
}

-(void)onSearchAddress{
    AddTestSearchViewController *search = [[AddTestSearchViewController alloc]init];
    search.from = @"old";
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
