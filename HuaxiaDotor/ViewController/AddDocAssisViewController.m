//
//  AddDocAssisViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/20.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AddDocAssisViewController.h"
#import "DocTableTableViewCell.h"
#import "TextTDocableViewCell.h"
#import "CollecDocAddViewController.h"
#import "CheckViewController.h"
#import "MedicViewController.h"
#import "AddviceMedTableViewCell.h"
#import "TZImagePickerController.h"
#import "DocAddCollectionViewCell.h"

@interface AddDocAssisViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate>
{
    UITableView *_addDocTale;
    NSMutableArray *_arrySecHeader;
    NSMutableDictionary *_dicData;
    CollecDocAddViewController *_collect;

    NSMutableArray *_arryImage;
//    NSMutableArray *_arryCheck;
//    NSMutableArray *_arryDrug;
    NSMutableArray *_arryImageUpdate;
}
@end

@implementation AddDocAssisViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"新增病历";
    
    UIBarButtonItem *itrmRight = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(onAddDocCommit)];
    self.navigationItem.rightBarButtonItem = itrmRight;
    
    _arrySecHeader = [NSMutableArray arrayWithObjects:@"患者",@"症状描述:",@"检查项目",@"用药记录", nil];
//    _arryDrug = [NSMutableArray array];
//    _arryCheck = [NSMutableArray array];
    _dicData  = [NSMutableDictionary dictionary];
    _arryImageUpdate = [NSMutableArray array];
    
    _addDocTale = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, kWith, kHeight - 65) style:UITableViewStyleGrouped];
    _addDocTale.dataSource = self;
    _addDocTale.delegate = self;
    [self.view addSubview:_addDocTale];
 
    [_addDocTale registerClass:[DocTableTableViewCell class] forCellReuseIdentifier:@"addDocAdviceDocL"];
    [_addDocTale registerClass:[TextTDocableViewCell class] forCellReuseIdentifier:@"addDocAdviceTextL"];
    [_addDocTale registerClass:[TextTDocableViewCell class] forCellReuseIdentifier:@"addDocAdviceTextDrugCheck"];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onPicNotifyDocAdd:) name:@"AddDocL" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onAddDocCheck:) name:@"check" object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onAddDocDurg:) name:@"dic" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddDocReduce:) name:@"reduce" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddDocAdd:) name:@"add" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddDocTextFiled:) name:@"addDocTextFiled" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAddDocTextView:) name:@"addDocTextView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeletePic:) name:@"deletePic" object:nil];

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 2;
    }
    else
    {
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *viewB = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 1)];
        viewB.backgroundColor = kBoradColor;
        return viewB;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger count = kWith/kItemWidth;
    NSInteger reste = (NSInteger)kWith % kItemWidth;
    float gap = reste/(count + 1);
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 80;
        }else
        {
            if ((_arryImageUpdate.count+1) % count == 0) {
                return (kItemWidth+gap)*((_arryImageUpdate.count+1)/count)+4*gap;
            }else
            {
                return (kItemWidth+gap)*((_arryImageUpdate.count+1)/count) + kItemWidth+gap*4;
            }
        }
    }else if(indexPath.section==0)
    {
        return 50;
    }else
    {
        return 80;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *viewB = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 40)];
    viewB.backgroundColor= [UIColor whiteColor];
    
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kWith/2-10, 40)];
    lblName.text = _arrySecHeader[section];
    lblName.font = [UIFont systemFontOfSize:15];
    [viewB addSubview:lblName];
    
    UILabel *lblContext = [[UILabel alloc]initWithFrame:CGRectMake(kWith/2, 0, kWith/2-20, 40)];
    lblContext.textAlignment = 2;
    lblContext.font = [UIFont systemFontOfSize:16];
    [viewB addSubview:lblContext];
//    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(kWith - 30, 10, 20, 20);
//    [btn setTitleColor:BLUECOLOR_STYLE forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageNamed:@"i+"] forState:UIControlStateNormal];
//    btn.tag = section+6000;
//    [btn addTarget:self action:@selector(onAddCheckAddDurg:) forControlEvents:UIControlEventTouchUpInside];
//    [viewB addSubview:btn];
    
    if (section == 0) {
        lblContext.hidden = NO;
        lblContext.attributedText = [self setTextAddODcL:[NSString stringWithFormat:@"%@  %@岁",self.model.name,self.model.age]];
//        btn.hidden = YES;
    }else if (section == 1){
        lblContext.hidden = YES;
//        btn.hidden = YES;
    }else
    {
        lblContext.hidden = YES;
//        btn.hidden = NO;
    }
    
    return viewB;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        DocTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addDocAdviceDocL" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1){
        TextTDocableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addDocAdviceTextL" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (indexPath.row == 1) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            for (UIView *viewB in cell.subviews) {
                [viewB removeFromSuperview];
            }
            for (UIViewController *vc in self.childViewControllers) {
                [vc removeFromParentViewController];
            }
            _collect = [[CollecDocAddViewController alloc]init];
            [self addChildViewController:_collect];
            _collect.arryData = _arryImageUpdate;
            [cell addSubview:_collect.view];
        }
        return cell;

    }else{
        TextTDocableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addDocAdviceTextDrugCheck" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return cell;
    }
}

//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 2) {
//        return YES;
//    }else
//    {
//        return NO;
//    }
//}
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [_arryCheck removeObjectAtIndex:indexPath.row];
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//}

#pragma mark-----------图片选择
-(void)onPicNotifyDocAdd:(NSNotification *)notify{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.selectedAssets = _arryImage;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        _arryImage = [NSMutableArray arrayWithArray:assets];
        _arryImageUpdate = [NSMutableArray arrayWithArray:photos];
        [_addDocTale reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark-----------添加检查项目与药品
//-(void)onAddCheckAddDurg:(UIButton *)btn{
//
//    if (btn.tag == 6002) {
//        CheckViewController *check = [[CheckViewController alloc]init];
//        [self.navigationController pushViewController:check animated:YES];
//    }else if(btn.tag == 6003)
//    {
//        MedicViewController *med = [[MedicViewController alloc]init];
//        med.arryDataDrug = _arryDrug;
//        [self.navigationController pushViewController:med animated:YES];
//    }
//}
//
//-(void)onAddDocDurg:(NSNotification *)notify{
//    NSMutableArray *arry = notify.object;
//    NSMutableArray *arryId = [NSMutableArray array];
//    for (NSDictionary *dicId in _arryDrug) {
//        [arryId addObject:[dicId objectForKey:@"drugId"]];
//    }
//    if (_arryDrug.count == 0) {
//        [_arryDrug addObjectsFromArray:arry];
//    }else
//    {
//        for (NSDictionary *dic in arry) {
//            if (![arryId containsObject:[dic objectForKey:@"drugId"]]) {
//                [_arryDrug addObject:dic];
//                break;
//            }else
//            {
//                for (NSInteger i = 0; i<_arryDrug.count; i++) {
//                    NSDictionary *dicMed = _arryDrug[i];
//                    if ([[dic objectForKey:@"drugId"] isEqualToString:[dicMed objectForKey:@"drugId"]]) {
//                        NSInteger count = [[dic objectForKey:@"drugCount"] integerValue];
//                        NSMutableDictionary *dicNew = [NSMutableDictionary dictionaryWithDictionary:dicMed];
//                        [dicNew setObject:[NSString stringWithFormat:@"%ld",count] forKey:@"drugCount"];
//                        [_arryDrug replaceObjectAtIndex:i withObject:dicNew];
//                        break;
//                    }
//                }
//            }
//        }
//        
//    }
//    [_addDocTale reloadData];
//}
//
//-(void)onAddDocCheck:(NSNotification *)notify{
//    [_arryCheck addObject:notify.userInfo];
//    [_addDocTale reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationFade];
//}
//
//#pragma mark-----------增加与减少
//-(void)onAddDocReduce:(NSNotification *)notify{
//    AddviceMedTableViewCell *cell = notify.object;
//    NSIndexPath *index = [_addDocTale indexPathForCell:cell];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_arryDrug[index.row]];
//    NSInteger i = [cell.lblCount.text integerValue];
//    NSString *name = [cell.lblName.text componentsSeparatedByString:@"    "][0];
//    i--;
//    if (i == 0) {
//        
//        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:    [NSString stringWithFormat:@"减到@“0”时，删除%@",name]preferredStyle:UIAlertControllerStyleAlert];
//        [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            [_arryDrug removeObjectAtIndex:index.row];
//            NSIndexPath *indddd = [NSIndexPath indexPathForRow:index.row inSection:3];
//            [_addDocTale deleteRowsAtIndexPaths:@[indddd] withRowAnimation:UITableViewRowAnimationFade];
//            return ;
//        }]];
//        [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            [dic setObject:[NSString stringWithFormat:@"1"] forKey:@"drugCount"];
//            _arryDrug[index.row] = dic;
//            [_addDocTale reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
//            return ;
//        }]];
//        [self presentViewController:alter animated:YES completion:nil];
//    }
//    [dic setObject:[NSString stringWithFormat:@"%ld",(long)i] forKey:@"drugCount"];
//    _arryDrug[index.row] = dic;
//    [_addDocTale reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
//}
//
//-(void)onAddDocAdd:(NSNotification *)notify{
//    AddviceMedTableViewCell *cell = notify.object;
//    NSIndexPath *index = [_addDocTale indexPathForCell:cell];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_arryDrug[index.row]];
//    NSInteger i = [[dic objectForKey:@"drugCount"] integerValue];
//    i++;
//    [dic setObject:[NSString stringWithFormat:@"%ld",(long)i] forKey:@"drugCount"];
//    _arryDrug[index.row] = dic;
//    [_addDocTale reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
//}

#pragma mark-----------文本框
-(void)onAddDocTextFiled:(NSNotification *)notify{
    [_dicData setObject:notify.object forKey:@"result"];
}

-(void)onAddDocTextView:(NSNotification *)notify{
    NSDictionary *dic = notify.userInfo;
    if ([dic objectForKey:@"error"]) {
        kAlter([dic objectForKey:@"error"]);
        return;
    }
    TextTDocableViewCell *cell = [dic objectForKey:@"cell"];
    NSIndexPath *index  = [_addDocTale indexPathForCell:cell];
    if (index.section==1) {
        
        [_dicData setObject:[dic objectForKey:@"txt"] forKey:@"advice"];

    }
    else if (index.section == 2){
        [_dicData setObject:[dic objectForKey:@"txt"] forKey:@"check"];

    }
    else if (index.section==3){
        [_dicData setObject:[dic objectForKey:@"txt"] forKey:@"drug"];

    }
}
#pragma mark-----------提交
-(void)onAddDocCommit{

    if ([_dicData objectForKey:@"result"]==nil||[_dicData objectForKey:@"advice"]==nil) {
        kAlter(@"所有选项为必填选项");
        return;
    }
    if ([[_dicData objectForKey:@"result"] length] > 20) {
        kAlter(@"初步预诊不得超过20个字");
        return;
    }
    
//    NSMutableArray *drugList = [[NSMutableArray alloc]init];
//    for (NSDictionary *dic in _arryDrug) {
//        if ([dic objectForKey:@"drugUnit"] != nil && [dic objectForKey:@"drugCount"] != nil &&[dic objectForKey:@"drugName"] != nil) {
//            NSMutableDictionary *dicDrug = [[NSMutableDictionary alloc]init];
//            [dicDrug setObject:[dic objectForKey:@"drugName"] forKey:@"drugName"];
//            [dicDrug setObject:[dic objectForKey:@"drugCount"] forKey:@"drugCount"];
//            [dicDrug setObject:[dic objectForKey:@"drugUnit"] forKey:@"drugUnit"];
//            [dicDrug setObject:[dic objectForKey:@"drugId"] forKey:@"drugId"];
//            [drugList addObject:dicDrug];
//        }
//    }
//    
//    NSMutableArray *checkList = [[NSMutableArray alloc]init];
//    for (NSDictionary *dic in _arryCheck) {
//        NSMutableDictionary *dicCheck = [[NSMutableDictionary alloc]init];
//        [dicCheck setObject:[dic objectForKey:@"checkName"] forKey:@"checkName"];
//        [dicCheck setObject:[dic objectForKey:@"checkId"] forKey:@"checkId"];
//        [checkList addObject:dicCheck];
//    }
    
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc]init];
    [dicData setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    [dicData setObject:self.model.Id forKey:@"patientId"];
    [dicData setObject:[_dicData objectForKey:@"result"] forKey:@"result"];
    [dicData setObject:[_dicData objectForKey:@"advice"] forKey:@"description"];
    [dicData setObject:[_dicData objectForKey:@"drug"] forKey:@"drugList"];
    [dicData setObject:[_dicData objectForKey:@"check"] forKey:@"checkList"];
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要提交新的病历" preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_arryImage.count != 0) {
            NSMutableArray *arryData  =[NSMutableArray array];
            for (UIImage *image in _arryImageUpdate) {
                NSData *data = UIImageJPEGRepresentation(image, 1);
                [arryData addObject:data];
            }
            NSDictionary *header = @{@"verifyCode":[kUserDefatuel objectForKey:@"verifyCode"]};

            
            [RequestManager CasePicWithURLString:[NSString stringWithFormat:@"%@/api/Share/PictureUpload",NET_URLSTRING] heads:header Parameters:arryData  viewConroller:self Complation:^(NSDictionary *dicCom) {
                if ([[dicCom objectForKey:@"code"] integerValue]==10000) {
                    [dicData setObject:[dicCom objectForKey:@"value"] forKey:@"picList"];
                    [self NoPic:dicData];
                }
                else
                {

                    kAlter(@"上传图片失败");
                }
            } Fail:^(NSError *error) {

                kAlter(@"上传图片失败");
            }];
            [dicData setObject:_arryImageUpdate forKey:@"picList"];
        }else
        {
            [self NoPic:dicData];
        }
    }]];
    [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alter animated:YES completion:nil];
}

-(void)NoPic:(NSMutableDictionary *)dicData{
    [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/NewMedicalRecordAdd",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dicData viewConroller:self success:^(id responseObject, BOOL ifTimeout) {

        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已提交成功！！" preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alter animated:YES completion:nil];
    } failure:^(NSError *error) {

    }];
 
}

//富文本
-(NSMutableAttributedString *)setTextAddODcL:(NSString *)text{
    
    NSArray *arry = [text componentsSeparatedByString:@"  "];
    NSString *strUnit = arry[1];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:text];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:kBoradColor} range:[text rangeOfString:strUnit]];
    return medStr;
}

-(void)onDeletePic:(NSNotification *)notify{
    DocAddCollectionViewCell *cell = notify.object;
    NSIndexPath *index = [_collect.collection indexPathForCell:cell];
    [_arryImage removeObjectAtIndex:index.item];
    [_arryImageUpdate removeObjectAtIndex:index.item];
    [_addDocTale reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
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