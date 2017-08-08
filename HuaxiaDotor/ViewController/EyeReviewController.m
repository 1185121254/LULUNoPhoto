//
//  EyeReviewTableViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/4/7.
//  Copyright © 2016年 kock. All rights reserved.
//  眼科检查

#import "EyeReviewController.h"
#import "EyeReviewTableViewCell.h"
#import "ImageBrowseViewController.h"

@interface EyeReviewController ()<UITableViewDataSource,UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
//设置用户的ID和VerifyCode
@property (strong, nonatomic)NSString *verifyCode,*userID;

//用户数组数据
@property (strong, nonatomic) NSMutableArray *DataArr;

@end

@implementation EyeReviewController

-(void)viewWillAppear:(BOOL)animated
{
    //获取眼科检查列表数据
}

- (void)viewDidLoad
{ 
    [super viewDidLoad];
    //导航栏标题的颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self getTableviewData];

    
    //调用tableView的试图
    [self createNibField];
    
    //
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 获取眼科检查列表数据
-(void)getTableviewData
{
    //获取verifyCode 和 ID
    //获取已添加页面的数据
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    //获取用户秘钥
    self.verifyCode=[userDefaults objectForKey:@"verifyCode"];
    
    //HEAD
    NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:self.verifyCode};
    
    //BODY
//    NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
    
    //获取需要上传的数据
    //GET
    [RequestManager getWithURLString:TOOL_EYEREVIEW_LIST heads:heads parameters:nil success:^(id responseObject)
     {
         NSMutableDictionary *DataDic=(NSMutableDictionary *)responseObject;
         self.DataArr=[NSMutableArray new];
         self.DataArr = DataDic[@"value"];
//         NSLog(@"%@",self.DataArr);
    
         [self.tableview reloadData];
         
     } failure:^(NSError *error)
    {
         NSLog(@"ERROR%@",error);
     }];
}

#pragma mark - 点击跳转到试图展示页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSMutableDictionary *dataDic=self.DataArr[indexPath.row];
    //图片字典
    NSMutableArray *arr=dataDic[@"piclist"];
    NSLog(@"%@",arr);
    NSMutableArray *picArr=[NSMutableArray new];
    //取出字典中图片字符
    for (int i=0; i<arr.count; i++)
    {
        dataDic=arr[i];
//        NSLog(@"%@",dataDic);
        //取出字符并获取图片存入数组
//        [picArr addObject:dataDic[@"picUrl"]];
//        UIImageView *imageview = [self setImageURL:dataDic[@"picUrl"]];
        //把去到的图片地址添加到数组中
        [picArr addObject:dataDic[@"picUrl"]];
//        NSLog(@"%@",picArr);
    }
    //跳转到图片预览界面
    ImageBrowseViewController *imageViewControllerView=[[ImageBrowseViewController alloc]init];
    self.delegate=imageViewControllerView;
    [self.delegate sendImageViewArr:picArr];
    [self.navigationController pushViewController:imageViewControllerView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.DataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EyeReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToolEye" forIndexPath:indexPath];
    cell.selectionStyle=NO;
    cell.HeadImage.layer.cornerRadius=cell.HeadImage.frame.size.height/2;
    [cell.imageView.layer setMasksToBounds:YES];
     //获取字典中头张照片
    NSMutableDictionary *dataDic=self.DataArr[indexPath.row];
    NSMutableArray *arr=dataDic[@"piclist"];
    dataDic=arr[0];
    [cell setCellForEyeInfo:self.DataArr[indexPath.row] withImageURL:dataDic[@"picUrl"]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

#pragma mark - 创建tableView上的Cell文件
-(void)createNibField
{
    //创建nib文件
    UINib *nib=[UINib nibWithNibName:@"ToolEyeReview" bundle:[NSBundle mainBundle]];
    //创建nib试图并注册到tableView中
    [self.tableview registerNib:nib forCellReuseIdentifier:@"ToolEye"];
}

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
