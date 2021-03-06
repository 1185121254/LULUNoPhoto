//
//  OutpatientSetting.m
//  HuaxiaDotor
//
//  Created by kock on 16/3/23.
//  Copyright © 2016年 kock. All rights reserved.
//  

#import "OutpatientSetting.h"
#define kMes @"请选择"

@interface OutpatientSetting ()<BasePickerViewDelegate>
{
    NSMutableArray *_arryDataPickName;
    NSMutableArray *_arryDataPickAll;
    
    NSDateFormatter *_dateFormatter;
    BasePickerView *_basePickerView;
    
    NSInteger _selectedTag;
    
}
//普通按钮
@property (weak, nonatomic) IBOutlet UIButton *commonButton;
//专家按钮
@property (weak, nonatomic) IBOutlet UIButton *expertButton;
//特需
@property (weak, nonatomic) IBOutlet UIButton *particularButton;
//专科
@property (weak, nonatomic) IBOutlet UIButton *specialtiesButton;
//国际
@property (weak, nonatomic) IBOutlet UIButton *internationalButton;
//按钮的判断  打开为100 关闭为110
@property (assign, nonatomic) int ButtonTag;
//出诊医院按钮
@property (weak, nonatomic) IBOutlet UIButton *hospitalBtn;
//出诊医院名字
@property (weak, nonatomic) IBOutlet UILabel *hospitalName;
//开始就诊时间
@property (weak, nonatomic) IBOutlet UILabel *lblStartTime;
@property (weak, nonatomic) IBOutlet UIView *startTimeView;
//结束就诊时间
@property (weak, nonatomic) IBOutlet UILabel *lblEndTime;
@property (weak, nonatomic) IBOutlet UIView *endTimeView;
//加号数量
@property (weak, nonatomic) IBOutlet UITextField *addNum;
//备注
@property (weak, nonatomic) IBOutlet UITextView *markText;

//滚动试图
@property (weak, nonatomic) IBOutlet UIScrollView *addCrollerView;
//点击点击试图的tag值
@property (assign, nonatomic)int viewTag;

//挂号类型(1:普通|2:专家|3:特需|4:专科|5：国际)
@property (strong, nonatomic)NSString *xtrType;
//设置用户的ID和VerifyCode
@property (strong, nonatomic)NSString *verifyCode,*userID;
//排号位置
@property (strong, nonatomic)NSString *orderby;
//确定按钮
@property (weak, nonatomic) IBOutlet UIButton *enter;

@property(nonatomic,strong)NSMutableArray *DatePicker;
@end

@implementation OutpatientSetting

-(void)viewDidAppear:(BOOL)animated
{

    
}

#pragma mark - 搜索出诊医院
- (IBAction)seachHospital:(UIButton *)sender
{
    kAlter(@"搜索医院开发中...");
}

//获取本地数据库中的verifyCode和ID
-(void)userDefaultsData
{
    //获取verifyCode 和 ID
    //获取已添加页面的数据
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    self.verifyCode=[userDefaults objectForKey:@"verifyCode"];
    //获取用户ID
    self.userID=[userDefaults objectForKey:@"id"];
    //获取排号的位置
    self.orderby=[userDefaults objectForKey:@"orderby"];
    
    //修改的页面进来的时候默认值
    if (_dicForSetting!=nil)
    {
        _hospitalName.text = _dicForSetting[@"xtrHospital"];
        _lblStartTime.text = _dicForSetting[@"beginSpan"];
        _lblEndTime.text = _dicForSetting[@"endSpan"];
        _addNum.text = _dicForSetting[@"xtrAccount"];
        _markText.text = _dicForSetting[@"remark"];
    }
}


//默认选中按钮
-(void)createCancleBtn
{
    if (_dicForSetting!=nil)
    {
        int i = (int)[_dicForSetting[@"xtrType"] integerValue];
        if (i==1)
        {
            //普通按钮
            [self setbuttonStyleWithButton:self.commonButton OpenButton:YES];
            _xtrType = [NSString stringWithFormat:@"%d",1];
        }
        else if (i==2)
        {
            //专家
            [self setbuttonStyleWithButton:self.expertButton OpenButton:YES];
            _xtrType = [NSString stringWithFormat:@"%d",2];
        }
        else if (i==3)
        {
            //特需
            [self setbuttonStyleWithButton:self.particularButton OpenButton:YES];
            _xtrType = [NSString stringWithFormat:@"%d",3];
        }
        else if (i==4)
        {
            //专科
            [self setbuttonStyleWithButton:self.specialtiesButton OpenButton:YES];
            _xtrType = [NSString stringWithFormat:@"%d",4];
        }
        else if (i==5)
        {
            //国际
            [self setbuttonStyleWithButton:self.internationalButton OpenButton:YES];
            _xtrType = [NSString stringWithFormat:@"%d",5];
        }
    }
    else if (_dicForSetting==nil)
    {
        //默认选中普通按钮普通按钮
        [self setbuttonStyleWithButton:self.commonButton OpenButton:YES];
        //默认为普通挂号
        //排号类型
        self.xtrType=[NSString stringWithFormat:@"%d",1];
    }
    //时间label样式
    self.lblStartTime.layer.borderColor=[UIColor colorWithWhite:0.000 alpha:0.200].CGColor;
    self.lblStartTime.layer.borderWidth=1;
    self.lblStartTime.layer.cornerRadius=3;
    self.lblStartTime.layer.masksToBounds=YES;
    self.lblEndTime.layer.borderColor=[UIColor colorWithWhite:0.000 alpha:0.199].CGColor;
    self.lblEndTime.layer.borderWidth=1;
    self.lblEndTime.layer.cornerRadius=3;
    self.lblEndTime.layer.masksToBounds=YES;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //时间选择器
    _DatePicker = [NSMutableArray array];
    NSMutableArray *arryMin = [NSMutableArray array];
    for (NSInteger i=0; i<60; i++) {
        [arryMin addObject:[NSString stringWithFormat:@"%02ld",i]];
    }
    [_DatePicker addObject:arryMin];
    self.title = @"设置加号信息";
    
    self.view.backgroundColor = kBackgroundColor;
    //按钮风格设置
    [self createButtonStyle];
    //就诊时间的选择
    [self createTimePickView];
    //默认选中按钮
    [self createCancleBtn];
    
    //获取用户的身份数据
    [self userDefaultsData];
    //确定按钮
    self.enter.layer.cornerRadius=5;
    self.enter.layer.masksToBounds=YES;
    NSDictionary *dic = @{@"doctorId":[kUserDefatuel objectForKey:@"id"]};
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetHospitalByDoc",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
        NSMutableArray *arry = [NSMutableArray arrayWithArray:(NSArray *)responseObject];

        _arryDataPickName = [NSMutableArray array];
        _arryDataPickAll = arry;
        for (NSDictionary *dic in arry) {
            [_arryDataPickName addObject:[dic objectForKey:@"hosName"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
    _basePickerView  = [[BasePickerView alloc]init];
    _basePickerView.delegate = self;
    [self.view addSubview:_basePickerView];
    
    _dateFormatter = [[NSDateFormatter alloc]init];
    [_dateFormatter setDateFormat:@"HH:mm"];
    
}

#pragma mark - 就诊时间的选择
-(void)createTimePickView
{
    //给选择器添加点击事件
    UITapGestureRecognizer  *tapGesturesStart=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickViewShow:)];
    UITapGestureRecognizer  *tapGesturesEnd=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pickViewShow:)];
    self.startTimeView.tag=100;
    self.endTimeView.tag=110;
    //两个选择器分别添加点击事件
    [self.startTimeView addGestureRecognizer:tapGesturesStart];
    [self.endTimeView addGestureRecognizer:tapGesturesEnd];
}

#pragma mark------- 出诊医院按钮
- (IBAction)btnChooseHosicap:(id)sender {
    [self.view endEditing:YES];
    if (_arryDataPickName.count >0) {
        NSMutableArray *arry = [NSMutableArray array];
        [arry addObject:_arryDataPickName];
        [_basePickerView pickerDelegateShow:arry];
    }
}

-(void)setPicker:(NSString *)count{
    if (_selectedTag==100) {
        _selectedTag = 0;

        self.lblStartTime.text=count;
        if ([self.lblStartTime.text isEqualToString:kMes]||[self.lblEndTime.text isEqualToString:kMes]) {
            return;
        }
        if ([self judgeSmallORBig:self.lblStartTime.text and:self.lblEndTime.text]!=1) {
            self.lblStartTime.text = kMes;
            kAlter(@"结束时间不能早于开始时间");
            return;
        }
    }
    else if (_selectedTag==110){
        _selectedTag = 0;
        self.lblEndTime.text=count;
        if ([self.lblStartTime.text isEqualToString:kMes]||[self.lblEndTime.text isEqualToString:kMes]) {
            return;
        }
        if ([self judgeSmallORBig:self.lblStartTime.text and:self.lblEndTime.text]!=1) {
            self.lblEndTime.text = kMes;
            kAlter(@"结束时间不能早于开始时间");
            return;
        }

    }
    else
    {
        _hospitalName.text =count;

    }
}

#pragma mark------- 时间选择器点击事件
-(void)pickViewShow:(UITapGestureRecognizer *)viewTag
{
    _selectedTag = viewTag.view.tag;
    [self.view endEditing:YES];
//    [_basePicker datePickerShow:nil MinDate:nil];
    NSArray *arryHour;
    if (_isAfter == NO) {
        arryHour = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11", nil];
    }else
    {
        arryHour = [NSArray arrayWithObjects:@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23", nil];

    }
    if (_DatePicker.count==1) {
        [_DatePicker insertObject:arryHour atIndex:0];
    }
    else if (_DatePicker.count==2){
        [_DatePicker replaceObjectAtIndex:0 withObject:arryHour];
    }
    [_basePickerView pickerDelegateShow:_DatePicker];
    
}

//-(void)setDateFromDatePicker:(NSDate *)date{
//    
//    if (_selectedTag==100)//开始时间
//    {
//        //截取时间
//        self.lblStartTime.text=[_dateFormatter stringFromDate:date];
//    }
//    else if (_selectedTag==110)//结束时间
//    {
//        //截取时间
//        self.lblEndTime.text=[_dateFormatter stringFromDate:date];
//    }
//    if ([self isDateIsTure:date] == NO) {
//        if (_isAfter == NO) {
//            kAlter(@"您当前选择是上午，不能选择下午时间");
//        }else
//        {
//            kAlter(@"您当前选择是下午，不能选择上午时间");
//        }
//        self.lblStartTime.text = kMes;
//        self.lblEndTime.text = kMes;
//        return;
//    }
//    if ([self.lblStartTime.text isEqualToString:kMes]||[self.lblEndTime.text isEqualToString:kMes]) {
//        return;
//    }
//    switch ([self judgeSmallORBig:self.lblStartTime.text and:self.lblEndTime.text]) {
//        case -1:
//        case 0:
//        {
//            self.lblEndTime.text = kMes;
//            kAlter(@"结束时间不能早于开始时间");
//        }
//            break;
//        default:
//            break;
//    }
//    
//}

-(BOOL)isDateIsTure:(NSDate *)date{
    NSString *strNowDate = [_dateFormatter stringFromDate:date];
    NSDate *dateNow = [_dateFormatter dateFromString:strNowDate];
    long long nowInter = [dateNow timeIntervalSince1970];
    if (_isAfter==NO)
    {
        NSDate *minDate = [_dateFormatter dateFromString:@"00:00"];
        long long minInter = [minDate timeIntervalSince1970];
        NSDate *maxDate = [_dateFormatter dateFromString:@"11:59"];
        long long maxInter = [maxDate timeIntervalSince1970];
        if (minInter <= nowInter &&nowInter<maxInter) {
            return YES;
        }
        return NO;
    }
    else
    {
        NSDate *minDate = [_dateFormatter dateFromString:@"12:00"];
        NSDate *maxDate = [_dateFormatter dateFromString:@"23:59"];
        long long minInter = [minDate timeIntervalSince1970];
        long long maxInter = [maxDate timeIntervalSince1970];
        if (minInter <= nowInter &&nowInter<maxInter) {
            return YES;
        }
        return NO;
        
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


#pragma mark - 各个按钮的方法
//普通按钮 commonButton
- (IBAction)commonButton:(UIButton *)sender
{
    //普通按钮
    [self setbuttonStyleWithButton:self.commonButton OpenButton:YES];
    //专家
    [self setbuttonStyleWithButton:self.expertButton OpenButton:NO];
    //特需
    [self setbuttonStyleWithButton:self.particularButton OpenButton:NO];
    //专科
    [self setbuttonStyleWithButton:self.specialtiesButton OpenButton:NO];
    //国际
    [self setbuttonStyleWithButton:self.internationalButton OpenButton:NO];
    //排号类型
    self.xtrType=[NSString stringWithFormat:@"%d",1];
}

//专家按钮 expertButton
- (IBAction)expertButton:(UIButton *)sender
{
    //普通按钮
    [self setbuttonStyleWithButton:self.commonButton OpenButton:NO];
    //专家
    [self setbuttonStyleWithButton:self.expertButton OpenButton:YES];
    //特需
    [self setbuttonStyleWithButton:self.particularButton OpenButton:NO];
    //专科
    [self setbuttonStyleWithButton:self.specialtiesButton OpenButton:NO];
    //国际
    [self setbuttonStyleWithButton:self.internationalButton OpenButton:NO];
    //排号类型
    self.xtrType=[NSString stringWithFormat:@"%d",2];
}

//特需 particularButton
- (IBAction)particularButton:(UIButton *)sender
{
    //普通按钮
    [self setbuttonStyleWithButton:self.commonButton OpenButton:NO];
    //专家
    [self setbuttonStyleWithButton:self.expertButton OpenButton:NO];
    //特需
    [self setbuttonStyleWithButton:self.particularButton OpenButton:YES];
    //专科
    [self setbuttonStyleWithButton:self.specialtiesButton OpenButton:NO];
    //国际
    [self setbuttonStyleWithButton:self.internationalButton OpenButton:NO];
    //排号类型
    self.xtrType=[NSString stringWithFormat:@"%d",3];
}

//专科 specialtiesButton
- (IBAction)secialtiesButton:(UIButton *)sender
{
    //普通按钮
    [self setbuttonStyleWithButton:self.commonButton OpenButton:NO];
    //专家
    [self setbuttonStyleWithButton:self.expertButton OpenButton:NO];
    //特需
    [self setbuttonStyleWithButton:self.particularButton OpenButton:NO];
    //专科
    [self setbuttonStyleWithButton:self.specialtiesButton OpenButton:YES];
    //国际
    [self setbuttonStyleWithButton:self.internationalButton OpenButton:NO];
    //排号类型
    self.xtrType=[NSString stringWithFormat:@"%d",4];

}

//国际 internationalButton
- (IBAction)internationalButton:(UIButton *)sender
{
    //普通按钮
    [self setbuttonStyleWithButton:self.commonButton OpenButton:NO];
    //专家
    [self setbuttonStyleWithButton:self.expertButton OpenButton:NO];
    //特需
    [self setbuttonStyleWithButton:self.particularButton OpenButton:NO];
    //专科
    [self setbuttonStyleWithButton:self.specialtiesButton OpenButton:NO];
    //国际
    [self setbuttonStyleWithButton:self.internationalButton OpenButton:YES];

    //排号类型
    self.xtrType=[NSString stringWithFormat:@"%d",5];
}


- (IBAction)hospitalBtn:(UIButton *)sender
{

    
}

#pragma mark - 设置按钮样式
-(void)createButtonStyle
{
        //普通按钮
        [self setbuttonStyleWithButton:self.commonButton OpenButton:NO];
        //专家
        [self setbuttonStyleWithButton:self.expertButton OpenButton:NO];
        //特需
        [self setbuttonStyleWithButton:self.particularButton OpenButton:NO];
        //专科
        [self setbuttonStyleWithButton:self.specialtiesButton OpenButton:NO];
        //国际
        [self setbuttonStyleWithButton:self.internationalButton OpenButton:NO];
}

/**
 *  按钮是否打开的风格
 *
 *  @param button 按钮
 *  @param open   按钮是否打开
 */
-(void)setbuttonStyleWithButton:(UIButton *)button OpenButton:(BOOL)open
{
    if (open==YES)
    {
        [button.layer setBorderColor:[UIColor whiteColor].CGColor];
        [button.layer setBorderWidth:0.0];
        [button.layer setMasksToBounds:YES];
        [button setBackgroundColor:[UIColor colorWithRed:0.353 green:0.675 blue:0.847 alpha:1.000]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.ButtonTag=100;
    }
    else
    {
        [button.layer setBorderColor:[UIColor colorWithWhite:0.000 alpha:0.500].CGColor];
        [button.layer setBorderWidth:0.5];
        [button.layer setMasksToBounds:YES];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.ButtonTag=110;
    }
}

#pragma mark - 确定按钮
//页面上确定
- (IBAction)enterSetting:(UIButton *)sender
{
    //上传前判断正确性
    [self getViewUserData];
}

////导航栏上确定
//- (IBAction)accountSetting:(UIBarButtonItem *)sender
//{
//    //上传前判断正确性
//    [self getViewUserData];
//
//}

#pragma mark - 获取页面上的数据,确人上传前判断
-(void)getViewUserData
{
    NSString *Str_Count = [NSString stringWithFormat:@"%@",_addNum.text];
    NSString *Regex = @"^[0-9]*$";
    NSPredicate *RegexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    //判断医院是否为空
    if ((self.hospitalName==nil)||[self.hospitalName.text isEqualToString:@""])
    {
        kAlter(@"请选择出诊医院");
    }
    else if ([self.lblStartTime.text isEqualToString:kMes]||[self.lblEndTime.text isEqualToString:kMes])
    {
        kAlter(@"请选择就诊时间");
    }
    else if([self.addNum.text isEqualToString:@""]||(self.addNum.text==nil))
    {
        
        kAlter(@"请添加号数量");
    }
    else if([RegexTest evaluateWithObject:Str_Count])
    {
        //调用确认上传的方法
        [self createAddManagerPOSTData];
    }
    else
    {
        kAlter(@"加号数量为数字");
    }
}

#pragma mark - 加号信息的数据上传
-(void)createAddManagerPOSTData
{
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:self.verifyCode};
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    
    //获取需要上传的数据
    //ID
    [parameters setObject:self.userID forKey:@"doctorId"];
    //排号位置
    [parameters setObject:[NSString stringWithFormat:@"%@",self.orderby]forKey:@"orderby"];
    //开始时间
    [parameters setObject:[NSString stringWithFormat:@"%@",self.lblStartTime.text]forKey:@"beginSpan"];
    //结束时间
    [parameters setObject:[NSString stringWithFormat:@"%@",self.lblEndTime.text] forKey:@"endSpan"];
    //挂号数量
    [parameters setObject:[NSString stringWithFormat:@"%@",self.addNum.text] forKey:@"xtrAccount"];
    //门诊医院
    [parameters setObject:[NSString stringWithFormat:@"%@",self.hospitalName.text] forKey:@"xtrHospital"];
    //排号类型
    [parameters setObject:[NSString stringWithFormat:@"%@",self.xtrType] forKey:@"xtrType"];
    //备注
    [parameters setObject:[NSString stringWithFormat:@"%@",self.markText.text] forKey:@"remark"];
    for (NSDictionary *dic in _arryDataPickAll) {
        if ([self.hospitalName.text isEqualToString:[dic objectForKey:@"hosName"]]) {
            [parameters setObject:[dic objectForKey:@"hospitalId"] forKey:@"hospitalId"];
            break;
        }
    }
    if (_dicForSetting!=nil)
    {
        //记录id
        [parameters setObject:[NSString stringWithFormat:@"%@",_dicForSetting[@"id"]] forKey:@"Id"];
    }
    if (_dicForSetting==nil)
    {
        //POST
        [RequestManager postWithURLString:DOCTOR_ADD_PATIENTS heads:heads parameters:parameters success:^(id responseObject) {
            
            [self setAlter:@"添加成功"];
            
        } failure:^(NSError *error)
         {
             NSLog(@"%@",error);
         }];
    }
    else if (_dicForSetting!=nil)
    {
        //POST
        [RequestManager postWithURLString:DOCTOR_ADD_UPDATE heads:heads parameters:parameters success:^(id responseObject) {
  
            [self setAlter:@"修改成功"];
            
    } failure:^(NSError *error)
         {
             NSLog(@"%@",error);
         }];
    }
}

-(void)setAlter:(NSString *)mes{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:mes preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }]];
    [self presentViewController:alter animated:YES completion:nil];
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
