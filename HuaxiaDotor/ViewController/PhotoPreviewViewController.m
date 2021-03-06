//
//  PhotoPreviewViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 17/3/13.
//  Copyright © 2017年 kock. All rights reserved.
//

#import "PhotoPreviewViewController.h"
#import "PhotoPreviewTableViewCell.h"
#import "PublishPhotoViewController.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
@interface PhotoPreviewViewController ()<UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate>
{
    NSArray *arryImage;
}


@property (strong, nonatomic) IBOutlet UIView *doctorHeaderView;
@property (strong, nonatomic) IBOutlet UIView *doctorFootView;
@property (nonatomic, strong) UIButton *rightItem;

@property (weak, nonatomic) IBOutlet UIImageView *doctorImage;
@property (weak, nonatomic) IBOutlet UILabel *doctorName;
@property (weak, nonatomic) IBOutlet UILabel *doctorHospical;
@property (weak, nonatomic) IBOutlet UILabel *doctorFrom;
@property (weak, nonatomic) IBOutlet UILabel *doctorDate;
@property (weak, nonatomic) IBOutlet UILabel *doctorState;
@property (weak, nonatomic) IBOutlet UILabel *doctorTitle;
@property (weak, nonatomic) IBOutlet UILabel *doctorAbout;
@property (strong, nonatomic) IBOutlet UITableViewCell *titleCell;

@property (weak, nonatomic) IBOutlet UITableView *doctorTable;

@end

@implementation PhotoPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
   
    if ([_dicData[@"state"] integerValue] != 2) {
        self.doctorTable.tableFooterView = self.doctorFootView;
    }
    self.doctorTable.tableHeaderView = self.doctorHeaderView;
    self.doctorTable.rowHeight = UITableViewAutomaticDimension;
    self.doctorTable.estimatedRowHeight = 500;
    [self.doctorTable registerNib:[UINib nibWithNibName:@"PhotoPreviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"photoPreViewCell"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}

-(void)setNav{
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    self.title = @"摄影大赛";
    
    _rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightItem.frame = CGRectMake(0, 0, 50, 40);
    _rightItem.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [_rightItem setTitle:@"分享" forState:UIControlStateNormal];
    [_rightItem setTintColor:[UIColor whiteColor]];
    [_rightItem addTarget:self action:@selector(shareUM) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_rightItem];
    self.navigationItem.rightBarButtonItem = item;;
    
    self.doctorName.text = _dicData[@"userName"];
    self.doctorDate.text = _dicData[@"createDate"];
    self.doctorTitle.text = [NSString stringWithFormat:@"#%@#",_dicData[@"title"]];
    self.doctorHospical.text = _dicData[@"hospital"];
    NSString *provin;
    NSString *city;
    if (_dicData[@"area"] == nil) {
        provin = @"";
    }else{
        provin = _dicData[@"area"];
    }
    if (_dicData[@"city"] == nil) {
        city = @"";
    }else{
        city = _dicData[@"city"];
    }
    self.doctorFrom.text = [NSString stringWithFormat:@"%@  %@",provin,city];
    self.doctorState.text = [self photoState:[_dicData[@"state"] integerValue]];
    self.doctorAbout.text = _dicData[@"description"];
    arryImage = _dicData[@"picList"];
    NSString *url = _dicData[@"picFileName"];
    [self.doctorImage sd_setImageWithURL:[NSURL URLWithString:[self replaceLine:url]]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arryImage.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return -1;
    }else{
        return kWith*5/6;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PhotoPreviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoPreViewCell" forIndexPath:indexPath];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        return _titleCell;
    }else{
        if (arryImage.count>0) {
            NSDictionary *dic = arryImage[indexPath.row-1];
            [cell setCell:dic DicData:_dicData];
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        return;
    }
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0 ; i < arryImage.count; i++) {
        //传递数据给浏览器
        MJPhoto *photo = [[MJPhoto alloc] init];
        NSDictionary *dic = arryImage[i];
        photo.url = [NSURL URLWithString:[self replaceLine:dic[@"picUrl"]]];
        [photos addObject:photo];
    }
    brower.currentPhotoIndex = indexPath.row-1;
    brower.photos = photos;
    [brower show];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (IBAction)photoEditing:(id)sender {
    
    PublishPhotoViewController *pub = [[PublishPhotoViewController alloc]init];
    pub.dicData = self.dicData;
    [self.navigationController pushViewController:pub animated:YES];
}

- (IBAction)photidele:(id)sender {

    if (_dicData[@"id"] == nil) {
        kAlter(@"获取话题失败");
        return;
    }
    
    NSDictionary *para = @{@"photoId":_dicData[@"id"]};
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Circle/PhotographDelete",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:para viewConroller:self success:^(id responseObject) {
        
        [self alterView];
        
    } failure:^(NSError *error) {
        
    }];

}

-(void)alterView{
    
    UIAlertController *ater = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除成功！" preferredStyle:UIAlertControllerStyleAlert];
    [ater addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    [self presentViewController:ater animated:YES completion:nil];
    
}

-(NSString *)replaceLine:(NSString *)url{
    return [[NSString stringWithFormat:@"%@%@",NET_URLSTRING,url] stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
}

-(NSString *)photoState:(NSInteger )sate{

    if (sate == 1) {
        _rightItem.hidden = YES;
        return @"待审核";
    }else if (sate == 2) {
        _rightItem.hidden = NO;
        return @"已审核";
    }else if (sate == 3) {
        _rightItem.hidden = YES;
        return @"审核未通过";
    }
    return @"";
}

-(void)shareUM{
    
    if (_dicData[@"id"] == nil) {
        kAlter(@"获取数据失败");
        return;
    }
    
    [UMSocialData defaultData].extConfig.title = @"眼科通-摄影大赛";
    //qq
    [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"http://www.yanketong.com/Photo/PhotoShare.html?id=%@",_dicData[@"id"]];
    //qq控件
    [UMSocialData defaultData].extConfig.qzoneData.url = [NSString stringWithFormat:@"http://www.yanketong.com/Photo/PhotoShare.html?id=%@",_dicData[@"id"]];
    //微信好友
    [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"http://www.yanketong.com/Photo/PhotoShare.html?id=%@",_dicData[@"id"]];
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
    //微信朋友圈
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"http://www.yanketong.com/Photo/PhotoShare.html?id=%@",_dicData[@"id"]];
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UMENGAPPKEY shareText:@"眼科通-摄影大赛" shareImage:[UIImage imageNamed:@"ios-template-180"] shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone] delegate:nil];
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
