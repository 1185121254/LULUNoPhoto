//
//  CommandToolViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/4/7.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "CommandToolViewController.h"

@interface CommandToolViewController ()

@property (weak, nonatomic) IBOutlet UIButton *eyeCheck;
@property (weak, nonatomic) IBOutlet UIButton *eyeCalculate;
@property (weak, nonatomic) IBOutlet UIButton *medicine;
@property (weak, nonatomic) IBOutlet UIButton *eyeCommandValue;
@property (weak, nonatomic) IBOutlet UIButton *eyeEnglish;
@property (weak, nonatomic) IBOutlet UIButton *crystalloid;


@end

@implementation CommandToolViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=NO;
    // Do any additional setup after loading the view.
    //导航栏标题的颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //设置按钮的边框
    [self buildingButton:self.eyeCheck];
    [self buildingButton:self.eyeCommandValue];
    [self buildingButton:self.medicine];
    [self buildingButton:self.eyeEnglish];
    [self buildingButton:self.crystalloid];
    [self buildingButton:self.eyeCalculate];
}

-(void)buildingButton:(UIButton *)button
{
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderWidth:1];
    [button.layer setBorderColor:[UIColor grayColor].CGColor];
    
}

#pragma mark - 眼科检查
- (IBAction)eyeCheck:(UIButton *)sender
{
    
}

#pragma mark - 眼科常用正常值
- (IBAction)eyeCommandValue:(UIButton *)sender
{
    
}

#pragma mark - 眼科常用药品
- (IBAction)medicine:(UIButton *)sender
{

}


#pragma mark - 眼科常用计算
- (IBAction)eyeCalculate:(UIButton *)sender
{
}

#pragma mark - 眼科常用英文
- (IBAction)eyeEnglish:(UIButton *)sender
{
    
}

#pragma mark - 人工晶体
- (IBAction)crystalloid:(UIButton *)sender
{
    
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
