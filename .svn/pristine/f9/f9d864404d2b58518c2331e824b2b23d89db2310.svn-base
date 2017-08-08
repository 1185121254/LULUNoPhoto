//
//  FriendsListViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/4/26.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "FriendsListViewController.h"
#import "FriendTableViewCell.h"
@interface FriendsListViewController ()<UITableViewDataSource,UITableViewDelegate>

//设置用户VerifyCode 和ID
@property (strong, nonatomic) NSString *userID,*verifyCode;

//好友的列表
@property (strong, nonatomic) NSMutableArray *arr_friendListData;

//创建右侧导航栏
@property (strong, nonatomic) NSMutableArray *arr_key;
//字典中的key
@property (strong, nonatomic) NSMutableArray *arr_dicKey;

@property (strong, nonatomic) NSMutableDictionary *dic_ground;

//整理过后的数据
@property (strong, nonatomic) NSMutableArray *arr_DoneData;
//tableview
@property (weak, nonatomic) IBOutlet UITableView *view_table;

@end

@implementation FriendsListViewController

-(NSMutableArray *)arr_friendListData
{
    if (_arr_friendListData == nil)
    {
        _arr_friendListData = [[NSMutableArray alloc]init];
    }
    return _arr_friendListData;
}
-(NSMutableArray *)arr_dicKey
{
    if (_arr_dicKey==nil)
    {
        _arr_dicKey = [[NSMutableArray alloc]init];
    }
    return _arr_dicKey;
}
-(NSMutableArray *)arr_key
{
    if (_arr_key==nil)
    {
        _arr_key = [[NSMutableArray alloc]init];
    }
    return _arr_key;
}
-(NSMutableArray *)arr_DoneData
{
    if (_arr_DoneData==nil)
    {
        _arr_DoneData = [[NSMutableArray alloc]init];
    }
    return _arr_DoneData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _view_table.sectionIndexColor = BLUECOLOR_STYLE;
    _view_table.sectionIndexTrackingBackgroundColor=[UIColor greenColor];
    //修改navigationBar返回键的颜色
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self getFriendListData];
    // Do any additional setup after loading the view.
}


#pragma mark - 传入汉子字符串,返回大写字母拼音首字母
-(NSString *)firstCharactor:(NSString *)WordString
{
    //转为可变的字符串
    NSMutableString *str = [NSMutableString stringWithString:WordString];
    //转为带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    //转为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    //转为大写拼音
    NSString * pinYin = [str capitalizedString];
    //返回首字母
    return [pinYin substringToIndex:1];
}

#pragma mark - 处理tableview的数组数组,并设置右侧的导航字母
-(void)createTableViewData
{
    //创建字典,存储英文的开头 和相对应的数组
    NSMutableDictionary *dic_name = [[NSMutableDictionary alloc]init];
    
    //创建26个可变的数组
    for (char character = 'A'; character <='Z'; character++)
    {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        [dic_name setObject:arr forKey:[NSString stringWithFormat:@"%c",character]];
        //A-Z 26 存入右侧栏的数组中
        [_arr_key addObject:[NSString stringWithFormat:@"%c",character]];
    }
    
    //把网络获取到的数组 按字母顺序检索出来, 放入对应的数组中
    for (int i=0; i<_arr_friendListData.count; i++)
    {
        //取出总数据中的字典
        NSMutableDictionary *dic_DataWithname = [[NSMutableDictionary alloc]init];
        //获得对应字典
        dic_DataWithname = _arr_friendListData[i];
        //获取字典中的名字
        NSString *str_names = dic_DataWithname[@"userName"];
        //通过名字获取拼音的首字母作为key值
        NSString *str_firtWord = [self firstCharactor:str_names];
        
        //取出26个字母的字典,把这个字典作为数组元素加入26个字母对应的key中
        NSMutableArray *array = [[NSMutableArray alloc]init];
        array = [dic_name objectForKey:str_firtWord];
        [array addObject:dic_DataWithname];
    }
    
    //把空的数组去掉
    for (char character = 'A'; character <= 'Z'; character++)
    {
        NSString *key = [NSString stringWithFormat:@"%c",character];
        NSArray *array = [dic_name objectForKey:key];
        if (!array.count)
        {
            [dic_name removeObjectForKey:key];
        }
    }
//     NSLog(@"%@",dic_name);
    
    //获取字典key值,并排序
    _arr_key = [[dic_name.allKeys sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
    
    //分组字典
    _dic_ground = dic_name;
    
}

#pragma mark - tableView dataSouse delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arr_key.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _arr_key[section];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _arr_key;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [_arr_key objectAtIndex:section];
    NSArray *arr = [_dic_ground objectForKey:key];
    return arr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendTableViewCell"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FriendTableViewCell" owner:self options:nil]lastObject];
    }
    NSString *key = [_arr_key objectAtIndex:indexPath.section];
    NSArray *arr = [_dic_ground objectForKey:key];
    NSMutableDictionary *dic = arr[indexPath.row];
    [cell setCell:dic];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - 获取好友列表
-(void)getFriendListData
{
    //获取verifyCode 和 ID
    
    //获取已添加页面的数据
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    self.verifyCode=[userDefaults objectForKey:@"verifyCode"];
    
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:self.verifyCode};
    
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    //获取登录医生数据字典
    NSMutableDictionary *userDic=[NSMutableDictionary new];
    userDic=[userDefaults objectForKey:@"DoctorDataDic"];
    _userID = userDic[@"loginid"];
    [parameters setObject:_userID forKey:@"doctorId"];
    
    //GET
    [RequestManager getWithURLString:CHEACK_FRIEND_LIST heads:heads parameters:parameters success:^(id responseObject)
     {
         _arr_friendListData = responseObject[@"value"];
         
          NSLog(@"%@",_arr_friendListData);
         
         //对数据进行处理,分组
          [self createTableViewData];
         
         [_view_table reloadData];
         
     } failure:^(NSError *error) {
         NSLog(@"error===%@",error);
     }];
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
