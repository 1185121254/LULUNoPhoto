//
//  WebDetailViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/21.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "WebDetailViewController.h"

@interface WebDetailViewController ()

@end

@implementation WebDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kWith, kHeight - 64)];
    web.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:web];

    UIButton *btnStore = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStore.frame = CGRectMake(0, 0, 20, 20);
    [btnStore setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [btnStore setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateSelected];
    [btnStore addTarget:self action:@selector(onStore:) forControlEvents:UIControlEventTouchUpInside];
    btnStore.selected = YES;
    UIBarButtonItem *itemstore = [[UIBarButtonItem alloc]initWithCustomView:btnStore];

    
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    btnShare.frame = CGRectMake(35, 0, 20, 20);
    [btnShare setBackgroundImage:[UIImage imageNamed:@"t-share-1"] forState:UIControlStateNormal];
    UIBarButtonItem *itemshare = [[UIBarButtonItem alloc]initWithCustomView:btnShare];
    self.navigationItem.rightBarButtonItems = @[itemshare,itemstore];
    
    
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.dicData objectForKey:@"webUrl"]]]];
    
}

-(void)onStore:(UIButton *)btn{

    
    if (btn.selected == YES) {
        NSDictionary *dic = @{@"id":[self.dicData objectForKey:@"id"]};
        [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/CollectionRemove",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
            btn.selected = NO;

        } failure:^(NSError *error) {

        }];
    }
    else
    {
        NSDictionary *dic = @{@"sourceID":[self.dicData objectForKey:@"sourceID"],@"collector":[self.dicData objectForKey:@"collector"],@"sourceType":@"1",@"title":[self.dicData objectForKey:@"title"],@"picUrl":@"",@"webUrl":[self.dicData objectForKey:@"webUrl"]};
        [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/CollectionAdd",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject, BOOL ifTimeout) {

            btn.selected = YES;

        } failure:^(NSError *error) {

        }];
    }
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
