//
//  CircleInfoViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/4/26.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "CircleInfoViewController.h"
#import "EyeCircleViewController.h"
#import "DialogueTableViewCell.h"
@interface CircleInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UICollectionView *imageCollection;
}

@property (weak, nonatomic) IBOutlet UILabel *Lbl_doctorName;//姓名
@property (weak, nonatomic) IBOutlet UIImageView *image_headImage;//头像试图
@property (weak, nonatomic) IBOutlet UILabel *lbl_hospatialName;//医院
@property (weak, nonatomic) IBOutlet UILabel *lbl_InfoTitle;//名称
@property (weak, nonatomic) IBOutlet UILabel *lbl_infoText;//内容
@property (weak, nonatomic) IBOutlet UIView *view_Image;//图片的容器
@property (weak, nonatomic) IBOutlet UILabel *lbl_time;//时间
@property (weak, nonatomic) IBOutlet UIButton *btn_zan;//点赞按钮
@property (weak, nonatomic) IBOutlet UIView *view_zan;//放点赞图片的容器
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height_tableview;

@property (weak, nonatomic) IBOutlet UITableView *view_table;//表格试图
@property (weak, nonatomic) IBOutlet UIView *view_headView;//头部试图

//图片试图高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HeightForImageView;
//头部试图高度
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HeightForHeaderView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *HeightForScrollerView;
//病例详情页面
@property (strong, nonatomic) NSMutableDictionary *dic_infoData;
//设置用户VerifyCode
@property (strong, nonatomic)NSString *verifyCode;

@property (strong, nonatomic) IBOutlet UIView *talkView;//聊天的文本框试图
@property (weak, nonatomic) IBOutlet UITextField *txtTalk;//输入文本框
@property (weak, nonatomic) IBOutlet UIScrollView *infoScrollView;//滚动试图


@property (strong, nonatomic) NSMutableDictionary *dic_userData;

@property (strong, nonatomic) NSMutableArray *arr_imageView;

@property (strong, nonatomic) UIImageView *collection_image;

//评论数据
@property (strong, nonatomic) NSMutableArray *arr_comments;
@property (strong, nonatomic) NSMutableArray *arr_zan;
@property (strong, nonatomic) NSMutableArray *arr_talk;

//医生ID
@property (strong, nonatomic) NSString *str_doctorID;
//回复的医生ID
@property (strong, nonatomic) NSString *str_replyToDoctorID;
//tableview的高度
//@property (assign, nonatomic) CGFloat Hight_tableview;
@end

@implementation CircleInfoViewController

-(void)viewWillAppear:(BOOL)animated
{
    //修改navigationBar返回键的颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.talkView.frame=CGRectMake(0, self.infoScrollView.frame.size.height-55, SCREEN_W, 55);
    [self.view addSubview:self.talkView];
    _txtTalk.layer.cornerRadius = 5;
    _txtTalk.layer.masksToBounds = YES;
    _infoScrollView.backgroundColor=[UIColor colorWithWhite:0.000 alpha:0.102];
    
    //downloadData
    [self createDataInfoWithInfoPageCase:YES AndTalk:NO AndZan:YES];
    
    //未点赞tag
    _btn_zan.tag = 20000;
    _view_table.delegate = self;
    _view_table.dataSource = self;
}

#pragma mark - 评论数据的处理 分开点赞和评论的数据
-(void)commentsData
{
    if (_arr_talk==nil)
    {
        _arr_talk = [[NSMutableArray alloc]init];
    }
    if (_arr_zan==nil)
    {
        _arr_zan = [[NSMutableArray alloc]init];
    }
    if (_arr_comments==nil)
    {
        _arr_comments = [[NSMutableArray alloc]init];
    }
    
    //区分点赞头像和评论数据
    for (int i = 0; i<_arr_comments.count; i++)
    {
         NSMutableDictionary *dic =_arr_comments[i];
        NSInteger int_type = [dic[@"commentType"] integerValue];
        if (int_type==1)
        {
            [_arr_zan addObject:dic];
        }
         else if(int_type==2)
        {
            [_arr_talk addObject:dic];
        }
    }
    //判断点赞按钮是否点中
    [self judgeZanIsSelect];
}

#pragma mark - 判断点赞按钮是否点中
-(void)judgeZanIsSelect
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    userDic =  [userDefaults objectForKey:@"DoctorDataDic"];
    NSString *longinid = userDic[@"loginid"];
    
    NSDictionary *dic_zan = [[NSDictionary alloc]init];
    for (int i = 0; i<_arr_zan.count; i++)
    {
        dic_zan = _arr_zan[i];
        NSString *str_zan = dic_zan[@"doctorId"];
        if ([str_zan isEqualToString:longinid])
        {
            [_btn_zan setImage:[UIImage imageNamed:@"i赞_h"] forState:UIControlStateNormal];
            _btn_zan.tag = 20001;
        }
    }
}

#pragma mark - 点赞按钮
- (IBAction)btnAct_zan:(UIButton *)sender
{
    if (_btn_zan.tag==20000)
    {
        //上传点赞数据并刷新点赞头像
        [self createCommants];
    }
    if (_btn_zan.tag==20001)
    {
        [showAlertView showAlertViewWithOnlyMessage:@"您已点赞过,请勿重复操作!"];
    }
}

#pragma mark - 点赞网络请求
-(void)createCommants
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    self.verifyCode = [userdefault objectForKey:@"verifyCode"];
    
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:self.verifyCode};
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    //话题ID
    [parameters setObject:_str_topID forKey:@"topicId"];
    //评论者ID
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    userDic =  [userDefaults objectForKey:@"DoctorDataDic"];
    NSString *longinid = userDic[@"loginid"];
    [parameters setObject:longinid forKey:@"doctorId"];
    //评论类型
    [parameters setObject:@"1" forKey:@"commentType"];
    //被回复者ID
    NSString *userid = _str_doctorID;
    [parameters setObject:userid forKey:@"reviewerId"];
    
    //POST
    [RequestManager postWithURLString:CIRCLEVIEWFINFO_COMMENTS heads:heads parameters:parameters success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        _arr_talk = [[NSMutableArray alloc]init];
        _arr_zan = [[NSMutableArray alloc]init];
        //设置按钮点赞
        [_btn_zan setImage:[UIImage imageNamed:@"i赞_h"] forState:UIControlStateNormal];
        //点赞的tag值
        _btn_zan.tag=20001;
        //重新下载头像
        [self createDataInfoWithInfoPageCase:YES AndTalk:NO AndZan:YES];
    } failure:^(NSError *error)
    {
        NSLog(@"%@",error);
    }];
}

#pragma mark - tableViewdelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr_talk.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString  *CellIdentiferId = @"DialogueTableViewCell";
    DialogueTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentiferId];
    if (cell == nil)
    {
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"DialogueTableViewCell" owner:nil options:nil];
        cell = [nibs lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setCell:_arr_talk[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _str_replyToDoctorID = [[NSString alloc]init];
    //选择对应的ID提交对话信息
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic = _arr_talk[indexPath.row];
    _txtTalk.placeholder = [NSString stringWithFormat:@"回复%@",dic[@"userName"]];
    _str_replyToDoctorID = dic[@"doctorId"];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic_str =[[NSMutableDictionary alloc]init];
    dic_str = _arr_talk[indexPath.row];
    NSString *str = dic_str[@"commentDetail"];
    UIFont *tfont = [UIFont systemFontOfSize:14.0];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:tfont,NSFontAttributeName,nil];
    CGSize sizeText = [str boundingRectWithSize:CGSizeMake(SCREEN_W, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        _height_tableview.constant +=sizeText.height+60;
//        _HeightForScrollerView.constant = _height_tableview.constant+_HeightForImageView.constant;
//    });
    return sizeText.height+50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - 转化cell中的label文本
-(NSAttributedString *)attributeBodyTextAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
    dic = _arr_talk[indexPath.row];

    NSString *text = dic[@"commentDetail"];
    UIFont *font = [UIFont systemFontOfSize:12];

    NSDictionary *testDic = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];

    NSAttributedString *string = [[NSAttributedString alloc]initWithString:text attributes:testDic];

    return string;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//确定回复按钮 加号
- (IBAction)btn_enterReply:(UIButton *)sender
{
    if ([_txtTalk.text isEqualToString:@""])
    {
        [showAlertView showAlertViewWithOnlyMessage:@"回复内容不能为空"];
        return;
    }
    [self replyToDoctor];
}

#pragma mark - 对话网络请求
-(void)replyToDoctor
{
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    self.verifyCode = [userdefault objectForKey:@"verifyCode"];
    
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:self.verifyCode};
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    //话题ID
    [parameters setObject:_str_topID forKey:@"topicId"];
    //评论者ID
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    userDic =  [userDefaults objectForKey:@"DoctorDataDic"];
    NSString *longinid = userDic[@"loginid"];
    [parameters setObject:longinid forKey:@"doctorId"];
    //评论内容
    [parameters setObject:_txtTalk.text forKey:@"commentDetail"];
    //评论类型
    [parameters setObject:@"2" forKey:@"commentType"];
    //被回复者ID
    if (_str_replyToDoctorID==nil)
    {
        NSString *userid = _str_doctorID;
        [parameters setObject:userid forKey:@""];
    }
    else
    {
        NSString *userid = _str_replyToDoctorID;
        [parameters setObject:userid forKey:@"reviewerId"];
    }
    
    //POST
    [RequestManager postWithURLString:CIRCLEVIEWFINFO_COMMENTS heads:heads parameters:parameters success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
        _arr_talk = [[NSMutableArray alloc]init];
        dispatch_async(dispatch_get_main_queue(), ^{
        //重新下载数据并刷新
            [self createDataInfoWithInfoPageCase:YES AndTalk:NO AndZan:NO];
            [self setImageAtView:_arr_imageView];
            [_view_table reloadData];
            [_txtTalk resignFirstResponder];
            _txtTalk.text=@"";
        });
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 获取详情的数据
-(void)createDataInfoWithInfoPageCase:(BOOL)caseY_N AndTalk:(BOOL)talkY_N AndZan:(BOOL)ZanY_N
{
    //获取verifyCode
    //获取已添加页面的数据
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    self.verifyCode=[userDefaults objectForKey:@"verifyCode"];
    
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:self.verifyCode};
    
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];

    [parameters setObject:[NSString stringWithFormat:@"%@",_str_topID] forKey:@"topicId"];
    
    //GET
    [RequestManager getWithURLString:CIRCLEVIEWFINFO_DATA heads:heads parameters:parameters success:^(id responseObject)
     {
         _dic_infoData = (NSMutableDictionary *)responseObject;
         _dic_infoData = _dic_infoData[@"value"];
         _arr_comments = _dic_infoData[@"commentList"];
         //话题ID
         _str_topID = _dic_infoData[@"topicId"];
         //医生的ID
         _str_doctorID = _dic_infoData[@"doctorId"];
//         NSLog(@"_arr_comments 获取到的的表格数据%@-------",_dic_infoData);

         //评论数据的处理
         [self commentsData];
         
         //回调或者说是通知主线程刷新，
         dispatch_async(dispatch_get_main_queue(), ^{
             //回调后刷新点赞的表格
             [self settingViewDataFromDownding];
             if (ZanY_N==YES)
             {
                 //设置点赞的数据
                 [self setttingZan];
             }
         });

     } failure:^(NSError *error) {
         NSLog(@"GET获取页面上按钮的数据错误===%@",error);
     }];
}

#pragma mark - 设置点赞的图片
-(void)setttingZan
{
    for (int i=0; i<_arr_zan.count; i++)
    {
        NSMutableDictionary *dic = _arr_zan[i];
        NSString *url_zan = dic[@"picFileName"];
        url_zan = [self setImageURL:url_zan];
        
        UIImageView *image_zan =[[UIImageView alloc]init];
        [_view_zan addSubview:image_zan];
        [image_zan sd_setImageWithURL:[NSURL URLWithString:url_zan]];
        
        image_zan.frame = CGRectMake(50*i+45, 10, 30, 30);
        
        image_zan.layer.cornerRadius = image_zan.frame.size.height/2;
        image_zan.layer.masksToBounds = YES;
    }
}

#pragma mark - 设置试图的数据
-(void)settingViewDataFromDownding
{
    NSUserDefaults *userDrefaults = [NSUserDefaults standardUserDefaults];
    _dic_userData = [userDrefaults objectForKey:@"DoctorDataDic"];
   
    
    _str_topID = _dic_infoData[@"topicId"];
     NSLog(@"%@",_str_topID);
//    //通过ID去获取数据;
//    [self topIDforData];
    
    _Lbl_doctorName.text = _dic_infoData[@"userName"];
    NSString *url_headImage = _dic_infoData[@"picFileName"];
    url_headImage = [self setImageURL:url_headImage];
    [_image_headImage sd_setImageWithURL:[NSURL URLWithString:url_headImage]];
    _image_headImage.layer.cornerRadius = _image_headImage.frame.size.height/2;
    _image_headImage.layer.masksToBounds = YES;
    
    _lbl_InfoTitle.text = [NSString stringWithFormat:@"#%@#",_dic_infoData[@"title"]];
    _lbl_infoText.text = _dic_infoData[@"detail"];
    _lbl_time.text = _dic_infoData[@"createDate"];
    _lbl_hospatialName.text = _dic_infoData[@"licenseHospital"];
    _arr_imageView = _dic_infoData[@"picList"];
//    NSLog(@"%@",_arr_imageView);
    
    [self setImageAtView:_arr_imageView];
//    NSLog(@"%@",_dic_infoData[@"createDate"]);
}

#pragma mark - 设置图片
-(void)setImageAtView:(NSMutableArray *)imageArr
{
    int j = 0;
    int k = 0;
    NSLog(@"%@",_view_table.tableHeaderView);
    //  如果图片数组没有数据
    if (imageArr==nil)
    {
        _HeightForImageView.constant = 0;
//        _HeightForHeaderView.constant = _HeightForHeaderView.constant-90;
        
        CGRect temp = _view_headView.frame;
        temp.size.height =90+50+50+[self heightOfString:_lbl_infoText.text font:[UIFont systemFontOfSize:14] width:kWith-16];
        _view_table.tableHeaderView.frame = temp;
        [_view_table setTableHeaderView:_view_headView];
        
        //如果有评论的数据就创建评论的表格
        if (_arr_talk.count==0)
        {
            _view_table.contentSize = temp.size;
        }
        else
        {
            [_view_table reloadData];
        }
    }
    //否则设置图片
    for (int i = 0; i<imageArr.count; i++)
    {
        NSMutableDictionary *dic_view=[[NSMutableDictionary alloc]init];
        dic_view = imageArr[i];
        NSString *url_ViewImage = dic_view[@"microPicUrl"];
        url_ViewImage = [self setImageURL:url_ViewImage];
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.tag  = 10000+i;
        _image_headImage.userInteractionEnabled = YES;
        
        if (i<4)
        {
            imageView.frame = CGRectMake(i*SCREEN_W/4+(SCREEN_W/4-77), 5, 75, 75);
            [_view_Image addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url_ViewImage]];
            
            CGRect temp = _view_headView.frame;
            temp.size.height =90+50+50+[self heightOfString:_lbl_infoText.text font:[UIFont systemFontOfSize:14] width:kWith-16]+80+10;
            _view_table.tableHeaderView.frame = temp;
            [_view_table setTableHeaderView:_view_headView];
            
            //如果有评论的数据就创建评论的表格
            if (_arr_talk.count==0)
            {
                CGSize tempTable = _view_table.contentSize;
                tempTable.height = temp.size.height+100;
                _view_table.contentSize = tempTable;
            }
            else
            {
                [_view_table reloadData];
            }
        }
        if ((i>3)&&(i<8))
        {
            imageView.frame = CGRectMake(j*SCREEN_W/4+(SCREEN_W/4-77), 10+75, 75, 75);
            [_view_Image addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url_ViewImage]];
            _HeightForImageView.constant = 80*2+5;
            
            CGRect temp = _view_headView.frame;
            temp.size.height =90+50+50+[self heightOfString:_lbl_infoText.text font:[UIFont systemFontOfSize:14] width:kWith-16]+80*2+5;
            _view_table.tableHeaderView.frame = temp;
            [_view_table setTableHeaderView:_view_headView];
            
            //如果有评论的数据就创建评论的表格
            if (_arr_talk.count==0)
            {
                CGSize tempTable = _view_table.contentSize;
                tempTable.height = temp.size.height+100;
                _view_table.contentSize = tempTable;
            }
            else
            {
                [_view_table reloadData];
            }
            
             j = j+1;
        }
        if (i>7)
        {
            imageView.frame = CGRectMake(k*SCREEN_W/4+(SCREEN_W/4-77), 15+75+75, 75, 75);
            [_view_Image addSubview:imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:url_ViewImage]];
            _HeightForImageView.constant = 80*3+5;
            
            CGRect temp = _view_headView.frame;
            temp.size.height =90+50+50+[self heightOfString:_lbl_infoText.text font:[UIFont systemFontOfSize:14] width:kWith-16]+80*3+5;
            _view_table.tableHeaderView.frame = temp;
            [_view_table setTableHeaderView:_view_headView];
            
            //如果有评论的数据就创建评论的表格
            if (_arr_talk.count==0)
            {
                CGSize tempTable = _view_table.contentSize;
                tempTable.height = temp.size.height+100;
                _view_table.contentSize = tempTable;
            }
            else
            {
                [_view_table reloadData];
            }
            k = k+1;
        }
    }
}

#pragma mark - 计算label文本行高
-(CGFloat)heightOfString:(NSString *)string font:(UIFont *)font width:(CGFloat)width
{
    CGRect bounds;
    NSDictionary * parameterDict=[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    bounds=[string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:parameterDict context:nil];
    return bounds.size.height;
}

/**
 *  传入图片地址返回图片正确地址
 *
 *  @param url 图片地址
 *
 *  @return 转换好的地址
 */
-(NSString *)setImageURL:(NSString *)url
{
    url=[NSString stringWithFormat:@"%@%@",NET_URLSTRING,url];
    NSString *strUrl=[url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    return strUrl;
}

@end
