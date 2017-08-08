//
//  StopDiagnosisViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/10.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "StopDiagnosisViewController.h"
#import "StopDetailViewController.h"

@interface StopDiagnosisViewController ()

//日期
@property (weak, nonatomic) IBOutlet UIButton *btnDayStart;
@property (weak, nonatomic) IBOutlet UIButton *btnDayEnd;
@property (strong, nonatomic) NSString *str_DayStart;
@property (strong, nonatomic)  NSString *str_DayEnd;

//时间
@property (weak, nonatomic) IBOutlet UIButton *btnTimeStart;
@property (weak, nonatomic) IBOutlet UIButton *btnTimeEnd;
@property (strong, nonatomic)  NSString *str_TimeStart;
@property (strong, nonatomic)  NSString *str_TimeEnd;
//类型
@property (weak, nonatomic) IBOutlet UIButton *btnOnline;
@property (weak, nonatomic) IBOutlet UIButton *btnTel;
@property (weak, nonatomic) IBOutlet UIButton *btnVideo;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;
@property (strong, nonatomic) NSMutableArray *arr_style;
//停诊原因
@property (weak, nonatomic) IBOutlet UIButton *btnWorkingCause;
@property (weak, nonatomic) IBOutlet UIButton *btnTemporaryCause;
@property (weak, nonatomic) IBOutlet UIButton *btnOtherCause;
@property (strong, nonatomic) NSString *str_StopCause;
//发布
@property (weak, nonatomic) IBOutlet UIButton *btnSend;

@end

@implementation StopDiagnosisViewController

-(void)viewWillAppear:(BOOL)animated
{
    [_btnTimeStart setTitle:@"请选择" forState:UIControlStateNormal];
    [_btnTimeEnd setTitle:@"请选择" forState:UIControlStateNormal];
    [_btnDayStart setTitle:@"请选择" forState:UIControlStateNormal];
    [_btnDayEnd setTitle:@"请选择" forState:UIControlStateNormal];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _arr_style = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"已停诊" style:UIBarButtonItemStylePlain target:self action:@selector(AlreadlrSendStop)];
    self.navigationItem.rightBarButtonItem = bar;
    
    self.view.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.952];
    self.navigationController.navigationBar.hidden = NO;
    
    [self createNullBtnStyle];
}

#pragma mark - 按钮的默认属性
-(void)createNullBtnStyle
{
    _btnSend.layer.cornerRadius = 3;
    _btnSend.layer.masksToBounds = YES;
    
    //按钮的默认风格设置
    [self setButtonSelect:_btnDayStart select:NO];
    [self setButtonSelect:_btnDayEnd select:NO];
    [self setButtonSelect:_btnTimeStart select:NO];
    [self setButtonSelect:_btnTimeEnd select:NO];
    [self setButtonSelect:_btnOnline select:NO];
    [self setButtonSelect:_btnTel select:NO];
    [self setButtonSelect:_btnVideo select:NO];
    [self setButtonSelect:_btnPlus select:NO];
    
    [self setButtonSelect:_btnWorkingCause select:NO];
    [self setButtonSelect:_btnTemporaryCause select:NO];
    [self setButtonSelect:_btnOtherCause select:NO];
}


//日期
- (IBAction)btnActionDays:(UIButton *)sender
{
    //开始时间tag 100010
    //结束时间tag 100020
    //创建遮盖试图
    UIView *shadeView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    shadeView.backgroundColor=[UIColor colorWithWhite:0.500 alpha:0.301];
    [self.view addSubview:shadeView];
    
    //创建时间滚轮
    UIDatePicker *datePickerView=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 250,120)];
    //    datePickerView.backgroundColor=BLUECOLOR_STYLE;
    //锁定为中文
    NSLocale *locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    datePickerView.locale=locale;
    //时间模式
    datePickerView.datePickerMode=UIDatePickerModeDate;
    datePickerView.minuteInterval = 1;
    
    //创建提示框
    CXAlertView *cxAlertView = [[CXAlertView alloc]initWithTitle:nil contentView:datePickerView cancelButtonTitle:nil];
    [cxAlertView addButtonWithTitle:@"确定"
                               type:CXAlertViewButtonTypeCustom
                            handler:^(CXAlertView *alertView, CXAlertButtonItem *button){
                                alertView.showBlurBackground = YES;
                                [alertView dismiss];
                                [shadeView removeFromSuperview];
                                
                                //截取时间
                                NSDate *select=[datePickerView date];
                                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
                                [dateFormatter setDateFormat:@"YYYY-MM-dd"];
                                NSString *dateTime=[dateFormatter stringFromDate:select];
                                self.str_DayStart = dateTime;
                                
                                if (sender.tag==100010)//开始日期
                                {
                                        [_btnDayStart setTitle:dateTime forState:UIControlStateNormal];
                                }
                                else if (sender.tag==100020)//结束日期
                                {
                                        [_btnDayEnd setTitle:dateTime forState:UIControlStateNormal];
                                }
                                
                                //停诊日期的先后判断
                                if (![[self.btnDayStart currentTitle] isEqualToString:@"请选择"]&&![[self.btnDayEnd currentTitle] isEqualToString:@"请选择"])
                                {
                                    NSInteger startSp = [self dateForTimeSp:[NSString stringWithFormat:@"%@",[self.btnDayStart currentTitle]]];
                                    NSInteger endSp = [self dateForTimeSp:[NSString stringWithFormat:@"%@",[self.btnDayEnd currentTitle]]];
//                                    NSLog(@"开始%ld",(long)startSp);
//                                    NSLog(@"结束%ld",(long)endSp);
                                   
                                    //判断文本的开始时间和结束时间
                                    if (startSp>endSp)
                                    {
                                        kAlter(@"结束日期不能早于开始时间");
                                        [_btnDayStart setTitle:@"请选择" forState:UIControlStateNormal];
                                        [_btnDayEnd setTitle:@"请选择" forState:UIControlStateNormal];
                                    }
//                                    else if (startSp==endSp)
//                                    {
//                                        [showAlertView showAlertViewWithMessage:@"结束日期不能等于开始时间"];
//                                        [_btnDayStart setTitle:@"请选择" forState:UIControlStateNormal];
//                                        [_btnDayEnd setTitle:@"请选择" forState:UIControlStateNormal];
//                                    }
                                    else if (startSp<=endSp)
                                    {
                                        [alertView dismiss];
                                        [shadeView removeFromSuperview];
                                    }
                                }
                            }];
    [cxAlertView addButtonWithTitle:@"取消"
                               type:CXAlertViewButtonTypeCustom
                            handler:^(CXAlertView *alertView, CXAlertButtonItem *button){
                                alertView.showBlurBackground = YES;
                                [alertView dismiss];
                                [shadeView removeFromSuperview];
                            }];
    cxAlertView.showBlurBackground = NO;
    [cxAlertView show];
}

#pragma mark - 传入字符串输出时间戳
-(NSInteger)dateForTimeSp:(NSString*)strTime
{
    NSString *timeStr = strTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:timeStr]; //------------将字符串按formatter转成nsdate
    NSInteger timeSp = [date timeIntervalSince1970];
//    NSLog(@"时间戳:%ld",(long)timeSp); //时间戳的值
    //转时间
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeSp];
//    NSLog(@"时间  = %@",confromTimesp);
    return timeSp;
}

//时间
- (IBAction)btnActionTime:(UIButton *)sender
{
    //开始时间tag 200010
    //结束时间tag 200020

    //创建遮盖试图
    UIView *shadeView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    shadeView.backgroundColor=[UIColor colorWithWhite:0.500 alpha:0.301];
    [self.view addSubview:shadeView];
    
    //创建时间滚轮
    UIDatePicker *datePickerView=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 250,120)];
    //    datePickerView.backgroundColor=BLUECOLOR_STYLE;
    //锁定为中文
    NSLocale *locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    datePickerView.locale=locale;
    //时间模式
    datePickerView.datePickerMode=UIDatePickerModeTime;
    //时间间隔
    datePickerView.minuteInterval = 1;
    
    //创建提示框
    CXAlertView *cxAlertView = [[CXAlertView alloc]initWithTitle:nil contentView:datePickerView cancelButtonTitle:nil];
    [cxAlertView addButtonWithTitle:@"确定"
                               type:CXAlertViewButtonTypeCustom
                            handler:^(CXAlertView *alertView, CXAlertButtonItem *button){
                                alertView.showBlurBackground = YES;
                                [alertView dismiss];
                                [shadeView removeFromSuperview];
                                
                                //截取时间
                                NSDate *select=[datePickerView date];
                                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
                                [dateFormatter setDateFormat:@"HH:mm"];
                                NSString *dateTime=[dateFormatter stringFromDate:select];
                                
                                if (sender.tag==200010)//开始时间
                                {
                                    [_btnTimeStart setTitle:dateTime forState:UIControlStateNormal];
                                }
                                else if (sender.tag==200020)//结束时间
                                {
                                   [_btnTimeEnd setTitle:dateTime forState:UIControlStateNormal];
                                }
                                //判断时间的先后
                                if (![[self.btnTimeStart currentTitle] isEqualToString:@"请选择"]&&![[self.btnTimeEnd currentTitle] isEqualToString:@"请选择"])
                                {
                                    //判断文本的开始时间和结束时间
                                    int i = [self judgeSmallORBig:[self.btnTimeStart currentTitle] and:[self.btnTimeEnd currentTitle]];
                                    if (i==-1)
                                    {
                                        kAlter(@"结束时间不能早于开始时间");
                                        [_btnTimeStart setTitle:@"请选择" forState:UIControlStateNormal];
                                        [_btnTimeEnd setTitle:@"请选择" forState:UIControlStateNormal];
                                    }
                                    else if (i==1)
                                    {
                                        [alertView dismiss];
                                        [shadeView removeFromSuperview];
                                    }
                                    else if (i==0)
                                    {
                                        kAlter(@"结束时间不能等于开始时间");
                                        [_btnTimeStart setTitle:@"请选择" forState:UIControlStateNormal];
                                        [_btnTimeEnd setTitle:@"请选择" forState:UIControlStateNormal];
                                    }
                                }
                            }];
    [cxAlertView addButtonWithTitle:@"取消"
                               type:CXAlertViewButtonTypeCustom
                            handler:^(CXAlertView *alertView, CXAlertButtonItem *button){
                                alertView.showBlurBackground = YES;
                                [alertView dismiss];
                                [shadeView removeFromSuperview];
                            }];
    cxAlertView.showBlurBackground = NO;
    [cxAlertView show];
    
}

//类型 多选按钮
- (IBAction)btnActionType:(UIButton *)sender
{
    //在线问诊tag 30001
    //电话问诊tag 30002
    //视频问诊tag 30003
    //加号问诊tag 30004
    
    int i = (int)(sender.tag - 30001);
    
    NSArray *arr =@[@"1",@"2",@"3",@"4"];
    NSString * str=arr[i];
    BOOL  iscontain = [_arr_style containsObject:str];
    
    [self setButtonSelect:sender select:!iscontain];
    if (!iscontain)
    {
        [_arr_style addObject:str];
    }
    else
    {
        [_arr_style removeObject:str];
    }
    
    NSLog(@"%@",_arr_style);
}

//原因
- (IBAction)btnActionCause:(UIButton *)sender
{
    //工作安排tag 400010
    //临时有事tag 400020
    //其他 tag   400030
    if (sender.tag==400010)
    {
        [self setButtonSelect:_btnWorkingCause select:YES];
        [self setButtonSelect:_btnTemporaryCause select:NO];
        [self setButtonSelect:_btnOtherCause select:NO];
        _str_StopCause = @"工作安排";
    }
    else if (sender.tag==400020)
    {
        [self setButtonSelect:_btnWorkingCause select:NO];
        [self setButtonSelect:_btnTemporaryCause select:YES];
        [self setButtonSelect:_btnOtherCause select:NO];
        _str_StopCause = @"临时有事";
    }
    else if (sender.tag==400030)
    {
        [self setButtonSelect:_btnWorkingCause select:NO];
        [self setButtonSelect:_btnTemporaryCause select:NO];
        [self setButtonSelect:_btnOtherCause select:YES];
        _str_StopCause = @"其他";
    }
    //给停止原因赋值
//    NSLog(@"%d",sender.tag);
}

//发布按钮
- (IBAction)btnActionSend:(UIButton *)sender
{
    //判断日期是否为空
    if ([[self.btnDayStart currentTitle] isEqualToString:@"请选择"]||[[self.btnDayEnd currentTitle] isEqualToString:@"请选择"])
    {
        kAlter(@"停诊日期请填写完整");
    }
    //判断时段是否为空
    else if ([[self.btnTimeStart currentTitle] isEqualToString:@"请选择"]||[[self.btnTimeEnd currentTitle] isEqualToString:@"请选择"])
    {
        kAlter(@"就诊时段请填写完整");
    }
    //判断停诊类型是否为空
    else if (_arr_style.count==0)
    {
        kAlter(@"请选择停诊类型");
    }
    //停诊原因是否为空
    else if (_str_StopCause==nil)
    {
        kAlter(@"请选择停诊原因");
    }
    else
    {
        //获取数据上传
        [self postStopCause];
    }
    
}

#pragma mark - 提交停诊通知数据
-(void)postStopCause
{
    //从NSUserDefaults获取身份验证秘钥
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode;
    verifyCode=[userdefault objectForKey:@"verifyCode"];
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    userDic = [userdefault objectForKey:@"DoctorDataDic"];
    //POST
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    //设置需要上传的字典数据
    //医生ID
    NSString *userID;
    userID = [userdefault objectForKey:@"id"];
    [parameters setObject:userID forKey:@"doctorId"];
    //医生姓名
    [parameters setObject:userDic[@"userName"] forKey:@"doctorName"];
    //停诊原因
    [parameters setObject:[NSString stringWithFormat:@"%@",_str_StopCause] forKey:@"stopReason"];
    //停诊开始日期
    [parameters setObject:[NSString stringWithFormat:@"%@",[self.btnDayStart currentTitle]] forKey:@"startDate"];
    //停诊截止日期
    [parameters setObject:[NSString stringWithFormat:@"%@",[self.btnDayEnd currentTitle]] forKey:@"endDate"];
    //停诊开始时段
    [parameters setObject:[NSString stringWithFormat:@"%@",[self.btnTimeStart currentTitle]] forKey:@"startSpan"];
    //停诊截止时段
    [parameters setObject:[NSString stringWithFormat:@"%@",[self.btnTimeEnd currentTitle]] forKey:@"endSpan"];
    //停诊类型
    [parameters setObject:_arr_style forKey:@"stopTypeList"];
    if (_arr_style.count == 0 || _arr_style == nil) {
        kAlter(@"类型为必填选项");
        return;
    }
    [RequestManager postWithURLString:STOPNOTICE heads:heads parameters:parameters success:^(id responseObject) {
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"发布成功" preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alter animated:YES completion:nil];
        
    } failure:^(NSError *error){
        NSLog(@"错误 = %@",error);
    }];
}


#pragma mark - 按钮选中的状态修改
-(void)setButtonSelect:(UIButton *)btn select:(BOOL)select
{
    if (select==YES)
    {
        btn.layer.masksToBounds = YES;
        [btn.layer setBorderWidth:0];
        btn.backgroundColor = BLUECOLOR_STYLE;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if (select==NO)
    {
        btn.layer.masksToBounds = YES;
        [btn.layer setBorderWidth:0.5];
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor colorWithWhite:0.000 alpha:0.500] forState:UIControlStateNormal];
        [btn.layer setBorderColor: [[UIColor colorWithWhite:0.000 alpha:0.500]CGColor]];
    }
}



#pragma mark - 判断时间的先后顺序
//判断就诊时间的先后顺序
-(int)judgeSmallORBig:(NSString *)startTime and:(NSString *)endTime
{
    int ci;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *statr=[[NSDate alloc]init];
    NSDate *end=[[NSDate alloc]init];
    
    statr = [dateFormatter dateFromString:startTime];
    end = [dateFormatter dateFromString:endTime];
    
    NSComparisonResult result = [statr compare:end];
    switch (result)
    {
            //end 比 start 小
        case NSOrderedAscending:
            ci = 1;
            break;
            //end 比 start 大
        case NSOrderedDescending:
            ci = -1;
            break;
            //相等
        case NSOrderedSame:
            ci = 0 ;
            break;
        default:
            break;
    }
    return ci;
}

#pragma mark ------------ 停诊
-(void)AlreadlrSendStop{

    StopDetailViewController *stop = [[StopDetailViewController alloc]init];
    [self.navigationController pushViewController:stop animated:YES];
}



- (void)didReceiveMemoryWarning
{
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
