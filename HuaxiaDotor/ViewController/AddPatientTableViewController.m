//
//  AddPatientTableViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/3/15.
//  Copyright © 2016年 kock. All rights reserved.
//  新增患者

#import "AddPatientTableViewController.h"
//#import "HZAreaPickerView.h"//城市选择
#import "STPickerArea.h"
#import "OutPatienrRecordViewController.h"
//语音
#import "iflyMSC/IFlyMSC.h"
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "IQKeyboardManager.h"
#import "AppDelegate.h"
@interface AddPatientTableViewController ()<STPickerAreaDelegate,UITextFieldDelegate,BaseDatePickerDelegate,IFlyRecognizerViewDelegate>
//用户名
@property (weak, nonatomic) IBOutlet UITextField *nameText;
//ID
@property (weak, nonatomic) IBOutlet UITextField *idText;
//性别 tag男101(1)  女102(0)
@property (assign, nonatomic) int sexTag;
@property (weak, nonatomic) IBOutlet UIButton *sexManBtn;
@property (weak, nonatomic) IBOutlet UIButton *sexWomanBtn;

//出生日期
@property (weak, nonatomic) IBOutlet UILabel *birthDateText;
@property (weak, nonatomic) IBOutlet UIView *birthDateView;
//年纪
@property (weak, nonatomic) IBOutlet UITextField *ageText;
//电话
@property (weak, nonatomic) IBOutlet UITextField *phoneNumText;
//省份城市
@property (weak, nonatomic) IBOutlet UILabel *cityNameText;
@property (weak, nonatomic) IBOutlet UIView *cityView;
@property (strong, nonatomic) NSString *cityName;

//就诊卡号
@property (weak, nonatomic) IBOutlet UITextField *patientNumText;
//门诊号码
@property (weak, nonatomic) IBOutlet UITextField *OutPatientNumTxt;

//疾病诊断
@property (weak, nonatomic) IBOutlet UITextField *diagnoseText;
//疾病备注
@property (weak, nonatomic) IBOutlet UITextField *diseaseMarkText;
//语音图
@property (strong, nonatomic) IFlyRecognizerView *iflyRecognizerView;
//判断  1:疾病诊断   2:备注按钮
@property (assign, nonatomic) int style;
@property (strong, nonatomic) IBOutlet UITableView *view_table;
@property (strong, nonatomic) STPickerArea *pickerArea;
@property (strong, nonatomic) BaseDatePickerViewController *basePicker;
//@property (strong, nonatomic) UITextField *textFiled;
@property (assign, nonatomic) CGFloat keyboardTop;
//@property (assign, nonatomic) CGFloat *textFileFoot;
@property (assign, nonatomic) CGFloat textFrameHeiht;
@end

@implementation AddPatientTableViewController

#pragma mark - 代理传值进来的字典数据
//代理方法
//-(void)userInfoDic:(NSDictionary *)userDic
//{
//    self.userDic=userDic;
//}

#pragma mark - 判断是否有传进来初始值
//初始进来时检查是否有上个页面传进字典数据
-(void)viewDidAppear:(BOOL)animated
{
    //如果字典不为空,便去设置
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    //性别默认为男
    //开关图
    UIImage *imageON=[UIImage imageNamed:@"i圈_h"];
    UIImage *imageOFF=[UIImage imageNamed:@"i圈"];
    [self.sexManBtn setImage:imageON forState:UIControlStateNormal];
    [self.sexWomanBtn setImage:imageOFF forState:UIControlStateNormal];
    self.sexTag=101;
    _pickerArea = [[STPickerArea alloc]init];
    //时间选择初始化
    _basePicker = [[BaseDatePickerViewController alloc]initWithModel:1];
    _basePicker.delegate = self;
    [self.view_table addSubview:_basePicker];

    //生日时间选择
    [self birthDatePickview];
    self.idText.delegate=self;
    //键盘通知
    [self registerForKeyboardNotifications];
}

#pragma mark - 键盘位置监听通知
- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}
- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    _keyboardTop = keyboardSize.height;

    if (_textFrameHeiht>_keyboardTop)
    {
        [self.view_table setContentOffset:CGPointMake(0, 90-64)animated:YES];
    }
//    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    ///keyboardWasShown = YES;
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    _keyboardTop = keyboardSize.height;
    [self.view_table setContentOffset:CGPointMake(0, -64)animated:YES];
//    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    // keyboardWasShown = NO;
    
}

#pragma mark - 保存新增患者
- (IBAction)addPatientBtn:(UIBarButtonItem *)sender
{
    if (_nameText.text.length == 0 || [_nameText.text isEqualToString:@""])
    {
        [showAlertView showAlertViewWithMessage:@"请输入患者姓名"];
    }
    else
    {
        //从NSUserDefaults获取身份验证秘钥
        NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
        //获取用户秘钥
        self.verifyCode=[userdefault objectForKey:@"verifyCode"];
        //    NSLog(@"获取身份验证秘钥%@",self.verifyCode);
        
        //POST
        //HEAD
        NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:self.verifyCode};
        //BODY
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        //设置需要上传的字典数据
        //患者姓名
        [parameters setObject:self.nameText.text forKey:@"name"];
        //身份证
        [parameters setObject:self.idText.text forKey:@"idCard"];
        //获取性别
        if (self.sexTag==101)
        {
            //男 1
            NSNumber *num = [NSNumber numberWithInt:0];
            [parameters setObject:num forKey:@"sex"];
        }
        if (self.sexTag==102)
        {
            //女 0
            NSNumber *num = [NSNumber numberWithInt:1];
            [parameters setObject:num forKey:@"sex"];
        }
        //出生日
        [parameters setObject:self.birthDateText.text forKey:@"birth"];
        //城市
        [parameters setObject:self.cityNameText.text forKey:@"city"];
        //就诊卡号
        [parameters setObject:self.patientNumText.text forKey:@"medicalCard"];
        //门诊号码
        [parameters setObject:self.OutPatientNumTxt.text forKey:@"ClinicId"];
        //疾病诊断
        [parameters setObject:self.diagnoseText.text forKey:@"illness"];
        //病例备注
        [parameters setObject:self.diseaseMarkText.text forKey:@"remark"];
        
        [RequestManager postWithURLString:ADD_PATIENT heads:heads parameters:parameters success:^(id responseObject) {
            UIAlertController *aolter = [UIAlertController alertControllerWithTitle:@"提示" message:@"添加成功" preferredStyle:UIAlertControllerStyleAlert];
            [aolter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }]];
            [self presentViewController:aolter animated:YES completion:nil];
            
        } failure:^(NSError *error){
            NSLog(@"错误 = %@",error);
        }];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = [self.view convertRect:textField.frame fromView:textField.superview];
    CGFloat textFrameHeiht = CGRectGetMaxY(frame);
    _textFrameHeiht = textFrameHeiht;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==112)
    {
        NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";;
        NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        if (![identityCardPredicate evaluateWithObject:self.idText.text])
        {
            [showAlertView showAlertViewWithMessage:@"身份证格式错误"];
        }
        else
        {
            //判定身份证的出生日期
            [self getInfoFromIDCard:self.idText.text];
            [self.tableView reloadData];
        }
    }
}

#pragma mark - 判定身份证的出生日期
-(void)getInfoFromIDCard:(NSString *)idCard
{
    //get year
    NSDate *today= [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear;
    NSDateComponents *dateCaomponent = [calendar components:unitFlags fromDate:today];
    NSInteger year = [dateCaomponent year];
    
    NSString *idYear = [idCard substringWithRange:NSMakeRange(6, 4)];
    NSString *idSex = [idCard substringWithRange:NSMakeRange(16, 1)];
    
    if ([idSex integerValue] % 2 == 0)
    {
        self.sexTag=101;
        [self.sexManBtn setImage:[UIImage imageNamed:@"i圈"] forState:UIControlStateNormal];
        [self.sexWomanBtn setImage:[UIImage imageNamed:@"i圈_h"] forState:UIControlStateNormal];
    }
    else
    {
        self.sexTag=102;
        [self.sexWomanBtn setImage:[UIImage imageNamed:@"i圈"] forState:UIControlStateNormal];
        [self.sexManBtn setImage:[UIImage imageNamed:@"i圈_h"] forState:UIControlStateNormal];
    }
    
    NSInteger age = year - [idYear integerValue];
    self.ageText.text=[NSString stringWithFormat:@"%d",(int)age];
    //设置出生年月日
    NSString *yearDay =  [NSString stringWithFormat:@"%@-%@-%@",[idCard substringWithRange:NSMakeRange(6, 4)],[idCard substringWithRange:NSMakeRange(10, 2)],[idCard substringWithRange:NSMakeRange(12, 2)]];
//    NSLog(@"%@",yearDay);
    self.birthDateText.text=yearDay;
}

#pragma mark - 选择器
-(void)birthDatePickview
{
    //给选择器添加点击事件
    UITapGestureRecognizer  *tapGesturesBirthDate=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(datePickViewShow)];
    UITapGestureRecognizer  *tapGesturesCity=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CityPickViewShow)];
    //两个选择器分别添加点击事件
    [self.cityView addGestureRecognizer:tapGesturesCity];
    [self.birthDateView addGestureRecognizer:tapGesturesBirthDate];
}



#pragma mark - 生日pickview
-(void)datePickViewShow
{
    [self.view endEditing:YES];
    [_basePicker datePickerShow:[NSDate date] MinDate:nil];
}

-(void)setDateFromDatePicker:(NSDate *)date
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.birthDateText.text = [formatter stringFromDate:date];
    [_view_table reloadData];
}


#pragma mark - 城市pickview
-(void)CityPickViewShow
{
    [self.view endEditing:YES];
    if (_pickerArea != nil)
    {
        _pickerArea = [[STPickerArea alloc]init];
    }
    [_pickerArea setDelegate:self];
    [_pickerArea setContentMode:STPickerContentModeBottom];
    [_pickerArea show];
}

- (void)pickerArea:(STPickerArea *)pickerArea province:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", province, city, area];
    self.cityNameText.text = text;
    [_view_table reloadData];
}

#pragma mark - 男女选择按钮
- (IBAction)sexBtn:(UIButton *)sender
{
    //开关图
    UIImage *imageON=[UIImage imageNamed:@"i圈_h"];
    UIImage *imageOFF=[UIImage imageNamed:@"i圈"];
    
    //判断按钮的tag值
    switch (sender.tag)
    {
            //男
        case 101:
            [self.sexManBtn setImage:imageON forState:UIControlStateNormal];
            [self.sexWomanBtn setImage:imageOFF forState:UIControlStateNormal];
            self.sexTag=101;
        break;
        case 102:
            [self.sexManBtn setImage:imageOFF forState:UIControlStateNormal];
            [self.sexWomanBtn setImage:imageON forState:UIControlStateNormal];
            self.sexTag=102;
        default:
            break;
    }
}

#pragma mark - 疾病诊断录音
- (IBAction)diagnoseVoiceBtn:(UIButton *)sender
{
    [self onNotifyXunFlyClip];
    _style = 1;
}

#pragma mark - 病例备注录音
- (IBAction)diseaseMarkVoiceBtn:(id)sender
{
    [self onNotifyXunFlyClip];
    _style = 2;
}

#pragma mark----------讯飞
-(void)onNotifyXunFlyClip
{
    
    if (_iflyRecognizerView == nil)
    {
        _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    }
    _iflyRecognizerView.delegate = self;
    [_iflyRecognizerView setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
    [_iflyRecognizerView setParameter:nil forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    //启动识别服务
    [_iflyRecognizerView start];
}
-(void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    
    NSString *str = [[resultArray lastObject] allKeys][0];
    if ([str isEqualToString:@"。"])
    {
        return;
    }
    else if (_style==1)
    {
        _diagnoseText.text = str;
    }
    else if (_style==2)
    {
        _diseaseMarkText.text = str;
    }
}

- (void)onError: (IFlySpeechError *) error
{
    NSLog(@"==========%@  %d   %d",error.errorDesc,error.errorCode,error.errorType);
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
    if (_dicData != nil)
    {
        _nameText.text = [self.dicData objectForKey:@"patientName"];
        _idText.text = [self.dicData objectForKey:@"idCard"];
        _patientNumText.text = [self.dicData objectForKey:@"medicalCard"];
//        [self getInfoFromIDCard:[self.dicData objectForKey:@"idCard"]];
        
        NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";;
        NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        if (![identityCardPredicate evaluateWithObject:[self.dicData objectForKey:@"idCard"]])
        {
//            kAlter(@"身份证格式错误");
        }
        else
        {
            if ([[self.dicData objectForKey:@"idCard"] length]==18) {
                [self getInfoFromIDCard:[self.dicData objectForKey:@"idCard"]];
            }
        }
    }
}

#pragma mark - 把新增患者信息上传服务器
-(void)createAddPationtInfo
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置组头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    //第一行,组头为0
    if (section==0)
    {
        return CGFLOAT_MIN;
        return tableView.sectionHeaderHeight;
    }
    //其他行数,组头为最小值
    return CGFLOAT_MIN;
    return tableView.sectionHeaderHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

// 设置组尾的高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0)
    {
        return 10;
    }
    return 50;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dealloc
{
    
}

@end
