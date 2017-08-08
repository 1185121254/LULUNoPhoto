//
//  DoctorInfoTableViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/10.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "DoctorInfoTableViewController.h"
#import "SeachFriendViewController.h"
@interface DoctorInfoTableViewController ()<DoctorInfoDataDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *image_head;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_hospital;
@property (weak, nonatomic) IBOutlet UILabel *lbl_department;
//职称
@property (weak, nonatomic) IBOutlet UILabel *lbl_technical;

@property (weak, nonatomic) IBOutlet UILabel *lbl_beGoodAt;

@property (weak, nonatomic) IBOutlet UIButton *btn_addFirend;

@property (strong, nonatomic) NSMutableDictionary *dic_dictorData;

@end

@implementation DoctorInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self settingTableviewData];
}

-(void)sendDoctorDicData:(NSMutableDictionary *)dic
{
    _dic_dictorData = [[NSMutableDictionary alloc]init];
    _dic_dictorData = dic;
}

-(void)settingTableviewData
{
    _lbl_name.text = _dic_dictorData[@"userName"];
    _lbl_hospital.text = _dic_dictorData[@"licenseHospital"];
    _lbl_department.text = _dic_dictorData[@"licenseDept"];
    _lbl_technical.text = _dic_dictorData[@"licenseTitle"];
    _lbl_beGoodAt.text = _dic_dictorData[@"speciality"];
    
    NSString *imageURl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,_dic_dictorData[@"picFileName"]];
    imageURl = [imageURl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [_image_head sd_setImageWithURL:[NSURL URLWithString:imageURl]];
    _image_head.layer.cornerRadius=_image_head.frame.size.height/2;
    [_image_head.layer setMasksToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnAction_addFriend:(UIButton *)sender
{
    //从NSUserDefaults获取身份验证秘钥
    NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    NSString *verifyCode = [[NSString alloc]init];
    verifyCode=[userdefault objectForKey:@"verifyCode"];
    
    //获取登录医生数据字典
    NSMutableDictionary *userDic=[NSMutableDictionary new];
    //获取当前用户ID
    userDic=[userdefault objectForKey:@"DoctorDataDic"];
    NSString *userid = userDic[@"id"];
    
    //POST
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
    //BODY
    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    //申请者ID
    [parameters setObject:userid forKey:@"applyId"];
    //验证着ID
    NSString *receID = _dic_dictorData[@"id"];
    [parameters setObject:receID forKey:@"receiveId"];
    
    [RequestManager postWithURLString:ADDFRIENDSDATA heads:heads parameters:parameters success:^(id responseObject) {
        [showAlertView showAlertViewWithOnlyMessage:@"添加好友成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failure:^(NSError *error){
        NSLog(@"错误 = %@",error);
    }];

}



//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
