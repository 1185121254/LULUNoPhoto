//
//  PatientInfoListViewController.m
//  HuaxiaPatient
//
//  Created by ydz on 17/2/28.
//  Copyright © 2017年 欧阳晓隆. All rights reserved.
//

#import "PatientInfoListViewController.h"
#import "PatientListTableViewCell.h"
#import "PatientInfoViewController.h"

@interface PatientInfoListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *patientList;

@property (nonatomic, strong) NSMutableArray *arryDataSource;

@end

@implementation PatientInfoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationBar];
    
    _patientList.rowHeight = UITableViewAutomaticDimension;
    _patientList.estimatedRowHeight = 300;
    [_patientList registerNib:[UINib nibWithNibName:@"PatientListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellInfoList"];
}

-(void)setNavigationBar
{
    self.title = @"PACS查询列表";
    
}



#pragma mark------------TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arryData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    PatientListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellInfoList" forIndexPath:indexPath];
    NSDictionary *dic = _arryData[indexPath.row];
    cell.nameList.text = dic[@"ExamItemName"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return -1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _arryData[indexPath.row];
    PatientInfoViewController *info = [[PatientInfoViewController alloc]init];
    info.dicInfo = self.dicPatientInfo;
    info.dataSource = dic;
    [self.navigationController pushViewController:info animated:YES];
    
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
