//
//  IsCertificateViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/28.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "IsCertificateViewController.h"
#import "KockDoctorApproveViewController.h"


@interface IsCertificateViewController ()

@end

@implementation IsCertificateViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    NSDictionary *dicLog = [kUserDefatuel objectForKey:@"DoctorDataDic"];
    if ([[dicLog objectForKey:@"state"] integerValue]==2) {
        [self.navigationController popViewControllerAnimated:NO];
    }
//13606073507
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kBackgroundColor;
    self.title = self.from;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    
    UIImageView *imageSign = [[UIImageView alloc]initWithFrame:CGRectMake((kWith-160)/2, (kHeight-290)/2,160, 160)];
    imageSign.image = [UIImage imageNamed:@"感叹号"];
    [self.view addSubview:imageSign];
    
    UILabel *lblText = [[UILabel alloc]initWithFrame:CGRectMake(10, imageSign.frame.origin.y+imageSign.frame.size.height+10, kWith - 20, 80)];
    lblText.textColor = [UIColor colorWithRed:185/255.0 green:189/255.0 blue:197/255.0 alpha:1];
    lblText.numberOfLines = 0;
    lblText.textAlignment = 1;
    lblText.font = [UIFont systemFontOfSize:16];
    lblText.text = @"您尚未完成认证，请认证后再使用该功能";
    [self.view addSubview:lblText];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, lblText.frame.origin.y+lblText.frame.size.height, kWith-40, 40);
    btn.backgroundColor = BLUECOLOR_STYLE;
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    [btn setTitle:@"现在认证" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onBTnToCertificate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    UIButton *btnleft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnleft.frame = CGRectMake(0, 0, 13, 22);
    [btnleft addTarget:self action:@selector(backLeft) forControlEvents:UIControlEventTouchUpInside];
    [btnleft setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    UIBarButtonItem *letf = [[UIBarButtonItem alloc]initWithCustomView:btnleft];
    self.navigationItem.leftBarButtonItem = letf;
    
}

-(void)backLeft{

    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)onBTnToCertificate{

    //创建新增患者界面
    UIStoryboard *storyboardName=[UIStoryboard storyboardWithName:@"PersonalStoryBoard" bundle:[NSBundle mainBundle]];
    //指定对应的故事版
    KockDoctorApproveViewController *newView=[storyboardName instantiateViewControllerWithIdentifier:@"Approvestory"];
    newView.from = self.from;
    //推送
    [self.navigationController pushViewController:newView animated:YES];
}

-(NSMutableAttributedString *)setNameTextLableSignCer:(NSString *)text{
    
    NSArray *arry = [text componentsSeparatedByString:@"\n"];
    NSString *strUnit = arry[1];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:text];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} range:[text rangeOfString:strUnit]];
    return medStr;
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
