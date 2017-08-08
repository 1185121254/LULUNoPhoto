//
//  ElePatSearchViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 17/5/2.
//  Copyright © 2017年 kock. All rights reserved.
//

#import "ElePatSearchViewController.h"
#import "ElePationTableViewCell.h"
#import "ElectronDetailViewController.h"

@interface ElePatSearchViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *EleSearchTable;
@property (nonatomic, strong) NSMutableArray *arryData;
@property (weak, nonatomic) IBOutlet UITextField *textName;

@end

@implementation ElePatSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setDefault];
    
}

-(void)setDefault{

    self.title = @"电子病例搜索";
    [self.EleSearchTable registerNib:[UINib nibWithNibName:@"ElePationTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellForPaSearch"];
    self.EleSearchTable.rowHeight = 105;
    self.EleSearchTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arryData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    ElePationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellForPaSearch" forIndexPath:indexPath];
    
    if (self.arryData.count>0) {
        NSDictionary *dic = self.arryData[indexPath.row];
        cell.dicModel = dic;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.arryData.count>0) {
        NSDictionary *dic = self.arryData[indexPath.row];
        ElectronDetailViewController *elecreon = [[ElectronDetailViewController alloc]init];
        elecreon.dicData=  dic;
        [self.navigationController pushViewController:elecreon animated:YES];
    }
}
- (IBAction)btnSearch:(id)sender {
    
    [self.textName resignFirstResponder];
    [self getDataFromNet];

}

-(void)getDataFromNet{
    NSDictionary *para = @{@"doctorId":@"",@"pageSize":@(20),@"name":self.textName.text,@"pageNumber":@(1)};
    [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/GetNowPubliceEvent",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:para viewConroller:self success:^(id responseObject, BOOL ifTimeout) {
        
        self.arryData = [NSMutableArray arrayWithArray:(NSArray *)responseObject];
        if (self.arryData.count==0) {
            kAlter(@"未搜索到结果");
        }
        [self.EleSearchTable reloadData];
     } failure:^(NSError *error) {
         
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
