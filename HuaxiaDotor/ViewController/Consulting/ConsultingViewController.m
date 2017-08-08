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
#import "PatientModel.h"
#import "SearchPublishViewController.h"


@interface ConsultingViewController ()<UIScrollViewDelegate>
{
    NSInteger _selectedBtn;
    UIView *_bottomView;
    UIScrollView *_scrollView;
    
}
@property (nonatomic,strong) NSMutableArray *dataSourse;
@end

@implementation ConsultingViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.view.backgroundColor = kBackgroundColor;
    self.title = @"图文咨询";
    
    UIButton *btnSearchCon       = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearchCon.backgroundColor = [UIColor whiteColor];
    btnSearchCon.frame           = CGRectMake(23, 60+14, kWith-23*2, 30);
    [btnSearchCon setTitle:@"🔍请根据患者姓名进行搜索" forState:UIControlStateNormal];
    [btnSearchCon setTitleColor:kBoradColor forState:UIControlStateNormal];
    [btnSearchCon addTarget:self action:@selector(onSearchCon) forControlEvents:UIControlEventTouchUpInside];
    btnSearchCon.layer.cornerRadius = 3;
    btnSearchCon.layer.masksToBounds = YES;
    [self.view addSubview:btnSearchCon];
    
    NSArray *arry = [[NSArray alloc]initWithObjects:@"新患者",@"已回复",@"已完成", nil];
    for (NSInteger i = 0; i<3; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(((kWith-2)/3+1)*i, btnSearchCon.frame.size.height+btnSearchCon.frame.origin.y+10, (kWith-2)/3, 43);
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
            _bottomView  = [[UIView alloc]initWithFrame:CGRectMake(0,btn.frame.origin.y+btn.frame.size.height,btn.frame.size.width,2)];
            _bottomView.backgroundColor = [UIColor colorWithRed:59/255.0 green:174/255.0 blue:218/255.0 alpha:1];
            [self.view addSubview:_bottomView];
        }
    }
    
    _scrollView               = [[UIScrollView alloc]initWithFrame:CGRectMake(0, btnSearchCon.frame.size.height+btnSearchCon.frame.origin.y+10+43+2, kWith, kHeight-btnSearchCon.frame.size.height-btnSearchCon.frame.origin.y-10-43-2)];
    _scrollView.delegate      = self;
    _scrollView.contentSize   = CGSizeMake(kWith*3, 0);
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];

    for (NSInteger i = 0; i<3; i++) {
        Patient *pati = [[Patient alloc]init];
        pati.view.frame = CGRectMake(kWith*i, 0, kWith,_scrollView.frame.size.height );
        if (i == 0) {
            //新患者
            pati.state = @"1";
        }
        else if (i == 1){
            //已回复
            pati.state = @"5";
        }
        else if (i == 2){
            //已完成
            pati.state = @"4";
        }
        [_scrollView addSubview:pati.view];
        [self addChildViewController:pati];
    }
}

-(void)onBtnClick:(UIButton *)btn{
    
    UIButton *selectedBtn = [self.view viewWithTag:_selectedBtn];
    selectedBtn.selected  = NO;
    btn.selected          = YES;
    _selectedBtn = btn.tag;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    _bottomView.frame =CGRectMake(btn.frame.origin.x,btn.frame.origin.y+btn.frame.size.height,btn.frame.size.width,2);
    [UIView commitAnimations];
    
    [_scrollView setContentOffset:CGPointMake((btn.tag-30)*kWith, 0) animated:YES];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger select = scrollView.contentOffset.x/kWith+30;
    UIButton *selectedBtn = [self.view viewWithTag:select];
    UIButton *oldBtn= [self.view viewWithTag:_selectedBtn];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    _bottomView.frame =CGRectMake(selectedBtn.frame.origin.x,selectedBtn.frame.origin.y+selectedBtn.frame.size.height,selectedBtn.frame.size.width,2);
    [UIView commitAnimations];
    selectedBtn.selected = YES;
    oldBtn.selected = NO;
    _selectedBtn = select;
}

#pragma mark-------刷新
-(void)reciveNotifyToRefreshConsult{
    
    UIButton *btnNO1 = [self.view viewWithTag:31];
    btnNO1.selected = NO;
    UIButton *btnNO2 = [self.view viewWithTag:32];
    btnNO2.selected = NO;
    
    UIButton *selectedBtn = [self.view viewWithTag:30];
    selectedBtn.selected = YES;
    _bottomView.frame =CGRectMake(selectedBtn.frame.origin.x,selectedBtn.frame.origin.y+selectedBtn.frame.size.height,selectedBtn.frame.size.width,2);
    if (_scrollView.contentOffset.x != 0) {
        _scrollView.contentOffset = CGPointMake(0, 0);
    }
    

    
    NSArray *childArry = self.childViewControllers;
    
    Patient *chatpatient = childArry[0];
    
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:[kUserDefatuel objectForKey:@"verifyCode"]};
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    [parameters setValue:@"1" forKey:@"orderType"];
    [parameters setObject:@"1" forKey:@"state"];
    [parameters setObject:@"" forKey:@"patientName"];
    
    [RequestManager getTextOrderListURL:[NSString stringWithFormat:@"%@/api/Share/GetTextOrderList",NET_URLSTRING] heads:heads parameters:parameters viewConroller:self Complation:^(NSMutableArray *arry) {

        if (arry == nil || arry.count == 0) {
            chatpatient.noData.hidden = NO;
        }else
        {
            chatpatient.noData.hidden = YES;
        }
        chatpatient.arryPatient = [NSString shengXuPatientConC:arry];
        [chatpatient.tableVIew reloadData];
    }Fail:^(NSError *error) {

        kReuestFaile;
    }];
}

-(void)dealloc
{

}
//#pragma mark-------未读消息变已读
//
//-(void)mesUnRead:(PatientModel *)patient State:(NSString *)state{
//
//    if ([state integerValue] != 4) {
//        NSMutableDictionary *Dic =[[NSMutableDictionary alloc]init];
//        [Dic setValue:patient.Id forKey:@"orderId"];
//        [Dic setObject:patient.patientIM forKey:@"fromAccount"];
//        [Dic setObject:kDoctorIM forKey:@"toAccount"];
//        [RequestManager CloseOnLine:[NSString stringWithFormat:@"%@/api/Share/SetMessageIsRead",NET_URLSTRING] Parameters:Dic Complation:^(NSNumber *code) {
//            if ([code integerValue] == 10000) {
//                NSLog(@"已读");
//            }
//        } Fail:^(NSError *error) {
//            
//        }];
//    }
//}
//
#pragma mark----------搜索
-(void)onSearchCon{
    
    SearchPublishViewController*search = [[SearchPublishViewController alloc]init];

    [self.navigationController pushViewController:search animated:YES];
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