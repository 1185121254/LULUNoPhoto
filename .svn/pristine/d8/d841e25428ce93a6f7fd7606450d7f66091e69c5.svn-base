//
//  SelectFriendsViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/10.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "SelectFriendsViewController.h"
#import "SelectFriendTableViewCell.h"

@interface SelectFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
//放头像的view
@property (weak, nonatomic) IBOutlet UIScrollView *image_FriendList;
//确定按钮
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnActionselectEnter;
//全选按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_allSelect;
//全选按钮
@property (weak, nonatomic) IBOutlet UIImageView *image_allSelect;
//朋友显示的试图
@property (weak, nonatomic) IBOutlet UITableView *view_tableView;
//全选标题
@property (weak, nonatomic) IBOutlet UILabel *lbl_Allselect;
//网络获取下来的数组数组
@property (strong, nonatomic) NSMutableArray *arr_patientData;
@property (strong, nonatomic) NSMutableArray *arr_doctorData;
//增加选择属性后的医生字典和患者字典
//@property (strong, nonatomic) NSMutableArray *arr_new_patientData;
//@property (strong, nonatomic) NSMutableArray *arr_new_doctorData;
//被选中的用户的数组
@property (strong, nonatomic) NSMutableArray *arr_select;

//是否隐藏患者
@property (assign, nonatomic) int intPatient;
@property (assign, nonatomic) int intDoctor;

@property (weak, nonatomic) IBOutlet UITextField *SearchTextFile;

@end

@implementation SelectFriendsViewController

-(void)viewWillAppear:(BOOL)animated
{
    _arr_patientData = [[NSMutableArray alloc]init];
    _arr_doctorData = [[NSMutableArray alloc]init];
    _arr_select = [[NSMutableArray alloc]init];
    
    //获取好友列表数据
    [self getFriendListData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kBackgroundColor;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onSendSearch) name:UITextFieldTextDidEndEditingNotification object:nil];
    _image_FriendList.showsVerticalScrollIndicator = YES;
}

#pragma mark - 重写tableView headview试图
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 30)];
    if (section==0)
    {
        headView.backgroundColor = [UIColor colorWithWhite:0.946 alpha:1.000];
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kWith, 30)];
        title.textColor = [UIColor grayColor];
        title.font = [UIFont systemFontOfSize:14];
        title.text =  @"我的患者";
        [headView addSubview:title];
        
        UITapGestureRecognizer *patientTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(patientTap:)];
        [headView addGestureRecognizer:patientTap];
        
        return headView;
    }
    else
    {
        headView.backgroundColor = [UIColor colorWithWhite:0.946 alpha:1.000];
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kWith, 30)];
        title.textColor = [UIColor grayColor];
        title.font = [UIFont systemFontOfSize:14];
        title.text =  @"我的医生朋友";
        [headView addSubview:title];
        
        UITapGestureRecognizer *doctorTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doctorTap:)];
        [headView addGestureRecognizer:doctorTap];
        
        return headView;
    }
}
#pragma mark - 重写tableViewfoot
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 1)];
     headView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.103];
     return headView;
}

#pragma mark - 患者头部点击事件
-(void)patientTap:(UITapGestureRecognizer*)sender
{
//    NSLog(@"患者");
    if (_intPatient==1)
    {
        _arr_patientData = [[NSMutableArray alloc]init];
        _intPatient=2;
    }
    else
    {
        _intPatient=1;
        [self getFriendListData];
    }
    [_view_tableView reloadData];
}

#pragma mark - 医生头部点击事件
-(void)doctorTap:(UITapGestureRecognizer*)sender
{
    if (_intDoctor==1)
    {
        _arr_doctorData = [[NSMutableArray alloc]init];
        _intDoctor=2;
    }
    else
    {
        _intDoctor=1;
        [self getFriendListData];
    }
    [_view_tableView reloadData];
}

#pragma mark - tableView 代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //病人列表
    if (section==0)
    {
        return _arr_patientData.count;
    }
    //医生列表
    else
    {
        return _arr_doctorData.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //我的患者
    if (indexPath.section==0)
    {
        //获取要设置的对象
        [self buttonSelectChange:indexPath withArray:_arr_patientData];
    }
    //我的医生朋友
    if (indexPath.section==1)
    {
        [self buttonSelectChange:indexPath withArray:_arr_doctorData];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectFriendTableViewCell"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SelectFriendTableViewCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //病人的列表
    if (indexPath.section==0)
    {
        dic = _arr_patientData[indexPath.row];
        if (_arr_select.count == 0)
        {
            [cell setCell:dic patient:YES andSelect:NO];
        }
        else
        {
            if ([_arr_select containsObject:dic])
            {
                [cell setCell:dic patient:YES andSelect:YES];
            }
            else
            {
                [cell setCell:dic patient:YES andSelect:NO];
            }
        }
    }
    else if (indexPath.section==1)
    {
        dic = _arr_doctorData[indexPath.row];
        if (_arr_select.count == 0)
        {
            [cell setCell:dic patient:NO andSelect:NO];
        }
        else
        {
            if ([_arr_select containsObject:dic])
            {
                [cell setCell:dic patient:NO andSelect:YES];
            }
            else
            {
                [cell setCell:dic patient:NO andSelect:NO];
            }
        }
    }
    return cell;
}

#pragma mark - 设置选择行
-(void)buttonSelectChange:(NSIndexPath *)indexPath withArray:(NSMutableArray *)array
{
    //获取要设置的对象
    NSMutableDictionary *dic = array[indexPath.row];
    if (_arr_select.count == 0)
    {
        [_arr_select addObject:dic];
    }
    else
    {
        if ([_arr_select containsObject:dic])
        {
            [_arr_select removeObject:dic];
        }
        else
        {
            [_arr_select addObject:dic];
        }
    }
    [_view_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self createHeadViewIndexPath:indexPath withArray:array];
}

#pragma mark - 设置选中的头像
-(void)createHeadViewIndexPath:(NSIndexPath*)indexPath withArray:(NSMutableArray *)array
{
    //循环遍历移除view中的子视图
    for (UIImageView *headImageView in [_image_FriendList subviews])
    {
        if ([headImageView isKindOfClass:[UIImageView class]])
        {
            [headImageView removeFromSuperview];
        }
    }
    CGFloat withScroller = 0.0;
    //设置选中的头像
    for (int i = 0; i<_arr_select.count; i++)
    {
        NSDictionary *dic = [[NSDictionary alloc]init];
        dic = _arr_select[i];
    
        NSString *imageURl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,dic[@"picFileName"]];
        if ([[dic allKeys] containsObject:@"picfileName"])
        {
            imageURl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,dic[@"picfileName"]];
        }
        imageURl = [imageURl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(36*i+5, 3, 36, 36)];
        [image sd_setImageWithURL:[NSURL URLWithString:imageURl] placeholderImage:[UIImage imageNamed:@"chatfrom_doctor_icon"]];
        image.layer.cornerRadius=image.frame.size.height/2;
        [image.layer setMasksToBounds:YES];
        image.tag = 40000+i;
        withScroller = 36*i+5+36+5;
        [_image_FriendList addSubview:image];
    }
    _image_FriendList.contentSize = CGSizeMake(withScroller, 41);
}

#pragma mark - 搜索获取联系人列表
-(void)onSendSearch
{
    [self getParatientsList:_SearchTextFile.text];
    [self getDoctorFriendList:_SearchTextFile.text];
}

#pragma mark - 获取联系人的列表数据
-(void)getFriendListData
{
    [self getParatientsList:@""];
    [self getDoctorFriendList:@""];
    //如果有上个页面的数据
    if (_arr_selectForUppageData.count != 0)
    {
        _arr_select = [NSMutableArray arrayWithArray:_arr_selectForUppageData];
        [self createImageForHead];
        [_view_tableView reloadData];
    }
}

#pragma mark - 从眼科圈获取医生好友数据
-(void)getDoctorFriendList:(NSString *)text
{
    //获取已添加页面的数据
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
    
    [parameters setObject:userID forKey:@"doctorId"];
    [parameters setObject:text forKey:@"doctorName"];
    //GET
    [RequestManager getWithURLString:CHEACK_FRIEND_LIST heads:heads parameters:parameters success:^(id responseObject)
     {
         _arr_doctorData = responseObject[@"value"];
        [_view_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
     } failure:^(NSError *error)
     {
         NSLog(@"ERROR%@",error);
     }];
}

#pragma mark - 从患者报道获取我的患者数据
-(void)getParatientsList:(NSString *)text
{
    //获取已添加页面的数据
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
    
    [parameters setObject:userID forKey:@"doctorId"];
    [parameters setObject:text forKey:@"patientName"];

    //GET
    [RequestManager getWithURLString:GETPARIENDTSLISTDADA heads:heads parameters:parameters success:^(id responseObject)
     {
         _arr_patientData = responseObject[@"value"];
          [_view_tableView reloadData];
         
     } failure:^(NSError *error)
     {
         NSLog(@"ERROR%@",error);
     }];
}

#pragma mark - 全选按钮
- (IBAction)btnActionSelectAll:(UIButton *)sender
{
    _arr_select = [[NSMutableArray alloc]init];
    if (sender.tag==90000)
    {
        for (int i =0; i<_arr_patientData.count; i++)
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            dic = [_arr_patientData[i] mutableCopy];
            [_arr_select addObject:dic];
        }
        for (int i =0; i<_arr_doctorData.count; i++)
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            dic = [_arr_doctorData[i] mutableCopy];
            if ([dic objectForKey:@"userName"]!=nil)
            {
                [_arr_select addObject:dic];
            }
        }
        //设置全选头像
        [self createFriendHeadAllSelect];
        sender.tag = 90001;
        _lbl_Allselect.text = @"反选";
        [_image_allSelect setImage:[UIImage imageNamed:@"i圈_h"]];
    }

    else if (sender.tag==90001)
    {
        for (int i =0; i<_arr_patientData.count; i++)
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            dic = [_arr_patientData[i] mutableCopy];
            
            NSNumber *isSelect = [NSNumber numberWithBool:NO];
            [dic setObject:isSelect forKey:@"isSelect"];
        }
    
        for (int i =0; i<_arr_doctorData.count; i++)
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            dic = [_arr_doctorData[i] mutableCopy];
            NSNumber *isSelect = [NSNumber numberWithBool:NO];
            [dic setObject:isSelect forKey:@"isSelect"];
        }
        //移除头像试图
        _arr_select = [[NSMutableArray alloc]init];
        //循环遍历移除view中的子视图
        for (UIImageView *headImageView in [_image_FriendList subviews])
        {
            if ([headImageView isKindOfClass:[UIImageView class]])
            {
                [headImageView removeFromSuperview];
            }
        }
        sender.tag = 90000;
        _lbl_Allselect.text = @"全选";
         [_image_allSelect setImage:[UIImage imageNamed:@"i圈"]];
    }
    //刷新表格
    [_view_tableView reloadData];
}

#pragma mark - 全选
-(void)createFriendHeadAllSelect
{
    //分别遍历医生和患者的数组,取出里面选中的头像进行设置
    for (int i =0; i<_arr_select.count; i++)
    {
        NSMutableDictionary *dic =[[NSMutableDictionary alloc]init];
        dic = _arr_select[i];
        //滚动头像的创建
        [self createImageForHead];
    }
}

#pragma mark - 滚动头像的创建
-(void)createImageForHead
{
    CGFloat withScroller = 0.0;
    //设置选中的头像
    for (int i = 0; i<_arr_select.count; i++)
    {
        NSDictionary *dic = [[NSDictionary alloc]init];
        dic = _arr_select[i];
        NSString *imageURl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,dic[@"picFileName"]];
        if ([[dic allKeys] containsObject:@"picfileName"])
        {
            imageURl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,dic[@"picfileName"]];
        }
        imageURl = [imageURl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(36*i+5, 3, 36, 36)];
        [image sd_setImageWithURL:[NSURL URLWithString:imageURl] placeholderImage:[UIImage imageNamed:@"chatfrom_doctor_icon"]];
        image.layer.cornerRadius=image.frame.size.height/2;
        [image.layer setMasksToBounds:YES];
        image.tag = 40000+i;
        withScroller = 36*i+5+36+5;
        [_image_FriendList addSubview:image];
    }
    _image_FriendList.contentSize = CGSizeMake(withScroller, 41);
}

#pragma mark - 确定按钮
- (IBAction)OKAction:(UIBarButtonItem *)sender
{
    // 制作通知的消息
    NSDictionary *dict = @{@"selectArr":_arr_select};
    /**
     *  notificationWithName : 通知的名字
     *  object : 发送者
     *  userInfo : 携带的信息
     */
    // 创建通知对象
    NSNotification *notification = [NSNotification notificationWithName:@"friendList" object:self userInfo:dict];
    // 把通知给通知中心发送 发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
