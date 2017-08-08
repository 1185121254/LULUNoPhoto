//
//  NewPatientScViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/8/10.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "NewPatientScViewController.h"
#import "STPickerArea.h"

#import "iflyMSC/IFlyMSC.h"
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "iflyMSC/IFlySpeechRecognizer.h"

@interface NewPatientScViewController ()<STPickerAreaDelegate,UITextFieldDelegate,BaseDatePickerDelegate,UITextViewDelegate,IFlyRecognizerViewDelegate>
{
//提交按钮
    UIButton *_btnSubmmit;
    
    //生日与常驻城市
    BaseDatePickerViewController *_basePicker;
    STPickerArea *_pickerArea;
    
    IFlyRecognizerView *_iflyRecognizerView;
    NSInteger _btnTag;
    
    NSDateFormatter *_dateFormatte;
    
    BOOL _isSubmmit;
}
@end

@implementation NewPatientScViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [self refreshLayoutNewPatient];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"新增患者";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.scrollNewPatient.backgroundColor = [UIColor whiteColor];
    
    _btnSubmmit = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSubmmit.frame = CGRectMake(0, 0, 40, 40);
    [_btnSubmmit setTitle:@"保存" forState:UIControlStateNormal];
    [_btnSubmmit addTarget:self action:@selector(onSubmmit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:_btnSubmmit];
    self.navigationItem.rightBarButtonItem = right;

    _dateFormatte = [[NSDateFormatter alloc]init];
    [_dateFormatte setDateFormat:@"yyyy-MM-dd"];
    
    [self getdata];

    //添加手势
    [self addGuseture];
}

#pragma mark------------   添加手势
-(void)addGuseture{

    _pickerArea = [[STPickerArea alloc]init];
    //时间选择初始化
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        _basePicker = [[BaseDatePickerViewController alloc]initWithModel:1];
        _basePicker.delegate = self;
        [self.view addSubview:_basePicker];
    });
    
    UITapGestureRecognizer *birthTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onbirthTap)];
    [self.birdView addGestureRecognizer:birthTap];
    
    UITapGestureRecognizer *cityTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oncityTap)];
    [self.cityView addGestureRecognizer:cityTap];
    
}

#pragma mark - 生日pickview
-(void)onbirthTap
{
    [self.view endEditing:YES];
    [_basePicker datePickerShow:[NSDate date] MinDate:nil];
}

-(void)setDateFromDatePicker:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.birdLbl.text = [formatter stringFromDate:date];
    self.birdLbl.textColor = [UIColor blackColor];
}

#pragma mark - 城市pickview
-(void)oncityTap
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
    self.cityLbl.text = text;
    self.cityLbl.textColor = [UIColor blackColor];
}

#pragma mark--------------------从不同地方获取数据
-(void)getdata{
    
    //来自门诊记录的数据
    if (self.dicData) {
        _nameTextFiled.text = [self.dicData objectForKey:@"patientName"];
        _idCardTextFiled.text = [self.dicData objectForKey:@"idCard"];
        _seeDocTextFiled.text = [self.dicData objectForKey:@"medicalCard"];
        
        NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";;
        NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        if ([identityCardPredicate evaluateWithObject:self.idCardTextFiled.text]) {
            [self getInfoFromIDCard:self.idCardTextFiled.text];
        }
    }
    //来自病历夹的数据
    else if (self.patientModel){
        self.title = @"患者资料";
        [_btnSubmmit setTitle:@"编辑" forState:UIControlStateNormal];
        [self handlePatientModel];
        _isSubmmit = NO;
        [self setSubmmitOrNo:_isSubmmit];
    }
//    [self refreshLayoutNewPatient];
}

-(void)handlePatientModel{
    //姓名
    if (self.patientModel.name) {
        self.nameTextFiled.text = self.patientModel.name;
    }
    //身份证
    if (self.patientModel.idCard) {
        self.idCardTextFiled.text = self.patientModel.idCard;
    }
    //性别
    if (self.patientModel.sex == nil) {
        self.btnMan.selected = YES;
        self.btnWoman.selected = NO;
    }else
    {
        if ([self.patientModel.sex integerValue]==1) {
            self.btnMan.selected = YES;
            self.btnWoman.selected = NO;
        }else
        {
            self.btnMan.selected = NO;
            self.btnWoman.selected = YES;
        }
    }
    //年龄
    if (self.patientModel.age) {
        self.ageTextFiled.text = [NSString stringWithFormat:@"%@",self.patientModel.age];
    }
    //生日
    if (self.patientModel.birth) {
        NSArray *arry = [self.patientModel.birth componentsSeparatedByString:@" "];
        NSString *oldbirth = arry[0];
        NSString *newBirth = [oldbirth stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        self.birdLbl.text = newBirth;
        self.birdLbl.textColor = [UIColor blackColor];
    }
    //电话
    if (self.patientModel.tel) {
        self.phoneTextFiled.text = self.patientModel.tel;
    }
    //常驻城市
    if (self.patientModel.city) {
        self.cityLbl.textColor  = [UIColor blackColor];
        self.cityLbl.text = self.patientModel.city;
    }
    //就诊卡号
    if (self.patientModel.medicalCard) {
        self.seeDocTextFiled.text = self.patientModel.medicalCard;
    }
    //门诊号码
    if (self.patientModel.clinicId) {
        self.outPatientTextFiled.text  = self.patientModel.clinicId;
    }
    //疾病诊断
    if (self.patientModel.illness) {
        self.diagnosePlacor.hidden = YES;
        self.diagnoseTextView.text = self.patientModel.illness;
        self.diagnoseHeight.constant = [self textViewheight:self.diagnoseTextView];
    }
    //病例备注
    if (self.patientModel.remark) {
        self.remarkPlacor.hidden = YES;
        self.remarkTextView.text = self.patientModel.remark;
        self.remarkHeight.constant = [self textViewheight:self.remarkTextView];
    }
    [self refreshLayoutNewPatient];
}

#pragma mark--------------------保存
-(void)onSubmmit{
    [self.view endEditing:YES];
    
    if (self.patientModel) {
        if (_isSubmmit == NO) {
            _isSubmmit = YES;
            [self setSubmmitOrNo:YES];
            self.title = @"编辑患者资料";
            [_btnSubmmit setTitle:@"保存" forState:UIControlStateNormal];
        }
        else
        {
            //编辑患者数据
            if ([self formPhoneIdcard]==NO) {
                return;
            }
            //编辑
 
            
            [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/UpPatient",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:[self requsetParamenter] viewConroller:self success:^(id responseObject, BOOL ifTimeout) {

                [self alterController];

            } failure:^(NSError *error) {

                
            }];
        }
    }else
    {
         //保存患者数据
        if ([self formPhoneIdcard]==NO) {
            return;
        }
        //新增

        
        [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/AddPatient",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:[self requsetParamenter] viewConroller:self success:^(id responseObject, BOOL ifTimeout) {

            [self alterController];

        } failure:^(NSError *error) {

        }];

    }
}

#pragma mark----- 判断是否为空
-(BOOL)formPhoneIdcard{
    if (self.nameTextFiled.text == nil||[self.nameTextFiled.text isEqualToString:@""]) {
        kAlter(@"请输入姓名");
        return NO;
    }
    
    if (![self.ageTextFiled.text isEqualToString:@""]) {
        NSString *regex = @"^[0-9]*$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if (![pred evaluateWithObject:self.ageTextFiled.text] || [self.ageTextFiled.text integerValue]<=0) {
            kAlter(@"年龄只能是大于0的数字！");
            return NO;
        }
    }
    
    if (![self.phoneTextFiled.text isEqualToString:@""]) {
        
        NSString *MOBILE = @"^1[34578]\\d{9}$";
        NSPredicate *regexTestMobile = [NSPredicate  predicateWithFormat:@"SELF MATCHES %@",MOBILE];
        if (![regexTestMobile evaluateWithObject:self.phoneTextFiled.text]) {
            kAlter(@"电话号码格式错误");
            return NO;
        }
    }
    
    if (![self.idCardTextFiled.text isEqualToString:@""]) {
        
        NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";;
        NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        if (![identityCardPredicate evaluateWithObject:self.idCardTextFiled.text]) {
            kAlter(@"身份证格式错误");
            return NO;
        }
    }
    return YES;
}

#pragma mark----- 设置参数
-(NSDictionary *)requsetParamenter{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.patientModel.Id) {
        [dic setObject:self.patientModel.Id forKey:@"id"];
    }
    NSString *sex;
    if (self.btnMan.selected == YES) {
        sex = @"1";
    }else
    {
        sex = @"0";
    }
    
    [dic setObject:self.nameTextFiled.text forKey:@"name"];
    [dic setObject:self.idCardTextFiled.text forKey:@"idCard"];
    [dic setObject:sex forKey:@"sex"];
    [dic setObject:self.ageTextFiled.text forKey:@"age"];
    if ([self.birdLbl.text isEqualToString:@"请选择出生日期"]) {
        [dic setObject:@"" forKey:@"birth"];
    }else
    {
        [dic setObject:self.birdLbl.text forKey:@"birth"];
    }
    [dic setObject:self.phoneTextFiled.text forKey:@"tel"];
    if ([self.cityLbl.text isEqualToString:@"请选择常驻城市"]) {
        [dic setObject:@"" forKey:@"city"];
    }else
    {
        [dic setObject:self.cityLbl.text forKey:@"city"];
    }
    [dic setObject:self.seeDocTextFiled.text forKey:@"medicalCard"];
    [dic setObject:self.outPatientTextFiled.text forKey:@"ClinicId"];
    [dic setObject:self.diagnoseTextView.text forKey:@"illness"];
    [dic setObject:self.remarkTextView.text forKey:@"remark"];
    return dic;
}

-(void)alterController{
    UIAlertController *alter = [UIAlertController  alertControllerWithTitle:@"提示" message:@"保存成功" preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alter animated:YES completion:nil];
}

#pragma mark--------------------讯飞语音

- (IBAction)xunFlyBtn:(UIButton *)sender {

    if (_iflyRecognizerView == nil) {
        _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    }
    _btnTag = sender.tag;
    _iflyRecognizerView.delegate = self;
    [_iflyRecognizerView setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
    [_iflyRecognizerView setParameter:nil forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    //启动识别服务
    [_iflyRecognizerView start];
}

-(void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast{
    
    NSString *str = [[resultArray lastObject] allKeys][0];
    if ([str isEqualToString:@"。"]) {
        return;
    }
    if (str != nil) {
        if (_btnTag == 980) {
            self.diagnoseTextView.text = str;
            self.diagnosePlacor.hidden = [self textViewLength:self.diagnoseTextView];
            if ([self textViewTextOutStr:self.diagnoseTextView length:25]) {
                kAlter(@"疾病诊断不能超出25个字符");
            }
            self.diagnoseHeight.constant = [self textViewheight:self.diagnoseTextView];
        }
        else if(_btnTag == 981){
            self.remarkTextView.text = str;
            self.remarkPlacor.hidden = [self textViewLength:self.remarkTextView];
            if ([self textViewTextOutStr:self.remarkTextView length:100]) {
                kAlter(@"症状描述不能超出100个字符");
            }
            self.remarkHeight.constant = [self textViewheight:self.remarkTextView];
        }
        [self refreshLayoutNewPatient];
    }
}

- (void)onError: (IFlySpeechError *) error
{
    NSLog(@"==========%@  %d   %d",error.errorDesc,error.errorCode,error.errorType);
}

#pragma mark--------------------设置性别
- (IBAction)btnSex:(UIButton *)sender {

    if (sender.tag == 123) {
    
        self.btnMan.selected = YES;
        self.btnWoman.selected = NO;
    }else
    {
        self.btnMan.selected = NO;
        self.btnWoman.selected = YES;
    }
    
}

#pragma mark--------------------是否可以编辑
-(void)setSubmmitOrNo:(BOOL)isSubmmit{

    self.nameTextFiled.enabled = isSubmmit;
    self.idCardTextFiled.enabled = isSubmmit;
    self.ageTextFiled.enabled = isSubmmit;
    self.phoneTextFiled.enabled = isSubmmit;
    self.seeDocTextFiled.enabled = isSubmmit;
    self.outPatientTextFiled.enabled = isSubmmit;
    
    self.diagnoseTextView.userInteractionEnabled = isSubmmit;
    self.remarkTextView.userInteractionEnabled = isSubmmit;
    self.cityView.userInteractionEnabled = isSubmmit;
    self.birdView.userInteractionEnabled = isSubmmit;
    self.btnWoman.userInteractionEnabled = isSubmmit;
    self.btnMan.userInteractionEnabled = isSubmmit;
    self.remarkXunFly.userInteractionEnabled = isSubmmit;
    self.diagnoseXunFly.userInteractionEnabled = isSubmmit;
}
#pragma mark--------------------TextViewDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.placeholder = @"";
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField.text isEqualToString:@""]) {
        [self placor:textField];
        return;
    }
    if (textField.tag == 951) {
        NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";;
        NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        if (![identityCardPredicate evaluateWithObject:self.idCardTextFiled.text]) {
            kAlter(@"身份证格式错误");
        }else
        {
            [self getInfoFromIDCard:textField.text];
        }
    }
    else if (textField.tag == 953){
        NSString *MOBILE = @"^1[34578]\\d{9}$";
        NSPredicate *regexTestMobile = [NSPredicate  predicateWithFormat:@"SELF MATCHES %@",MOBILE];
        if (![regexTestMobile evaluateWithObject:self.phoneTextFiled.text]) {
            kAlter(@"电话号码格式错误");
        }
    }
}

-(void)placor:(UITextField *)textFiled{

    if (textFiled.tag == 950) {
        textFiled.placeholder = @"请输入姓名";
    }
    else if (textFiled.tag == 951){
       textFiled.placeholder = @"请输入身份证号";
    }
    else if (textFiled.tag == 952){
        textFiled.placeholder = @"请输入年龄";
    }
    else if (textFiled.tag == 953){
        textFiled.placeholder = @"请输入联系电话";
    }
    else if (textFiled.tag == 954){
        textFiled.placeholder = @"请输入就诊卡号";
    }
    else if (textFiled.tag == 955){
        textFiled.placeholder = @"请输入门诊号码";
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
    
    if (idCard.length == 18) {
        
        NSString *idYear = [idCard substringWithRange:NSMakeRange(6, 4)];
        NSString *idSex = [idCard substringWithRange:NSMakeRange(16, 1)];
        
        if ([idSex integerValue] % 2 == 0)
        {
            self.btnWoman.selected = YES;
            self.btnMan.selected = NO;
        }
        else
        {
            self.btnWoman.selected = NO;
            self.btnMan.selected = YES;
        }
        
        NSInteger age = year - [idYear integerValue];
        self.ageTextFiled.text=[NSString stringWithFormat:@"%d",(int)age];
        //设置出生年月日
        NSString *yearDay =  [NSString stringWithFormat:@"%@-%@-%@",[idCard substringWithRange:NSMakeRange(6, 4)],[idCard substringWithRange:NSMakeRange(10, 2)],[idCard substringWithRange:NSMakeRange(12, 2)]];
        self.birdLbl.text=yearDay;
        self.birdLbl.textColor = [UIColor blackColor];
    }
    else if(idCard.length == 15){
    
        NSString *idYear = [idCard substringWithRange:NSMakeRange(6, 2)];
        NSString *idSex = [idCard substringWithRange:NSMakeRange(14, 1)];
        if ([idSex integerValue] % 2 == 0)
        {
            self.btnWoman.selected = YES;
            self.btnMan.selected = NO;
        }
        else
        {
            self.btnWoman.selected = NO;
            self.btnMan.selected = YES;
        }
        NSInteger age = year - [idYear integerValue]-1900;
        self.ageTextFiled.text=[NSString stringWithFormat:@"%d",(int)age];
        //设置出生年月日
        NSString *yearDay =  [NSString stringWithFormat:@"%@-%@-%@",[NSString stringWithFormat:@"19%@",[idCard substringWithRange:NSMakeRange(6, 2)]],[idCard substringWithRange:NSMakeRange(8, 2)],[idCard substringWithRange:NSMakeRange(10, 2)]];
        self.birdLbl.text=yearDay;
        self.birdLbl.textColor = [UIColor blackColor];
    }

}



#pragma mark--------------------TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.tag == 990) {
        self.diagnosePlacor.hidden = [self textViewLength:textView];
        if ([self textViewTextOutStr:textView length:25]) {
            kAlter(@"疾病诊断不能超出25个字符");
        }
        self.diagnoseHeight.constant = [self textViewheight:textView];
    }
    else if(textView.tag == 991){
        self.remarkPlacor.hidden = [self textViewLength:textView];
        if ([self textViewTextOutStr:textView length:100]) {
            kAlter(@"症状描述不能超出100个字符");
        }
        self.remarkHeight.constant = [self textViewheight:textView];
    }
    [self refreshLayoutNewPatient];
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (textView.tag == 990) {
        self.diagnosePlacor.hidden = YES;
    }
    else if (textView.tag == 991){
        self.remarkPlacor.hidden = YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView.tag == 990) {
        self.diagnosePlacor.hidden = [self textViewLength:textView];
    }
    else if (textView.tag == 991){
        self.remarkPlacor.hidden = [self textViewLength:textView];
    }
}

-(BOOL)textViewTextOutStr:(UITextView *)textView length:(NSInteger)legth{
    
    if (textView.text.length>legth) {
        NSString *outLength = [textView.text substringWithRange:NSMakeRange(legth, textView.text.length-legth)];
        textView.text =  [textView.text stringByReplacingOccurrencesOfString:outLength withString:@""];
        return YES;
    }
    return NO;
}

-(BOOL)textViewLength:(UITextView *)textView{
    if (textView.text.length==0) {
        return NO;
    }
    return YES;
}

-(CGFloat)textViewheight:(UITextView *)textView{
    CGRect bounds = textView.bounds;
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    return newSize.height;
}
#pragma mark--------------------更新约束

-(void)refreshLayoutNewPatient{
    [self.view layoutIfNeeded];
    CGFloat height = self.nameHeight.constant+self.idCardHeight.constant+self.sexheight.constant+self.ageheight.constant+self.birdHeight.constant+self.phoneHeight.constant+self.cityHeight.constant+self.outPatientHeight.constant+self.seeDocHeight.constant+self.diagnoseHeight.constant+self.remarkHeight.constant+5+9*2;
    if (height<=kHeight-64) {
        height = kHeight-64+1;
    }
    self.scrollNewPatient.contentSize = CGSizeMake(kWith, height);
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
