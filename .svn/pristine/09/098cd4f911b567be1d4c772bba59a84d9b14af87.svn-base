//
//  PatientReportViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/3/21.
//  Copyright © 2016年 kock. All rights reserved.
//  患者报道

#import "PatientReportViewController.h"

@interface PatientReportViewController ()
//待接受按钮
@property (weak, nonatomic) IBOutlet UIButton *unsettledBtn;
//已添加按钮
@property (weak, nonatomic) IBOutlet UIButton *alreadyBtn;
//按钮上的指示条
@property (strong, nonatomic) UIView *btnViewSelect1,*btnViewSelect2;

@end

@implementation PatientReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=NO;
    
    //调用滚动试图
    [self createScrollerView];
    
    //调用按钮的知识器
    [self createButtonViewSelect];
}

#pragma mark - 创建滚动视图
-(void)createScrollerView
{
    UIScrollView *patientScroll =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 160, SCREEN_W, SCREEN_H-158)];
    
    patientScroll.backgroundColor=[UIColor grayColor];
    int w = patientScroll.frame.size.width;
    int h = patientScroll.frame.size.height;
    //内容区大小
    patientScroll.contentSize = CGSizeMake(w*2, h);
    
    //去掉滚动条
    patientScroll.showsHorizontalScrollIndicator=NO;
    //回弹效果
    patientScroll.bounces = NO;
    //分页显示
    patientScroll.pagingEnabled=YES;
    
    [self.view addSubview:patientScroll];
}

#pragma mark - 待接受按钮
- (IBAction)unsettledBtn:(UIButton *)sender
{
    [self.btnViewSelect1 removeFromSuperview];
    [self.unsettledBtn addSubview:self.btnViewSelect2];
}

#pragma mark - 添加按钮
- (IBAction)alreadyBtn:(UIButton *)sender
{
    [self.btnViewSelect2 removeFromSuperview];
    [self.alreadyBtn addSubview:self.btnViewSelect1];
}

/**
 *  给选择按钮添加指示器
 */
-(void)createButtonViewSelect
{
    self.btnViewSelect1=[[UIView alloc]initWithFrame:CGRectMake(0, 49,SCREEN_W/2-1, 3)];
    self.btnViewSelect1.backgroundColor=BLUECOLOR_STYLE;
    
    self.btnViewSelect2=[[UIView alloc]initWithFrame:CGRectMake(0, 49,SCREEN_W/2-1, 3)];
    self.btnViewSelect2.backgroundColor=BLUECOLOR_STYLE;
    
    //添加到按钮上
    //默认第一个
//    [self.alreadyBtn addSubview:self.btnViewSelect1];
    [self.unsettledBtn addSubview:self.btnViewSelect2];
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
