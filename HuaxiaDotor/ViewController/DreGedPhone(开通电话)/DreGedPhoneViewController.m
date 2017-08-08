//
//  DreGedPhoneViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/19.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "DreGedPhoneViewController.h"
#import "ScheduleTableViewController.h"
#define kInstru @"    1.医生通过电话形式解答患者电话咨询的问题。\n    2.患者购买服务后，到达预约时间系统将自动拨通双方电话进行电话咨询，医生亦可提前发起通话。\n    3.每次通话时长为15分钟，到时系统将自动终止本次通话。"

@interface DreGedPhoneViewController ()
{
    UISwitch *_swit;
    UITextField *_textFile;
    UIView *_viewPrece;
    UIView *_viewSwit;
    UIButton *_btnRigh;

    ScheduleTableViewController *_sche;
}
@end

@implementation DreGedPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor  = kBackgroundColor;
    self.title= @"电话咨询";
    
    [self creatSwit];
    
    [self creatPriceView];
    
    _btnRigh = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRigh.frame = CGRectMake(0, 0, 35, 35);
    [_btnRigh setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    _btnRigh.titleLabel.font = [UIFont systemFontOfSize:16];
    [_btnRigh setTitle:@"确定" forState:UIControlStateNormal];
    [_btnRigh addTarget:self action:@selector(onRightReged) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:_btnRigh];
    self.navigationItem.rightBarButtonItem = bar;

    _sche = [[ScheduleTableViewController alloc]init];
    _sche.from = @"dreged";
    [self.view addSubview:_sche.view];
    [self addChildViewController:_sche];
    
    if (self.isdreged == YES) {
        _viewPrece.hidden = NO;
        _sche.view.hidden = NO;
    }
    else
    {
        _viewPrece.hidden = YES;
        _btnRigh.hidden = YES;
        _sche.view.hidden = YES;
    }
}

#pragma mark-----创建开关视图
-(void)creatSwit{

    _viewSwit = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kWith, 130)];
    _viewSwit.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_viewSwit];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kWith-20-60, 30)];
    lbl.backgroundColor = [UIColor whiteColor];
    lbl.text  =@"是否开通电话咨询";
    lbl.font = [UIFont systemFontOfSize:15];
    [_viewSwit addSubview:lbl];
    
    _swit = [[UISwitch alloc]initWithFrame:CGRectMake(kWith-60, 3, 50, 30)];
    [_swit addTarget:self action:@selector(onSwitchPhone) forControlEvents:UIControlEventValueChanged];
    _swit.on = self.isdreged;
    [_viewSwit addSubview:_swit];
    
    UILabel *lineFirst = [[UILabel alloc]initWithFrame:CGRectMake(10, 34.5, kWith-20, 0.5)];
    lineFirst.backgroundColor = kBoradColor;
    [_viewSwit addSubview:lineFirst];
    
    UILabel *lblText = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, kWith-20, 80)];
    lblText.text = kInstru;
    lblText.numberOfLines = 0;
    lblText.backgroundColor = [UIColor whiteColor];
    lblText.font = [UIFont systemFontOfSize:13];
    [_viewSwit addSubview:lblText];
}

#pragma mark-----创建价格视图
-(void)creatPriceView{
    _viewPrece= [[UIView alloc]initWithFrame:CGRectMake(10, 204, kWith-20, 40)];
    _viewPrece.backgroundColor = [UIColor whiteColor];
    _viewPrece.layer.cornerRadius = 5;
    _viewPrece.layer.masksToBounds = YES;
    _viewPrece.layer.borderWidth = 1;
    _viewPrece.layer.borderColor = [kBoradColor CGColor];
    
    UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 100, 30)];
    lblPrice.text = @"    单次价格";
    lblPrice.font = [UIFont systemFontOfSize:15];
    [_viewPrece addSubview:lblPrice];
    
    _textFile = [[UITextField alloc]initWithFrame:CGRectMake(kWith-150, 5, 80, 30)];
    _textFile.textColor = BLUECOLOR_STYLE;
    _textFile.text = self.price;
    _textFile.textAlignment = 1;
    [_viewPrece addSubview:_textFile];
    
    UILabel *lblUnit = [[UILabel alloc]initWithFrame:CGRectMake(kWith-65, 5, 40, 30)];
    lblUnit.text = @"元";
    lblUnit.font = [UIFont systemFontOfSize:13];
    [_viewPrece addSubview:lblUnit];
    [self.view addSubview:_viewPrece];

}

-(void)onRightReged{
    
    if (_textFile.text == nil || [_textFile.text isEqualToString:@""] || [_textFile.text isEqualToString:@"0"]) {
        kAlter(@"价格为空，请重新设置");
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    [dic setObject:@(2) forKey:@"type"];
    [dic setObject:@([_textFile.text floatValue]) forKey:@"price"];

    

    [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/VasServiceSet",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject, BOOL ifTimeout) {

        _swit.on = YES;
        _btnRigh.hidden = NO;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.Id forKey:@"id"];
        [dic setObject:@"True" forKey:@"isOpen"];
        [dic setObject:_textFile.text forKey:@"price"];
        [dic setObject:@"2" forKey:@"type"];
        [kUserDefatuel setObject:dic forKey:@"VasSet1"];
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"开通成功" preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alter animated:YES completion:nil];

    } failure:^(NSError *error) {

    }];
}


-(void)onSwitchPhone{
    
    if (_swit.on == NO) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:self.Id forKey:@"Id"];
        [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/VasServiceClose",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic  viewConroller:self success:^(id responseObject) {
            _swit.on = NO;
            _textFile.text = @"";
            _viewPrece.hidden = YES;
            _sche.view.hidden = YES;
            _btnRigh.hidden = YES;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:self.Id forKey:@"id"];
            [dic setObject:@"False" forKey:@"isOpen"];
            [dic setObject:_textFile.text forKey:@"price"];
            [dic setObject:@"2" forKey:@"type"];
            [kUserDefatuel setObject:dic forKey:@"VasSet1"];
            kAlter(@"关闭成功");
        } failure:^(NSError *error) {
            
        }];
    }
    else
    {
        _viewPrece.hidden = NO;
        _sche.view.hidden = NO;
        _btnRigh.hidden = NO;
        
    }
    
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
