//
//  CollectionPicViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/10.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "CollectionPicViewController.h"
#import "CollectionPicViewCell.h"

@interface CollectionPicViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_collection;
}
@end

@implementation CollectionPicViewController

-(void)loadView{
    
    UIView *view = [[UIView alloc]init];
    NSInteger count = kWith/kItemWidth;
    NSInteger reste = (NSInteger)kWith % kItemWidth;
    float gap = reste/(count + 1);
    
    if (_arryCollData.count == 0) {
        view.frame = CGRectMake(0, 0, 0, 0);
    }else
    {
        if (_arryCollData.count % count == 0) {
            view.frame = CGRectMake(0, 0, kWith, (kItemWidth+gap)*(_arryCollData.count/count)+gap*4);
        }else
        {
            view.frame = CGRectMake(0, 0, kWith, (kItemWidth+gap)*(_arryCollData.count/count) + kItemWidth+gap*4);
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
    _collection.dataSource = self;
    _collection.delegate = self;
    [self.view addSubview:_collection];

    [_collection registerClass:[CollectionPicViewCell class] forCellWithReuseIdentifier:@"collectionPicGen"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arryCollData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    CollectionPicViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionPicGen" forIndexPath:indexPath];

    NSDictionary *dic = _arryCollData[indexPath.item];
    NSString *yrl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,[dic objectForKey:@"microPicUrl"]];
    NSString *url = [yrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [cell.imageViewCllec sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"ic_login_account"]];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    //2.告诉图片浏览器显示所有的图片
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0 ; i < self.arryCollData.count; i++) {
        NSDictionary *dic = self.arryCollData[i];
        //传递数据给浏览器
        MJPhoto *photo = [[MJPhoto alloc] init];
        NSString *yrl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,[dic objectForKey:@"picUrl"]];
        NSString *url = [yrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        photo.url = [NSURL URLWithString:url];
        [photos addObject:photo];
    }
    brower.currentPhotoIndex = indexPath.item;
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
