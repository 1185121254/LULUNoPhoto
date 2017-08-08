//
//  DregedViedoViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/19.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "DregedViedoViewController.h"
#import "ViedoSchedelViewController.h"
#import "OnLineViedo.h"
#define kInstruViedo @"    1.医生通过视频形式面对面解答患者咨询问题。\n    2.视频由医生发起，每次视频时长为15分钟，到时系统将自动终止本次视频。"

@interface DregedViedoViewController ()
{
    UISwitch *_swit;
    UITextField *_textFile;
    UIView *_viewPrece;
    UIView *_viewSwit;
    UIButton *_btnRigh;

    ViedoSchedelViewController *_viedo;

}
@end

@implementation DregedViedoViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    NSMutableDictionary *dicP = [NSMutableDictionary dictionary];
    [dicP setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];

    _viedo.arryWeek = [[NSMutableArray alloc]init];
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetVasAnnoucement",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dicP viewConroller:self success:^(id responseObject) {
        
        NSMutableArray *arry = [self detailWithData:(NSArray *)responseObject];
        
        NSMutableArray *Monday = [NSMutableArray array];
        NSMutableArray *Tuesday = [NSMutableArray array];
        NSMutableArray *Wednesday = [NSMutableArray array];
        NSMutableArray *Thursday = [NSMutableArray array];
        NSMutableArray *Friday = [NSMutableArray array];
        NSMutableArray *Saturday = [NSMutableArray array];
        NSMutableArray *Sunday = [NSMutableArray array];
        
        for (OnLineViedo *onLine in arry) {
            if ([onLine.week isEqualToString:@"1"]) {
                [Monday addObject:onLine];
            }else if ([onLine.week isEqualToString:@"2"]){
                [Tuesday addObject:onLine];
            }else if ([onLine.week isEqualToString:@"3"]){
                [Wednesday addObject:onLine];
            }else if ([onLine.week isEqualToString:@"4"]){
                [Thursday addObject:onLine];
            }else if ([onLine.week isEqualToString:@"5"]){
                [Friday addObject:onLine];
            }else if ([onLine.week isEqualToString:@"6"]){
                [Saturday addObject:onLine];
            }else if ([onLine.week isEqualToString:@"7"]){
                [Sunday addObject:onLine];
            }
        }
        
        [_viedo.arryWeek addObject:Monday];
        [_viedo.arryWeek addObject:Tuesday];
        [_viedo.arryWeek addObject:Wednesday];
        [_viedo.arryWeek addObject:Thursday];
        [_viedo.arryWeek addObject:Friday];
        [_viedo.arryWeek addObject:Saturday];
        [_viedo.arryWeek addObject:Sunday];
        [_viedo.tableView reloadData];

        
    } failure:^(NSError *error) {

    }];
    
    if (self.isdreged == YES) {
        _viewPrece.hidden = NO;
        _viedo.view.hidden = NO;
    }
    else
    {
        _viewPrece.hidden = YES;
        _btnRigh.hidden = YES;
        _viedo.view.hidden = YES;
    }
}

-(NSMutableArray *)detailWithData :(NSArray *)arryValue{

    NSMutableArray *arryData =[ NSMutableArray array];
    for (NSDictionary *dicValue in arryValue) {
        OnLineViedo *onLine = [[OnLineViedo alloc]init];
        for (NSString *key in [dicValue allKeys]) {
            [onLine setValue:[dicValue objectForKey:key] forKey:key];
        }
        [arryData addObject:onLine];
    }
    return arryData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor  = kBackgroundColor;
    self.title= @"视频咨询";
    
    [self creatSwit];
    [self creatPriceView];
    
    _viedo = [[ViedoSchedelViewController alloc]init];
    [self.view addSubview:_viedo.view];
    [self addChildViewController:_viedo];
    
    _btnRigh = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnRigh.frame = CGRectMake(0, 0, 35, 35);
    [_btnRigh setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];    _btnRigh.titleLabel.font = [UIFont systemFontOfSize:16];
    [_btnRigh setTitle:@"确定" forState:UIControlStateNormal];
    [_btnRigh addTarget:self action:@selector(onRightReged) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:_btnRigh];
    self.navigationItem.rightBarButtonItem = bar;
}

#pragma mark-----创建开关视图
-(void)creatSwit{
    
    _viewSwit = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kWith, 100)];
    _viewSwit.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_viewSwit];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kWith-20-60, 30)];
    lbl.backgroundColor = [UIColor whiteColor];
    lbl.text  =@"是否开通视频咨询";
    lbl.font = [UIFont systemFontOfSize:15];
    [_viewSwit addSubview:lbl];
    
    _swit = [[UISwitch alloc]initWithFrame:CGRectMake(kWith-60, 3, 50, 30)];
    [_swit addTarget:self action:@selector(onSwitchPhone) forControlEvents:UIControlEventValueChanged];
    _swit.on = self.isdreged;
    [_viewSwit addSubview:_swit];
    
    UILabel *lineFirst = [[UILabel alloc]initWithFrame:CGRectMake(10, 34.5, kWith-20, 0.5)];
    lineFirst.backgroundColor = kBoradColor;
    [_viewSwit addSubview:lineFirst];
    
    UILabel *lblText = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, kWith-20, 60)];
    lblText.text = kInstruViedo;
    lblText.numberOfLines = 0;
    lblText.backgroundColor = [UIColor whiteColor];
    lblText.font = [UIFont systemFontOfSize:13];
    [_viewSwit addSubview:lblText];
}

#pragma mark-----创建价格视图
-(void)creatPriceView{
    _viewPrece= [[UIView alloc]initWithFrame:CGRectMake(10, 174, kWith-20, 40)];
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
    [dic setObject:@(3) forKey:@"type"];
    [dic setObject:@([_textFile.text floatValue]) forKey:@"price"];


    [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/VasServiceSet",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject, BOOL ifTimeout) {

        _swit.on = YES;
        _btnRigh.hidden = NO;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:self.Id forKey:@"id"];
        [dic setObject:@"True" forKey:@"isOpen"];
        [dic setObject:_textFile.text forKey:@"price"];
        [dic setObject:@"3" forKey:@"type"];
        [kUserDefatuel setObject:dic forKey:@"VasSet2"];
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


        [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/VasServiceClose",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self  success:^(id responseObject) {
            
            NSMutableDictionary *dicClose = [NSMutableDictionary dictionary];
            [dicClose setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
            [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/ServiceRecordClose",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dicClose viewConroller:self success:^(id responseObject) {

                _swit.on = NO;
                _textFile.text = @"";
                _viewPrece.hidden = YES;
                _btnRigh.hidden = YES;
                _viedo.view.hidden = YES;
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic setObject:self.Id forKey:@"id"];
                [dic setObject:@"False" forKey:@"isOpen"];
                [dic setObject:_textFile.text forKey:@"price"];
                [dic setObject:@"3" forKey:@"type"];
                [kUserDefatuel setObject:dic forKey:@"VasSet2"];
                
                kAlter(@"关闭成功");

            } failure:^(NSError *error) {

            }];
   
        } failure:^(NSError *error) {

        }];
    }
    else
    {
        _viewPrece.hidden = NO;
        _viedo.view.hidden = NO;
        _btnRigh.hidden = NO;
    }
    
}


-(void)colse{
    kAlter(@"关闭失败");
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
