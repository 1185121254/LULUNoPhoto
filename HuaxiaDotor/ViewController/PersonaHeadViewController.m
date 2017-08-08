//
//  PersonaHeadViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/17.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "PersonaHeadViewController.h"
#import "PersonalInfoDataViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface PersonaHeadViewController ()
{

}
@property (weak, nonatomic) IBOutlet UIButton *btn_head;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
//收入
@property (weak, nonatomic) IBOutlet UILabel *lbl_income;
//余额
@property (weak, nonatomic) IBOutlet UILabel *lbl_balance;

@property (strong, nonatomic) NSMutableDictionary *userDic;

@end

@implementation PersonaHeadViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden  = NO;
    [self.view endEditing:YES];
    //从userdefault中回去用户数据
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取登录医生数据字典
    _userDic = [[NSMutableDictionary alloc]init];
    _userDic=[NSMutableDictionary new];
    _userDic=[userDefaults objectForKey:@"DoctorDataDic"];
    
    _lbl_name.text = _userDic[@"userName"];
    
    NSString *imageURl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,_userDic[@"picFileName"]];
    imageURl = [imageURl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [_btn_head sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageURl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"默认婷婷"]];
    _btn_head.layer.cornerRadius=_btn_head.frame.size.height/2;
    [_btn_head.layer setMasksToBounds:YES];
    

    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetEarnings",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
        NSDictionary *dicData = (NSDictionary *)responseObject;

        NSString *sum;
        if ([dicData objectForKey:@"walletSum"] == nil) {
            sum = @"0.00";
        }else
        {
            sum = [NSString stringWithFormat:@"%.2f",[[dicData objectForKey:@"walletSum"] floatValue]];
        }
        NSString *earnning;
        if ([dicData objectForKey:@"monthlyEarnnings"] == nil) {
            earnning = @"0.00";
        }else{
            earnning = [NSString stringWithFormat:@"%.2f",[[dicData objectForKey:@"monthlyEarnnings"] floatValue]];
        }
        _lbl_balance.text = sum;
        _lbl_income.text = earnning;
    } failure:^(NSError *error) {

    }];

}

-(CGFloat)setTotalMonthPer:(NSArray *)arry{
    CGFloat total = 0;;
    for (NSDictionary *dic in arry) {
        total = total + [[dic objectForKey:@"orderAmount"] floatValue];
    }
    return total;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    [_bottomView.layer insertSublayer:[NSString shadowAsInverseCGRect:CGRectMake(0, 0, kWith, 244) EndColor:[UIColor colorWithRed:72/255.0 green:207/255.0 blue:176/255.0 alpha:1]] atIndex:0];
    
    self.YuEView.backgroundColor = [UIColor colorWithRed:78/255.0 green:172/255.0 blue:157/255.0 alpha:0.5];
    self.NowMothView.backgroundColor = [UIColor colorWithRed:78/255.0 green:172/255.0 blue:157/255.0 alpha:0.5];
    
}

#pragma mark - 个人信息页面
- (IBAction)btnHeadAction:(UIButton *)sender
{
    //创建新增患者界面
    UIStoryboard *PersonalStoryBoard=[UIStoryboard storyboardWithName:@"PersonalStoryBoard" bundle:[NSBundle mainBundle]];
    //指定对应的故事版
    PersonalInfoDataViewController *perView=[PersonalStoryBoard instantiateViewControllerWithIdentifier:@"personalDataStroryboard"];
    //推送
    [self.navigationController pushViewController:perView animated:YES];
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
