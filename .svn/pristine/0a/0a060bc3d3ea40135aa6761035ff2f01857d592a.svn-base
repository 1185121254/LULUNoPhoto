//
//  WebLineInfoVIew.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/30.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "WebLineInfoVIew.h"
#import "KCommandTableViewCell.h"
#import "KZANTableViewCell.h"
#import "KCommandViewController.h"
#import "CustTapGesture.h"

@interface WebLineInfoVIew ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *image_head;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_hospital;
@property (weak, nonatomic) IBOutlet UILabel *lbl_doctorTItle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_time;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;

@property (weak, nonatomic) IBOutlet UIView *viewForImage;
@property (weak, nonatomic) IBOutlet UIView *viewForTextInfo;
@property (weak, nonatomic) IBOutlet UIView *viewForHeadView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForImageView;

//评论和赞按钮
@property (weak, nonatomic) IBOutlet UILabel *btnCommand;
@property (weak, nonatomic) IBOutlet UILabel *btnZan;
@property (weak, nonatomic) IBOutlet UIButton *btncomand;
@property (weak, nonatomic) IBOutlet UIButton *btnzan;
@property (strong, nonatomic) UIView *viewWithSelectCommand;
@property (strong, nonatomic) UIView *viewWithSelectZan;

//收藏 评论 赞
@property (weak, nonatomic) IBOutlet UIButton *btnCollect;
@property (weak, nonatomic) IBOutlet UILabel *lbl_collect;
@property (weak, nonatomic) IBOutlet UIButton *btnForCommand;
@property (weak, nonatomic) IBOutlet UILabel *lbl_command;
@property (weak, nonatomic) IBOutlet UIButton *btnForZan;
@property (weak, nonatomic) IBOutlet UILabel *lbl_zan;
@property (weak, nonatomic) IBOutlet UIImageView *image_zan;

@property (weak, nonatomic) IBOutlet UITableView *viewForTable;
//收藏按钮图片
@property (weak, nonatomic) IBOutlet UIImageView *Image_Collect;
//数据字典
@property (strong, nonatomic) NSMutableDictionary *dic_infoData;

//图片的数组
@property (strong, nonatomic) NSMutableArray *arrForImage;
//评论和点赞数组
@property (strong, nonatomic) NSMutableArray *arr_commentList;
@property (strong, nonatomic) NSMutableArray *arr_commentZan;
@property (strong, nonatomic) NSMutableArray *arr_comment;

//收藏数量
@property (assign, nonatomic) int *collectCount;

//被查看的医生
@property (strong, nonatomic) NSString *str_doctorID;
//点赞个数
@property (assign, nonatomic) NSInteger upvoteCount;
//点赞的ID
@property (strong, nonatomic) NSString *str_ZanID;
//删除按钮
@property (weak, nonatomic) IBOutlet UIBarButtonItem *delegateInfo;

@property(nonatomic,strong)UIView *viewForg;
@end

@implementation WebLineInfoVIew

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _arr_commentList = [[NSMutableArray alloc]init];
    _arr_commentZan = [[NSMutableArray alloc]init];
    _arr_comment = [[NSMutableArray alloc]init];
    _dic_infoData = [[NSMutableDictionary alloc]init];
    
    _viewWithSelectCommand.hidden = NO;
    _viewWithSelectZan.hidden = YES;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.hidden = YES;
    
    _viewForg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, kHeight)];
    _viewForg.backgroundColor = kBackgroundColor;
    [self.view addSubview:_viewForg];
    
    //获取数据
    [self getNETCONSULTATIONDETAILFINDData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    
    if (_isCircle) {
        self.title = @"眼科圈";
    }else
    {
        self.title = @"互联网会诊";
    }
    
    UIBarButtonItem *itemBack = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(onItemBack)];
    self.navigationItem.leftBarButtonItem = itemBack;
    
    //加识别view
    _viewWithSelectZan = [[UIView alloc]initWithFrame:CGRectMake(0, _btnzan.frame.size.height-2, _btnzan.frame.size.width, 2)];
    _viewWithSelectCommand = [[UIView alloc]initWithFrame:CGRectMake(0,_btncomand.frame.size.height-2, _btncomand.frame.size.width, 2)];
    _viewWithSelectCommand.backgroundColor = BLUECOLOR_STYLE;
    _viewWithSelectZan.backgroundColor = BLUECOLOR_STYLE;
    [_btnzan addSubview:_viewWithSelectZan];
    [_btncomand addSubview:_viewWithSelectCommand];
    _viewWithSelectCommand.hidden = NO;
    _viewWithSelectZan.hidden = YES;
    
    self.view.backgroundColor = kBackgroundColor;
}

-(void)onItemBack{

    [self.navigationController popViewControllerAnimated:YES];
    
}

//设置页面基本数据
-(void)getData
{
    _lbl_name.text = _dic_infoData[@"userName"];
    _lblTitle.text= [NSString stringWithFormat:@"#%@#",_dic_infoData[@"title"]];
    //计算label高度
    NSString *strInfo = [[NSString alloc]init];
    
    if (_isCircle==YES)//眼科圈
    {
        strInfo = _dic_infoData[@"detail"];
    }
    else//互联网会诊
    {
        NSString *sex = _dic_infoData[@"sex"];
        NSString *strSex = [[NSString alloc]init];
        if ([sex isEqualToString:@"1"])
        {
            strSex = @"男性患者";
        }
        else if ([sex isEqualToString:@"0"])
        {
            strSex = @"女性患者";
        }
        NSString *age = _dic_infoData[@"age"];
        NSString *illness =_dic_infoData[@"illness"];
        NSString *detail = _dic_infoData[@"detail"];
        NSString *illDetail = _dic_infoData[@"illDetail"];
//        strInfo = [NSString stringWithFormat:@"%@,%@岁,诊断:%@,症状:%@,备注:%@",strSex,age,illDetail,illness,detail];
        if (!_dic_infoData[@"detail"])
        {
            strInfo = [NSString stringWithFormat:@"%@，%@岁，症状:%@，诊断:%@",strSex,age,illDetail,illness];
        }
        else
        {
            strInfo = [NSString stringWithFormat:@"%@，%@岁，症状:%@，诊断:%@，备注:%@",strSex,age,illDetail,illness,detail];
        }
    }
    _lblInfo.text = strInfo;
    _lblInfo.numberOfLines = 0;
    _lbl_time.text = _dic_infoData[@"createDate"];
    if (_dic_infoData[@"licenseTitle"] == nil) {
        _lbl_doctorTItle.hidden = YES;

    }else{
        _lbl_doctorTItle.text = _dic_infoData[@"licenseTitle"];
        _lbl_doctorTItle.hidden = NO;
    }
    _lbl_doctorTItle.layer.cornerRadius = 3;
    _lbl_doctorTItle.layer.masksToBounds = YES;
    
    _lbl_hospital.text = _dic_infoData[@"licenseHospital"];
    _btnCommand.text = [NSString stringWithFormat:@"评论:%d",(int)_arr_comment.count];
    
    NSString *strHead =[NSString stringWithFormat:@"%@%@",NET_URLSTRING,_dic_infoData[@"picFileName"]];
    strHead = [strHead stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [_image_head sd_setImageWithURL:[NSURL URLWithString:strHead] placeholderImage:[UIImage imageNamed:@"默认婷婷"]];
    _image_head.layer.masksToBounds = YES;
    _image_head.layer.cornerRadius = _image_head.frame.size.height/2;
    
    //是否有图
    if (![_dic_infoData objectForKey:@"picList"])
    {
        _heightForImageView.constant = 0;
        
        //文本高度
        CGRect temp = _viewForHeadView.frame;
        temp.size.height =75+35+45+[self heightOfString:strInfo font:[UIFont systemFontOfSize:15] width:kWith-16];
        _viewForTable.tableHeaderView.frame = temp;
        [_viewForTable setTableHeaderView:_viewForHeadView];
        
        _viewForTable.delegate = self;
        _viewForTable.dataSource = self;
    }
    else
    {
        _arrForImage = [[NSMutableArray alloc]init];
        _arrForImage = _dic_infoData[@"picList"];
        //65 *65
        for (int i = 0; i<_arrForImage.count; i++)
        {
            
            UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            dic = _arrForImage[i];
            NSString *strImageURl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,dic[@"microPicUrl"]];
            strImageURl = [strImageURl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            [btnImage sd_setImageWithURL:[NSURL URLWithString:strImageURl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"感叹号"]];
            
            btnImage.tag = i+800;
            [btnImage addTarget:self action:@selector(onBtnImage:) forControlEvents:UIControlEventTouchUpInside];
            NSInteger num = (NSInteger)(SCREEN_W/65);
            float padding = (SCREEN_W-(num*65))/(num+1);
            NSInteger row = (NSInteger)(i/num);
            NSInteger firstX = i-num*row;
            btnImage.frame = CGRectMake(padding*(firstX+1)+firstX*65, row *65 +5*(row+1), 65, 65);
            [_viewForImage addSubview:btnImage];
            
            
//            UIImageView *imageVIEW = [[UIImageView alloc]init];
//            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
//            dic = _arrForImage[i];
//            NSString *strImageURl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,dic[@"picUrl"]];
//            strImageURl = [strImageURl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
//            [imageVIEW sd_setImageWithURL:[NSURL URLWithString:strImageURl]];
//            
//            NSInteger num = (NSInteger)(SCREEN_W/65);
//            float padding = (SCREEN_W-(num*65))/(num+1);
//            NSInteger row = (NSInteger)(i/num);
//            NSInteger firstX = i-num*row;
//            imageVIEW.frame = CGRectMake(padding*(firstX+1)+firstX*65, row *65 +5*(row+1), 65, 65);
//            [_viewForImage addSubview:imageVIEW];
        }
        //添加点击查看图片
//        UITapGestureRecognizer *OpenImage=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openImage)];
//        
//        [_viewForImage addGestureRecognizer:OpenImage];
        //每行个数
        
        int num = [UIScreen mainScreen].bounds.size.width/65;
        //每两个间隔
//        float a = [32.0 integerValue]%65;
        
        if (num*2<_arrForImage.count)
        {   //图片高度
            _heightForImageView.constant = 80+135;
        }
        else if (num<_arrForImage.count)
        {
            //图片高度
            _heightForImageView.constant = 80+65;
        }
        //文本高度
        CGRect temp = _viewForHeadView.frame;
        temp.size.height =75+35+45+[self heightOfString:strInfo font:[UIFont systemFontOfSize:15] width:kWith-16]+_heightForImageView.constant;
        _viewForTable.tableHeaderView.frame = temp;
        [_viewForTable setTableHeaderView:_viewForHeadView];
        
        _viewForTable.delegate = self;
        _viewForTable.dataSource = self;
    }
}

#pragma mark - 删除按钮
- (IBAction)delegateActioInfo:(UIBarButtonItem *)sender
{
    
    //创建遮盖试图
    UIView *shadeView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    shadeView.backgroundColor=[UIColor colorWithWhite:0.500 alpha:0.301];
    [self.view addSubview:shadeView];
    //创建提示框
    CXAlertView *cxAlertView = [[CXAlertView alloc]initWithTitle:nil message:@"确定删除?" cancelButtonTitle:nil];
    
    [cxAlertView addButtonWithTitle:@"确定"
                               type:CXAlertViewButtonTypeCustom
                            handler:^(CXAlertView *alertView, CXAlertButtonItem *button){
                                alertView.showBlurBackground = YES;
                                [alertView dismiss];
                                [shadeView removeFromSuperview];
                                [self deleAction];
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

#pragma mark - 删除操作
-(void)deleAction
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode;
    verifyCode=[userDefaults objectForKey:@"verifyCode"];
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    NSString *str_url = [[NSString alloc]init];
    if (_isCircle==YES)//眼科圈
    {
        //眼科ID
        [parameters setObject:_str_topID forKey:@"topicId"];
        str_url = TOPICDELETE;
    }
    else//互联网会诊
    {
        //会诊ID
        [parameters setObject:_str_topID forKey:@"consulId"];
        str_url = NET_CONSULTATIONDELETE;
    }
    [RequestManager getWithURLString:str_url heads:heads parameters:parameters success:^(id responseObject)
     {
//         [showAlertView showAlertViewWithMessage:@"删除成功"];
         [self.navigationController popViewControllerAnimated:YES];
     } failure:^(NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

#pragma mark - 点击查看图片
-(void)onBtnImage:(UIButton *)btn
{
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    //2.告诉图片浏览器显示所有的图片
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0 ; i < _arrForImage.count; i++) {
        NSDictionary *dic = _arrForImage[i];
        //传递数据给浏览器
        MJPhoto *photo = [[MJPhoto alloc] init];
        NSString *yrl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,[dic objectForKey:@"picUrl"]];
        NSString *url = [yrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        photo.url = [NSURL URLWithString:url];
        [photos addObject:photo];
    }
    brower.currentPhotoIndex = btn.tag-800;
    brower.photos = photos;
    //4.显示浏览器
    [brower show];
}

#pragma mark - 完整获取会诊详情的数据
-(void)getNETCONSULTATIONDETAILFINDData
{
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode;
    verifyCode=[userDefaults objectForKey:@"verifyCode"];
    NSString *userID;
    userID = [userDefaults objectForKey:@"id"];
    
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    
    _dic_infoData = [[NSMutableDictionary alloc]init];
    MBProgressHUD *_HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"正在加载";
    _HUD.hidden = NO;
    //医生ID
    [parameters setObject:userID forKey:@"doctorId"];
    
    NSString *str_url = [[NSString alloc]init];
    if (_isCircle==YES)//眼科圈
    {
        //眼科ID
        [parameters setObject:_str_topID forKey:@"topicId"];
        str_url = CIRCLEVIEWFINFO_DATA;
    }
    else//互联网会诊
    {
        //会诊ID
        [parameters setObject:_str_topID forKey:@"id"];
        str_url = NETCONSULTATIONDETAILFIND;
    }
    
    //GET
    [RequestManager getWithURLString:str_url heads:heads parameters:parameters success:^(id responseObject)
     {
         _viewForg.hidden = YES;
         _HUD.hidden = YES;
         //互联网会诊
         _dic_infoData = responseObject[@"value"];
         NSString *doctorID = _dic_infoData[@"doctorId"];
         if (![doctorID isEqualToString:userID])//判断是否本身的详情
         {
             UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
             UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
             self.navigationItem.rightBarButtonItem = releaseButtonItem;
         }
         _arr_commentList = [[NSMutableArray alloc]init];
         _arr_commentList = _dic_infoData[@"commentList"];
         //收藏
         _lbl_collect.text  = [NSString stringWithFormat:@"%@",_dic_infoData[@"collectCount"]];
         //----
         if (_isCircle==YES)//眼科圈
         {
             _str_topID = _dic_infoData[@"topicId"];
         }
         else//互联网会诊
         {
             _str_topID = _dic_infoData[@"id"];
         }
         //---
         //被回复医生ID
         _str_doctorID =  _dic_infoData[@"doctorId"];
         //点赞数量
         _upvoteCount = [_dic_infoData[@"upvoteCount"] integerValue];
         //是否收藏
         NSString *strSelect = [[NSString alloc]init];
         strSelect = _dic_infoData[@"isCollect"];
         if ([strSelect isEqualToString:@"false"])
         {
             [_Image_Collect setImage:[UIImage imageNamed:@"i-收藏关注"]];
             _btnCollect.tag = 70000;
         }
         else
         {
             [_Image_Collect setImage:[UIImage imageNamed:@"i-收藏关注_h"]];
             _btnCollect.tag = 60000;
         }
         
         for (int i = 0; i<_arr_commentList.count; i++)
         {
             NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
             dic = _arr_commentList[i];
             NSNumber *type = dic[@"commentType"];
             //赞
             if ([type isEqual: @(1)])
             {
                 [_arr_commentZan addObject:dic];
             }
             //评论
             else if ([type isEqual:@(2)])
             {
                 [_arr_comment addObject:dic];
             }
         }
         for (NSDictionary *dic in _arr_commentZan)
         {
             NSString *str_Zan = dic[@"doctorId"];
             _str_ZanID = [[NSString alloc]init];
             _str_ZanID = dic[@"id"];
             NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
             NSString *userID;
             userID = [userDefaults objectForKey:@"id"];
             if ([str_Zan isEqualToString:userID])//已点赞
             {
                 [_image_zan setImage:[UIImage imageNamed:@"i赞_h"]];
                 _btnForZan.tag = 90000;
                 break;
             }
             else//未点赞
             {
                 [_image_zan setImage:[UIImage imageNamed:@"i赞"]];
                 _btnForZan.tag = 80000;
             }
         }
         //设置页面基本数据
         [self getData];
         _viewForTable.tag = 10002;
         [_viewForTable reloadData];
         //评论
         _lbl_command.text = [NSString stringWithFormat:@"%d",(int)_arr_comment.count];
         //赞
         _lbl_zan.text = [NSString stringWithFormat:@"%d",(int)_arr_commentZan.count];
         _btnZan.text = [NSString stringWithFormat:@"赞:%d",(int)_arr_commentZan.count];
         
     } failure:^(NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

#pragma mark - 获取点赞的数据
-(void)getDataForCommlist
{
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode;
    verifyCode=[userDefaults objectForKey:@"verifyCode"];
    
    NSString *userID;
    userID = [userDefaults objectForKey:@"id"];
    
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    
    
    NSString *str_url = [[NSString alloc]init];
    if (_isCircle==YES)//眼科圈
    {
        //眼科ID
        [parameters setObject:_str_topID forKey:@"topicId"];
        str_url = CIRCLEVIEWFINFO_DATA;
    }
    else//互联网会诊
    {
        //会诊ID
        [parameters setObject:_str_topID forKey:@"id"];
        str_url = NETCONSULTATIONDETAILFIND;
    }
    //医生ID
    [parameters setObject:userID forKey:@"doctorId"];
    
    _dic_infoData = [[NSMutableDictionary alloc]init];
    //GET
    [RequestManager getWithURLString:str_url heads:heads parameters:parameters success:^(id responseObject)
     {
         _dic_infoData = responseObject[@"value"];
         NSString *doctorID = _dic_infoData[@"doctorId"];
         if (![doctorID isEqualToString:userID])//判断是否本身的详情
         {
             UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
             UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
             self.navigationItem.rightBarButtonItem = releaseButtonItem;
         }
         _arr_commentList = [[NSMutableArray alloc]init];
         _arr_commentList = _dic_infoData[@"commentList"];
         //收藏
         _lbl_collect.text  = [NSString stringWithFormat:@"%@",_dic_infoData[@"collectCount"]];
         //是否收藏
         NSString *strSelect = [[NSString alloc]init];
         strSelect = _dic_infoData[@"isCollect"];
         //----
         if (_isCircle==YES)//眼科圈
         {
             _str_topID = _dic_infoData[@"topicId"];
         }
         else//互联网会诊
         {
             _str_topID = _dic_infoData[@"id"];
         }
         //---
         
         if ([strSelect isEqualToString:@"false"])
         {
             [_Image_Collect setImage:[UIImage imageNamed:@"i-收藏关注"]];
             _btnCollect.tag = 70000;
         }
         else
         {
             [_Image_Collect setImage:[UIImage imageNamed:@"i-收藏关注_h"]];
             _btnCollect.tag = 60000;
         }
         
         _arr_commentZan = [[NSMutableArray alloc]init];
         _arr_comment = [[NSMutableArray alloc]init];
         
         for (int i = 0; i<_arr_commentList.count; i++)
         {
             NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
             dic = _arr_commentList[i];
             NSNumber *type = dic[@"commentType"];
             //赞
             if ([type isEqual: @(1)])
             {
                 [_arr_commentZan addObject:dic];
             }
             //评论
             else if ([type isEqual:@(2)])
             {
                 [_arr_comment addObject:dic];
             }
         }
         for (NSDictionary *dic in _arr_commentZan)
         {
             NSString *str_Zan = dic[@"doctorId"];
             _str_ZanID = [[NSString alloc]init];
             _str_ZanID = dic[@"id"];
             NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
             NSString *userID;
             userID = [userDefaults objectForKey:@"id"];
             if ([str_Zan isEqualToString:userID])//已点赞
             {
                 [_image_zan setImage:[UIImage imageNamed:@"i赞_h"]];
                 _btnForZan.tag = 90000;
                 break;
             }
             else//未点赞
             {
                 [_image_zan setImage:[UIImage imageNamed:@"i赞"]];
                 _btnForZan.tag = 80000;
             }
         }
         _viewForTable.tag = 10001;
         _viewWithSelectCommand.hidden = YES;
         _viewWithSelectZan.hidden = NO;
         [_viewForTable reloadData];
         //评论
         _lbl_command.text = [NSString stringWithFormat:@"%d",(int)_arr_comment.count];
         //赞
         _lbl_zan.text = [NSString stringWithFormat:@"%d",(int)_arr_commentZan.count];
         _btnZan.text = [NSString stringWithFormat:@"赞:%d",(int)_arr_commentZan.count];
         //             NSLog(@"%@===",_arr_commentList);
     } failure:^(NSError *error)
     {
         NSLog(@"%@",error);
     }];
}

#pragma mark - 计算label文本行高
-(CGFloat)heightOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width
{
    CGRect bounds;
    NSDictionary * parameterDict=[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    bounds=[string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:parameterDict context:nil];
    return bounds.size.height;
}

#pragma mark - tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==10001)
    {
        return _arr_commentZan.count;
    }
    else
    {
        return _arr_comment.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==10001)
    {
        return 55;
    }
    else
    {
        NSMutableDictionary *dic_str =[[NSMutableDictionary alloc]init];
        dic_str = _arr_comment[indexPath.row];
        NSString *str = dic_str[@"commentDetail"];
        
        CGFloat sizeText = [self heightOfString:str font:[UIFont systemFontOfSize:15] width:SCREEN_W-60];
        return sizeText+75;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==10002)
    {
        static  NSString  *CellIdentiferId = @"KCommandTableViewCell";
        KCommandTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
        if (cell == nil)
        {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"KCommandTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCell:_arr_comment[indexPath.row]];
        return cell;
    }
    else
    {
        static  NSString  *CellIdentiferId = @"KZANTableViewCell";
        KZANTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
        if (cell == nil)
        {
            NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"KZANTableViewCell" owner:nil options:nil];
            cell = [nibs lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setCell:_arr_commentZan[indexPath.row]];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==10002)
    {
//        NSMutableDictionary *dic = _arr_commentList[indexPath.row];
        NSMutableDictionary *dic = _arr_comment[indexPath.row];
        //创建新增患者界面
        UIStoryboard *storyboardName=[UIStoryboard storyboardWithName:@"WebLine" bundle:[NSBundle mainBundle]];
        //指定对应的故事版
        KCommandViewController *commandView=[storyboardName instantiateViewControllerWithIdentifier:@"KCommandViewController"];
        commandView.isCopy = 2;//指定回复人
        commandView.topID = _str_topID;
        commandView.dic_command = _dic_infoData;
        commandView.str_reviewerName = dic[@"doctorId"];
        if (_isCircle==YES)//眼科圈
        {
            commandView.isCircle = YES;
        }
        else//互联网会诊
        {
            commandView.isCircle = NO;
        }
        //推送
        [self.navigationController pushViewController:commandView animated:YES];
    }
    return;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


#pragma mark - 评论 切换
- (IBAction)btnActionCommand:(UIButton *)sender
{
    _viewWithSelectCommand.hidden = NO;
    _viewWithSelectZan.hidden = YES;
    _viewForTable.tag = 10002;
    [_viewForTable reloadData];
}

#pragma mark - 赞 切换
- (IBAction)btnActionZan:(UIButton *)sender
{
    _viewWithSelectCommand.hidden = YES;
    _viewWithSelectZan.hidden = NO;
    _viewForTable.tag = 10001;
    [_viewForTable reloadData];
}

#pragma mark - 收藏
- (IBAction)btnActionCollect:(UIButton *)sender
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode;
    verifyCode=[userDefaults objectForKey:@"verifyCode"];
    NSString *userID;
    userID = [userDefaults objectForKey:@"id"];
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    
    if (sender.tag==60000)//已收藏 去取消收藏
    {
        [parameters setObject:userID forKey:@"doctorId"];
        [parameters setObject:_str_topID forKey:@"sourceId"];
        [RequestManager getWithURLString:COLLECTIONCANCEL heads:heads parameters:parameters success:^(id responseObject){
            //            NSLog(@"%@",responseObject);
            _btnCollect.tag = 70000;
            [_Image_Collect setImage:[UIImage imageNamed:@"i-收藏关注"]];
            //更新收藏数据
            [self getCollectCountData];
            [showAlertView showAlertViewWithMessage:@"取消收藏"];
        } failure:^(NSError *error) {
            
        }];
    }
    else if (sender.tag==70000)//未收藏 去收藏申请
    {
        [parameters setObject:userID forKey:@"collector"];
        //收藏来源ID
        [parameters setObject:_str_topID forKey:@"sourceID"];
        if (_arrForImage.count != 0)
        {
            NSDictionary *imageDic = _arrForImage[0];
            NSString *imageUrl = imageDic[@"picUrl"];
            [parameters setObject:imageUrl forKey:@"picUrl"];
        }
        if (_isCircle==YES)//眼科圈
        {
            [parameters setObject:@"3" forKey:@"sourceType"];
        }
        else//互联网会诊
        {
            [parameters setObject:@"2" forKey:@"sourceType"];
        }
        NSString *title = [NSString stringWithFormat:@"%@",_dic_infoData[@"title"]];
        if (title.length>=20)
        {
            title = [title substringToIndex:20];
        }
        [parameters setObject:title forKey:@"title"];
        [RequestManager postWithURLString:COLLECTIONADD heads:heads parameters:parameters success:^(id responseObject) {
            [showAlertView showAlertViewWithMessage:@"收藏成功"];
            [_Image_Collect setImage:[UIImage imageNamed:@"i-收藏关注_h"]];
            _btnCollect.tag = 60000;
            //收藏个数
            NSInteger countForcollect = [_dic_infoData[@"collectCount"] integerValue];
            _lbl_collect.text = [NSString stringWithFormat:@"%d",(int)countForcollect+1];
            //        NSLog(@"%@",responseObject);
        } failure:^(NSError *error){
            NSLog(@"错误 = %@",error);
        }];
    }
}

#pragma mark - 评论页面
- (IBAction)btnActionForCommand:(UIButton *)sender
{
    //创建新增患者界面
    UIStoryboard *storyboardName=[UIStoryboard storyboardWithName:@"WebLine" bundle:[NSBundle mainBundle]];
    //指定对应的故事版
    KCommandViewController *commandView=[storyboardName instantiateViewControllerWithIdentifier:@"KCommandViewController"];
    commandView.isCopy = 1;//没有指定回复人
    commandView.topID = _str_topID;
    commandView.dic_command = _dic_infoData;//----
    if (_isCircle==YES)//眼科圈
    {
        commandView.isCircle = YES;
    }
    else//互联网会诊
    {
        commandView.isCircle = NO;
    }
    //---
    //推送
    [self.navigationController pushViewController:commandView animated:YES];
}

#pragma mark - 点赞按钮
- (IBAction)btnActionForZan:(UIButton *)sender
{
    MBProgressHUD *_HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _HUD.mode = MBProgressHUDModeIndeterminate;
    _HUD.labelText = @"点赞";
    _HUD.hidden = NO;
    sender.userInteractionEnabled = NO;
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode;
    verifyCode=[userDefaults objectForKey:@"verifyCode"];
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    NSString *strID =[[NSString alloc]init];
    NSString *userID = [[NSString alloc]init];
    userID = [userDefaults objectForKey:@"id"];
    
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    //医生ID
    [parameters setObject:userID forKey:@"doctorId"];
    //评论类型
    [parameters setObject:@"1" forKey:@"commentType"];
    //被回复ID
    [parameters setObject:_str_doctorID forKey:@"reviewerId"];
    //----
    
    if (_isCircle==YES)//眼科圈
    {
        strID = _dic_infoData[@"topicId"];
        [parameters setObject:strID forKey:@"topicId"];
    }
    else//互联网会诊
    {
        strID = _dic_infoData[@"id"];
        [parameters setObject:strID forKey:@"consulId"];
    }
    //---
    
    if (sender.tag==90000) //已点赞过 - 取消点赞
    {
        //----
        if (_isCircle==YES)//眼科圈
        {
            [parameters setObject:_str_ZanID forKey:@"commentId"];
            [RequestManager getWithURLString:DELEGATE_CIRCLE_COMMENT heads:heads parameters:parameters success:^(id responseObject) {
                //            NSLog(@"%@",responseObject);
                _btnForZan.tag = 80000;
//                _lbl_zan.text = [NSString stringWithFormat:@"%d",(int)(_upvoteCount)-1];
//                _btnZan.text = [NSString stringWithFormat:@"赞:%d",(int)(_upvoteCount)-1];
                [_image_zan setImage:[UIImage imageNamed:@"i赞"]];
                [self getDataForCommlist];
                [_viewForTable reloadData];
                _HUD.hidden = YES;
                sender.userInteractionEnabled = YES;
            } failure:^(NSError *error) {
                _HUD.hidden = YES;
                sender.userInteractionEnabled = YES;
                NSLog(@"%@",error);
            }];
        }
        else//互联网会诊
        {
            [parameters setObject:_str_ZanID forKey:@"commentId"];
            [RequestManager getWithURLString:DELEGATE_ZAN heads:heads parameters:parameters success:^(id responseObject) {
                //            NSLog(@"%@",responseObject);
                _btnForZan.tag = 80000;
//                _lbl_zan.text = [NSString stringWithFormat:@"%d",(int)(_upvoteCount)-1];
//                _btnZan.text = [NSString stringWithFormat:@"赞:%d",(int)(_upvoteCount)-1];
                [_image_zan setImage:[UIImage imageNamed:@"i赞"]];
                [self getDataForCommlist];
                [_viewForTable reloadData];
                _HUD.hidden = YES;
                sender.userInteractionEnabled = YES;
            } failure:^(NSError *error) {
                _HUD.hidden = YES;
                sender.userInteractionEnabled = YES;
                NSLog(@"%@",error);
            }];
        }
        //---
    }
    else  //未点赞 - 点赞
    {
        //----
        if (_isCircle==YES)//眼科圈
        {
            [RequestManager postWithURLString:CIRCLEVIEWFINFO_COMMENTS heads:heads parameters:parameters success:^(id responseObject) {
                _btnForZan.tag = 90000;
                _upvoteCount = (int)_arr_commentZan.count;
                _lbl_zan.text = [NSString stringWithFormat:@"%d",(int)(_upvoteCount)+1];
                _btnZan.text = [NSString stringWithFormat:@"赞:%d",(int)(_upvoteCount)+1];
                [_image_zan setImage:[UIImage imageNamed:@"i赞_h"]];
                [self getDataForCommlist];
                [_viewForTable reloadData];
                _HUD.hidden = YES;
                sender.userInteractionEnabled = YES;
            } failure:^(NSError *error)
             {
                 _HUD.hidden = YES;
                 sender.userInteractionEnabled = YES;
                 NSLog(@"%@",error);
             }];
        }
        else//互联网会诊
        {
            [RequestManager postWithURLString:COMMENTADD heads:heads parameters:parameters success:^(id responseObject)
             {
                 _btnForZan.tag = 90000;
                 _upvoteCount = (int)_arr_commentZan.count;
                 _lbl_zan.text = [NSString stringWithFormat:@"%d",(int)(_upvoteCount)+1];
                 _btnZan.text = [NSString stringWithFormat:@"赞:%d",(int)(_upvoteCount)+1];
                 [_image_zan setImage:[UIImage imageNamed:@"i赞_h"]];
                 [self getDataForCommlist];
                 [_viewForTable reloadData];
                 _HUD.hidden = YES;
                 sender.userInteractionEnabled = YES;
             } failure:^(NSError *error)
             {
                 _HUD.hidden = YES;
                 sender.userInteractionEnabled = YES;
                 NSLog(@"%@",error);
             }];
        }
        //--
        
    }
}

#pragma mark - 更新收藏个数
-(void)getCollectCountData
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode;
    verifyCode=[userDefaults objectForKey:@"verifyCode"];
    NSString *userID;
    userID = [userDefaults objectForKey:@"id"];
    
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    
    NSString *str_url = [[NSString alloc]init];
    if (_isCircle==YES)//眼科圈
    {
        //眼科ID
        [parameters setObject:_str_topID forKey:@"topicId"];
        str_url = CIRCLEVIEWFINFO_DATA;
    }
    else//互联网会诊
    {
        //会诊ID
        [parameters setObject:_str_topID forKey:@"id"];
        str_url = NETCONSULTATIONDETAILFIND;
    }
    [parameters setObject:userID forKey:@"doctorId"];
    
    //GET
    [RequestManager getWithURLString:str_url heads:heads parameters:parameters success:^(id responseObject)
     {
         _dic_infoData = responseObject[@"value"];
         NSString *doctorID = _dic_infoData[@"doctorId"];
         if (![doctorID isEqualToString:userID])//判断是否本身的详情
         {
             UIButton *releaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
             UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:releaseButton];
             self.navigationItem.rightBarButtonItem = releaseButtonItem;
         }
         _arr_commentList = [[NSMutableArray alloc]init];
         
         _arr_commentList = _dic_infoData[@"commentList"];
         //收藏
         _lbl_collect.text  = [NSString stringWithFormat:@"%@",_dic_infoData[@"collectCount"]];
         //----
         if (_isCircle==YES)//眼科圈
         {
             _str_topID = _dic_infoData[@"topicId"];
         }
         else//互联网会诊
         {
             _str_topID = _dic_infoData[@"id"];
         }
         //---
         //是否收藏
         NSString *strSelect = [[NSString alloc]init];
         strSelect = _dic_infoData[@"isCollect"];
         if ([strSelect isEqualToString:@"false"])
         {
             [_Image_Collect setImage:[UIImage imageNamed:@"i-收藏关注"]];
             _btnCollect.tag = 70000;
         }
         else
         {
             [_Image_Collect setImage:[UIImage imageNamed:@"i-收藏关注_h"]];
             _btnCollect.tag = 60000;
         }
     } failure:^(NSError *error)
     {
         NSLog(@"%@",error);
     }];
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
