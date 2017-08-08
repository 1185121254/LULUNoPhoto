//
//  HomeView.m
//  dawnEye
//
//  Created by KockPeter on 16/3/8.
//  Copyright © 2016年 kockPeter. All rights reserved.
//  

#import "HomeView.h"
//站内消息
#import "MassageTableViewController.h"

//病例讨论
#import "CaseDiscussViewController.h"

@implementation HomeView

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.view endEditing:YES];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
   
    //获取已添加页面的数据
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取登录医生数据字典
    NSMutableDictionary *userDic=[NSMutableDictionary new];
    
    userDic=[userDefaults objectForKey:@"DoctorDataDic"];
    
    //头像
    NSString *headUrl=userDic[@"picFileName"];
    headUrl=[NSString stringWithFormat:@"%@%@",NET_URLSTRING,headUrl];
    NSString *strUrl=[headUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"默认婷婷"]];
    
    self.headImage.layer.masksToBounds=YES;
    self.headImage.layer.cornerRadius=self.headImage.frame.size.height/2;
    
    //名字
    self.doctorName.text= userDic[@"userName"];
    NSDictionary *dic = [kUserDefatuel objectForKey:@"DoctorDataDic"];
    if (dic != nil) {
        if ([[dic objectForKey:@"state"] integerValue] == 0) {
            _lblCertification.text = @"未认证";
            _imageViewCertification.image = [UIImage imageNamed:@"认证v"];
        }else if ([[dic objectForKey:@"state"] integerValue] == 1){
            _lblCertification.text = @"认证中";
            _imageViewCertification.image = [UIImage imageNamed:@"认证v"];
        }else if ([[dic objectForKey:@"state"] integerValue] == 2){
            _lblCertification.text = @"已认证";
            _imageViewCertification.image = [UIImage imageNamed:@"V-金属"];
        }
        //患者总量
        self.Totol.text = [dic objectForKey:@"totalAppointment"];
        self.todayTotol.text = [dic objectForKey:@"appointment"];
    }
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _readNum.userInteractionEnabled = YES;
    _readNum.layer.cornerRadius = 8;
    _readNum.layer.masksToBounds = YES;

}

- (IBAction)btnMsgZhan:(id)sender {
    
    //创建新增患者界面
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"PersonalStoryBoard" bundle:[NSBundle mainBundle]];
    //指定对应的故事版
    MassageTableViewController *massageTable=[storyboard instantiateViewControllerWithIdentifier:@"MassageTableView"];
    //推送
    [self.navigationController pushViewController:massageTable animated:YES];
}


@end

