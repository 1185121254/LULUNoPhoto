//
//  ConsultationDetailViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/10.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ConsultationDetailViewController.h"
#import "PatientDetailViewController.h"
#import "ShowPick.h"

@interface ConsultationDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_arry;
    
    NSMutableArray *_imageArray;

    
    PublishNav *_publish;
}
@end

@implementation ConsultationDetailViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden= NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kBackgroundColor;
    
    _arry = [[NSArray alloc]initWithObjects:@"症状描述",@"资料图片", nil];
    _imageArray = [[NSMutableArray alloc]init];
    
    _publish= [[PublishNav alloc]init];
    _publish.title.text = @"咨询详情";
    [_publish.leftBtn addTarget:self action:@selector(onLeftBack) forControlEvents:UIControlEventTouchUpInside];
    _publish.rightBtn.frame = CGRectMake(kWith-60, 24, 40, 40);
    [_publish.rightBtn addTarget:self action:@selector(onRight) forControlEvents:UIControlEventTouchUpInside];
    [_publish.rightBtn setTitle:@"更多" forState:UIControlStateNormal];
    [self.view addSubview:_publish];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, kWith, 40)];
    lbl.backgroundColor = BLUECOLOR_STYLE;
    lbl.textColor = [UIColor whiteColor];
    lbl.attributedText = [self setText:[NSString stringWithFormat:@"  %@    %@  %@岁",self.patient.patientName,[self sex:self.patient.sex],self.patient.age]];
    [self.view addSubview:lbl];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, kWith, kHeight-100) style:UITableViewStyleGrouped];
    _tableView.dataSource= self;
    _tableView.rowHeight = 44;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"con"];

    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetDiagnosisAdvice",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:@{@"orderId":self.patient.Id} viewConroller:self success:^(id responseObject) {
        AdviewDetail *adview = [self setDataAd:(NSDictionary *)responseObject];
        _imageArray = adview.picList;
        [_tableView reloadData];

    } failure:^(NSError *error) {

    }];
}

-(AdviewDetail *)setDataAd:(NSDictionary *)dicValue{
    NSArray *arry = [dicValue allKeys];
    AdviewDetail *adviece = [[AdviewDetail alloc]init];
    for (NSString *key in arry) {
        [adviece setValue:[dicValue objectForKey:key] forKey:key];
    }
    return adviece;
}

#pragma mark----右按钮项

-(void)onRight{
    PatientDetailViewController *admin = [[PatientDetailViewController alloc]init];
    admin.patient= self.patient;
    [self.navigationController pushViewController:admin animated:YES];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *str;
        if (self.patient.Description == nil) {
            str = @"未填写";
        }else
        {
            str = self.patient.Description;
        }
        return [NSString cellHeight:str];
    }
    else
    {
        NSInteger count = kWith/kItemWidth;
        NSInteger reste = (NSInteger)kWith % kItemWidth;
        float gap = reste/(count + 1);
        if (_imageArray == 0 || _imageArray == nil) {
            return 44;
        }else
        {
            if ((_imageArray.count) % count == 0) {
                return (kItemWidth+gap)*((_imageArray.count)/count)+4*gap;
            }else
            {
                return (kItemWidth+gap)*((_imageArray.count)/count) + kItemWidth+gap*4;
            }
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 30)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *blue = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 7, 15)];
    blue.backgroundColor = BLUECOLOR_STYLE;
    [view addSubview:blue];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kWith-20, 30)];
    lbl.font = [UIFont systemFontOfSize:13];
    lbl.text = _arry[section];
    lbl.backgroundColor = [UIColor whiteColor];
    [view addSubview:lbl];
    return view;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"con" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        NSString *str;
        if (self.patient.Description == nil) {
            str = @"未填写";
        }else
        {
            str = self.patient.Description;
        }
        cell.textLabel.text = str;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
    else
    {
        if (_imageArray.count == 0 || _imageArray == nil) {
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.text = @"未添加";
        }else
        {
            
            [self setImageSuperView:cell.contentView];
            
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark----------------  创建图片
-(void)setImageSuperView:(UIView *)superView{
    
    NSInteger count = kWith/kItemWidth;
    NSInteger reste = (NSInteger)kWith % kItemWidth;
    float gap = reste/(count + 1);
    
    CGFloat height;
    if ((_imageArray.count) % count == 0) {
        height = (kItemWidth+gap)*((_imageArray.count)/count)+4*gap;
    }else
    {
        height = (kItemWidth+gap)*((_imageArray.count)/count) + kItemWidth+gap*4;
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(gap, gap, gap, gap);
    layout.minimumLineSpacing = gap;
    layout.minimumInteritemSpacing = gap;
    layout.itemSize = CGSizeMake(kItemWidth, kItemWidth);
    
    ShowPick *picK = [[ShowPick alloc]initWithFrame:CGRectMake(0, 0, superView.frame.size.width, height) collectionViewLayout:layout];
    picK.arryData = _imageArray;
    [superView addSubview:picK];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearDisk];
    
    [[SDImageCache sharedImageCache] clearMemory];//可有可无
}

-(NSString *)sex:(NSString *)sex{
    
    NSString *str;
    if ([sex isEqualToString:@"1"]) {
        str = @"男";
    }
    else
    {
        str = @"女";
    }
    return str;
}

-(NSMutableAttributedString *)setText:(NSString *)name{
    
    NSArray *arry = [name componentsSeparatedByString:@"    "];
    NSString *strUnit = arry[1];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:name];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:[name rangeOfString:strUnit]];
    
    return medStr;
}

#pragma mark--------回跳
-(void)onLeftBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//-(CGFloat)cellHeight:(NSString *)text{
//    CGRect rect = [text boundingRectWithSize:CGSizeMake(kWith - 40, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
//    return rect.size.height+20;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end