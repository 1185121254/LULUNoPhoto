//
//  PublishPhotoViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 17/3/13.
//  Copyright © 2017年 kock. All rights reserved.
//

#import "PublishPhotoViewController.h"
#import "SelectCityViewController.h"
#import "AddPtotoCollectionViewCell.h"
#import "TZImagePickerController.h"
#import "PhotoPreviewViewController.h"
#import "ShowPic.h"
#import "ShowPicCollectionViewCell.h"

@interface PublishPhotoViewController ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,UITextViewDelegate>
{
    NSString *province;
    NSString *city;
    
    NSMutableArray *arryImage;
    NSMutableArray *arryPhotoLoac;
    NSMutableArray *arrySets;
    NSDictionary *dicCity;
    ShowPic *_picList;
}

@property (weak, nonatomic) IBOutlet UIView *picView;
@property (strong, nonatomic) IBOutlet UITableViewCell *tablePhotoCell;
@property (weak, nonatomic) IBOutlet UICollectionView *addPhotoCollect;

@property (strong, nonatomic) IBOutlet UITableViewCell *textAddCell;
@property (weak, nonatomic) IBOutlet UITextView *textPhoto;
@property (weak, nonatomic) IBOutlet UILabel *placloader;

@property (strong, nonatomic) IBOutlet UIView *tableFoot;
@property (strong, nonatomic) IBOutlet UIView *tableHead;
@property (weak, nonatomic) IBOutlet UITableView *tableViewPhoto;
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UILabel *areaText;

@property (nonatomic, strong) NSMutableArray *selectedPhotoArray;

@end

@implementation PublishPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNav];
    [self setImage];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChangeCity:) name:@"ChangCityPhotoPublish" object:nil];

    //添加图片
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNotifyCAsePicAddDoc:) name:@"addPic" object:nil];
    //删除图片
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onDeletePic:) name:@"picDelete" object:nil];
}

-(void)setNav{
    arryImage = [NSMutableArray array];
    self.title = @"摄影大赛";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;

    self.tableViewPhoto.rowHeight = UITableViewAutomaticDimension;
    self.tableViewPhoto.estimatedRowHeight = 500;
    self.tableViewPhoto.tableHeaderView = self.tableHead;
    self.tableViewPhoto.tableFooterView = self.tableFoot;
    
    [self setDefaultData];
}

-(void)setDefaultData{

    if (_dicData != nil) {
        if (_dicData[@"id"]) {
            
            province = _dicData[@"area"];
            city = _dicData[@"city"];
            _areaText.text = _dicData[@"city"];
            _titleText.text = _dicData[@"title"];
            if (_dicData[@"description"] == nil) {
                _placloader.hidden = NO;
            }else{
                _textPhoto.text = _dicData[@"description"];
                _placloader.hidden = YES;
            }
            arryImage = [NSMutableArray arrayWithArray:_dicData[@"picList"]];
            [self updatePicList:arryImage];
        }
    }
}

#pragma mark-----TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 150;
    }else{
        return 78;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.row ==1) {
        cell = self.tablePhotoCell;
    }else{
        cell = self.textAddCell;
    }
    return cell;
}

#pragma mark-----TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.placloader.hidden = YES;

}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length>0) {
        self.placloader.hidden = YES;
    }else
    {
        self.placloader.hidden = NO;
    }
}

#pragma mark-----发布按钮
- (IBAction)publishBtn:(id)sender {
    [self.view endEditing:YES];

    [self upLoadingPhoti];
    
}
#pragma mark-----选择城市
- (IBAction)selectedCity:(id)sender {
    SelectCityViewController *sel = [[SelectCityViewController alloc]init];
    sel.from = @"Publish";
    [self.navigationController pushViewController:sel animated:YES];
}

-(void)onChangeCity:(NSNotification *)notify{
    
    dicCity = notify.object;
    if (dicCity) {
        _areaText.text = dicCity[@"city"];
    }
}

#pragma mark----------------  创建图片
-(void)setImage{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 2;
    layout.itemSize = CGSizeMake(60, 60);
    
    _picList = [[ShowPic alloc]initWithFrame:CGRectMake(0, 0, _picView.frame.size.width ,_picView.frame.size.height) collectionViewLayout:layout];
    _picList.arryData = arryImage;
    _picList.from = @"pic";
    [_picView addSubview:_picList];
}
#pragma mark----------------  更新图片
-(void)updatePicList:(NSMutableArray *)arry{

    NSMutableArray *arryDic = [NSMutableArray array];
    for (NSInteger i = 0; i<arry.count; i++) {
        if ([arry[i] isKindOfClass:[NSDictionary class]]) {
            [arryDic addObject:arry[i]];
        }
    }
    [arry removeAllObjects];
    [arry addObjectsFromArray:arryDic];
    [arry addObjectsFromArray:arryPhotoLoac];
    [_picList refreshCollection:arry];

}

#pragma mark --------选择图片
-(void)onNotifyCAsePicAddDoc:(NSNotification *)notify
{
    [self.view endEditing:YES];
    if (arryImage.count == 3) {
        kAlter(@"不能超过三张图片");
        return;
    }
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3-[self contentDicOrImage] delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.selectedAssets = arrySets;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto)
     {
         arryPhotoLoac = [NSMutableArray arrayWithArray:photos];
         arrySets = [NSMutableArray arrayWithArray:assets];
         [self updatePicList:arryImage];

     }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark--------------------删除图片
-(void)onDeletePic:(NSNotification *)notify{
    ShowPicCollectionViewCell *cell = notify.object;
    NSIndexPath *index = [_picList indexPathForCell:cell];

    if ([arryImage[index.item] isKindOfClass:[UIImage class]]) {
        NSInteger ind = [arryPhotoLoac indexOfObject:arryImage[index.item]];
        [arryPhotoLoac removeObject:arryImage[index.item]];
        [arrySets removeObjectAtIndex:ind];
    }
    [arryImage removeObjectAtIndex:index.item];

    [self updatePicList:arryImage];
}

#pragma mark-----上传照片

-(void)upLoadingPhoti{

    
    if (arryImage.count == 0) {
        kAlter(@"未选择上传的图片");
    }else if ([_titleText.text isEqualToString:@""] || _titleText.text == nil){
        kAlter(@"标题不能为空");
    }else if ([_areaText.text isEqualToString:@""] || _areaText.text == nil){
        kAlter(@"所选区域不能为空");
    }else{
        [self startUpLoad];
    }
}

-(void)startUpLoad{
    
    if (dicCity[@"city"] == nil || dicCity[@"province"]==nil) {
        province = @"";
        city = @"";
    }else{
        province = dicCity[@"province"];
        city = dicCity[@"city"];
    }
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:@{@"doctorId":[kUserDefatuel objectForKey:@"id"],@"area":province,@"city":city,@"description":_textPhoto.text,@"title":_titleText.text}];
    
    NSMutableArray *arryImageWithdic = [NSMutableArray array];
    NSMutableArray *arryData  =[NSMutableArray array];
    for (NSInteger i = 0; i< arryImage.count; i++) {
        if ([arryImage[i] isKindOfClass:[UIImage class]]) {
            UIImage *image = arryImage[i];
            NSData *data = UIImageJPEGRepresentation(image, 1);
            [arryData addObject:data];
        }else{
            [arryImageWithdic addObject:arryImage[i]];
        }
    }
    if (arryData.count == 0) {
        [para setObject:arryImageWithdic forKey:@"PicList"];
        if (_dicData[@"id"] == nil) {
            [self pubilishPhoto:para];
        }else{
            [self editing:para];
        }
        return;
    }
    [RequestManager CasePicWithURLString:[NSString stringWithFormat:@"%@/api/Circle/PictureUpload",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE Parameters:arryData  viewConroller:self Complation:^(NSDictionary *dicCom) {
        if ([[dicCom objectForKey:@"code"] integerValue]==10000) {
            for (NSDictionary *dicaa in (NSArray *)dicCom[@"value"]) {
                [arryImageWithdic addObject:dicaa];
            }
            [para setObject:arryImageWithdic forKey:@"PicList"];
            if (_dicData[@"id"] == nil) {
                [self pubilishPhoto:para];
            }else{
                [self editing:para];
            }
        }
        else
        {
            kAlter(@"上传图片失败");
        }
    } Fail:^(NSError *error) {
        kAlter(@"上传图片失败");
    }];
}

-(void)pubilishPhoto:(NSMutableDictionary *)para{
    [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Circle/PhotographAdd",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:para viewConroller:self success:^(id responseObject, BOOL ifTimeout) {
        
        [self alterView];
        
    } failure:^(NSError *error) {
        NSLog(@"+++%@",error);
    }];
}

-(void)editing:(NSMutableDictionary *)para{
//
    [para setObject:_dicData[@"id"] forKey:@"id"];
    [RequestManager postWithURLStringALL:[NSString stringWithFormat:@"%@/api/Circle/PhotographUpdate",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:para viewConroller:self success:^(id responseObject, BOOL ifTimeout) {
        
        [self alterView];
        
    } failure:^(NSError *error) {
        NSLog(@"+++%@",error);
    }];
}

-(void)alterView{

    UIAlertController *ater = [UIAlertController alertControllerWithTitle:@"提示" message:@"发布成功！" preferredStyle:UIAlertControllerStyleAlert];
    [ater addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [self.navigationController popToRootViewControllerAnimated:YES];
    }]];
    [self presentViewController:ater animated:YES completion:nil];
    
}

-(void)showPic:(NSMutableArray *)arry NSIndex:(NSIndexPath *)index{
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0 ; i < arry.count; i++) {
        //传递数据给浏览器
        MJPhoto *photo = [[MJPhoto alloc] init];
        if ([arry[i] isKindOfClass:[UIImage class]]) {
            UIImage *image = arry[i];
            photo.image = image;
        }else{
            NSDictionary *dic = arry[i];
            NSString *url = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,dic[@"picUrl"]];
            NSString *newUrl = [url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            photo.url = [NSURL URLWithString:newUrl];
        }
        [photos addObject:photo];
    }
    brower.currentPhotoIndex = index.item;
    brower.photos = photos;
    [brower show];
}

-(NSInteger)contentDicOrImage{
    NSMutableArray *arrayDic = [NSMutableArray array];
    for (NSInteger i = 0; i < arryImage.count ; i++) {
        if (![arryImage[i] isKindOfClass:[UIImage class]]) {
            [arrayDic addObject:arryImage[i]];
        }
    }
    return arrayDic.count;
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
