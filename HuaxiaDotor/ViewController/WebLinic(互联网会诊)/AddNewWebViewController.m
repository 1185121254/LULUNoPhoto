//
//  AddNewWebViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/8/10.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AddNewWebViewController.h"
#import "ImportPatientViewController.h"
#import "TZImagePickerController.h"
#import "ShowPicCollectionViewCell.h"
#import "ShowPic.h"

#import "iflyMSC/IFlyMSC.h"
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
@interface AddNewWebViewController ()<TZImagePickerControllerDelegate,IFlyRecognizerViewDelegate>
{
    //是否导入病例
    BOOL _isHaveImport;
    //图片数组
    NSMutableArray *_arryImage;
    NSMutableArray *_arryPhonoes;
    NSArray *_arryImport;
    //图片列表
    ShowPic *_picList;
    
    IFlyRecognizerView *_iflyRecognizerView;
    NSInteger _btnTage;

}
@end

@implementation AddNewWebViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshLayout];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"添加患者病历";
    self.scrollWeb.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    self.submmitBtn.backgroundColor = BLUECOLOR_STYLE;
    
    UIBarButtonItem *rightCase = [[UIBarButtonItem alloc]initWithTitle:@"导入病历" style:UIBarButtonItemStylePlain target:self action:@selector(onRightCase)];
    self.navigationItem.rightBarButtonItem = rightCase;
    
    UIButton *btnleft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnleft.frame = CGRectMake(0, 0, 13, 22);
    [btnleft addTarget:self action:@selector(onLeftCase) forControlEvents:UIControlEventTouchUpInside];
    [btnleft setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    UIBarButtonItem *letf = [[UIBarButtonItem alloc]initWithCustomView:btnleft];
    self.navigationItem.leftBarButtonItem = letf;
 
    //图片列表
    _arryImage = [NSMutableArray array];
    [self setImage];
    
    //添加图片
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNotifyCAsePicAddDoc:) name:@"addPic" object:nil];
    //删除图片
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onDeletePic:) name:@"picDelete" object:nil];
}

#pragma mark --------获取导入病例的数据
-(void)getData{
    //姓名
    if ([self.dicImport objectForKey:@"name"]) {
        self.nameTextFiled.text =  [self.dicImport objectForKey:@"name"];
    }
    //性别
    if ([self.dicImport objectForKey:@"sex"] == nil)
    {
        self.btnMan.selected = YES;
        self.btnWoman.selected = NO;
    }else
    {
        if ([[self.dicImport objectForKey:@"sex"] integerValue]==1) {
            self.btnMan.selected = YES;
            self.btnWoman.selected = NO;
        }else
        {
            self.btnMan.selected = NO;
            self.btnWoman.selected = YES;
        }
    }
    //年龄
    if ([self.dicImport objectForKey:@"age"])
    {
        self.ageTextFiled.text =  [NSString stringWithFormat:@"%@",[self.dicImport objectForKey:@"age"]];
    }
    //诊断
    if ([self.dicImport objectForKey:@"description"]) {
        self.diagnoseTextView.text = [self.dicImport objectForKey:@"description"];
        self.diagnoseHeight.constant = [self textViewheight:self.diagnoseTextView];
    }else
    {
        self.diagnoseTextView.text = @"";
    }
    self.diagnosePlacor.hidden = YES;

    //描述
    if ([self.dicImport objectForKey:@"illDetail"]) {
        self.despTextView.text = [self.dicImport objectForKey:@"illDetail"];
        self.despHeight.constant = [self textViewheight:self.despTextView];
    }else
    {
        self.despTextView.text = @"";
    }
    self.despPlacor.hidden = YES;

    //图片
    if ([self.dicImport objectForKey:@"picList"] != nil) {
        _isHaveImport = YES;
        _arryImage = [NSMutableArray arrayWithArray:[self.dicImport objectForKey:@"picList"]];
        _arryImport = [self.dicImport objectForKey:@"picList"];
    }else
    {
        _arryImport = [NSArray array];
        _arryImage = [NSMutableArray array];
        _isHaveImport = NO;
    }
    [self updatePicList:_arryImage];
}

#pragma mark----------------  创建图片
-(void)setImage{
    NSInteger count = kWith/kItemWidth;
    NSInteger reste = (NSInteger)kWith % kItemWidth;
    float gap = reste/(count + 1);
    if ((_arryImage.count+1) % count == 0) {
        _picHeight.constant = (kItemWidth+gap)*((_arryImage.count+1)/count)+4*gap;
    }else
    {
        _picHeight.constant = (kItemWidth+gap)*((_arryImage.count+1)/count) + kItemWidth+gap*4;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(gap, gap, gap, gap);
    layout.minimumLineSpacing = gap;
    layout.minimumInteritemSpacing = gap;
    layout.itemSize = CGSizeMake(kItemWidth, kItemWidth);
    
    _picList = [[ShowPic alloc]initWithFrame:CGRectMake(0, 0, _picView.frame.size.width, _picHeight.constant) collectionViewLayout:layout];
    _picList.arryData = _arryImage;
    _picList.from = @"pic";
    [_picView addSubview:_picList];
}
#pragma mark----------------  更新图片
-(void)updatePicList:(NSMutableArray *)arry{
    NSInteger count = kWith/kItemWidth;
    NSInteger reste = (NSInteger)kWith % kItemWidth;
    float gap = reste/(count + 1);
    if ((arry.count+1) % count == 0) {
        _picHeight.constant = (kItemWidth+gap)*((arry.count+1)/count)+4*gap;
    }else
    {
        _picHeight.constant = (kItemWidth+gap)*((arry.count+1)/count) + kItemWidth+gap*4;
    }
    _picList.frame = CGRectMake(0, 0, _picView.frame.size.width, _picHeight.constant);
    [_picList refreshCollection:arry];
    [self refreshLayout];
}

#pragma mark --------选择图片
-(void)onNotifyCAsePicAddDoc:(NSNotification *)notify
{
    if (9-_arryImage.count<=0) {
        kAlter(@"不能超过九张图片");
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9-_arryImport.count delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.selectedAssets = _arryPhonoes;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto)
     {
         _arryPhonoes = [NSMutableArray arrayWithArray:assets];
         _arryImage = [NSMutableArray arrayWithArray:_arryImport];
         for (UIImage *image in photos)
         {
             [_arryImage addObject:image];
         };
         [self updatePicList:_arryImage];
     }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark--------------------删除图片
-(void)onDeletePic:(NSNotification *)notify{
    ShowPicCollectionViewCell *cell = notify.object;
    NSIndexPath *index = [_picList indexPathForCell:cell];
    if (_isHaveImport != YES) {
        [_arryPhonoes removeObjectAtIndex:index.item];
    }else
    {
        if (index.item<_arryImport.count) {
            NSMutableArray *arryMU = [NSMutableArray arrayWithArray:_arryImport];
            [arryMU removeObjectAtIndex:index.item];
            _arryImport = [NSArray arrayWithArray:arryMU];
        }else
        {
            [_arryPhonoes removeObjectAtIndex:index.item-_arryImport.count];
        }
    }
    [_arryImage removeObjectAtIndex:index.item];
    [self updatePicList:_arryImage];
}

#pragma mark--------------------讯飞语音
- (IBAction)btnXunFly:(UIButton *)sender {
    if (_iflyRecognizerView == nil) {
        _iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    }
    _btnTage = sender.tag;
    _iflyRecognizerView.delegate = self;
    [_iflyRecognizerView setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    [_iflyRecognizerView setParameter:nil forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    [_iflyRecognizerView start];
}

-(void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast{
    
    NSString *str = [[resultArray lastObject] allKeys][0];
    if ([str isEqualToString:@"。"]) {
        return;
    }
    if (str) {
        if (_btnTage == 811) {
            self.diagnoseTextView.text = str;
            self.diagnoseHeight.constant = [self textViewheight:self.diagnoseTextView];
            self.diagnosePlacor.hidden = YES;
        }
        else if (_btnTage == 812){
            self.despTextView.text = str;
            self.despHeight.constant = [self textViewheight:self.despTextView];
            self.despPlacor.hidden = YES;
        }
        else if (_btnTage == 813){
            self.remakTextView.text = str;
            self.remarkHeight.constant = [self textViewheight:self.remakTextView];
            self.remarkPlacor.hidden = YES;
        }
        [self refreshLayout];
    }
}

- (void)onError: (IFlySpeechError *) error
{
    NSLog(@"==========%@  %d   %d",error.errorDesc,error.errorCode,error.errorType);
}

#pragma mark--------------------选择性别
- (IBAction)btnMan:(UIButton *)sender {
    self.btnMan.selected = YES;
    self.btnWoman.selected = NO;
}

- (IBAction)btnWoamn:(UIButton *)sender {
    self.btnMan.selected = NO;
    self.btnWoman.selected = YES;
}

#pragma mark--------------------发布病例
-(BOOL)isNull{
    if (self.titleTextView.text == nil||[self.titleTextView.text isEqualToString:@""]) {
        kAlter(@"标题不能为空");
        return NO;
    }
    if (self.nameTextFiled.text == nil||[self.nameTextFiled.text isEqualToString:@""]) {
        kAlter(@"姓名不能为空");
        return NO;
    }
    if (self.diagnoseTextView.text == nil||[self.diagnoseTextView.text isEqualToString:@""]) {
        kAlter(@"疾病诊断不能为空");
        return NO;
    }
    if (self.despTextView.text == nil||[self.despTextView.text isEqualToString:@""]) {
        kAlter(@"症状描述不能为空");
        return NO;
    }
    if (self.ageTextFiled.text == nil||[self.ageTextFiled.text isEqualToString:@""]) {
        kAlter(@"年龄不能为空");
        return NO;
    }
    NSString *regex = @"^[0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject:_ageTextFiled.text] || [_ageTextFiled.text integerValue]<=0) {
        kAlter(@"年龄只能是大于0的数字！");
        return NO;
    }
    if ([_ageTextFiled.text integerValue] > 150) {
        kAlter(@"年龄最大不能超过150岁");
        return NO;
    }
    if ([_nameTextFiled.text length] >50) {
        kAlter(@"名字不能超过50个字符");
        return NO;
    }
    return YES;
}

- (IBAction)btnPublish:(UIButton *)sender {
    [self.view endEditing:YES];
    [self sendPatients];
}
-(void)sendPatients
{
    if ([self isNull]==NO) {
        return;
    }

    
    NSString *sex;
    if (self.btnMan.selected == YES) {
        sex = @"1";
    }else
    {
        sex = @"0";
    }
    NSMutableDictionary * parm= [[NSMutableDictionary alloc]init];
    [parm setObject:self.titleTextView.text forKey:@"title"];
    [parm setObject:self.nameTextFiled.text forKey:@"patientName"];
    [parm setObject:sex forKey:@"sex"];
    [parm setObject:self.ageTextFiled.text forKey:@"age"];
    //描述
    [parm setObject:self.despTextView.text forKey:@"illDetail"];
    //诊断
    [parm setObject:self.diagnoseTextView.text forKey:@"illness"];
    //备注
    [parm setObject:self.remakTextView.text forKey:@"detail"];
    [parm setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    //上传图片
    NSMutableArray *arryIMageData = [NSMutableArray array];
    NSMutableArray *arryImageUrl = [NSMutableArray array];
    if (_arryImage.count != 0 && _arryImage != nil) {
        for (id obj in _arryImage)
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
            [RequestManager CasePicWithURLString:[NSString stringWithFormat:@"%@/api/Share/PictureUpload",NET_URLSTRING] heads:header Parameters:arryIMageData  viewConroller:self Complation:^(NSDictionary *dicCom) {
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

#pragma mark--------------------TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.tag == 710) {
        self.titlePlacor.hidden = [self textViewLength:textView];
        if ([self textViewTextOutStr:textView length:50]) {
            kAlter(@"标题不能超出50个字符");
        }
        self.titleHeight.constant = [self textViewheight:textView];
    }
    else if(textView.tag == 711){
        self.diagnosePlacor.hidden = [self textViewLength:textView];
        if ([self textViewTextOutStr:textView length:50]) {
            kAlter(@"疾病诊断不能超出50个字符");
        }
        self.diagnoseHeight.constant = [self textViewheight:textView];
    }
    else if(textView.tag == 712){
        self.despPlacor.hidden = [self textViewLength:textView];
        if ([self textViewTextOutStr:textView length:200]) {
            kAlter(@"症状描述不能超出200个字符");
        }
        self.despHeight.constant = [self textViewheight:textView];
    }
    else if(textView.tag == 713){
        self.remarkPlacor.hidden = [self textViewLength:textView];
        if ([self textViewTextOutStr:textView length:200]) {
            kAlter(@"备注不能超出200个字符");
        }
        self.remarkHeight.constant = [self textViewheight:textView];
    }
    [self refreshLayout];
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (textView.tag == 710) {
        self.titlePlacor.hidden = YES;
    }
    else if (textView.tag == 711){
        self.diagnosePlacor.hidden = YES;
    }
    else if (textView.tag == 712){
        self.despPlacor.hidden = YES;
    }
    else if (textView.tag == 713){
        self.remarkPlacor.hidden = YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView.tag == 710) {
        self.titlePlacor.hidden = [self textViewLength:textView];
    }
    else if (textView.tag == 711){
        self.diagnosePlacor.hidden = [self textViewLength:textView];
    }
    else if (textView.tag == 712){
        self.despPlacor.hidden = [self textViewLength:textView];
    }
    else if (textView.tag == 713){
        self.remarkPlacor.hidden = [self textViewLength:textView];
    }
}

-(BOOL)textViewTextOutStr:(UITextView *)textView length:(NSInteger)legth{
    
    if (textView.text.length>legth) {
        NSString *outLength = [textView.text substringWithRange:NSMakeRange(legth, textView.text.length-legth)];
        textView.text =  [textView.text stringByReplacingOccurrencesOfString:outLength withString:@""];
        return YES;
    }
    return NO;
}

-(BOOL)textViewLength:(UITextView *)textView{
    if (textView.text.length==0) {
        return NO;
    }
    return YES;
}

-(CGFloat)textViewheight:(UITextView *)textView{
    CGRect rect = textView.bounds;
    CGSize maxSize = CGSizeMake(rect.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    return newSize.height+1;
}
#pragma mark--------------------更新约束

-(void)refreshLayout{
    [self.view layoutIfNeeded];
    
    CGFloat height = self.titleHeight.constant+self.addCaseHeight.constant+self.nameHeight.constant+self.sexHeight.constant+self.ageHeight.constant+self.diagnoseHeight.constant+self.despHeight.constant+self.remarkHeight.constant+self.picHeight.constant+self.submmitBtnHeight.constant+8*8;
    
    if (height<kHeight-64) {
        height = kHeight-64+1;
    }
    
    self.scrollWeb.contentSize = CGSizeMake(kWith, height);
}


#pragma mark --------导入病例
-(void)onRightCase{
    ImportPatientViewController *import = [[ImportPatientViewController alloc]init];
    import.from = @"webImport";
    [self.navigationController pushViewController:import animated:YES];
}

-(void)onLeftCase{
    [self.navigationController popViewControllerAnimated:YES];
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
