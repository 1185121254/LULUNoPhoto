//
//  OnLineViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/18.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "OnLineViewController.h"
#import "OnLineTableViewCell.h"
#import "DregedConViewController.h"
#import "DreGedPhoneViewController.h"
#import "DregedViedoViewController.h"
#import "DregedAddViewController.h"

#import "HomeViewController.h"


@interface OnLineViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *_tableView;
    
    NSMutableArray *_arryName;
    NSMutableArray *_arryPic;
    NSMutableArray *_arryFountion;
    NSMutableArray *_arryPrice;
}

@end

@implementation OnLineViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    _arryPrice = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%@元/次",[[kUserDefatuel objectForKey:@"VasSet0"] objectForKey:@"price"]],[NSString stringWithFormat:@"%@元/次",[[kUserDefatuel objectForKey:@"VasSet1"] objectForKey:@"price"]],[NSString stringWithFormat:@"%@元/次",[[kUserDefatuel objectForKey:@"VasSet2"] objectForKey:@"price"]],[NSString stringWithFormat:@"%@元/次",[[kUserDefatuel objectForKey:@"VasSet3"] objectForKey:@"price"]], nil];
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线服务管理";
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:248/255.0 blue:250/255.0 alpha:1];
    _arryPic = [NSMutableArray arrayWithObjects:@"i图文问诊",@"i电话问诊",@"i视频问诊",@"i加号管理-1", nil];
    _arryName = [NSMutableArray arrayWithObjects:@"图文咨询",@"电话咨询",@"视频咨询",@"加号管理", nil];
    _arryFountion = [NSMutableArray arrayWithObjects:@"为患者提供图文在线远程医疗服务",@"为患者提供电话咨询服务",@"为患者提供视频远程医疗服务",@"为患者提供加号预约申请", nil];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, kWith, kHeight-65) style:UITableViewStyleGrouped];
    _tableView.dataSource  =self;
    _tableView.delegate = self;
    _tableView.rowHeight = 90;
    [self.view addSubview:_tableView];

    [_tableView registerClass:[OnLineTableViewCell class] forCellReuseIdentifier:@"onLine"];
    
    UIButton *btnleft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnleft.frame = CGRectMake(0, 0, 13, 22);
    [btnleft addTarget:self action:@selector(onLeftOnLine) forControlEvents:UIControlEventTouchUpInside];
    [btnleft setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    UIBarButtonItem *letf = [[UIBarButtonItem alloc]initWithCustomView:btnleft];
    self.navigationItem.leftBarButtonItem = letf;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 40)];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, kWith-40, 20)];
    lbl.font  = [UIFont systemFontOfSize:13];
    lbl.text = @"在眼科通医生版平台上,医生可设置四类在线服务";
    [view addSubview:lbl];
    return view;
}

-(OnLineTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OnLineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"onLine" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.avater.image = [UIImage imageNamed:_arryPic[indexPath.row]];
    cell.lblName.text = _arryName[indexPath.row];
    cell.lblFunction.text = _arryFountion[indexPath.row];
    if ([_arryPrice[indexPath.row] isEqualToString:@"元/次"] || [_arryPrice[indexPath.row] isEqualToString:@"0元/次"]) {
        cell.lblPrice.text = @"未开通";
    }else
    {
        cell.lblPrice.text = _arryPrice[indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            NSDictionary *dic = [kUserDefatuel objectForKey:@"VasSet0"];
            NSLog(@"---%@",dic);
            //图文咨询
            if ([[dic objectForKey:@"isOpen"] isEqualToString:@"True"]) {
                DregedConViewController *dre = [[DregedConViewController alloc]init];
                dre.isdreged = YES;
                dre.price = [dic objectForKey:@"price"];
                dre.Id = [dic objectForKey:@"id"];
                [self.navigationController pushViewController:dre animated:YES];
            }
            else
            {
                DregedConViewController *dre = [[DregedConViewController alloc]init];
                dre.isdreged = NO;
                dre.price = [dic objectForKey:@"price"];
                dre.Id = [dic objectForKey:@"id"];
                [self.navigationController pushViewController:dre animated:YES];
                
            }
     
        }
            break;
        case 1:
        {
            NSDictionary *dic = [kUserDefatuel objectForKey:@"VasSet1"];
            NSLog(@"---%@",dic);
            //电话咨询
            if ([[dic objectForKey:@"isOpen"] isEqualToString:@"True"]) {
                DreGedPhoneViewController *dre = [[DreGedPhoneViewController alloc]init];
                dre.isdreged = YES;
                dre.price = [dic objectForKey:@"price"];
                dre.Id = [dic objectForKey:@"id"];
                [self.navigationController pushViewController:dre animated:YES];
            }
            else
            {
                DreGedPhoneViewController *dre = [[DreGedPhoneViewController alloc]init];
                dre.isdreged = NO;
                dre.price = [dic objectForKey:@"price"];
                dre.Id = [dic objectForKey:@"id"];
                [self.navigationController pushViewController:dre animated:YES];
                
            }
        }
            break;
            
        case 2:
        {
            NSDictionary *dic = [kUserDefatuel objectForKey:@"VasSet2"];
            NSLog(@"---%@",dic);
            //视频咨询
            if ([[dic objectForKey:@"isOpen"] isEqualToString:@"True"]) {
                DregedViedoViewController *dre = [[DregedViedoViewController alloc]init];
                dre.isdreged = YES;
                dre.price = [dic objectForKey:@"price"];
                dre.Id = [dic objectForKey:@"id"];
                [self.navigationController pushViewController:dre animated:YES];
            }
            else
            {
                DregedViedoViewController *dre = [[DregedViedoViewController alloc]init];
                dre.isdreged = NO;
                dre.price = [dic objectForKey:@"price"];
                dre.Id = [dic objectForKey:@"id"];
                [self.navigationController pushViewController:dre animated:YES];
            }
        }
            break;
            
        case 3:
        {
            NSDictionary *dic = [kUserDefatuel objectForKey:@"VasSet3"];
            NSLog(@"---%@",dic);
            //加号管理
            if ([[dic objectForKey:@"isOpen"] isEqualToString:@"True"]) {
                DregedAddViewController *dre = [[DregedAddViewController alloc]init];
                dre.isdreged = YES;
                dre.price = [dic objectForKey:@"price"];
                dre.Id = [dic objectForKey:@"id"];
                [self.navigationController pushViewController:dre animated:YES];
            }
            else
            {
                DregedAddViewController *dre = [[DregedAddViewController alloc]init];
                dre.isdreged = NO;
                dre.price = [dic objectForKey:@"price"];
                dre.Id = [dic objectForKey:@"id"];
                [self.navigationController pushViewController:dre animated:YES];
                
            }
        }
            break;
            
        default:
            break;
    }
    
    
}


-(void)onLeftOnLine{
    
    if ([self.from isEqualToString:@"freePatient"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    NSArray *arry = self.navigationController.viewControllers;
    HomeViewController *home = arry[0];
    [self.navigationController popToViewController:home animated:YES];
    
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
