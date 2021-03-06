//
//  AddManagerSetting.m
//  HuaxiaDotor
//
//  Created by kock on 16/3/23.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AddManagerSetting.h"
//门诊类型设置
#import "OutpatientSetting.h"
@interface AddManagerSetting ()

//给医生看的信息
@property (weak, nonatomic) IBOutlet UILabel *lblMessage1;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage2;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage3;
@property (weak, nonatomic) IBOutlet UILabel *lblMessageLook;

@property (weak, nonatomic) IBOutlet UILabel *lblPrice;

@property (weak, nonatomic) IBOutlet UIView *viewPrice;
@property (weak, nonatomic) IBOutlet UIView *viewConnect;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *lblView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SuperView;


//周一 到 周日 上午到下午
//一
@property (weak, nonatomic) IBOutlet UIButton *BtnMonAM;
@property (weak, nonatomic) IBOutlet UIButton *BtnMonPM;
//二
@property (weak, nonatomic) IBOutlet UIButton *BtnTuesAM;
@property (weak, nonatomic) IBOutlet UIButton *BtnTuesPM;
//三
@property (weak, nonatomic) IBOutlet UIButton *BtnWedAM;
@property (weak, nonatomic) IBOutlet UIButton *BtnWedPM;
//四
@property (weak, nonatomic) IBOutlet UIButton *BtnThursAM;
@property (weak, nonatomic) IBOutlet UIButton *BtnThursPM;
//五
@property (weak, nonatomic) IBOutlet UIButton *BtnFriAM;
@property (weak, nonatomic) IBOutlet UIButton *BtnFriPM;
//六
@property (weak, nonatomic) IBOutlet UIButton *BtnSatAM;
@property (weak, nonatomic) IBOutlet UIButton *BtnSatPM;
//日
@property (weak, nonatomic) IBOutlet UIButton *BtnSunAM;
@property (weak, nonatomic) IBOutlet UIButton *BtnSunPM;


//设置用户的ID和VerifyCode
@property (strong, nonatomic)NSString *verifyCode,*userID;
//按钮位置
@property (strong, nonatomic) NSString *orderby;
//排号星期
@property (strong, nonatomic) NSString *week;
//上下午
@property (strong, nonatomic) NSString *timeType;
//开始时间
@property (strong, nonatomic) NSString *beginSpan;
//结束时间
@property (strong, nonatomic) NSString *endSpan;
//挂号数量
@property (strong, nonatomic) NSString *xtrAccount;
//门诊医院
@property (strong, nonatomic) NSString *xtrHospital;
//挂号价格
@property (strong, nonatomic) NSString *xtrPrice;
//备注
@property (strong, nonatomic) NSString *remark;

//按钮上的数据数组
@property (strong, nonatomic) NSMutableArray *buttonDataArr;
//排号ID 做删除用
@property (strong, nonatomic) NSString *lottoID;
//修改传进去的ID
@property (strong, nonatomic) NSMutableDictionary *dicForSetting;
//@property(strong, nonatomic) NSMutableDictionary *userDataDic;
//修改界面背景试图
@property (strong, nonatomic) UIView *shadeView;
//提示框
@property (strong, nonatomic) CXAlertView *cxAlertView;

@end

@implementation AddManagerSetting


-(void)viewWillAppear:(BOOL)animated
{
    //获取页面上的数据
    [self postPageData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:0.965 green:0.969 blue:0.984 alpha:1.000];
    self.scrollView.showsVerticalScrollIndicator = NO;
    //导航栏的字体和颜色
    self.title=@"加号设置";
    //导航栏标题的颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];

    NSDictionary *dic = [kUserDefatuel objectForKey:@"VasSet3"];
    _lblPrice.textAlignment = 1;
    _lblPrice.text = [dic objectForKey:@"price"];
    
    
    if ([self.from isEqualToString:@"add"])
    {
        self.view.frame =  CGRectMake(0, 284, kWith, kHeight-284);
        self.scrollView.backgroundColor = kBackgroundColor;
        self.lblView.backgroundColor = kBackgroundColor;
        self.SuperView.priority = UILayoutPriorityDefaultHigh;
        self.topView.priority = UILayoutPriorityDefaultLow;
    }
    else{
        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.lblView.backgroundColor = [UIColor whiteColor];
        self.topView.priority = UILayoutPriorityDefaultHigh;
        self.SuperView.priority = UILayoutPriorityDefaultLow;
    }
}

#pragma mark - 获取对应的按钮tag值存入userdeaults中
//获取对应的按钮tag值存入userdeaults中
-(void)buttonTagInUserDefaults
{
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    //存入排号位置
    [userDefaults setObject:self.orderby forKey:@"orderby"];
    
    [[NSUserDefaults standardUserDefaults]synchronize];
}


#pragma mark - 星期按钮
//一
- (IBAction)BtnMonAMaction:(UIButton *)sender
{
    //设置按钮位置
    self.orderby=[NSString stringWithFormat:@"%d",0];
    //判断加号的按钮是跳转或者修改删除
    [self changeButtonInfoData:sender AMorPM:NO];
}

- (IBAction)BtnMonPMaction:(UIButton *)sender
{
    //设置按钮位置
    self.orderby=[NSString stringWithFormat:@"%d",1];
    //判断加号的按钮是跳转或者修改删除
    [self changeButtonInfoData:sender AMorPM:YES];
}

//二
- (IBAction)BtnTuesAMaction:(UIButton *)sender
{
    //设置按钮位置
    self.orderby=[NSString stringWithFormat:@"%d",2];
    //判断加号的按钮是跳转或者修改删除
    [self changeButtonInfoData:sender AMorPM:NO];
}

- (IBAction)BtnTuesPMaction:(UIButton *)sender
{
    
    //设置按钮位置
    self.orderby=[NSString stringWithFormat:@"%d",3];
    //判断加号的按钮是跳转或者修改删除
    [self changeButtonInfoData:sender AMorPM:YES];
}

//三
- (IBAction)BtnWedAMaction:(UIButton *)sender
{
    //设置按钮位置
    self.orderby=[NSString stringWithFormat:@"%d",4];
    //判断加号的按钮是跳转或者修改删除
    [self changeButtonInfoData:sender AMorPM:NO];
}

- (IBAction)BtnWedPMaction:(UIButton *)sender
{
    //设置按钮位置
    self.orderby=[NSString stringWithFormat:@"%d",5];
    //判断加号的按钮是跳转或者修改删除
    [self changeButtonInfoData:sender AMorPM:YES];
}

//四
- (IBAction)BtnThursAMaction:(UIButton *)sender
{
    //设置按钮位置
    self.orderby=[NSString stringWithFormat:@"%d",6];
    //判断加号的按钮是跳转或者修改删除
    [self changeButtonInfoData:sender AMorPM:NO];
}

- (IBAction)BtnThursPMaction:(UIButton *)sender
{
    //设置按钮位置
    self.orderby=[NSString stringWithFormat:@"%d",7];
    //判断加号的按钮是跳转或者修改删除
    [self changeButtonInfoData:sender AMorPM:YES];
}

//五
- (IBAction)BtnFriAMaction:(UIButton *)sender
{
    //设置按钮位置
    self.orderby=[NSString stringWithFormat:@"%d",8];
    //判断加号的按钮是跳转或者修改删除
    [self changeButtonInfoData:sender AMorPM:NO];
}
- (IBAction)BtnFriPMaction:(UIButton *)sender
{
    //设置按钮位置
    self.orderby=[NSString stringWithFormat:@"%d",9];
    //判断加号的按钮是跳转或者修改删除
    [self changeButtonInfoData:sender AMorPM:YES];
}

//六
- (IBAction)BtnSatAMaction:(UIButton *)sender
{
    //设置按钮位置
    self.orderby=[NSString stringWithFormat:@"%d",10];
    //判断加号的按钮是跳转或者修改删除
    [self changeButtonInfoData:sender AMorPM:NO];
}
- (IBAction)BtnSatPMaction:(UIButton *)sender
{
    //设置按钮位置
    self.orderby=[NSString stringWithFormat:@"%d",11];
    //判断加号的按钮是跳转或者修改删除
    [self changeButtonInfoData:sender AMorPM:YES];
}

//日
- (IBAction)BtnSunAMaction:(UIButton *)sender
{
    //设置按钮位置
    self.orderby=[NSString stringWithFormat:@"%d",12];
    //判断加号的按钮是跳转或者修改删除
    [self changeButtonInfoData:sender AMorPM:NO];
}

- (IBAction)BtnSunPMaction:(UIButton *)sender
{
    //设置按钮位置
    self.orderby=[NSString stringWithFormat:@"%d",13];
    //判断加号的按钮是跳转或者修改删除
    [self changeButtonInfoData:sender AMorPM:NO];
}



#pragma mark - 判断加号的按钮是跳转或者修改删除
-(void)changeButtonInfoData:(UIButton *)sender AMorPM:(BOOL)isAfter
{
    if ([sender.titleLabel.text isEqualToString:@"点击设置"])
    {
        //存入suerdefaults
        [self buttonTagInUserDefaults];
        //跳转到设置页面
        [self createrSettingViewSendDicData:NO AMorPM:isAfter];
    }
    else
    {
        //存入suerdefaults
        [self buttonTagInUserDefaults];
        //弹出修改或者删除按钮
        [self createChangeAndDeleteAmOrPM:isAfter];
    }
}

#pragma mark - 弹出修改或者删除按钮
-(void)createChangeAndDeleteAmOrPM:(BOOL)isAfter
{
    //创建遮盖试图
    _shadeView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    _shadeView.backgroundColor=[UIColor colorWithWhite:0.500 alpha:0.301];
    [self.view addSubview:_shadeView];
    
    //创建提示框
    _cxAlertView = [[CXAlertView alloc]initWithTitle:nil message:@"请选择修改或关闭该服务" cancelButtonTitle:nil];
    //取消修改
    UITapGestureRecognizer *singerRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelSetting)];
    [_cxAlertView addGestureRecognizer:singerRecognizer];
    
    [_cxAlertView addButtonWithTitle:@"关闭"
                               type:CXAlertViewButtonTypeCustom
                            handler:^(CXAlertView *alertView, CXAlertButtonItem *button){
                                alertView.showBlurBackground = YES;
                                [alertView dismiss];
                                [_shadeView removeFromSuperview];
                                //调用删除功能
                                [self deleteAddManager];
                            }];
    [_cxAlertView addButtonWithTitle:@"修改"
                               type:CXAlertViewButtonTypeCustom
                            handler:^(CXAlertView *alertView, CXAlertButtonItem *button){
                                alertView.showBlurBackground = YES;
                                [alertView dismiss];
                                [_shadeView removeFromSuperview];
                                //修改功能
                                [self settingManager];
                                
                                //跳转到设置修改页面
                                [self createrSettingViewSendDicData:YES AMorPM:isAfter];
                            }];
    _cxAlertView.showBlurBackground = NO;
    [_cxAlertView show];
}

#pragma mark - 取消修改操作
-(void)cancelSetting
{
    [_shadeView removeFromSuperview];
    [_cxAlertView dismiss];
}

#pragma mark - 加号管理的修改功能
-(void)settingManager
{
    //获取需要上传的数据
    NSString *delegateID;
    int orderBy=-1;
    //通过orderby获取id
    for (int i =0 ; i<_buttonDataArr.count; i++)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        dic = _buttonDataArr[i];
        int XForOrderby = [[NSString stringWithFormat:@"%@",self.orderby] intValue];
        orderBy = (int)[dic[@"orderby"] integerValue];
        if (XForOrderby==orderBy)
        {
            delegateID = dic[@"id"];
            _dicForSetting = dic;
        }
    }
}

#pragma mark - 加号管理删除功能
-(void)deleteAddManager
{
    //获取verifyCode 和 ID
    //获取已添加页面的数据
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    self.verifyCode=[userDefaults objectForKey:@"verifyCode"];
    //获取排号的位置
    self.orderby=[userDefaults objectForKey:@"orderby"];
    
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:self.verifyCode};

    //获取需要上传的数据
    NSString *delegateID;
    int orderByForDic=-99;
    int YforOrderBy=-99;
    //通过orderby获取id
    for (int i =0 ; i<_buttonDataArr.count; i++)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        dic = _buttonDataArr[i];
        int XForOrderby = [[NSString stringWithFormat:@"%@",self.orderby] intValue];
        orderByForDic = (int)[dic[@"orderby"] integerValue];
        
        if (XForOrderby==orderByForDic)
        {
            delegateID = dic[@"id"];
            YforOrderBy = (int)[dic[@"orderby"] integerValue];
        }
    }
    
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    [parameters setObject:delegateID forKey:@"Id"];
    //GET
    [RequestManager getWithURLString:DOCTOR_SETTING_REMOVE heads:heads parameters:parameters success:^(id responseObject)
     {
         [showAlertView showAlertViewWithMessage:@"删除成功"];
         //删除后修改按钮的状态
             UIButton *Label=(UIButton *)[self.view viewWithTag:YforOrderBy+20];
             [Label setTitle:[NSString stringWithFormat:@"点击设置"] forState:UIControlStateNormal];
             [Label setTitleColor:BLUECOLOR_STYLE forState:UIControlStateNormal];
         //移除相对应的字典
         NSDictionary *dicp = [[NSDictionary alloc]init];
         for (NSMutableDictionary * dic in _buttonDataArr)
         {
             int order = (int)[dic[@"orderby"] integerValue];
             if (order==YforOrderBy)
             {
                 dicp = dic;
                 return;
             }
         }
         //移除数组中的对应数据
         [_buttonDataArr removeObject:dicp];
         
     } failure:^(NSError *error) {
         NSLog(@"error===%@",error);
     }];
}

#pragma mark - GET获取页面上按钮的数据
-(void)postPageData
{
    //获取已添加页面的数据
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    self.verifyCode=[userDefaults objectForKey:@"verifyCode"];
    //获取用户ID
    self.userID=[userDefaults objectForKey:@"id"];

    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:self.verifyCode};
    
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    
    //获取需要上传的数据
    //ID
    [parameters setObject:[NSString stringWithFormat:@"%@",self.userID] forKey:@"doctorId"];
    //排号位置
//    [parameters setObject:[NSString stringWithFormat:@"%@",self.orderby]forKey:@"orderby"];

    //GET 
    [RequestManager getWithURLString:DOCTOR_SETTING_LIST heads:heads parameters:parameters success:^(id responseObject)
     {
         NSMutableDictionary *buttonsData=(NSMutableDictionary *)responseObject;
         _buttonDataArr=[NSMutableArray new];
         _buttonDataArr = buttonsData[@"value"];
         
         //根据传入的数组来设置按钮的标题
        [self setButtonTitle:_buttonDataArr];
      
    } failure:^(NSError *error) {
        NSLog(@"GET获取页面上按钮的数据===%@",error);
    }];
}

#pragma mark - 根据传入的数组来设置按钮的标题
-(void)setButtonTitle:(NSMutableArray *)buttonDataArr
{
    //获取按钮上的字典数据并设置在相应按钮上
    for (int i=0; i<buttonDataArr.count; i++)
    {
        //初始化字典
        NSMutableDictionary *buttonDataDic=buttonDataArr[i];
        //按钮的位置
        int orderby=[buttonDataDic[@"orderby"]intValue];
        //排号的类型
        int xtrTypeInt=[buttonDataDic[@"xtrType"]intValue];
        //排号的数量
        int xtrAccount=[buttonDataDic[@"xtrAccount"]intValue];
        
        if (xtrTypeInt==1)
        {
            //普通
            UIButton *Label=(UIButton *)[self.view viewWithTag:orderby+20];
            [Label setTitle:[NSString stringWithFormat:@"普通号%d个",xtrAccount] forState:UIControlStateNormal];
             [Label setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        else if (xtrTypeInt==2)
        {
            //专家
            UIButton *Label=(UIButton *)[self.view viewWithTag:orderby+20];
            [Label setTitle:[NSString stringWithFormat:@"专家号%d个",xtrAccount] forState:UIControlStateNormal];
            [Label setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        else if(xtrTypeInt==3)
        {
            //特需
            UIButton *Label=(UIButton *)[self.view viewWithTag:orderby+20];
            [Label setTitle:[NSString stringWithFormat:@"特需号%d个",xtrAccount] forState:UIControlStateNormal];
            [Label setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        else if(xtrTypeInt==4)
        {
            //专科
            UIButton *Label=(UIButton *)[self.view viewWithTag:orderby+20];
            [Label setTitle:[NSString stringWithFormat:@"专科号%d个",xtrAccount] forState:UIControlStateNormal];
            [Label setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        else if (xtrTypeInt==5)
        {
            //国际
            UIButton *Label=(UIButton *)[self.view viewWithTag:orderby+20];
            [Label setTitle:[NSString stringWithFormat:@"国际号%d个",xtrAccount] forState:UIControlStateNormal];
            [Label setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
}



#pragma mark - 跳转到设置门诊类型页面
-(void)createrSettingViewSendDicData:(BOOL)select AMorPM:(BOOL)isAfter
{
    UIStoryboard *outpatientSetting=[UIStoryboard storyboardWithName:@"AddManager" bundle:[NSBundle mainBundle]];
    //指定对应的故事版
    OutpatientSetting *outpatientSettingView=[outpatientSetting instantiateViewControllerWithIdentifier:@"OutpatientSetting"];
    if (select==YES)
    {
        outpatientSettingView.dicForSetting = _dicForSetting;
    }
    outpatientSettingView.isAfter = isAfter;
    [self.navigationController pushViewController:outpatientSettingView animated:YES];
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
