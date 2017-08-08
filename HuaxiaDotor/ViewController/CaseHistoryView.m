//
//  CaseHistoryView.m
//  dawnEye
//
//  Created by KockPeter on 16/3/9.
//  Copyright © 2016年 kockPeter. All rights reserved.
//

#import "CaseHistoryView.h"
#import "GroupModel.h"
#import "GroupDetailModel.h"
#import "GruopDetailTableViewCell.h"
//#import "NewPientClipViewController.h"
#import "NewPatientScViewController.h"

#import "PersonCenterClipViewController.h"
#import "LongPressRestClip.h"
#import "KeyClipViewController.h"
#import "CaseDiscussViewController.h"
#import "SearchGroupViewController.h"

#define deleGroup @"删除该分组后，组内联系人将移至默认分组，确定删除此分组？"

@interface CaseHistoryView ()<UITableViewDelegate,UITableViewDataSource,BasePickerViewDelegate>
{
    UITableView *_tableViewGroup;
    NSMutableArray *_arryGroup;
    NSMutableArray *_stateArry;
    
    NSIndexPath *_selectedIndexPath;
    NSInteger _selectedRow;

    BasePickerView *_basePickerView;
    
}
@end

@implementation CaseHistoryView

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
       [self.view endEditing:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"病历夹";
    
    [self getDataSourceIsShowHUD];

}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIButton *btnSearchCon = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSearchCon.backgroundColor = [UIColor whiteColor];
    btnSearchCon.frame = CGRectMake(20, 60+10, kWith-40, 30);
    [btnSearchCon setTitle:@"🔍输入患者相关信息" forState:UIControlStateNormal];
    [btnSearchCon setTitleColor:kBoradColor forState:UIControlStateNormal];
    [btnSearchCon addTarget:self action:@selector(onSearchGroup) forControlEvents:UIControlEventTouchUpInside];
    btnSearchCon.layer.cornerRadius = 3;
    btnSearchCon.layer.masksToBounds = YES;
    [self.view addSubview:btnSearchCon];
    
    UIBarButtonItem *rightClip =[[UIBarButtonItem alloc]initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(onBtnClip)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightClip;
        
    [self creatPatienLi];

    _tableViewGroup = [[UITableView alloc]initWithFrame:CGRectMake(0, 210, kWith, kHeight - 210 - 49) style:UITableViewStyleGrouped];
    _tableViewGroup.dataSource = self;
    _tableViewGroup.delegate = self;
    _tableViewGroup.rowHeight = 60;
    [self.view addSubview:_tableViewGroup];
    [_tableViewGroup registerClass:[UITableViewCell class] forCellReuseIdentifier:@"patientClip"];
    
    _basePickerView  = [[BasePickerView alloc]init];
    _basePickerView.delegate = self;
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:_basePickerView];
    
}

-(void)getDataSourceIsShowHUD{

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/GetGroupByDoc",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject, BOOL ifTimeout) {
        
        NSMutableArray *arryData = [NSMutableArray array];
        for (NSDictionary *dicValue in (NSArray *)responseObject) {
            GroupModel *group = [[GroupModel alloc]init];
            for (NSString *key in [dicValue allKeys]) {
                [group setValue:[dicValue objectForKey:key] forKey:key];
            }
            [arryData addObject:group];
        }
        _arryGroup = arryData;
        _stateArry  = [NSMutableArray array];
        for (NSInteger i = 0; i<_arryGroup.count; i++) {
            [_stateArry addObject:@"hidden"];
        }
        [_tableViewGroup reloadData];

    } failure:^(NSError *error) {

    }];
}

#pragma mark--------------设置列表
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arryGroup.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *state = _stateArry[section];
    GroupModel *model = _arryGroup[section];
    if ([state isEqualToString:@"hidden"]) {
        return 0;
    }else{
        return model.groupDetail.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *str = _stateArry[section];
    UIView *viewHeader =[[ UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 40)];
    viewHeader.backgroundColor = [UIColor whiteColor];
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(kWith-25, 15, 15, 8)];
    if ([str isEqualToString:@"hidden"]) {
        image.image = [UIImage imageNamed:@"arrow_down_gray"];
    }else
    {
        image.image = [UIImage imageNamed:@"arrow_up_gray"];
    }
    [viewHeader addSubview:image];
    
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, kWith - 50, 30)];
    GroupModel *model = _arryGroup[section];
    lbl.text = model.groupName;
    lbl.font = [UIFont systemFontOfSize:14];
    [viewHeader addSubview:lbl];
    
    UIControl *colon = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, kWith, 40)];
    colon.tag = 1300+section;
    [colon addTarget:self action:@selector(onStateTableGrop:) forControlEvents:UIControlEventTouchUpInside];
    [viewHeader addSubview:colon];
    
    LongPressRestClip *longPress = [[LongPressRestClip alloc]initWithTarget:self action:@selector(onLongPreseeSectionHeader:)];
    longPress.tag = 1570+section;
    longPress.longId = model.Id;
    [viewHeader addGestureRecognizer:longPress];
    return viewHeader;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *user = @"ClipGroupDetail";
    GruopDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:user];
    if (cell == nil) {
        cell = [[GruopDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:user];
    }
    GroupModel *model = _arryGroup[indexPath.section];
    GroupDetailModel *detailModel = model.groupDetail[indexPath.row];
    cell.lblName.text = detailModel.name;
    [cell.imageAvater sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",NET_URLSTRING]] placeholderImage:[UIImage imageNamed:@"人物"]];
    return cell;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self deleTableNSIndex:indexPath tale:tableView];
    }];
    
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"移动分组" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self tableMove:indexPath];
    }];
    return @[deleteRowAction,moreRowAction];
}

#pragma mark--------------删除分组
-(void)deleTableNSIndex:(NSIndexPath *)indexPath tale:(UITableView *)tableView{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定删除该患者吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *dic =[NSMutableDictionary dictionary];
        GroupModel *model = _arryGroup[indexPath.section];
        GroupDetailModel *detailModel = model.groupDetail[indexPath.row];
        [dic setObject:detailModel.Id forKey:@"id"];
        
        [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/PatientDelete",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self  success:^(id responseObject, BOOL ifTimeout) {
            [model.groupDetail removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } failure:^(NSError *error) {
            
        }];

    }]];
    [self presentViewController:alter animated:YES completion:nil];
}

#pragma mark--------------移动分组
-(void)tableMove:(NSIndexPath *)indexPath{
    NSMutableArray *arryName = [NSMutableArray array];
    for (GroupModel *modelDes in _arryGroup) {
        [arryName addObject:modelDes.groupName];
    }
    
    NSMutableArray *arry = [NSMutableArray array];
    [arry addObject:arryName];
    _selectedIndexPath = indexPath;
    [_basePickerView pickerDelegateShow:arry];
}

-(void)setPicker:(NSString *)count{
  
    for (NSInteger i = 0; i<_arryGroup.count; i++) {
        GroupModel *modelDes = _arryGroup[i];
        if ([count isEqualToString:modelDes.groupName]) {
            [self onSureDocPicCaseGroupId:modelDes MovedSection:i];
            break;
        }
    }
}

-(void)onSureDocPicCaseGroupId:(GroupModel *)modelDes MovedSection:(NSInteger)selectedSection{
    GroupModel *model = _arryGroup[_selectedIndexPath.section];
    GroupDetailModel *detailModel = model.groupDetail[_selectedIndexPath.row];


    
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic setObject:detailModel.Id forKey:@"patientId"];
    [dic setObject:modelDes.Id forKey:@"groupId"];
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/PatientGroupMove",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
        
        [model.groupDetail removeObject:detailModel];
        [modelDes.groupDetail insertObject:detailModel atIndex:0];
        NSMutableIndexSet *set = [NSMutableIndexSet indexSetWithIndex:_selectedIndexPath.section];
        [set addIndex:selectedSection];
        [_tableViewGroup reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
        _tableViewGroup.editing = NO;

    } failure:^(NSError *error) {

    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroupModel *model = _arryGroup[indexPath.section];
    GroupDetailModel *detailModel = model.groupDetail[indexPath.row];
    PersonCenterClipViewController *per = [[PersonCenterClipViewController alloc]init];
    per.group = detailModel;
    [self.navigationController pushViewController:per animated:YES];
}

#pragma mark--------------折合表
-(void)onStateTableGrop:(UIControl *)colo{

    NSString *str = _stateArry[colo.tag - 1300];
    if ([str isEqualToString:@"hidden"]) {
        [_stateArry replaceObjectAtIndex:colo.tag - 1300 withObject:@"show"];
        GroupModel *model = _arryGroup[colo.tag - 1300];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:model.Id forKey:@"groupId"];


        [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/GetPatientByGroup",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
            
            NSMutableArray *arryData = [NSMutableArray array];
            for (NSDictionary *dicValue in (NSArray *)responseObject) {
                GroupDetailModel *groupD = [[GroupDetailModel alloc]init];
                for (NSString *key in [dicValue allKeys]) {
                    [groupD setValue:[dicValue objectForKey:key] forKey:key];
                }
                [arryData addObject:groupD];
            }
            model.groupDetail = arryData;
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:colo.tag - 1300];
            [_tableViewGroup reloadSections:set withRowAnimation:UITableViewRowAnimationFade];

        } failure:^(NSError *error) {

        }];

    }else
    {
     [_stateArry replaceObjectAtIndex:colo.tag - 1300 withObject:@"hidden"];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:colo.tag - 1300];
        [_tableViewGroup reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark--------------讨论中的病例与重点病例
-(void)creatPatienLi{
    NSArray *arryImage = [NSArray arrayWithObjects:@"i讨论中的病历",@"i重点关注的病历", nil];
    NSArray *arryHeader = [NSArray arrayWithObjects:@"讨论中的病例",@"重点关注的病历", nil];
    for (NSInteger i = 0; i<2; i++) {
        UIView *viewWidth = [[UIView alloc]init];
        viewWidth.frame = CGRectMake(((kWith -2)/2+2)*i, 110, (kWith - 2)/2, 60);
        viewWidth.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:viewWidth];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, viewWidth.frame.size.width, 30)];
        lbl.textAlignment = 1;
        lbl.text = arryHeader[i];
        lbl.font = [UIFont systemFontOfSize:14];
        [viewWidth addSubview:lbl];
        
//        UILabel *lblcount = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, viewWidth.frame.size.width, 30)];
//        lblcount.textAlignment = 1;
//        lblcount.textColor = [UIColor redColor];
//        lblcount.text = @"5";
//        lblcount.font  =  [UIFont systemFontOfSize:15];
//        [viewWidth addSubview:lblcount];
        
        UIImageView *imageVi = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 15, 25)];
        imageVi.image = [UIImage imageNamed:arryImage[i]];
        [viewWidth addSubview:imageVi];
        
        UIButton *btnClip = [[UIButton alloc]initWithFrame:viewWidth.frame];
        btnClip.tag = 2000+i;
        [btnClip addTarget:self action:@selector(onBtnClip:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnClip];
    }
    
    UILabel *lblGrup = [[UILabel alloc]initWithFrame:CGRectMake(10, 170, 150, 40)];
    lblGrup.text = @"患者分组";
    lblGrup.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:lblGrup];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kWith - 80, 170, 75, 40);
    [btn setTitleColor:BLUECOLOR_STYLE forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(onBtnAddGroup) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"新建分组" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:15];
    [self.view addSubview:btn];
}

-(void)onBtnClip:(UIButton *)btnClip{

    if (btnClip.tag == 2000) {
        NSDictionary *dicLog = [kUserDefatuel objectForKey:@"DoctorDataDic"];
        if ([[dicLog objectForKey:@"state"] integerValue]==2) {
            CaseDiscussViewController *caseDiss =[[CaseDiscussViewController alloc]init];
            [self.navigationController pushViewController:caseDiss animated:YES];
        }else
        {
            IsCertificateViewController *isCer = [[IsCertificateViewController alloc]init];
            isCer.from = @"病历讨论";
            [self.navigationController pushViewController:isCer animated:YES];
            return;
        }
    }else
    {
        KeyClipViewController *key = [[KeyClipViewController alloc]init];
        [self.navigationController pushViewController:key animated:YES];
    }
    
}

#pragma mark--------------添加分组
-(void)onBtnAddGroup{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:@"创建分组" preferredStyle:UIAlertControllerStyleAlert];
    [alter addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textAlignment  =1;
        textField.placeholder = @"请输入组名";
    }];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        for (UITextField *tf in alter.textFields) {
            [self sureDocAlterdefaultClip:tf.text];
        }
    }]];
    [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alter animated:YES completion:nil
     ];
}

-(void)sureDocAlterdefaultClip:(NSString *)text{
    if (text == nil || [text isEqualToString:@""]) {
        kAlter(@"新增分组名为空");
        return;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:text forKey:@"groupName"];


    [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/AddGroup",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject, BOOL ifTimeout) {
         

        [self getDataSourceIsShowHUD];

     } failure:^(NSError *error) {

     }];
}

#pragma mark--------------删除分组与改名
-(void)onLongPreseeSectionHeader:(LongPressRestClip *)longPress{
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alter addAction:[UIAlertAction actionWithTitle:@"修改组名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self alterCustomCAse:(longPress.tag - 1570)];
    }]];
    
    if (longPress.tag != 1570) {
        [alter addAction:[UIAlertAction actionWithTitle:@"删除分组" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            GroupModel *model = _arryGroup[longPress.tag - 1570];
            if (model.groupDetail.count > 0) {
                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:deleGroup preferredStyle:UIAlertControllerStyleAlert];
                [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self deleteGroup:longPress.longId];
                }]];
                [self presentViewController:alter animated:YES completion:nil];
            }else
            {
                [self deleteGroup:longPress.longId];
            }
        }]];
    }

    [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alter animated:YES completion:nil];
}

-(void)alterCustomCAse:(NSInteger)tag{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:@"创建分组" preferredStyle:UIAlertControllerStyleAlert];
    [alter addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textAlignment  =1;
        textField.placeholder = @"请输入组名";
    }];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        GroupModel *model = _arryGroup[tag];
        for (UITextField *tf in alter.textFields) {
            [self onSureEditingGroupNaem:tf.text groupID:model.Id];
        }
    }]];
    [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alter animated:YES completion:nil
     ];
    
}

-(void)onSureEditingGroupNaem:(NSString *)text groupID:(NSString *)ID{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:text forKey:@"groupName"];
    [dic setObject:ID forKey:@"groupId"];


    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/GroupUpDate",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic  viewConroller:self success:^(id responseObject) {
        [self getDataSourceIsShowHUD];

    } failure:^(NSError *error) {

    }];

}

-(void)deleteGroup:(NSString *)ID{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:ID forKey:@"groupId"];

    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/GroupRemove",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
        [self getDataSourceIsShowHUD];

    } failure:^(NSError *error) {

    }];

}

#pragma mark--------------新增患者
-(void)onBtnClip{

    NewPatientScViewController *new = [[NewPatientScViewController alloc]init];
    [self.navigationController pushViewController:new animated:YES];
    
}

-(void)onSearchGroup{
    SearchGroupViewController *search = [[SearchGroupViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
}
@end



