//
//  AddFriendsViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/6.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AddFriendsViewController.h"
#import "FriendvalidationTableViewCell.h"
@interface AddFriendsViewController ()<UITableViewDataSource,UITableViewDelegate,relodataTableView>
@property (strong, nonatomic) NSArray *arr_friendLitData;
@property (strong, nonatomic) NSString *verifyCode,*userID;
@property (weak, nonatomic) IBOutlet UITableView *view_table1;

@end

@implementation AddFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _view_table1.delegate = self;
    _view_table1.dataSource = self;
    
    self.arr_friendLitData = [[NSArray alloc]init];
    [self getfriendListData];
}
#pragma mark - cell返回回来的刷新方法
-(void)reloadTableViewWithData:(NSDictionary *)data
{
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    _verifyCode=[userDefaults objectForKey:@"verifyCode"];
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:self.verifyCode};
    [RequestManager postWithURLString:CIRCLEFRIENDVALIDATE heads:heads parameters:data success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [self getfriendListData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
//    [_view_table1 reloadSections:[[NSIndexSet alloc]initWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - tableview delegate datasouse
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr_friendLitData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendvalidationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendvalidationTableViewCell"];
    
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FriendvalidationTableViewCell" owner:self options:nil]lastObject];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.reloadDelegate =self;
    [cell setCell:self.arr_friendLitData[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取请求好友的表格数据
-(void)getfriendListData
{
    //获取verifyCode 和 ID
    //获取已添加页面的数据
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    _verifyCode=[userDefaults objectForKey:@"verifyCode"];
    //获取用户ID
    _userID=[userDefaults objectForKey:@"id"];
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:self.verifyCode};
    
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    
    [parameters setObject:_userID forKey:@"doctorId"];
    
    //获取需要上传的数据
    //GET
    [RequestManager getWithURLString:CIRELE_CIRELE_FRIENDINFO heads:heads parameters:parameters success:^(id responseObject)
     {
         self.arr_friendLitData = responseObject[@"value"];
//         NSLog(@"%@",self.arr_friendLitData);
        [_view_table1 reloadData];
     } failure:^(NSError *error)
     {
         NSLog(@"ERROR%@",error);
     }];
    [_view_table1 reloadData];
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
