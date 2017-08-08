//
//  CollecDocAddViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/20.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "CollecDocAddViewController.h"
#import "DocAddCollectionViewCell.h"
#import "LocalPhotoViewController.h"
#import "AddDocAssisViewController.h"

@interface CollecDocAddViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation CollecDocAddViewController

-(void)loadView{

    UIView *view = [[UIView alloc]init];
    NSInteger count = kWith/kItemWidth;
    NSInteger reste = (NSInteger)kWith % kItemWidth;
    float gap = reste/(count + 1);
    
    if (self.arryData == nil) {
        _arryData = [NSMutableArray array];
    }
    if (_arryData.count == 0) {
        view.frame = CGRectMake(0, 0, kWith, kItemWidth+gap*4);
    }else
    {
        if ((_arryData.count+1) % count == 0) {
            view.frame = CGRectMake(0, 0, kWith, (kItemWidth+gap)*((_arryData.count+1)/count)+gap*4);
        }else
        {
            view.frame = CGRectMake(0, 0, kWith, (kItemWidth+gap)*((_arryData.count+1)/count) + kItemWidth+gap*4);
        }
    }
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger count = kWith/kItemWidth;
    NSInteger reste = (NSInteger)kWith % kItemWidth;
    float gap = reste/(count + 1);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(gap, gap, gap, gap);
    layout.minimumLineSpacing = gap;
    layout.minimumInteritemSpacing = gap;
    layout.itemSize = CGSizeMake(kItemWidth, kItemWidth);
    
    _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, gap, kWith, self.view.frame.size.height-gap*2) collectionViewLayout:layout];
    _collection.backgroundColor = [UIColor whiteColor];
    _collection.delegate = self;
    _collection.dataSource = self;
    [self.view addSubview:_collection];
    
    [_collection registerClass:[DocAddCollectionViewCell class] forCellWithReuseIdentifier:@"addDocCollectionL"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arryData.count+2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    DocAddCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addDocCollectionL" forIndexPath:indexPath];
    if (_arryData.count == 0) {
        if (indexPath.item == 0) {
            cell.hidden = NO;
            cell.lblName.hidden = YES;
            cell.imageViewDoc.hidden = NO;
            cell.imageViewDoc.image = [UIImage imageNamed:@"添加照片"];
            cell.btnDelete.hidden = YES;
        }else
        {
            cell.hidden = NO;
            cell.userInteractionEnabled = NO;
            cell.lblName.hidden = NO;
            cell.imageViewDoc.hidden = YES;
            cell.btnDelete.hidden = YES;
        }
    }else
    {
        cell.lblName.hidden = YES;
        if (indexPath.item == _arryData.count+1) {
            cell.hidden = YES;
            cell.btnDelete.hidden = YES;
        }else
        {
            if (indexPath.item == _arryData.count) {
                cell.imageViewDoc.image = [UIImage imageNamed:@"添加照片"];
                 cell.btnDelete.hidden = YES;
            }else
            {
            //照片
//                ALAsset *asset=_arryData[indexPath.item];
//                CGImageRef posterImageRef=[asset aspectRatioThumbnail];
//                UIImage *posterImage=[UIImage imageWithCGImage:posterImageRef];
//                cell.imageViewDoc.image = posterImage;
                cell.btnDelete.hidden = NO;
                if ([_arryData[indexPath.item] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dic = _arryData[indexPath.item];
                    NSString *picUrl = [dic objectForKey:@"microPicUrl"];
                    NSString *newUrl = [picUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
                    [cell.imageViewDoc sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NET_URLSTRING,newUrl]] placeholderImage:[UIImage imageNamed:@"感叹号"]];
                }
                else if([_arryData[indexPath.item] isKindOfClass:[UIImage class]])
                {
                    cell.imageViewDoc.image = _arryData[indexPath.item];
                }

            }
        }
    }
    return cell;
}

-(void)refreshNSArray:(NSMutableArray *)arry{
    _arryData = arry;
    [self.collection reloadData];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (_arryData.count == 0) {
        if (indexPath.item == 0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AddDocL" object:@(indexPath.item)];
        }else
        {
             [self onNotifyCAsePicListBig:indexPath];
        }
    }else
    {
        if (indexPath.item == _arryData.count) {
             [[NSNotificationCenter defaultCenter]postNotificationName:@"AddDocL" object:@(indexPath.item)];
        }else
        {
            [self onNotifyCAsePicListBig:indexPath];
        }
    }
    
}
-(void)onNotifyCAsePicListBig:(NSIndexPath *)index{
    
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    //2.告诉图片浏览器显示所有的图片
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0 ; i < _arryData.count; i++) {
        //传递数据给浏览器
        MJPhoto *photo = [[MJPhoto alloc] init];
        if ([_arryData[i] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = _arryData[i];
            NSString *picUrl = [dic objectForKey:@"picUrl"];
            NSString *newUrl = [picUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NET_URLSTRING,newUrl]];
            [photos addObject:photo];
            
        }
        else if([_arryData[i] isKindOfClass:[UIImage class]])
        {
            photo.image = _arryData[i];
            [photos addObject:photo];
        }
    }
    brower.currentPhotoIndex = index.item;
    brower.photos = photos;
    
    //3.设置默认显示的图片索引
    //    brower.currentPhotoIndex = recognizer.view.tag;
    //4.显示浏览器
    [brower show];
    
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
