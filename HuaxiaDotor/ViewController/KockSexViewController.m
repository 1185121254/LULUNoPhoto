//
//  KockSexViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/19.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "KockSexViewController.h"

@interface KockSexViewController ()
@property (strong, nonatomic) NSString *str_sex;
@property (weak, nonatomic) IBOutlet UIImageView *imageMan;
@property (weak, nonatomic) IBOutlet UIImageView *imageWoman;

@end

@implementation KockSexViewController


-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([_str_Sex isEqualToString:@"男"])
    {
        _str_sex = @"男";
        [_imageWoman setImage:[UIImage imageNamed:@"i圈"]];
        [_imageMan setImage:[UIImage imageNamed:@"i圈_h"]];
    }
    else if ([_str_Sex isEqualToString:@"女"])
    {
        _str_sex = @"女";
        [_imageWoman setImage:[UIImage imageNamed:@"i圈_h"]];
        [_imageMan setImage:[UIImage imageNamed:@"i圈"]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)btnSexAction:(UIButton *)sender
{
    if (sender.tag==20000)
    {
        _str_sex = @"女";
        [_imageWoman setImage:[UIImage imageNamed:@"i圈_h"]];
        [_imageMan setImage:[UIImage imageNamed:@"i圈"]];
    }
     if(sender.tag==10000)
    {
        _str_sex = @"男";
        [_imageWoman setImage:[UIImage imageNamed:@"i圈"]];
        [_imageMan setImage:[UIImage imageNamed:@"i圈_h"]];
    }
}

#pragma mark - 完成性别修改
- (IBAction)btnActionEnter:(UIBarButtonItem *)sender
{
    if (_str_sex==nil||_str_sex==NULL)
    {
        [showAlertView showAlertViewWithOnlyMessage:@"请选择性别"];
    }
    else
    {
        [self createSex];
    }
}

#pragma mark - 发送性别
-(void)createSex
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode;
    verifyCode=[userDefaults objectForKey:@"verifyCode"];
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *userDic=[NSMutableDictionary new];
    userDic=[userDefaults objectForKey:@"DoctorDataDic"];
    NSString *loginID;
    loginID = userDic[@"loginid"];
    [parameters setObject:loginID forKey:@"loginid"];
    [parameters setObject:_str_sex forKey:@"sex"];
    
    [RequestManager postWithURLString:DOCTORSETTINGDATAFORSELF heads:heads parameters:parameters success:^(id responseObject)
     {
         //         NSLog(@"%@",responseObject);
         NSUserDefaults *userDeaults = [NSUserDefaults standardUserDefaults];
         NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[userDeaults objectForKey:@"DoctorDataDic"]];
         if ([_str_sex isEqualToString:@"男"])
         {
             [dic setObject:[NSString stringWithFormat:@"%d",1] forKey:@"sex"];
         }
         else if ([_str_sex isEqualToString:@"女"])
         {
             [dic setObject:[NSString stringWithFormat:@"%d",0] forKey:@"sex"];
         }
         [userDeaults setObject:dic forKey:@"DoctorDataDic"];
         [[NSUserDefaults standardUserDefaults]synchronize];
         [self.navigationController popViewControllerAnimated:YES];
         [showAlertView showAlertViewWithMessage:@"设置成功"];
     } failure:^(NSError *error)
     {
         NSLog(@"错误 = %@",error);
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
