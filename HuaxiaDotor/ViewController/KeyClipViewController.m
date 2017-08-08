//
//  KeyClipViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/8.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "KeyClipViewController.h"
#import "GroupDetailModel.h"
#import "KeyClipTableViewCell.h"
#import "PersonCenterClipViewController.h"
@interface KeyClipViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_arryFouse;
    UITableView *_tableViewFouce;
}
@end

@implementation KeyClipViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;


    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/GetFocusPatient",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
        
        NSMutableArray *arryData = [NSMutableArray array];
        for (NSDictionary *dicValue in (NSArray *)responseObject) {
            GroupDetailModel *groupD = [[GroupDetailModel alloc]init];
            for (NSString *key in [dicValue allKeys]) {
                [groupD setValue:[dicValue objectForKey:key] forKey:key];
            }
            [arryData addObject:groupD];
        }

        if (arryData.count == 0||arryData == nil) {
            self.noData.frame = CGRectMake(0, (kHeight-60)/2, kWith, 60);
            self.noData.hidden = NO;
        }else
        {
            self.noData.hidden = YES;
        }
        _arryFouse = arryData;
        [_tableViewFouce reloadData];
    } failure:^(NSError *error) {

    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"重点关注病历";
    self.view.backgroundColor = kBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableViewFouce = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kWith, kHeight - 64)];
    _tableViewFouce.dataSource = self;
    _tableViewFouce.delegate = self;
    _tableViewFouce.backgroundColor = [UIColor clearColor];
    _tableViewFouce.rowHeight = 71;
    _tableViewFouce.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableViewFouce];
        
    [_tableViewFouce registerClass:[KeyClipTableViewCell class] forCellReuseIdentifier:@"keyClip"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arryFouse.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    KeyClipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"keyClip" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GroupDetailModel *model = _arryFouse[indexPath.row];
    cell.lblName.text = model.name;
    cell.lblAgeSex.text = [NSString stringWithFormat:@"%@  |  %@岁",[self setSexClipKEy:model.sex],model.age];
    [cell.imageAvater sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NET_URLSTRING,model.picFileName]] placeholderImage:[UIImage imageNamed:@"ic_login_account"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PersonCenterClipViewController *per = [[PersonCenterClipViewController alloc]init];
    GroupDetailModel *model = _arryFouse[indexPath.row];
    per.group = model;
    [self.navigationController pushViewController:per animated:YES];
    
}

-(NSString *)setSexClipKEy:(NSString *)sex{
    if ([sex integerValue] ==1) {
        return @"男";
    }else
    {
    return @"女";
    }
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
