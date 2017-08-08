//
//  MassNoticeViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/10.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "MassNoticeViewController.h"
#import "SeachFriendTableViewCell.h"
#import "SelectFriendsViewController.h"
#import "SendReadlyViewController.h"

@interface MassNoticeViewController ()<UITextViewDelegate>
//发送给谁 高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightSendToVOther;
//主题

@property (weak, nonatomic) IBOutlet UITextField *txt_title;

@property (weak, nonatomic) IBOutlet UITextView *txt_info;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_info;
//发送给
@property (weak, nonatomic) IBOutlet UILabel *txt_sendOther;
@property (weak, nonatomic) IBOutlet UIView *view_sendOther;

@property (strong, nonatomic) NSMutableArray *arr_selectFriend;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForNameView;

//接受这集合
@property (strong, nonatomic) NSMutableArray *arr_sendPeopleList;

@end

@implementation MassNoticeViewController

-(void)viewWillAppear:(BOOL)animated
{
    _arr_sendPeopleList = [[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //发送给谁的文本框
    [self sendToOtherPeopleText];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor =kBackgroundColor;
    // 注册监听者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setArr:) name:@"friendList" object:nil];
    _txt_info.delegate = self;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag==10001)
    {
        if ([textView.text isEqualToString:@"请输入标题"])
        {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }
    else if (textView.tag==10002)
    {
        if ([textView.text isEqualToString:@"请输入内容"])
        {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag==10001)
    {
        if (textView.text.length<1)
        {
            textView.text = @"请输入标题";
            textView.textColor = [UIColor colorWithWhite:0.000 alpha:0.500];
        }
    }
    else if (textView.tag==10002)
    {
        if (textView.text.length<1)
        {
            textView.text = @"请输入内容";
            textView.textColor = [UIColor colorWithWhite:0.000 alpha:0.500];
        }
    }
}


#pragma mark 响应监听通知的方法 (收到通知后的操作)
-(void)setArr:(NSNotification *)notification
{
    // 获取内容
    NSDictionary *dict = notification.userInfo;
    // 获取数据
    _arr_selectFriend = dict[@"selectArr"];
//    NSLog(@"%@",_arr_selectFriend);
}

#pragma mark - 发送给谁的文本框
-(void)sendToOtherPeopleText
{
//    NSMutableString *strName = [[NSMutableString alloc]init];
    NSMutableArray *arr_name = [[NSMutableArray alloc]init];
    for (int i = 0; i<_arr_selectFriend.count; i++)
    {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        dic = _arr_selectFriend[i];
        NSString *str_name = dic[@"userName"];
        NSString *str_name1 =dic[@"name"];
        
        if (str_name!=nil)
        {
//            [strName stringByAppendingFormat:@"%@,%@",strName,str_name1];
            [arr_name addObject:str_name];
        }
        if (str_name1!=nil)
        {
//            [strName stringByAppendingFormat:@"%@,%@",strName,str_name];
             [arr_name addObject:str_name1];
        }
        
    }
    NSString *strName = [arr_name componentsJoinedByString:@"，"];
    CGRect rect = [strName boundingRectWithSize:CGSizeMake(210, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];

    _heightForNameView.constant = rect.size.height+20;
    
    _txt_sendOther.text = strName;

}

//发送
- (IBAction)sendAction:(UIBarButtonItem *)sender
{
    SendReadlyViewController *send = [[SendReadlyViewController alloc]init];
    [self.navigationController pushViewController:send animated:YES];
}

- (IBAction)sendActions:(UIButton *)sender
{
    [self sendToMass];
}

//添加好友按钮
- (IBAction)addAction:(UIButton *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MASS" bundle:[NSBundle mainBundle]];
    SelectFriendsViewController *selectView = [storyboard instantiateViewControllerWithIdentifier:@"SelectFriends"];
    //选中的数据传递过去
    selectView.arr_selectForUppageData = _arr_selectFriend;
    [self.navigationController pushViewController:selectView animated:YES];
}

#pragma mark - 发送通知
-(void)sendToMass
{
    if ([_txt_title.text isEqualToString:@""])
    {
        kAlter(@"请输入标题");
    }
    else if ([_txt_info.text isEqualToString:@"请输入内容"]){
        kAlter(@"请输入内容");
    }
    else if(_arr_selectFriend.count==0)
    {
        [showAlertView showAlertViewWithOnlyMessage:@"请选择通知对象"];
    }
    else
    {
        //发送通知
        [self postSendMass];
    }
}

-(void)postSendMass
{
    //从NSUserDefaults获取身份验证秘钥
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode = [[NSString alloc]init];
    verifyCode=[userdefault objectForKey:@"verifyCode"];
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    //消息主题
    [parameters setObject:[NSString stringWithFormat:@"%@",_txt_title.text] forKey:@"messageTitle"];
    //消息内容
    [parameters setObject:[NSString stringWithFormat:@"%@",_txt_info.text] forKey:@"messageDetail"];
    //发布者ID
    NSString *userID;
    userID = [userdefault objectForKey:@"id"];
    [parameters setObject:[NSString stringWithFormat:@"%@",userID] forKey:@"publisherId"];
    //发布者姓名
    NSMutableDictionary *userDic=[NSMutableDictionary new];
    userDic=[userdefault objectForKey:@"DoctorDataDic"];
    NSString *name = userDic[@"userName"];
    [parameters setObject:name forKey:@"publisherName"];
    
    //接收者集合
    [self createOtherPeopleList];
    [parameters setObject:_arr_sendPeopleList forKey:@"receiverList"];
    [RequestManager postWithURLString:MASSNOTICE heads:heads parameters:parameters success:^(id responseObject) {
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"提交成功" preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }]];
        [self presentViewController:alter animated:YES completion:nil];
    } failure:^(NSError *error){
        NSLog(@"错误 = %@",error);
    }];
}

#pragma mark - 创建接收者的结合
-(void)createOtherPeopleList
{
//    _dic_sendPeopleList =
    for (int i = 0; i<_arr_selectFriend.count; i++)
    {
        NSMutableDictionary *dic = _arr_selectFriend[i];
        NSString *str_other = dic[@"friendId"];//接收者ID
        NSString *str_licenseDept = dic[@"licenseDept"];
        NSString *str_type;//接受者类型
        if (str_licenseDept==nil)//为患者数据
        {
            str_type = @"2";
        }
        else if (str_licenseDept!=nil)//医生数据
        {
            str_type = @"1";
        }
        //创建用户数据集合
        NSMutableDictionary *dicUser = [[NSMutableDictionary alloc]init];
        [dicUser setObject:str_other forKey:@"receiverId"];
        [dicUser setObject:str_type forKey:@"receiverType"];
        if ([dic objectForKey:@"userName"] == nil) {
            [dicUser setObject:[dic objectForKey:@"name"] forKey:@"receiverName"];
        }else
        {
            [dicUser setObject:[dic objectForKey:@"userName"] forKey:@"receiverName"];
        }
        //加入接收者集合中
        [_arr_sendPeopleList addObject:dicUser];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
