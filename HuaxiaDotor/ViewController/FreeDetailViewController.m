//
//  FreeDetailViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/23.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "FreeDetailViewController.h"

@interface FreeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    CollectionPicViewController *_pic;

}
@end

@implementation FreeDetailViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden= NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.view.backgroundColor = kBackgroundColor;
    
    PublishNav *publish= [[PublishNav alloc]init];
    publish.title.text = @"咨询详情";
    [publish.leftBtn addTarget:self action:@selector(onLeftBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:publish];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, kWith, 40)];
    lbl.backgroundColor = BLUECOLOR_STYLE;
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:15];
    NSString *sex;
    if ([self.patientModel.sex isEqualToString:@"1"]||[self.patientModel.sex isEqualToString:@"男"]) {
        sex = @"男";
    }else{
        sex = @"女";
    }
    lbl.text = [NSString stringWithFormat:@"  %@    %@  %@岁",self.patientModel.name,sex,self.patientModel.age];
    [self.view addSubview:lbl];

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, kWith, kHeight - 100) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tableView];

    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FreeDetailP"];
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
        return [NSString cellHeight:self.patientModel.questionDetail];
    }else
    {
        NSInteger count = kWith/kItemWidth;
        NSInteger reste = (NSInteger)kWith % kItemWidth;
        float gap = reste/(count + 1);
        if (self.patientModel.picList.count == 0) {
            return [NSString cellHeight:@"未添加"];
        }else
        {
            if ((self.patientModel.picList.count) % count == 0) {
                return (kItemWidth+gap)*((self.patientModel.picList.count)/count)+4*gap;
            }else
            {
                return (kItemWidth+gap)*((self.patientModel.picList.count)/count) + kItemWidth+gap*4;
            }
        }

    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 
    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 30)];
    viewBottom.backgroundColor = [UIColor whiteColor];
    
    UILabel *blue = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 7, 15)];
    blue.backgroundColor = BLUECOLOR_STYLE;
    [viewBottom addSubview:blue];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, kWith-20, 30)];
    if (section == 0) {
        lbl.text = @"问题详情";
    }else
    {
        lbl.text = @"资料图片";
    }
    lbl.font = [UIFont systemFontOfSize:13];
    [viewBottom addSubview:lbl];
    return viewBottom;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FreeDetailP" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.textLabel.text = self.patientModel.questionDetail;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
    }else
    {
        if (self.patientModel.picList.count == 0 || self.patientModel.picList == nil) {
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.text = @"未添加";
            return cell;
        }else
        {
            for (UIView *viw in cell.subviews) {
                [viw removeFromSuperview];
            }
            for (UIViewController *vc in self.childViewControllers) {
                [vc removeFromParentViewController];
            }
            _pic= [[CollectionPicViewController alloc]init];
            _pic.arryCollData = (NSMutableArray *)self.patientModel.picList;
            [cell addSubview:_pic.view];
            [self addChildViewController:_pic];
            return cell;
        }
    }
    return cell;
}

#pragma mark--------回跳
-(void)onLeftBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
