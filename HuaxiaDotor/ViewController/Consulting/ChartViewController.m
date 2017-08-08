//
//  ChartViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/4.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ChartViewController.h"
#import "UUInputFunctionView.h"
#import "MJRefresh.h"
#import "UUMessageCell.h"
#import "IQKeyboardManager.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"
#import "UUInputView.h"
#import "MessageCustomCell.h"
#import "MessageSystemTableViewCell.h"
#import "Attachment.h"

#import "ScrollAdviceViewController.h"

#import "ConsultingViewController.h"
#import "PatientDetailViewController.h"
#import "AdminAdviceViewController.h"
#import "ConsultationDetailViewController.h"


@interface ChartViewController ()<UUInputFunctionViewDelegate,UUMessageCellDelegate,UITableViewDataSource,UITableViewDelegate,NIMChatManagerDelegate,NIMChatManager,NIMConversationManagerDelegate,NIMSystemNotificationManagerDelegate,UUInputViewDelegate>

//@property (strong, nonatomic) ChatModel *chatModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


@end

@implementation ChartViewController

{
    UUInputFunctionView *IFView;
    UUInputView *InPutView;
    UUMessageFrame *messageFrame;
    
    UITableView *_tableView;

    NIMSession *_patientSession;
    
    NSDictionary *_sendDic;
    NSMutableDictionary *_doctorBaseDic;
    NSMutableDictionary *_patientBaseDic;
    NSDictionary *_patientDic;
    NSDictionary *_receiveDic;
    
    NSMutableArray *_arryData;
    
    UIView *_addView;
    
    //是否是医生发的第一条消息
    BOOL _isFirstMsg;
    //医生是否已经回复
    BOOL _isDoctorRead;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeChat:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeChat:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottomChat) name:UIKeyboardDidShowNotification object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.patient.patientName;
    _arryData = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickAvter) name:@"dlickAvter" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickPhoneNum:) name:@"clickPhoneNum" object:nil];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapC)];
    [self.view addGestureRecognizer:tap];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWith, kHeight - 64 - 40)];
//    _tableView.rowHeight = UITableViewAutomaticDimension;
//    _tableView.estimatedRowHeight = 200;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    UIBarButtonItem *right                    = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"点"] style:UIBarButtonItemStylePlain target:self action:@selector(onRight)];
    self.navigationItem.rightBarButtonItem    = right;

    UIBarButtonItem *back                     = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];
    self.navigationItem.leftBarButtonItem     = back;
    
    [self addViewRightAngle];

    [self setDataOfDoctor];
    [self setDataOfPatient];
    [self loadBaseViewsAndData];
    
    _patientSession = [NIMSession session:self.patient.patientIM type:NIMSessionTypeP2P];
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    [self setChatList];
}
-(void)onTapC{
    _addView.hidden = YES;
    [self changeFramImageTxt];
    [IFView.TextViewInput resignFirstResponder];
}

#pragma mark 右按钮项
-(void)addViewRightAngle{
    _addView = [[UIView alloc]init];
    _addView.backgroundColor = [UIColor whiteColor];
    NSArray *arry = [[NSArray alloc]initWithObjects:@"患者详情",@"诊断建议",@"发起结束", nil];
    float heigth = (100-2)/3;
    
    NSInteger count;
    if ([self.state integerValue]==4) {
        count = 2;
        _addView.frame = CGRectMake(kWith-13-88, 6+60, 100, 100-heigth);
    }
    else{
        _addView.frame = CGRectMake(kWith-13-88, 6+60, 100, 100);
        count =3;
    }
    
    for (NSInteger i = 0; i<count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor colorWithRed:59/255.0 green:175/255.0 blue:217/255.0 alpha:1];
        btn.frame = CGRectMake(0, (heigth+1)*i+2, 100, heigth);
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = i+110;
        [btn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:arry[i] forState:UIControlStateNormal];
        [_addView addSubview:btn];
    }
    _addView.hidden = YES;
    [self.view addSubview:_addView];
}

-(void)onRight{
    if (_addView.hidden == YES) {
        _addView.hidden = NO;
    }
    else
    {
        _addView.hidden = YES;
    }
    
}

-(void)onBtn:(UIButton *)btn{
    if (btn.tag == 110) {
        PatientDetailViewController *detail= [[PatientDetailViewController alloc]init];
        detail.patient = self.patient;
        [self.navigationController pushViewController:detail animated:YES];
    }else if (btn.tag == 111){
        if ([self.state integerValue]==4) {
            
            ScrollAdviceViewController  *advice = [[ScrollAdviceViewController alloc]init];
            advice.patient = self.patient;
            advice.from = @"BennOver";
            [self.navigationController pushViewController:advice animated:YES];

        }else
        {
            ScrollAdviceViewController *advice = [[ScrollAdviceViewController alloc]init];
            advice.patient = self.patient;
            advice.from = @"BeenReply";
            [self.navigationController pushViewController:advice animated:YES];
        }

    }else
    {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"您好，您确定现在发起结束对%@的图文咨询吗？",self.patient.patientName] preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self sendSystemNotificationWithContent:[NSString stringWithFormat:@"3:%@",self.patient.Id]];
        }]];
        
        [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alter animated:YES completion:nil];
    }
    _addView.hidden = YES;
}

#pragma mark 设置列表
-(void)setChatList
{
    //添加系统数据
    [self getHisToreyFromDBAddSever];
}

#pragma mark 历史数据

-(void)getHisToreyFromDBAddSever{

    NSArray *historyMessageArray = [[NIMSDK sharedSDK].conversationManager messagesInSession:_patientSession message:nil limit:NSIntegerMax];
    if (historyMessageArray.count==0) {
        
        NIMHistoryMessageSearchOption *op = [[NIMHistoryMessageSearchOption  alloc]init];
        op.currentMessage = nil;
        op.startTime = 0;
        op.limit = 100;
        op.sync = YES;
        [[NIMSDK sharedSDK].conversationManager fetchMessageHistory:_patientSession option:op result:^(NSError * _Nullable error, NSArray<NIMMessage *> * _Nullable messages) {
            if (!error) {
                NSArray * array = [[messages reverseObjectEnumerator] allObjects];
                [self getHistoryMessage:array];
            }
        }];
    }else
    {
        [self getHistoryMessage:historyMessageArray];
    }
}

-(void)getHistoryMessage:(NSArray *)array
{
    BOOL isCustom = NO;
    
    for (NSInteger i    = 0; i<array.count; i++) {
    NIMMessage *message = [array objectAtIndex:i];

    NSDictionary *dic   = message.remoteExt;
    if ([self.patient.Id isEqualToString:[dic objectForKey:@"order"]] && [[dic objectForKey:@"source"] integerValue]==1) {
        
        if ([message.from isEqualToString:kDoctorIM]) {
            _isFirstMsg = YES;
            _isDoctorRead = YES;
        }
        
        if (message.messageType == NIMMessageTypeText) {
            [self setTextMessageWithMessage:message];
        }
        else if(message.messageType == NIMMessageTypeCustom){
            isCustom = YES;
            [self getCustomMessage:message];
            [self addNIMNotifyMessage];
        }
        else
        {
            [self setMessageArrayWithMessage:message];
        }
    }
    }
    
    if (isCustom == NO) {
        [self setCustomMessage];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arryData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([_arryData[indexPath.row] isKindOfClass:[UUMessageFrame class]]) {
        UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
        if (cell == nil) {
            cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
            cell.delegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setMessageFrame:_arryData[indexPath.row]];
        return cell;
    }else{
        if ([_arryData[indexPath.row] isKindOfClass:[NSDictionary class]]) {
            MessageCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCustomCellIdentif"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageCustomCell" owner:self options:nil]lastObject];
            }

            NSString *uyl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,self.patient.picFileName];
            NSString *url = [uyl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            [cell messageCustomCell:_arryData[indexPath.row] AvterURL:url];
            return cell;
        }else{
            MessageSystemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageSystemTableViewCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageSystemTableViewCell"owner:self options:nil]lastObject];
            }
            cell.systemLabel.text = _arryData[indexPath.row];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_arryData[indexPath.row] isKindOfClass:[UUMessageFrame class]]) {
        return [_arryData[indexPath.row] cellHeight];
    }
    else if ([_arryData[indexPath.row] isKindOfClass:[NSDictionary class]]){
        NSDictionary *dic = _arryData[indexPath.row];
        NSDictionary *dicValue = [dic objectForKey:@"value"];
        NSString *symptom = [dicValue objectForKey:@"symptom"];
        if (symptom) {
            CGRect rect = [symptom boundingRectWithSize:CGSizeMake(kWith-50-60, 500) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
            if (rect.size.height+31 < 44+25) {
                return 44+25+20;
            }else
            {
                return rect.size.height+76;
            }
        }else
        {
        return 44+25+20;
        }
    }
    return -1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)tableViewScrollToBottomChat
{
    if (_arryData.count > 0){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_arryData.count-1 inSection:0];
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

#pragma mark - 键盘通知
-(void)keyboardChangeChat:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    //adjust ChatTableView's height
    if (notification.name == UIKeyboardWillShowNotification) {
        _tableView.frame = CGRectMake(0, 60, kWith, kHeight- keyboardEndFrame.size.height-40 -60);
    }else{
        _tableView.frame = CGRectMake(0, 60, kWith, kHeight - 40 -60);
    }
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = IFView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    IFView.frame = newFrame;
    
    [UIView commitAnimations];

    
}

#pragma mark - 打电话
-(void)clickPhoneNum:(NSNotification *)notify{
    UIButton *btn = (UIButton *)notify.object;
    if ([btn.titleLabel.text isEqualToString:@""]||btn.titleLabel.text == nil) {
        kAlter(@"电话号码错误");
    }else{

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",btn.titleLabel.text]]];

    }
}

#pragma mark - 点击头像
-(void)clickAvter{
    ConsultationDetailViewController *con  =[[ConsultationDetailViewController alloc]init];
    con.patient = self.patient;
    [self.navigationController pushViewController:con animated:YES];
}

- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId{
    
    if ([userId isEqualToString:self.patient.patientName]) {
        ConsultationDetailViewController *con  =[[ConsultationDetailViewController alloc]init];
        con.patient = self.patient;
        [self.navigationController pushViewController:con animated:YES];
    }
    else{
        return;
    }
}

#pragma mark - 回调
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    
    if (IFView.TextViewInput.text == nil || [IFView.TextViewInput.text isEqualToString:@""]) {
        [IFView.TextViewInput resignFirstResponder];
        return;
    }
    //判断是否是第一个条消息
    [self isFirstMsg];
    //判断医生是否有回复
    [self isDoctorRead];
    
    funcView.TextViewInput.text = @"";
    _sendDic = [self addDataOfSendWithData:message type:[NSNumber numberWithInt:UUMessageTypeText] sendDic:_doctorBaseDic sendTime:[[NSDate date] description]];
    [self sendDoctorMessage:message];

}


-(void)UUInputView:(UUInputView *)funcView sendPicture:(UIImage *)image{
    
    //判断是否是第一个条消息
    [self isFirstMsg];
    //判断医生是否有回复
    [self isDoctorRead];
    
    _sendDic = [self addDataOfSendWithData:@[image] type:[NSNumber numberWithInt:UUMessageTypePicture] sendDic:_doctorBaseDic sendTime:[[NSDate date] description]];
    [self sendDoctorPicture:image];
    [self changeFramImageTxt];

}

-(void)UUinputCustom:(UUInputView *)custom{
    
}

-(void)UUInputView{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2f];
    CGRect newFrame = IFView.frame;
    newFrame.origin.y = kHeight-120-40;
    IFView.frame = newFrame;
    
    _tableView.frame = CGRectMake(0, 60, kWith, IFView.frame.origin.y-60);
    
    CGRect InPutNewFrame = InPutView.frame;
    InPutNewFrame.origin.y = kHeight-120;
    InPutView.frame = InPutNewFrame;
    [UIView commitAnimations];
    [self tableViewScrollToBottomChat];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
    
}
-(void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoicePath:(NSString *)path time:(NSInteger)second
{
    //判断是否是第一个条消息
    [self isFirstMsg];
    //判断医生是否有回复
    [self isDoctorRead];
    
    NSData *voice = [NSData dataWithContentsOfFile:path];
    NSArray *arr = @[voice,[NSString stringWithFormat:@"%ld",(long)second]];
    _sendDic = [self addDataOfSendWithData:arr type:[NSNumber numberWithInt:UUMessageTypeVoice] sendDic:_doctorBaseDic sendTime:[[NSDate date] description]];
    [self sendDoctorVoicePath:path];
    [self changeFramImageTxt];
}


-(void)changeFramImageTxt{

    [UIView animateWithDuration:0.2 animations:^{
       
        IFView.frame = CGRectMake(0, kHeight-40, kWith, 40);
        InPutView.frame = CGRectMake(0, kHeight, kWith, 120);
        _tableView.frame = CGRectMake(0, 60, kWith, kHeight-40-60);
        
    }];
    
}

#pragma mark 判断医生是否读过这条消息
-(void)isDoctorRead{

    [NSString isDoctorRead:_isDoctorRead OrderId:self.patient.Id viewController:self Compent:^(BOOL isRead) {
        _isDoctorRead = isRead;
    }];
    
}

#pragma mark  判断是否是第一个条消息
-(void)isFirstMsg{
    
    [NSString isFristMsgDoctor:_isFirstMsg Patient:[NSString getPatientTel:self.patient] type:@"1" viewController:self  Compent:^(BOOL isFrirt) {
        _isFirstMsg = isFrirt;
    }];

}

#pragma mark 发送信息
//发送文本
-(void)sendDoctorMessage:(NSString *)mes
{
    //构造消息
    NIMMessage *message = [[NIMMessage alloc] init];
    message.text = mes;
    message.remoteExt = @{@"order":self.patient.Id,@"source":@"1"};
    message.apnsContent = mes;
    //发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:_patientSession error:nil];
}
//发送图片
-(void)sendDoctorPicture:(UIImage *)image
{
    //构造消息
    NIMImageObject * imageObject = [[NIMImageObject alloc] initWithImage:image];
    NIMMessage *message          = [[NIMMessage alloc] init];
    message.messageObject        = imageObject;
    message.remoteExt = @{@"order":self.patient.Id,@"source":@"1"};
    message.apnsContent = @"你收到一张图片";
    
    //发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:_patientSession error:nil];
}
//发送语音
-(void)sendDoctorVoicePath:(NSString *)filePath
{
    //构造消息
    NIMAudioObject *audioObject = [[NIMAudioObject alloc] initWithSourcePath:filePath];
    NIMMessage *message        = [[NIMMessage alloc] init];
    message.messageObject      = audioObject;
    message.remoteExt = @{@"order":self.patient.Id,@"source":@"1"};
    message.apnsContent = @"你收到一段语音";
    //发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:_patientSession error:nil];
}

-(void)setCustomMessage{

    NSString *name;
    NSString *sex;
    NSString *age;
    NSString *desp;
    if (self.patient.patientName ==nil) {
        name = @"";
    }else{
        name = self.patient.patientName;
    }
    if (self.patient.sex ==nil) {
        sex = @"";
    }else{
        if ([self.patient.sex integerValue]==1) {
           sex = @"男";
        }else{
        sex = @"女";
        }
    }
    if (self.patient.age ==nil) {
        age = @"";
    }else{
        age = self.patient.age;
    }
    if (self.patient.Description ==nil) {
        desp = @"";
    }else{
        desp = self.patient.Description;
    }
    NSDictionary *dicValue = @{@"age":age,@"name":name,@"sex":sex,@"symptom":desp};
    NSDictionary *dic = @{@"value":dicValue};
    [_arryData insertObject:dic atIndex:0];
    [_arryData insertObject:@"点击患者头像可查看本次咨询详情，点击右上角可查看更多" atIndex:1];
    [_tableView reloadData];
}

//发送自定义消息
- (void)sendCustomMessageWithFlag:(NSNumber *)flag patientDic:(NSDictionary *)patientDic
{
    //构造自定义内容
    Attachment *attachment  = [[Attachment alloc] init];
    attachment.flag         = flag;
    attachment.patientDic   = patientDic;

    //构造自定义MessageObject
    NIMCustomObject *object = [[NIMCustomObject alloc] init];
    object.attachment       = attachment;

    //构造自定义消息
    NIMMessage *message     = [[NIMMessage alloc] init];
    message.messageObject   = object;
    message.remoteExt       = @{@"order":self.patient.Id,@"source":@"1"};

    //发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:_patientSession error:nil];
}
//提醒消息
-(void)sendTipMessageWithFlag:(NSString *)flag
{
    //构造消息
    NIMTipObject *tipObject = [[NIMTipObject alloc]init];
    NIMMessage *message     = [[NIMMessage alloc] init];
    message.text = flag;
    message.messageObject   = tipObject;
    
    //发送消息
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:_patientSession error:nil];
}

#pragma mark 发送系统通知
-(void)sendSystemNotificationWithContent:(NSString *)content
{
    NIMCustomSystemNotification *notification = [[NIMCustomSystemNotification alloc] initWithContent:content];
    notification.sendToOnlineUsersOnly = YES;
    [[[NIMSDK sharedSDK] systemNotificationManager] sendCustomNotification:notification
                                                                 toSession:_patientSession
                                                                completion:nil];
}
#pragma mark 接收系统通知
-(void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
{
    NSArray *arry = [notification.content componentsSeparatedByString:@":"];
    if ([arry[1] isEqualToString:self.patient.Id]) {
        if ([arry[0] isEqualToString:@"0"]) {
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"患者%@已结束对您的图文咨询，感谢您对%@的问诊。",self.patient.patientName,self.patient.patientName] preferredStyle:UIAlertControllerStyleAlert];
            [alter addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                NSMutableDictionary *Dic =[[NSMutableDictionary alloc]init];
                [Dic setValue:self.patient.Id forKey:@"orderId"];
                [Dic setValue:@"4" forKey:@"state"];
                [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/TextOrdeTypeUpdate",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:Dic  viewConroller:self success:^(id responseObject) {
                    
                } failure:^(NSError *error) {
                    
                }];
                [self.navigationController popViewControllerAnimated:YES];
            }]];
            [self presentViewController:alter animated:YES completion:nil];
        }
        else if ([arry[0] isEqualToString:@"1"]){
            
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:        [NSString stringWithFormat:@"患者%@已同意您的结束请求，感谢您对%@的问诊。",self.patient.patientName,self.patient.patientName] preferredStyle:UIAlertControllerStyleAlert];
            [alter addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                NSMutableDictionary *Dic =[[NSMutableDictionary alloc]init];
                [Dic setValue:self.patient.Id forKey:@"orderId"];
                [Dic setValue:@"4" forKey:@"state"];
                [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/TextOrdeTypeUpdate",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:Dic  viewConroller:self success:^(id responseObject) {
                    
                } failure:^(NSError *error) {
                    
                }];

                [self.navigationController popViewControllerAnimated:YES];
            }]];
            
            [self presentViewController:alter animated:YES completion:nil];
            
        }else if ([arry[0] isEqualToString:@"2"]){
            [self alterController:[NSString stringWithFormat:@"患者%@拒绝您的结束请求，请进一步完成您对%@的问诊。",self.patient.patientName,self.patient.patientName]];
        }
    }
}

-(void)alterController:(NSString *)text{

    kAlter(text);
    
}

#pragma mark 发送消息代理方法
//即将发送消息
-(void)willSendMessage:(NIMMessage *)message
{
    NSLog(@"即将发送消息");
    //    if ([message.session.sessionId isEqualToString:doctorUserID]&&message.messageType!=NIMMessageTypeCustom) {
    //        [_arryData addObject:messageFrame];
    //        [_tableVIew reloadData];
    //    }
}
//消息发送进度
-(void)sendMessage:(NIMMessage *)message progress:(CGFloat)progress
{
    NSLog(@"发送消息中……");
}
//消息发送完毕
-(void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error
{
    if (error == nil) {
        [self setConSendMsg:_sendDic];
        NSLog(@"发送消息完毕");
    }else
    {
        kAlter(@"发送失败");
    }
}
//重发
-(BOOL)resendMessage:(NIMMessage *)message error:(NSError *__autoreleasing *)error
{
    if (error != nil) {
        kAlter(@"提交失败");
        return YES;
    }

    return YES;
}

#pragma mark 设置医生数据
-(void)setDataOfDoctor
{
    _doctorBaseDic = [NSMutableDictionary dictionary];
    NSDictionary *dic =[[NSUserDefaults standardUserDefaults] objectForKey:@"DoctorDataDic"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,[dic objectForKey:@"picFileName"]];
    if ([dic objectForKey:@"userName"]) {
        [_doctorBaseDic setObject:[dic objectForKey:@"userName"] forKey:@"strName"];
    }
    if (url) {
        [_doctorBaseDic setObject:url forKey:@"strIcon"];
    }
    [_doctorBaseDic setObject:[NSNumber numberWithInt:0] forKey:@"from"];
}
#pragma mark 设置患者数据
-(void)setDataOfPatient
{
    NSString *url = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,self.patient.picFileName];
    
    _patientBaseDic = [NSMutableDictionary dictionary];
    [_patientBaseDic setObject:[NSNumber numberWithInt:1] forKey:@"from"];
    [_patientBaseDic setObject:url forKey:@"strIcon"];
    if (self.patient.patientName != nil) {
        [_patientBaseDic setObject:self.patient.patientName forKey:@"strName"];
    }
}

-(NSDictionary *)addDataOfSendWithData:(id)data type:(NSNumber *)type sendDic:(NSDictionary *)dic sendTime:(NSString *)time
{
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [newDic setObject:time forKey:@"strTime"];
    [newDic setObject:type forKey:@"type"];
    NSArray *arr;
    if ([data isKindOfClass:[NSArray class]]) {
        arr = (NSArray *)data;
    }
    switch ([type integerValue]) {
        case 0:
            [newDic setObject:(NSString *)data forKey:@"strContent"];
            break;
        case 1:
            [newDic setObject:[arr firstObject] forKey:@"picture"];
            if (arr.count > 1) {
                [newDic setObject:[arr lastObject] forKey:@"pictureUrl"];
            }
            break;
        case 2:
            [newDic setObject:[arr objectAtIndex:0] forKey:@"voice"];
            [newDic setObject:[arr objectAtIndex:1] forKey:@"strVoiceTime"];
            break;
        default:
            break;
    };
    return newDic;
}

#pragma mark 设置MessageFrame
static NSString *previousTime = nil;
-(void)setMessageFrameWithData:(NSDictionary *)dic
{
    messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    [message setWithDict:dic];
    [message minuteOffSetStart:previousTime end:dic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        previousTime = dic[@"strTime"];
    }
}

#pragma mark 接收消息
//接收文本消息
-(void)onRecvMessages:(NSArray *)messages
{
    NIMMessage *message = [messages firstObject];
    NSDictionary *dic = message.remoteExt;
    if ([self.patient.Id isEqualToString:[dic objectForKey:@"order"]] && [[dic objectForKey:@"source"] isEqualToString:@"1"]) {
        if (message.messageType == NIMMessageTypeText) {
            [self setTextMessageWithMessage:message];
        }else if (message.messageType == NIMMessageTypeCustom){
            [self getCustomMessage:message];
        }else if (message.messageType == NIMMessageTypeTip){
            [self getTipMessage:message];
        }
    }
}
//接收图片视频消息
//第一次接收时
-(BOOL)fetchMessageAttachment:(NIMMessage *)message error:(NSError *__autoreleasing *)error
{
    return YES;
}
//附件下载过程时
-(void)fetchMessageAttachment:(NIMMessage *)message progress:(CGFloat)progress
{
    
}
-(void)fetchMessageAttachment:(NIMMessage *)message didCompleteWithError:(NSError *)error
{
    NSDictionary *dic = message.remoteExt;
    if ([self.patient.Id isEqualToString:[dic objectForKey:@"order"]] && [[dic objectForKey:@"source"] isEqualToString:@"1"]) {
        [self setMessageArrayWithMessage:message];
    }
}

#pragma mark 添加消息
//添加文字
-(void)setTextMessageWithMessage:(NIMMessage *)message
{

    NSDate *sendTime = [NSDate dateWithTimeIntervalSince1970:message.timestamp];
    NSDictionary *dic = message.remoteExt;
    if ([self.patient.Id isEqualToString:[dic objectForKey:@"order"]] && [[dic objectForKey:@"source"] isEqualToString:@"1"]) {
        if ([message.from isEqualToString:self.patient.patientIM]) {
            _receiveDic = [self addDataOfSendWithData:message.text type:[NSNumber numberWithInt:UUMessageTypeText] sendDic:_patientBaseDic sendTime:[sendTime description]];
            [self setConSendMsg:_receiveDic];
        }else
        {
            _receiveDic = [self addDataOfSendWithData:message.text type:[NSNumber numberWithInt:UUMessageTypeText] sendDic:_doctorBaseDic sendTime:[sendTime description]];
            [self setConSendMsg:_receiveDic];
        }
    }
}

-(void)setConSendMsg:(NSDictionary *)dic{
    [self setMessageFrameWithData:dic];
    [_arryData addObject:messageFrame];
    [_tableView reloadData];
    [self tableViewScrollToBottomChat];
}

-(void)setMessageArrayWithMessage:(NIMMessage *)message
{
    NSDate *sendTime = [NSDate dateWithTimeIntervalSince1970:message.timestamp];
    
    if (message.messageType == NIMMessageTypeImage) {
        //图片
        NIMImageObject *imageObject = (NIMImageObject *)message.messageObject;
        NSString *imageUrl = imageObject.url;
        UIImage *image = [UIImage imageWithContentsOfFile:imageObject.thumbPath];
        if (image && imageUrl) {
            if ([message.from isEqualToString:self.patient.patientIM]) {
                _receiveDic = [self addDataOfSendWithData:@[image,imageUrl] type:[NSNumber numberWithInt:UUMessageTypePicture] sendDic:_patientBaseDic sendTime:[sendTime description]];
                [self setConSendMsg:_receiveDic];
            }else
            {
                _receiveDic = [self addDataOfSendWithData:@[image,imageUrl] type:[NSNumber numberWithInt:UUMessageTypePicture] sendDic:_doctorBaseDic sendTime:[sendTime description]];
                [self setConSendMsg:_receiveDic];
            }
        }
    }else if (message.messageType == NIMMessageTypeAudio){

        NIMAudioObject *audioObject = (NIMAudioObject *)message.messageObject;
        NSData *voice;
        voice = [NSData dataWithContentsOfFile:audioObject.path];
        if (voice==nil) {
            voice = [NSData dataWithContentsOfURL:[NSURL URLWithString:audioObject.url]];
        }
        NSString *voiceTime = [NSString stringWithFormat:@"%ld",audioObject.duration/1000];
        if (voice && voiceTime) {
            if ([message.from isEqualToString:self.patient.patientIM]) {
                _receiveDic = [self addDataOfSendWithData:@[voice,voiceTime] type:[NSNumber numberWithInt:UUMessageTypeVoice] sendDic:_patientBaseDic sendTime:[sendTime description]];
                [self setConSendMsg:_receiveDic];
            }else
            {
                _receiveDic = [self addDataOfSendWithData:@[voice,voiceTime] type:[NSNumber numberWithInt:UUMessageTypeVoice] sendDic:_doctorBaseDic sendTime:[sendTime description]];
                [self setConSendMsg:_receiveDic];
            }
        }
    }
}


#pragma mark 接收自定义消息
-(void)getCustomMessage:(NIMMessage *)message
{
    if (message.messageType == NIMMessageTypeCustom) {
        NIMCustomObject *customMessage = (NIMCustomObject *)message.messageObject;
        Attachment *attachment  = (Attachment *)customMessage.attachment;
        switch ([attachment.flag integerValue]) {
            case 0:
                break;
            case 5:
            {
                [_arryData addObject:attachment.patientDic];
                [_tableView reloadData];
                [self tableViewScrollToBottomChat];
            }
                break;
            default:
                break;
        }
    }
}

-(void)addNIMNotifyMessage{

    [_arryData addObject:@"点击患者头像可查看本次咨询详情，点击右上角可查看更多"];    
}
#pragma mark 接收提醒消息
-(void)getTipMessage:(NIMMessage *)message
{
    if (message.messageType == NIMMessageTypeTip) {
        NSInteger flag = [message.text integerValue];
        switch (flag) {
            case 0:
                break;
                
            default:
                break;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    if ([self.state integerValue]!=4) {
        NSMutableDictionary *Dic =[[NSMutableDictionary alloc]init];
        [Dic setValue:self.patient.Id forKey:@"orderId"];
        [Dic setObject:self.patient.patientIM forKey:@"fromAccount"];
        [Dic setObject:kDoctorIM forKey:@"toAccount"];
        [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/SetMessageIsRead",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:Dic viewConroller:self success:^(id responseObject) {
            
        } failure:^(NSError *error) {
            
        }];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

- (void)loadBaseViewsAndData
{
    IFView = [[UUInputFunctionView alloc]initWithSuperVC:self];
    IFView.delegate = self;
    [self.view addSubview:IFView];
    
    if ([self.state integerValue]==4) {
        [IFView removeFromSuperview];
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, kHeight-40, kWith, 40)];
        lbl.backgroundColor = kBackgroundColor;
        lbl.textAlignment = 1;
        lbl.text = @"咨询已完成";
        [self.view addSubview:lbl];
        return;
    }
    
    InPutView  = [[UUInputView alloc]initWithSuperVC:self TipCount:2];
    InPutView.delegate  =self;
    [self.view addSubview:InPutView];
}

-(void)onBack{

    [self.view endEditing:YES];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        
        if ([vc isKindOfClass:[ConsultingViewController class]]) {
            ConsultingViewController *patie = (ConsultingViewController *)vc;
            [self.navigationController popToViewController:patie animated:YES];
            break;
        }
    }
}

@end