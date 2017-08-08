//
//  ScrollAdviceViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/8/8.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ScrollAdviceViewController.h"
#import "RequestManager.h"
#import "IQKeyboardManager.h"

#import "iflyMSC/IFlyMSC.h"
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"
#import "iflyMSC/IFlySpeechRecognizer.h"

#define NoStr @"未填写"

@interface ScrollAdviceViewController ()<UITextViewDelegate,IFlyRecognizerViewDelegate>
{
    //图片
    NSMutableArray *_arryImage;
    
    IFlyRecognizerView *_iflyRecognizerView;
    NSInteger _btnTage;

    
    PublishNav *_publish;
    //是否显示提交按钮
    BOOL isShowSubmitBtn;
    //网络获取的诊断建议  信息
    AdviewDetail *_advice;
}

@end

@implementation ScrollAdviceViewController
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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollAdvice.backgroundColor = kBackgroundColor;
    self.btnSubmit.layer.cornerRadius= 5;
    self.btnSubmit.layer.masksToBounds = YES;

    _publish= [[PublishNav alloc]init];
    _publish.title.text = @"诊断建议";
    [_publish.leftBtn addTarget:self action:@selector(onLeftBack) forControlEvents:UIControlEventTouchUpInside];
    _publish.rightBtn.frame = CGRectMake(kWith-60, 24, 40, 40);
    [_publish.rightBtn addTarget:self action:@selector(OnRight) forControlEvents:UIControlEventTouchUpInside];
    [_publish.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.view addSubview:_publish];

    [self btnShow:NO];
    [self creatTitle];
    [self getWebData];
    [self reslutHeight];
    isShowSubmitBtn = NO;

}
#pragma mark---------------获取网络数据
-(void)getWebData{

    
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetDiagnosisAdvice",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:@{@"orderId":self.patient.Id} viewConroller:self success:^(id responseObject) {

        AdviewDetail *adview = [self setDataAd:(NSDictionary *)responseObject];
        [self showWebData:adview];
        
        if ([self.from isEqualToString:@"BennOver"]) {
            if (adview.result == nil || [adview.result isEqualToString:@""]) {
                //已完成的咨询如果没有填写诊断建议可以再填写一次
                _publish.rightBtn.hidden = NO;
            }else{
                //已完成的咨询如果有填写诊断建议，则不可以再次填写
                _publish.rightBtn.hidden = YES;
            }
        }
        else
        {
            if ([self.from isEqualToString:@"BeenDia"]) {
                //点击绿色按钮进去
                _publish.rightBtn.hidden = YES;
            }
            else{
                //点击蓝色按钮进去
                _publish.rightBtn.hidden = NO;
            }
        }

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

-(void)showWebData:(AdviewDetail *)adview{
    //图片
    for (UIView *view in self.picView.subviews) {
        [view removeFromSuperview];
    }
    if (adview.picList == nil||adview.picList.count == 0) {
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, self.picView.frame.size.width, self.picView.frame.size.height)];
        lbl.text = @"未添加";
        lbl.font = [UIFont systemFontOfSize:15];
        [self.picView addSubview:lbl];
        self.picHeight.constant = 65;
    }
    else
    {
        [self forPicView:adview];
    }
    
    //症状描述
    if (self.patient.Description==nil||[self.patient.Description isEqualToString:@""]) {
        self.despTextView.text = NoStr;
        self.despHeight.constant = 65;
    }else
    {
        self.despTextView.textColor = [UIColor blackColor];
        self.despTextView.text = self.patient.Description;
        self.despHeight.constant = [self textViewHeight:self.despTextView]+30;
    }
    //初步预诊
    if (adview.result) {
        self.resultPlacor.hidden = YES;
        self.reslutTextView.text = adview.result;
        self.reslutHeight.constant = [self textViewHeight:self.reslutTextView]+30;
    }else
    {
        self.resultPlacor.hidden = NO;
        self.resultPlacor.text = NoStr;
        self.reslutHeight.constant = 65;
    }
    //建议用药
    if (adview.drugList) {
        self.drugPlacor.hidden = YES;
        self.drugTextView.text = adview.drugList;
        self.drugHeight.constant = [self textViewHeight:self.drugTextView]+30;
    }else
    {
        self.drugPlacor.hidden = NO;
        self.drugPlacor.text = NoStr;
        self.drugHeight.constant = 65;
    }
    //建议检查项目
    if (adview.checkList) {
        self.checkPlacor.hidden = YES;
        self.checkTextView.text = adview.checkList;
        self.checkHeight.constant = [self textViewHeight:self.checkTextView]+30;
    }else
    {
        self.checkPlacor.hidden = NO;
        self.checkPlacor.text = NoStr;
        self.checkHeight.constant = 65;
    }
    //诊断建议
    if (adview.advice) {
        self.advicePlacor.hidden = YES;
        self.adviceTextView.text = adview.advice;
        self.adviceHeight.constant = [self textViewHeight:self.adviceTextView]+30;
    }else
    {
        self.advicePlacor.hidden = NO;
        self.advicePlacor.text = NoStr;
        self.adviceHeight.constant = 65;
    }
    [self refreshLayout];
}

-(void)forPicView:(AdviewDetail *)adview{
    NSInteger count = kWith/kItemWidth;
    NSInteger reste = (NSInteger)kWith % kItemWidth;
    float gap = reste/(count + 1);
    _arryImage = adview.picList;
    for (NSInteger i = 0; i<adview.picList.count; i++) {
        UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
        btnImage.tag = i+700;
        btnImage.frame = CGRectMake(gap+(kItemWidth+gap)*(i%count), gap+(kItemWidth+gap)*(i/count), kItemWidth, kItemWidth);
        [btnImage addTarget:self action:@selector(onBtnImage:) forControlEvents:UIControlEventTouchUpInside];
        
        NSDictionary *dic = adview.picList[i];
        NSString *yrl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,[dic objectForKey:@"microPicUrl"]];
        NSString *url = [yrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        [btnImage sd_setBackgroundImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ic_login_account"]];
        [self.picView addSubview:btnImage];
        if (i == adview.picList.count-1) {
            self.picHeight.constant = btnImage.frame.origin.y+btnImage.frame.size.height+35;
        }
    }
}

-(void)onBtnImage:(UIButton *)btn{
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0 ; i < _arryImage.count; i++) {
        NSDictionary *dic = _arryImage[i];
        //传递数据给浏览器
        MJPhoto *photo = [[MJPhoto alloc] init];
        NSString *yrl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,[dic objectForKey:@"picUrl"]];
        NSString *url = [yrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        photo.url = [NSURL URLWithString:url];
        [photos addObject:photo];
    }
    brower.currentPhotoIndex = btn.tag-700;
    brower.photos = photos;
    [brower show];
}

#pragma mark---------------设置标题与提交按钮
-(void)creatTitle{
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, kWith, 40)];
    lbl.backgroundColor = BLUECOLOR_STYLE;
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont systemFontOfSize:15];
    NSString *sex;
    if ([self.patient.sex isEqualToString:@"1"]) {
        sex = @"男";
    }else{
        sex = @"女";
    }
    lbl.attributedText = [self setText:[NSString stringWithFormat:@"  %@    %@  %@岁",self.patient.patientName,sex,self.patient.age]];
    [self.view addSubview:lbl];
}
#pragma mark---------------讯飞语音
- (IBAction)btnXunLy:(UIButton *)sender {
    
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
        if (_btnTage == 411) {
            self.reslutTextView.text = str;
            self.resultPlacor.hidden = YES;
            self.reslutHeight.constant = [self textViewHeight:self.reslutTextView]+30;
        }
        else if (_btnTage == 412){
            self.drugTextView.text = str;
            self.drugPlacor.hidden = YES;
            self.drugHeight.constant = [self textViewHeight:self.drugTextView]+30;
        }
        else if (_btnTage == 413){
            self.checkTextView.text = str;
            self.checkPlacor.hidden = YES;
            self.checkHeight.constant = [self textViewHeight:self.checkTextView]+30;
        }
        else if (_btnTage == 414){
            self.adviceTextView.text = str;
            self.advicePlacor.hidden = YES;
            self.adviceHeight.constant = [self textViewHeight:self.adviceTextView]+30;
        }
        [self refreshLayout];
    }
    
}

- (void)onError: (IFlySpeechError *) error
{
    NSLog(@"==========%@  %d   %d",error.errorDesc,error.errorCode,error.errorType);
}


#pragma mark-----TextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{

    if (textView.tag == 311) {
        self.resultPlacor.hidden = YES;
    }
    else if (textView.tag == 312){
        self.drugPlacor.hidden = YES;
    }
    else if (textView.tag == 313){
        self.checkPlacor.hidden = YES;
    }
    else if (textView.tag == 314){
        self.advicePlacor.hidden = YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView{

    if (textView.tag == 311) {
        self.resultPlacor.hidden = [self textViewLength:textView];
        if ([self textViewTextOutStr:textView length:50]) {
            kAlter(@"初步预诊不能超出50个字符");
        }
        self.reslutHeight.constant = [self textViewHeight:textView]+30;
    }
    else if (textView.tag == 312){
        self.drugPlacor.hidden = [self textViewLength:textView];
        if ([self textViewTextOutStr:textView length:100]) {
            kAlter(@"建议用药不能超出100个字符");
        }
        self.drugHeight.constant = [self textViewHeight:textView]+30;
    }
    else if (textView.tag == 313){
        self.checkPlacor.hidden = [self textViewLength:textView];
        if ([self textViewTextOutStr:textView length:100]) {
            kAlter(@"建议检查项目不能超出100个字符");
        }
        self.checkHeight.constant = [self textViewHeight:textView]+30;
    }
    else if (textView.tag == 314){
        self.advicePlacor.hidden = [self textViewLength:textView];
        if ([self textViewTextOutStr:textView length:50]) {
            kAlter(@"诊断建议不能超出50个字符");
        }
        self.adviceHeight.constant = [self textViewHeight:textView]+30;
    }
    [self refreshLayout];
}

- (void)textViewDidEndEditing:(UITextView *)textView{

    if (textView.tag == 311) {
        self.resultPlacor.hidden = [self textViewLength:textView];
    }
    else if (textView.tag == 312){
        self.drugPlacor.hidden = [self textViewLength:textView];
    }
    else if (textView.tag == 313){
        self.checkPlacor.hidden = [self textViewLength:textView];
    }
    else if (textView.tag == 314){
        self.advicePlacor.hidden = [self textViewLength:textView];
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

-(CGFloat)textViewHeight:(UITextView *)textView{

    CGRect bounds = textView.bounds;
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [textView sizeThatFits:maxSize];
    return newSize.height+5;
}

#pragma mark---------更新约束

-(void)refreshLayout{
    [self.view layoutIfNeeded];
    
    CGFloat height = self.despHeight.constant+self.picHeight.constant+self.reslutHeight.constant+self.drugHeight.constant+self.checkHeight.constant+self.adviceHeight.constant+self.btnSummitHeight.constant+8*8;
    if (height<kHeight-64) {
        height = kHeight-64+1;
    }
    
    self.scrollAdvice.contentSize = CGSizeMake(kWith, height);
}
#pragma mark--------回跳
-(void)onLeftBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark---------------设置右按钮项
-(void)OnRight{
    if (isShowSubmitBtn == YES) {
        isShowSubmitBtn = NO;
    }else
    {
        isShowSubmitBtn = YES;
    }
    _publish.rightBtn.hidden = YES;
    [self btnShow:isShowSubmitBtn];
}

-(void)btnShow:(BOOL)isShow{

    self.btnSubmit.hidden =! isShow;
    self.drugBtn.hidden =! isShow;
    self.checkBtn.hidden =! isShow;
    self.adviceBtn.hidden =! isShow;
    self.resultBtn.hidden =! isShow;
    self.reslutTextView.editable = isShow;
    self.drugTextView.editable = isShow;
    self.checkTextView.editable = isShow;
    self.adviceTextView.editable = isShow;
}

#pragma mark---------------提交
- (IBAction)btnSubmit:(id)sender {
    [self.view endEditing:YES];
    if (self.reslutTextView.text == nil ||[self.reslutTextView.text isEqualToString:@""]) {
        kAlter(@"初步预诊为空");
    }
    else if (self.adviceTextView.text == nil ||[self.adviceTextView.text isEqualToString:@""]){
        kAlter(@"诊断建议为空");
    }
    else
    {
        NSString *mess;
        if ([self.from isEqualToString:@"BeenAA"] || [self.from isEqualToString:@"BeenDia"] || [self.from isEqualToString:@"BennOver"]) {
            mess = @"确认提交本次诊断建议,提交成功后将无法修改？";
        }else
        {
            mess = @"提交成功后，待患者确认咨询结束后将无法进行修改，确认提交吗？";
        }
        
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:mess preferredStyle:UIAlertControllerStyleAlert];
        [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            
            [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/DiagnosisAdviceAdd",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:[self setParamangent] viewConroller:self success:^(id responseObject, BOOL ifTimeout) {

                UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已提交成功！！" preferredStyle:UIAlertControllerStyleAlert];
                [alter addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }]];
                [self presentViewController:alter animated:YES completion:nil];
            } failure:^(NSError *error) {

            }];
        }]];
        [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alter animated:YES completion:nil];
    }
}

-(NSMutableDictionary *)setParamangent{
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc]init];
    [dicData setObject:self.patient.Id forKey:@"orderId"];
    [dicData setObject:self.patient.doctorId forKey:@"doctorId"];
    [dicData setObject:self.patient.patientId forKey:@"patientId"];
    [dicData setObject:self.reslutTextView.text forKey:@"result"];
    [dicData setObject:self.drugTextView.text forKey:@"drugList"];
    [dicData setObject:self.checkTextView.text forKey:@"checkList"];
    [dicData setObject:self.adviceTextView.text forKey:@"advice"];
    return dicData;
}

//富文本
-(NSMutableAttributedString *)setText:(NSString *)text{
    
    NSArray *arry = [text componentsSeparatedByString:@"    "];
    NSString *strUnit = arry[1];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:text];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:[text rangeOfString:strUnit]];
    return medStr;
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
