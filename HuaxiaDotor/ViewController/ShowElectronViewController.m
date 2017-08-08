//
//  ShowElectronViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/8/5.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ShowElectronViewController.h"

@interface ShowElectronViewController ()<UIWebViewDelegate>
{
    UIWebView *web ;
}
@end

@implementation ShowElectronViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.electronTitle;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;

    
    UIBarButtonItem *itemLeft = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(onBtnBack)];
    self.navigationItem.leftBarButtonItem = itemLeft;
    
    web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kWith, kHeight-64)];
    web.backgroundColor = kBackgroundColor;
    web.scalesPageToFit = YES;
    web.delegate  = self;
    NSURL *myDocument=[NSURL URLWithString:self.strURL];
    NSURLRequest *request=[NSURLRequest requestWithURL:myDocument];
    [web loadRequest:request];
    [self.view addSubview:web];

}

-(void)onBtnBack{
    if (web.canGoBack) {
        [web goBack];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    if ([error code] != -999) {
        kAlter(@"网络加载失败")
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
