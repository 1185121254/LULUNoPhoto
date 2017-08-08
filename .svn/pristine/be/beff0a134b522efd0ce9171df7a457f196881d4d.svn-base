//
//  GeneralViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/18.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "GeneralViewController.h"
#import "OnLineViewController.h"

@interface GeneralViewController ()

@property (nonatomic,copy)NSString *GEN;
@end

@implementation GeneralViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = kBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self.from isEqualToString:@"con"]) {
        _GEN = @"图文咨询";
    }else if ([self.from isEqualToString:@"phone"]){
        _GEN = @"电话咨询";
    }
    else if([self.from isEqualToString:@"viedo"]){
        _GEN = @"视频咨询";
    }else if ([self.from isEqualToString:@"addA"]){
        _GEN = @"加号管理";
    }
    self.title = _GEN;
    
    float y;
    if (kHeight == 480) {
        y = 10;
    }else
    {
        y = 50;
    }
    
    UIImageView *imageSign = [[UIImageView alloc]initWithFrame:CGRectMake((kWith-160)/2, 70+y,160, 160)];
    imageSign.image = [UIImage imageNamed:@"感叹号"];
    [self.view addSubview:imageSign];
    
    UILabel *lblText = [[UILabel alloc]initWithFrame:CGRectMake(10, imageSign.frame.origin.y+imageSign.frame.size.height+10, kWith - 20, 80)];
    lblText.textColor = kBoradColor;
    lblText.numberOfLines = 0;
    lblText.textAlignment = 1;
    lblText.font = [UIFont systemFontOfSize:15];
    lblText.text = [NSString stringWithFormat:@"对不起，您尚未开通%@，请到在线服务管理进行设置开通。",_GEN];
    [self.view addSubview:lblText];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, lblText.frame.origin.y+lblText.frame.size.height, kWith-40, 40);
    btn.backgroundColor = BLUECOLOR_STYLE;
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"现在开通" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btnleft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnleft.frame = CGRectMake(0, 0, 13, 22);
    [btnleft addTarget:self action:@selector(backLeft) forControlEvents:UIControlEventTouchUpInside];
    if ([self.from isEqualToString:@"眼科圈"]) {
        btnleft.hidden = YES;
    }else
    {
        btnleft.hidden = NO;
    }
    
    [btnleft setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    UIBarButtonItem *letf = [[UIBarButtonItem alloc]initWithCustomView:btnleft];
    self.navigationItem.leftBarButtonItem = letf;
}

-(void)onBtn{

    OnLineViewController *online = [[OnLineViewController alloc]init];
    [self.navigationController pushViewController:online animated:YES];

}

-(void)backLeft{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
