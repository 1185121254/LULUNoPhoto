//
//  AddCaseViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/24.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AddCaseViewController.h"
#import "CaseNameTableViewCell.h"
#import "CasePicTableViewCell.h"
#import "SelectFriendsViewController.h"
#import "CaseDocListViewController.h"
#import "CaseSexTableViewCell.h"
#import "CaseModel.h"
#import "CaseCommentViewController.h"
#import "CaseHistoryView.h"
#import "CollecDocAddViewController.h"
#import "ImportPatientViewController.h"
#import "DocAddCollectionViewCell.h"
#import "TZImagePickerController.h"
#import "iflyMSC/IFlyMSC.h"
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "CaseCommentViewController.h"

@interface AddCaseViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,IFlyRecognizerViewDelegate>
{
    UITableView *_tableView;
    //描述数组
    NSMutableArray *_arryDesp;
    //内容数组
    NSMutableArray *_arryData;
    //placelor的数组
    NSMutableArray *_arryPlacelor;
    //选择照片Data数组
    NSMutableArray *_arryPhonoes;
    //医生数组
    NSMutableArray *_arryotherDoc;

    //选择照片URL数组
    NSMutableArray *_arryUpImage;
    
    IFlyRecognizerView *_iflyRecognizerView;
    NSInteger _selectedRow;
    
    CollecDocAddViewController *_collect;

    BOOL _isHaveImport;
    NSArray *_arryImageImport;
}
@end

@implementation AddCaseViewController

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if ([self.from isEqualToString:@"import"])
    {
        self.from = @"";
        [_arryPhonoes removeAllObjects];
        [self getData];
    }
}

#pragma mark - 导入病历中得数据
-(void)getData
{
        //年龄
    if ([self.dicImport objectForKey:@"age"] == nil ||[[self.dicImport objectForKey:@"age"] integerValue]==0)
    {
        [_arryData replaceObjectAtIndex:2 withObject:@""];
    }
    else
    {
        [_arryData replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%@",[self.dicImport objectForKey:@"age"]]];
    }
    //性别
    if ([self.dicImport objectForKey:@"sex"] == nil)
    {
        [_arryData replaceObjectAtIndex:1 withObject:@"1"];
      
    }else
    {
        [_arryData replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@",[self.dicImport objectForKey:@"sex"]]];
    }
        
    if (_isWebLine == YES)
    {
        //描述
        if ([self.dicImport objectForKey:@"illDetail"]) {
            [_arryData replaceObjectAtIndex:4 withObject:[self.dicImport objectForKey:@"illDetail"]];
        }
        //诊断
        if ([self.dicImport objectForKey:@"description"]) {
            [_arryData replaceObjectAtIndex:3 withObject:[self.dicImport objectForKey:@"description"]];
        }
        //姓名
        if ([self.dicImport objectForKey:@"name"]) {
            [_arryData replaceObjectAtIndex:0 withObject:[self.dicImport objectForKey:@"name"]];
        }
    }
    else
    {
        //描述
        if ([self.dicImport objectForKey:@"illDetail"]) {
            [_arryData replaceObjectAtIndex:4 withObject:[self.dicImport objectForKey:@"illDetail"]];
        }
        //诊断
        if ([self.dicImport objectForKey:@"description"]) {
            [_arryData replaceObjectAtIndex:3 withObject:[self.dicImport objectForKey:@"description"]];
        }
        //姓名
        if ([self.dicImport objectForKey:@"name"]) {
            [_arryData replaceObjectAtIndex:0 withObject:[self.dicImport objectForKey:@"name"]];
        }
        
    }
    //图片
    [_arryPhonoes removeAllObjects];
    if ([self.dicImport objectForKey:@"picList"] != nil) {
        _isHaveImport = YES;
        _arryUpImage = [NSMutableArray arrayWithArray:[self.dicImport objectForKey:@"picList"]];
        _arryImageImport = [self.dicImport objectForKey:@"picList"];
    }else
    {
        _arryImageImport = [NSMutableArray array];
        _arryUpImage = [NSMutableArray array];
        _isHaveImport = NO;
    }
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加患者病历";
    
    
    self.view.backgroundColor = kBackgroundColor;
    _arryData = [NSMutableArray arrayWithObjects:@"",@"", nil];
    if (_isWebLine == YES)
    {
        _arryDesp = [NSMutableArray arrayWithObjects:@"姓名",@"性别",@"年龄",@"疾病诊断",@"症状描述",@"备注",@"标题", nil];
        _arryData = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
        _arryPlacelor = [NSMutableArray arrayWithObjects:@"请输入姓名",@"",@"请输入年龄",@"请输入疾病诊断",@"请输入症状",@"请输入备注",@"请输入标题", nil];
    }
    else
    {
        _arryDesp = [NSMutableArray arrayWithObjects:@"姓名",@"性别",@"年龄",@"疾病诊断",@"症状描述", nil];
        _arryData = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
        _arryPlacelor = [NSMutableArray arrayWithObjects:@"请输入姓名",@"",@"请输入年龄",@"请输入疾病诊断",@"请输入症状", nil];
    }
    
    _arryotherDoc = [NSMutableArray array];
    
    [self getData];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, kWith, kHeight - 65) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *rightCase = [[UIBarButtonItem alloc]initWithTitle:@"导入病历" style:UIBarButtonItemStylePlain target:self action:@selector(onRightCase)];
    self.navigationItem.rightBarButtonItem = rightCase;
    
    UIButton *btnleft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnleft.frame = CGRectMake(0, 0, 13, 22);
    [btnleft addTarget:self action:@selector(onLeftCase) forControlEvents:UIControlEventTouchUpInside];
    [btnleft setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    UIBarButtonItem *letf = [[UIBarButtonItem alloc]initWithCustomView:btnleft];
    self.navigationItem.leftBarButtonItem = letf;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AddCase"];
    [_tableView registerClass:[CaseNameTableViewCell class] forCellReuseIdentifier:@"CaseName"];
    [_tableView registerClass:[CasePicTableViewCell class] forCellReuseIdentifier:@"CasePic"];
    [_tableView registerClass:[CaseSexTableViewCell class] forCellReuseIdentifier:@"CaseSex"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"casePicAddCollection"];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNoifyCaseAddPic:) name:@"CaseAddImage" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNotifyCASEFriends:) name:@"CASEFriends" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNotifyNameCase:) name:@"CaseNameText" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNotifyXunFly:) name:@"CaseXunFly" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNotifyCaseSex:) name:@"CaseSex" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNotifyCAsePicAddDoc:) name:@"AddDocL" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onDeletePic:) name:@"deletePic" object:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isWebLine == YES)
    {
        if (section == 1)
        {
            return 7;
        }
        return 1;
    }
    else
    {
        if (section == 0)
        {
            return 6;
        }
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isWebLine == YES)
    {
        NSInteger count = kWith/kItemWidth;
        NSInteger reste = (NSInteger)kWith % kItemWidth;
        float gap = reste/(count + 1);
        if (indexPath.section == 1) {
            if (indexPath.row == 6) {
                if ((_arryUpImage.count+1) % count == 0) {
                    return (kItemWidth+gap)*((_arryUpImage.count+1)/count)+4*gap;
                }else
                {
                    return (kItemWidth+gap)*((_arryUpImage.count+1)/count) + kItemWidth+gap*4;
                }
            }else
            {
                if (indexPath.row == 3||indexPath.row == 4||indexPath.row == 5) {
                    return 70;
                }
                return 40;
            }
        }else{
            return 40;
        }
    }
    else
    {
        NSInteger count = kWith/kItemWidth;
        NSInteger reste = (NSInteger)kWith % kItemWidth;
        float gap = reste/(count + 1);
        if (indexPath.section == 0) {
            if (indexPath.row == 5) {
                if ((_arryUpImage.count+1) % count == 0) {
                    return (kItemWidth+gap)*((_arryUpImage.count+1)/count)+4*gap;
                }else
                {
                    return (kItemWidth+gap)*((_arryUpImage.count+1)/count) + kItemWidth+gap*4;
                }
            }else
            {
                if (indexPath.row ==3||indexPath.row == 4) {
                    return 70;
                }
                return 40;
            }
        }else{
            NSInteger count2 = kWith/60;
            NSInteger reste2 = (NSInteger)kWith % 60;
            float gap2 = reste2/(count2 + 1);
            if ((_arryotherDoc.count +1) % count2 == 0) {
                return (60+gap2)*((_arryotherDoc.count +1)/count2);
            }else
            {
                return gap2+(60+gap2)*((_arryotherDoc.count +1)/count2) + 60+gap2;
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_isWebLine == YES)
    {
        if (section == 0)
        {
            return 0.01;
        }
        return 35;
    }
    else
    {
        return 35;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_isWebLine == YES)
    {
        if (section == 1)
        {
            return 80;
        }
        return 0.01;
    }
    else
    {
        if (section == 1)
        {
            return 80;
        }
        return 0.01;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 30)];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, kWith - 20, 20)];
    lbl.font = [UIFont systemFontOfSize:13];
    
    if (_isWebLine == YES)
    {
        if (section == 1)
        {
            lbl.text = @"添加患者病历";
        }
        [view addSubview:lbl];
        return view;
    }
    else
    {
        if (section == 0)
        {
            lbl.text = @"添加患者病历";
        }else
        {
            lbl.text = @"邀请医生加入病历讨论";
        }
        [view addSubview:lbl];
        return view;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (_isWebLine == YES)
    {
        if (section == 1)
        {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 45)];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10, 20, kWith - 20, 40);
            btn.backgroundColor = BLUECOLOR_STYLE;
            btn.layer.cornerRadius = 3;
            btn.layer.masksToBounds = YES;
            [btn setTitle:@"发布" forState:UIControlStateNormal];
            btn.userInteractionEnabled = YES;
            [btn addTarget:self action:@selector(sendPatients) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
            return view;
        }
        return 0;
    }
    else
    {
        if (section == 1)
        {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWith, 45)];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(10, 20, kWith - 20, 40);
            if (_arryotherDoc.count == 0) {
                btn.backgroundColor = [UIColor grayColor];
                btn.userInteractionEnabled = NO;
            }else
            {
                btn.backgroundColor = BLUECOLOR_STYLE;
                btn.userInteractionEnabled = YES;
            }
            btn.layer.cornerRadius = 3;
            btn.layer.masksToBounds = YES;
            [btn setTitle:@"开始讨论" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(onBtnComm) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
            return view;
        }
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isWebLine == YES)
    {
        if (indexPath.section == 0)
        {
            CaseNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CaseName" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            if (indexPath.row == 0)
            {
                cell.Casetext.tag = 410+6;
                [cell patientTextCellHeight:_arryData[6] Desp:_arryDesp[6] Placelor:_arryPlacelor[6] isHeight:NO];
                cell.btnXunFly.hidden = YES;
                return cell;
            }
        }
        else if(indexPath.section == 1)
        {
            if (indexPath.row != 6 && indexPath.row != 1)
            {
                CaseNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CaseName" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.Casetext.tag = 410+indexPath.row;
                if (indexPath.row == 2) {
                    cell.Casetext.keyboardType = UIKeyboardTypeNumberPad;
                }else
                {
                    cell.Casetext.keyboardType = UIKeyboardTypeDefault;
                }
                
                if (indexPath.row == 5 || indexPath.row == 4 || indexPath.row == 3)
                {
                    cell.btnXunFly.hidden  = NO;
                    [cell patientTextCellHeight:_arryData[indexPath.row] Desp:_arryDesp[indexPath.row] Placelor:_arryPlacelor[indexPath.row] isHeight:YES];
                }
                else
                {
                    cell.btnXunFly.hidden = YES;
                    [cell patientTextCellHeight:_arryData[indexPath.row] Desp:_arryDesp[indexPath.row] Placelor:_arryPlacelor[indexPath.row] isHeight:NO];
                }
                return cell;
            }
            else if(indexPath.row == 1)
            {
                CaseSexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CaseSex" forIndexPath:indexPath];
                if ([_arryData[1] isEqualToString:@""])
                {
                    cell.btnMan.selected = NO;
                    cell.btnWoman.selected = NO;
                }else if([_arryData[1] integerValue]==1)
                {
                    cell.btnMan.selected = YES;
                    cell.btnWoman.selected = NO;
                }else
                {
                    cell.btnMan.selected = NO;
                    cell.btnWoman.selected = YES;
                }
                return cell;
            }
            else
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"casePicAddCollection" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                for (UIView *viewB in cell.subviews)
                {
                    [viewB removeFromSuperview];
                }
                for (UIViewController *vc in self.childViewControllers)
                {
                    [vc removeFromParentViewController];
                }
                _collect = [[CollecDocAddViewController alloc]init];
                _collect.arryData = _arryUpImage;
                [cell addSubview:_collect.view];
                [self addChildViewController:_collect];
                return cell;
            }
        }
        return 0;
    }
    else
    {
        if (indexPath.section == 0) {
            if (indexPath.row != 5 && indexPath.row != 1) {
                CaseNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CaseName" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.Casetext.tag = indexPath.row+890;
                if (indexPath.row ==2) {
                    cell.Casetext.keyboardType = UIKeyboardTypeNumberPad;
                }else
                {
                    cell.Casetext.keyboardType = UIKeyboardTypeDefault;

                }
                if (indexPath.row ==4 || indexPath.row == 3) {
                    cell.btnXunFly.hidden  = NO;
                    [cell patientTextCellHeight:_arryData[indexPath.row] Desp:_arryDesp[indexPath.row] Placelor:_arryPlacelor[indexPath.row] isHeight:YES];

                }else
                {
                    cell.btnXunFly.hidden = YES;
                    [cell patientTextCellHeight:_arryData[indexPath.row] Desp:_arryDesp[indexPath.row] Placelor:_arryPlacelor[indexPath.row] isHeight:NO];
                }
                return cell;
            }
            else if(indexPath.row == 1){
                CaseSexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CaseSex" forIndexPath:indexPath];
                if ([_arryData[1] isEqualToString:@""]) {
                    cell.btnMan.selected = NO;
                    cell.btnWoman.selected = NO;
                }else if([_arryData[1] integerValue]==1){
                    cell.btnMan.selected = YES;
                    cell.btnWoman.selected = NO;
                }else
                {
                    cell.btnMan.selected = NO;
                    cell.btnWoman.selected = YES;
                }
                return cell;
            }
            else
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"casePicAddCollection" forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                for (UIView *viewB in cell.subviews) {
                    [viewB removeFromSuperview];
                }
                for (UIViewController *vc in self.childViewControllers) {
                    [vc removeFromParentViewController];
                }
                _collect = [[CollecDocAddViewController alloc]init];
                _collect.arryData = _arryUpImage;
                [cell addSubview:_collect.view];
                [self addChildViewController:_collect];
                return cell;
            }
        }
        else{
            CasePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CasePic" forIndexPath:indexPath];
            [cell setPicOtherImageFraem:_arryotherDoc];
            return cell;
        }
        return 0;
    }
}

#pragma mark --------选择图片
-(void)onNotifyCAsePicAddDoc:(NSNotification *)notify
{
    if (9-_arryImageImport.count<=0) {
        kAlter(@"不能超过九张图片");
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9-_arryImageImport.count delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.selectedAssets = _arryPhonoes;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto)
     {
         _arryPhonoes = [NSMutableArray arrayWithArray:assets];
         _arryUpImage =[NSMutableArray arrayWithArray:_arryImageImport];
         for (UIImage *image in photos)
         {
             [_arryUpImage addObject:image];
         };
         if (_isWebLine == YES) {
             [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
         }else
         {
             [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
         }

     }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

-(void)onNoifyCaseAddPic:(NSNotification *)notify{
    
    CaseDocListViewController *doc = [[CaseDocListViewController alloc]init];
    doc.from = @"CaseAdd";
    doc.arryS = _arryotherDoc;
    [self.navigationController pushViewController:doc animated:YES];
}

#pragma mark --------邀请好友
-(void)onNotifyCASEFriends:(NSNotification *)notify{
    _arryotherDoc = notify.object;
    [_tableView reloadData];
}

#pragma mark --------输入完成
-(void)onNotifyNameCase:(NSNotification *)notify{
    
    NSDictionary *dicUsein = notify.userInfo;
    CaseNameTableViewCell *cell = [dicUsein objectForKey:@"cell"];
    NSIndexPath *index =[_tableView indexPathForCell:cell];
    if (_isWebLine == YES)
    {
        if (index.section == 0)
        {
            if ([dicUsein objectForKey:@"error"]) {
                kAlter([dicUsein objectForKey:@"error"]);
                return;
            }
            [_arryData replaceObjectAtIndex:6 withObject:[dicUsein objectForKey:@"text"]];
        }
        else
        {
            if ([dicUsein objectForKey:@"error"]) {
                kAlter([dicUsein objectForKey:@"error"]);
                return;
            }
            [_arryData replaceObjectAtIndex:index.row withObject:[dicUsein objectForKey:@"text"]];
        }
    }
    else
    {
        if ([dicUsein objectForKey:@"error"]) {
            kAlter([dicUsein objectForKey:@"error"]);
            return;
        }else
        {
            [_arryData replaceObjectAtIndex:index.row withObject:[dicUsein objectForKey:@"text"]];
        }
    }
}

-(void)onNotifyCaseSex:(NSNotification *)notify{
    
    UIButton *btn = notify.object;
    if (btn.tag == 1250) {
        [_arryData replaceObjectAtIndex:1 withObject:@"1"];
    }
    else
    {
        [_arryData replaceObjectAtIndex:1 withObject:@"0"];
    }
}

#pragma mark - 发布会诊
-(void)sendPatients
{
    if ([self isNull]==NO) {
        return;
    }
    
    NSMutableArray *members = [NSMutableArray array];
    for (NSDictionary *dic in _arryotherDoc)
    {
        NSString *DocID = [dic objectForKey:@"loginId"];
        [members addObject:[NSString stringWithFormat:@"d%@",DocID]];
    }

    
    
    NSMutableDictionary * parm= [[NSMutableDictionary alloc]init];
    [parm setObject:_arryData[6] forKey:@"title"];
    [parm setObject:_arryData[0] forKey:@"patientName"];
    [parm setObject:_arryData[1] forKey:@"sex"];
    [parm setObject:_arryData[2] forKey:@"age"];
    //描述
    [parm setObject:_arryData[3] forKey:@"illDetail"];
    //诊断
    [parm setObject:_arryData[4] forKey:@"illness"];
    //备注
    [parm setObject:_arryData[5] forKey:@"detail"];
    [parm setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    //上传图片
    NSMutableArray *arryIMageData = [NSMutableArray array];
    NSMutableArray *arryImageUrl = [NSMutableArray array];
    if (_arryUpImage.count != 0 && _arryUpImage != nil) {
        for (id obj in _arryUpImage)
        {
            if ([obj isKindOfClass:[UIImage class]]) {
                NSData *data = UIImageJPEGRepresentation(obj, 1);
                [arryIMageData addObject:data];
            }else
            {
                [arryImageUrl addObject:obj];
            }
        };
        if (arryIMageData.count>0) {
            NSDictionary *header = @{@"verifyCode":[kUserDefatuel objectForKey:@"verifyCode"]};
            [RequestManager CasePicWithURLString:[NSString stringWithFormat:@"%@/api/Share/PictureUpload",NET_URLSTRING] heads:header Parameters:arryIMageData viewConroller:self Complation:^(NSDictionary *dicCom) {
                if ([[dicCom objectForKey:@"code"] integerValue]==10000)
                {
                    for (NSDictionary *dicimage in [dicCom objectForKey:@"value"]) {
                        [arryImageUrl addObject:dicimage];
                    }
                    [parm setObject:arryImageUrl forKey:@"picList"];
                    [self senPatientCase:parm];
                }
                else
                {

                    kAlter(@"上传图片失败");
                }
            } Fail:^(NSError *error) {

                kAlter(@"上传图片失败");
            }];
        }else
        {
            [parm setObject:arryImageUrl forKey:@"picList"];
            [self senPatientCase:parm];
        }
    }else
    {
        [parm setObject:arryImageUrl forKey:@"picList"];
        [self senPatientCase:parm];
    }
}

-(void)senPatientCase:(NSMutableDictionary *)dic{
    [RequestManager postWithURLStringALL:NETCONSULTATIONADD heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject, BOOL ifTimeout) {

        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"发布成功" preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [self presentViewController:alter animated:YES completion:nil];

    } failure:^(NSError *error) {

    }];
}

#pragma mark --------开始讨论

-(BOOL)isNull{
    if (_isWebLine == YES) {
        if ([_arryData[0] isEqualToString:@""]) {
            kAlter(@"姓名不能为空");
            return NO;
        }
        if ([_arryData[3] isEqualToString:@""]) {
            kAlter(@"疾病诊断不能为空");
            return NO;
        }
        if ([_arryData[4] isEqualToString:@""]) {
            kAlter(@"症状描述不能为空");
            return NO;
        }
        if ([_arryData[6] isEqualToString:@""]) {
            kAlter(@"标题不能为空");
            return NO;
        }
    }else
    {
        if ([_arryData[0] isEqualToString:@""]) {
            kAlter(@"姓名不能为空");
            return NO;
        }
        if ([_arryData[3] isEqualToString:@""]) {
            kAlter(@"疾病诊断不能为空");
            return NO;
        }
        if ([_arryData[4] isEqualToString:@""]) {
            kAlter(@"症状描述不能为空");
            return NO;
        }
    }
    if ([_arryData[2] isEqualToString:@""]) {
        kAlter(@"年龄不能为空");
        return NO;
    }
    NSString *regex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject:_arryData[2]] || [_arryData[2] integerValue]<=0) {
        kAlter(@"年龄只能是大于0的数字！");
        return NO;
    }
    if ([_arryData[2] integerValue] > 150) {
        kAlter(@"年龄最大不能超过150岁");
        return NO;
    }
    if ([_arryData[0] length] >50) {
        kAlter(@"名字不能超过50个字符");
        return NO;
    }
    return YES;
}

-(void)onBtnComm{
    if ([self isNull]==NO) {
        return;
    }
    
    NIMCreateTeamOption *option = [[NIMCreateTeamOption alloc] init];
    option.name       = @"zhengchang";
    option.type       = NIMTeamTypeNormal;
    

    
    NSMutableArray *members = [NSMutableArray array];
    for (NSDictionary *dic in _arryotherDoc) {
        NSString *DocID = [dic objectForKey:@"loginId"];
        [members addObject:[NSString stringWithFormat:@"d%@",DocID]];
    }
    [[NIMSDK sharedSDK].teamManager createTeam:option users:members completion:^(NSError *error, NSString *teamId) {
        if (!error) {
            
            NSMutableArray *arryIMageData = [NSMutableArray array];
            NSMutableArray *arryImageUrl = [NSMutableArray array];
            if (_arryUpImage.count != 0 && _arryUpImage != nil) {
                for (id obj in _arryUpImage)
                {
                    if ([obj isKindOfClass:[UIImage class]]) {
                        NSData *data = UIImageJPEGRepresentation(obj, 1);
                        [arryIMageData addObject:data];
                    }else
                    {
                        [arryImageUrl addObject:obj];
                    }
                };
                if (arryIMageData.count>0) {
                    NSDictionary *header = @{@"verifyCode":[kUserDefatuel objectForKey:@"verifyCode"]};
                    //上传图片
                    [RequestManager CasePicWithURLString:[NSString stringWithFormat:@"%@/api/Share/PictureUpload",NET_URLSTRING] heads:header Parameters:arryIMageData  viewConroller:self Complation:^(NSDictionary *dicCom) {
                        if ([[dicCom objectForKey:@"code"] integerValue]==10000)
                        {
                            for (NSDictionary *dicimage in [dicCom objectForKey:@"value"]) {
                                [arryImageUrl addObject:dicimage];
                            }
                            [self submitData:arryImageUrl team:teamId];
                        }
                        else
                        {

                            kAlter(@"上传图片失败");
                        }
                    } Fail:^(NSError *error) {

                        kAlter(@"上传图片失败");
                    }];
                }else
                {
                    [self submitData:arryImageUrl team:teamId];
                }
            }else
            {
                [self submitData:arryImageUrl team:teamId];
            }
        }else{

            kAlter(@"提交失败");
            return;
        }
    }];
}

-(void)submitData:(NSMutableArray *)arryImageUrl team:(NSString *)teamId{
    
    NSMutableArray *arryID = [NSMutableArray array];
    for (NSDictionary *dic in _arryotherDoc) {
        NSDictionary *dicMem = @{@"memberId":[dic objectForKey:@"friendId"]};
        [arryID addObject:dicMem];
    }
    NSDictionary * parm=@{@"patientName":_arryData[0],
                          @"sex":_arryData[1],
                          @"age":_arryData[2],@"illness":_arryData[4],
                          @"memberList":arryID,@"teamId":teamId,
                          @"diagnosisResult":_arryData[3],
                          @"picList":arryImageUrl,
                          @"doctorId":[kUserDefatuel objectForKey:@"id"]};
    [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Doctor/DiscussionAdd",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:parm viewConroller:self success:^(id responseObject, BOOL ifTimeout) {

        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"发布成功" preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CaseCommentViewController *caseComm = [[CaseCommentViewController alloc]init];
            caseComm.from = @"creatCasePatient";
            caseComm.dicGroup = (NSDictionary *)responseObject;
            [self.navigationController pushViewController:caseComm animated:YES];
        }]];
        [self presentViewController:alter animated:YES completion:nil];
        
    } failure:^(NSError *error) {

    }];
}

#pragma mark --------讯飞
-(void)onNotifyXunFly:(NSNotification *)notify{
    
    CaseNameTableViewCell *cell = notify.object;
    NSIndexPath *index  = [_tableView indexPathForCell:cell];
    if (_iflyRecognizerView == nil) {
        _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    }
    _selectedRow = 2400 + index.row;
    _iflyRecognizerView.delegate = self;
    [_iflyRecognizerView setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    //asr_audio_path保存录音文件名，如不再需要，设置value为nil表示取消，默认目录是documents
    [_iflyRecognizerView setParameter:nil forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    //启动识别服务
    [_iflyRecognizerView start];
    
}

-(void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast{
    NSString *str = [[resultArray lastObject] allKeys][0];
    if ([str isEqualToString:@"。"])
    {
        return;
    }
    if (_isWebLine == YES) {
        if (_selectedRow == 2403)
        {
            //诊断
            [_arryData replaceObjectAtIndex:3 withObject:str];
        }
        else if(_selectedRow == 2404)
        {
            //描述
            [_arryData replaceObjectAtIndex:4 withObject:str];
        }
        else if (_selectedRow == 2405)
        {
            //备注
            [_arryData replaceObjectAtIndex:5 withObject:str];
        }
    }else
    {
        if (_selectedRow == 2403)
        {
            [_arryData replaceObjectAtIndex:3 withObject:str];
        }
        else if(_selectedRow == 2404)
        {
            [_arryData replaceObjectAtIndex:4 withObject:str];
        }
    }

    [_tableView reloadData];
}

- (void)onError: (IFlySpeechError *) error
{
    NSLog(@"==========%@  %d   %d",error.errorDesc,error.errorCode,error.errorType);
}

#pragma mark --------导入病例
-(void)onRightCase{
    
    ImportPatientViewController *import = [[ImportPatientViewController alloc]init];
    [self.navigationController pushViewController:import animated:YES];
    
}

-(void)onLeftCase{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-----------删除图片
-(void)onDeletePic:(NSNotification *)notify{
    
    DocAddCollectionViewCell *cell = notify.object;
    NSIndexPath *index = [_collect.collection indexPathForCell:cell];
    if (_isHaveImport != YES) {
        [_arryPhonoes removeObjectAtIndex:index.item];
    }else
    {
        if (index.item<_arryImageImport.count) {
            NSMutableArray *arryMU = [NSMutableArray arrayWithArray:_arryImageImport];
            [arryMU removeObjectAtIndex:index.item];
            _arryImageImport = [NSArray arrayWithArray:arryMU];
        }else
        {
            [_arryPhonoes removeObjectAtIndex:index.item-_arryImageImport.count];
        }
    }
    [_arryUpImage removeObjectAtIndex:index.item];
    if (_isWebLine == YES)
    {
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
    
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
