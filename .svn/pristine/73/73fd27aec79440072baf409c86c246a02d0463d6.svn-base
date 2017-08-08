//
//  PublishNewCaseViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/8/12.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "PublishNewCaseViewController.h"
#import "TZImagePickerController.h"
#import "ShowPicCollectionViewCell.h"
#import "ShowPic.h"

@interface PublishNewCaseViewController ()<TZImagePickerControllerDelegate>

{
    //图片数组
    NSMutableArray *_arryImage;
    NSMutableArray *_arryPhonoes;
    //图片列表
    ShowPic *_picList;

    
}

@end

@implementation PublishNewCaseViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.publishPatientCase.backgroundColor = kBackgroundColor;
    self.btnPublish.backgroundColor = BLUECOLOR_STYLE;
    
    if ([self.from isEqualToString:@"1"]) {
        self.titlePlacor.text = @"请输入病例标题";
    }else
    {
        self.titlePlacor.text = @"请输入话题标题";
    }
    
    //图片列表
    _arryImage = [NSMutableArray array];
    [self setImage];
    
    //添加图片
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNotifyCAsePicAddDoc:) name:@"addPic" object:nil];
    //删除图片
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onDeletePic:) name:@"picDelete" object:nil];
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
    if (_arryImage.count>=9) {
        kAlter(@"不能超过九张图片");
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.selectedAssets = _arryPhonoes;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto)
     {
         _arryPhonoes = [NSMutableArray arrayWithArray:assets];
         _arryImage = [NSMutableArray arrayWithArray:photos];
         [self updatePicList:_arryImage];
     }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark--------------------删除图片
-(void)onDeletePic:(NSNotification *)notify{
    ShowPicCollectionViewCell *cell = notify.object;
    NSIndexPath *index = [_picList indexPathForCell:cell];
    [_arryImage removeObjectAtIndex:index.item];
    [_arryPhonoes removeObjectAtIndex:index.item];
    [self updatePicList:_arryImage];
}

#pragma mark--------------------提交
- (IBAction)btnPublish:(id)sender {
    [self.view endEditing:YES];
    if ([self isNull]) {
        return;
    }
    
    NSMutableDictionary *dicData = [self setParament];
    
    if (_arryImage != nil && _arryImage.count>0) {
        NSMutableArray *arryData  =[NSMutableArray array];
        for (UIImage *image in _arryImage) {
            NSData *data = UIImageJPEGRepresentation(image, 1);
            [arryData addObject:data];
        }
        NSDictionary *header = @{@"verifyCode":[kUserDefatuel objectForKey:@"verifyCode"]};

        
        [RequestManager CasePicWithURLString:[NSString stringWithFormat:@"%@/api/Share/PictureUpload",NET_URLSTRING] heads:header Parameters:arryData  viewConroller:self Complation:^(NSDictionary *dicCom) {
            if ([[dicCom objectForKey:@"code"] integerValue]==10000) {
                [dicData setObject:[dicCom objectForKey:@"value"] forKey:@"picList"];
                [self postRequest:dicData];
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
        [dicData setObject:_arryImage forKey:@"picList"];
        [self postRequest:dicData];
    }
}

-(void)postRequest:(NSDictionary *)parameters{

    [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Circle/TopicRelease",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:parameters viewConroller:self success:^(id responseObject, BOOL ifTimeout) {

        [self popAlter];
    } failure:^(NSError *error) {

    }];
}

-(void)popAlter{
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"提示" message:@"发表成功" preferredStyle:UIAlertControllerStyleAlert];
    [alter addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [self presentViewController:alter animated:YES completion:nil];
}

-(BOOL)isNull{
    if (self.titleTextView.text == nil||[self.titleTextView.text isEqualToString:@""]) {
        kAlter(@"发表标题为空");
        return YES;
    }
    else if (self.connectTextView.text == nil||[self.connectTextView.text isEqualToString:@""]){
        kAlter(@"发表内容为空");
        return YES;
    }else
    {
        return NO;
    }
}

-(NSMutableDictionary *)setParament{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.titleTextView.text forKey:@"title"];
    [dic setObject:self.connectTextView.text forKey:@"detail"];
    [dic setObject:self.from forKey:@"type"];

    return dic;
}


#pragma mark--------------------TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.tag == 490) {
        self.titlePlacor.hidden = [self textViewLength:textView];
        if ([self textViewTextOutStr:textView length:25]) {
            kAlter(@"疾病诊断不能超出25个字符");
        }
        self.titleHeight.constant = [self textViewheight:textView];
    }
    else if(textView.tag == 491){
        self.connectPlacor.hidden = [self textViewLength:textView];
        if ([self textViewTextOutStr:textView length:100]) {
            kAlter(@"疾病诊断不能超出100个字符");
        }
        if ([self textViewheight:textView] < 80 ) {
            self.connectHeight.constant = 80;
        }else
        {
            self.connectHeight.constant = [self textViewheight:textView];
        }
    }
    [self refreshLayout];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (textView.tag == 490) {
        self.titlePlacor.hidden = YES;
    }
    else if (textView.tag == 491){
        self.connectPlacor.hidden = YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView.tag == 911) {
        self.titlePlacor.hidden = [self textViewLength:textView];
    }
    else if (textView.tag == 912){
        self.connectPlacor.hidden = [self textViewLength:textView];
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
    
    CGFloat height = self.titleHeight.constant+self.connectHeight.constant+self.picHeight.constant+self.btnPublishHeight.constant+1;
    
    if (height <= kHeight-64) {
        height = kHeight-64+1;
    }
    self.publishPatientCase.contentSize = CGSizeMake(kWith, height);

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
