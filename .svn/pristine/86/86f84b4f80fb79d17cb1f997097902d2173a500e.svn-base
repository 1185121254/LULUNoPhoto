//
//  SettingViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/16.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "SettingViewController.h"
#import "VideoTableViewController.h"
#import "HomeViewController.h"

#define INFO @"温馨提示:\n1.每个患者的就诊时间为15分钟,15分钟后系统会自动中断。\n2.开启视频咨询服务后,相关患者会收到开诊提醒。"

@interface SettingViewController ()<BasePickerViewDelegate>
{

    NSMutableArray *_arryPicker;
    
    UILabel *_lblCountBottom;
    UIView *_viewMid;
    UISwitch *_switc;
    
    BasePickerView *_basePickerView;
}
@end

@implementation SettingViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = kBackgroundColor;
    
    _arryPicker = [NSMutableArray array];
    for (NSInteger i = 0; i < 50; i++ ) {
        [_arryPicker addObject:[NSString stringWithFormat:@"%ld",i+1]];
    }
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(onRightItem)];
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *btnleft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnleft.frame = CGRectMake(0, 0, 13, 22);
    [btnleft addTarget:self action:@selector(onLeft) forControlEvents:UIControlEventTouchUpInside];
    [btnleft setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    UIBarButtonItem *letf = [[UIBarButtonItem alloc]initWithCustomView:btnleft];
    self.navigationItem.leftBarButtonItem = letf;
    
    [self creatSwitchIvew];
    
    [self creatViedoDetail];
    
    [self creatViewCount];
    
    _basePickerView  = [[BasePickerView alloc]init];
    _basePickerView.delegate = self;
    [self.view addSubview:_basePickerView];
}

#pragma mark---------创建viewSwitch

-(void)creatSwitchIvew{

    UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kWith, 40)];
    viewTop.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:viewTop];
    
    UILabel *lblFree =  [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 130, 40)];
    lblFree.text = @"是否开启义诊:";
    lblFree.font = [UIFont systemFontOfSize:17];
    [viewTop addSubview:lblFree];
    
    _switc= [[UISwitch alloc]initWithFrame:CGRectMake(kWith-20-50, 5, 50, 30)];
    [viewTop addSubview:_switc];
}


#pragma mark---------创建viewDetail
-(void)creatViedoDetail{

    CGRect rect = [INFO boundingRectWithSize:CGSizeMake(kWith-40, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];

    _viewMid = [[UIView alloc]initWithFrame:CGRectMake(0, 105, kWith, rect.size.height+10)];
    _viewMid.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_viewMid];
    
    UILabel *detail = [[UILabel alloc]initWithFrame:CGRectMake(10, 05, kWith-20, rect.size.height)];
    detail.backgroundColor = [UIColor whiteColor];
    detail.font = [UIFont systemFontOfSize:15];
    detail.numberOfLines = 0;
    detail.text = INFO;
    [_viewMid addSubview:detail];
}

#pragma mark---------创建viewCount

-(void)creatViewCount{

    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(10, _viewMid.frame.origin.y+_viewMid.frame.size.height+10, kWith-20, 40)];
    viewBottom.backgroundColor = [UIColor whiteColor];
    viewBottom.layer.borderColor = [kBoradColor CGColor];
    viewBottom.layer.borderWidth = 1;
    [self.view addSubview:viewBottom];
    
    UILabel *lblCount = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 110, 40)];
    lblCount.text = @"就诊数量";
    lblCount.font = [UIFont systemFontOfSize:16];
    [viewBottom addSubview:lblCount];
    
    _lblCountBottom= [[UILabel alloc]initWithFrame:CGRectMake(kWith-100-20-10, 0, 100, 40)];
    _lblCountBottom.textAlignment = 2;
    _lblCountBottom.userInteractionEnabled = YES;
    _lblCountBottom.font = [UIFont systemFontOfSize:15];
    _lblCountBottom.text = @"5       次";
    [viewBottom addSubview:_lblCountBottom];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPicker)];
    [_lblCountBottom addGestureRecognizer:tap];
    
}

#pragma mark---------选择器
-(void)onPicker{
    NSMutableArray *arry = [NSMutableArray array];
    [arry addObject:_arryPicker];
    [_basePickerView pickerDelegateShow:arry];
}

-(void)setPicker:(NSString *)count{
    _lblCountBottom.text = [NSString stringWithFormat:@"%@        次",count];
}

#pragma mark---------右按钮项  开启视频问诊
-(void)onRightItem{
    if (_lblCountBottom.text == nil || [_lblCountBottom.text isEqualToString:@""]) {
        kAlter(@"就诊数量为空");
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    [dic setObject:@([_lblCountBottom.text integerValue]) forKey:@"serviceAmount"];
    [dic setObject:@(_switc.on) forKey:@"isFree"];

    
    [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/ServiceRecordAdd",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self  success:^(id responseObject, BOOL ifTimeout) {

        VideoTableViewController *tab = [[VideoTableViewController alloc]init];
        tab.xtrID = (NSString *)responseObject;
        [self.navigationController pushViewController:tab animated:YES];
    } failure:^(NSError *error) {

    }];
}

#pragma mark---------左按钮项
-(void)onLeft{
 
    NSArray *arry = self.navigationController.viewControllers;
    HomeViewController *home = arry[0];
    [self.navigationController popToViewController:home animated:YES];
    
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
