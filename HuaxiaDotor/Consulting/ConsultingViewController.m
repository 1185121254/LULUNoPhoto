//
//  ConsultingViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/3.
//  Copyright © 2016年 kock. All rights reserved.
//图文咨询

#import "ConsultingViewController.h"
#import "Patient.h"
#import "RequestManager.h"

#define kWith [UIApplication sharedApplication].keyWindow.bounds.size.width
#define kHeight [UIApplication sharedApplication].keyWindow.bounds.size.height


@interface ConsultingViewController ()
{
    NSMutableArray *_arryNewUser;
    NSInteger _selectedBtn;
    UIView *_bottomView;
}
@end

@implementation ConsultingViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.title = @"图文咨询";
    _arryNewUser = [[NSMutableArray alloc]init];
    
    
    UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(23, 60+17, kWith-17*2, 30)];
    text.placeholder = @"🔍输入患者相关信息";
    text.borderStyle = UITextBorderStyleRoundedRect;
    text.textAlignment = 1;
    [self.view addSubview:text];
    
    NSArray *arry = [[NSArray alloc]initWithObjects:@"新患者",@"已回复",@"完成咨询", nil];
    for (NSInteger i = 0; i<3; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(((kWith-2)/3+1)*i, text.frame.size.height+text.frame.origin.y+17, (kWith-2)/3, 43);
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:arry[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1] forState:UIControlStateSelected];
        btn.tag = i+30;
        [btn addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        if (i == 0) {
            btn.selected = YES;
            _selectedBtn = 30;
            _bottomView  = [[UIView alloc]initWithFrame:CGRectMake(0,43-2.5,btn.frame.size.width,2.5)];
            _bottomView.backgroundColor = [UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1];
            [self.view addSubview:_bottomView];
        }
    }
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, text.frame.size.height+text.frame.origin.y+17+43+2, kWith, kHeight-text.frame.size.height-text.frame.origin.y-17-43-2)];
    scrollView.backgroundColor = [UIColor greenColor];
    
    for (NSInteger i = 0; i<3; i++) {
        Patient *pati = [[Patient alloc]init];
        
        
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        //获取用户秘钥
        NSString *verifyCode=[userDefaults objectForKey:@"verifyCode"];
        NSString *doctorID = [userDefaults objectForKey:@"id"];
        //HEAD
        NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
        
        //BODY
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        
        [parameters setObject:doctorID forKey:@"doctorId"];
        [parameters setValue:@"1" forKey:@"state"];
        [parameters setValue:@"1" forKey:@"orderType"];

        
        switch (i) {
            case 0:
            {
                [RequestManager getTextOrderListURL:[NSString stringWithFormat:@"%@/api/Share/GetTextOrderList",NET_URLSTRING] heads:heads parameters:parameters Complation:^(NSMutableArray *arry) {
                    
                }];
            }
                break;
            case 1:
            {
                
            }
                break;
            case 2:
            {
                
            }
                break;
            default:
                break;
        }
        pati.view.frame = scrollView.frame;
        [self.view addSubview:pati.view];
        [self addChildViewController:pati];
        
    }
    
    
    
    
    [self.view addSubview:scrollView];
    
    
    

}

-(void)onBtnClick:(UIButton *)btn{

    UIButton *selectedBtn = [self.view viewWithTag:_selectedBtn];
    selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn.tag;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    _bottomView.frame =CGRectMake(btn.frame.origin.x,43-2.5,btn.frame.size.width,2.5);
    [UIView commitAnimations];
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

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
