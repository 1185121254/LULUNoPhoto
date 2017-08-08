//
//  ShowPick.m
//  HuaxiaDotor
//
//  Created by ydz on 16/9/2.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ShowPick.h"
#import "ShowPickCollectionViewCell.h"

@implementation ShowPick

-(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.collectionViewLayout = layout;
        self.dataSource = self;
        self.delegate = self;
        self.frame = frame;
        
        [self registerNib:[UINib nibWithNibName:@"ShowPickCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"showPick"];
    }
    return self;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arryData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ShowPickCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"showPick" forIndexPath:indexPath];
    NSDictionary *dic = _arryData[indexPath.item];
    NSString *yrl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,[dic objectForKey:@"microPicUrl"]];
    NSString *url = [yrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [cell.imagePic sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"感叹号"]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0 ; i < _arryData.count; i++) {
        //传递数据给浏览器
        MJPhoto *photo = [[MJPhoto alloc] init];
        
        NSDictionary *dic = _arryData[i];
        NSString *picUrl = [dic objectForKey:@"picUrl"];
        NSString *newUrl = [picUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NET_URLSTRING,newUrl]];
        [photos addObject:photo];
    }
    brower.currentPhotoIndex = indexPath.item;
    brower.photos = photos;
    [brower show];
    
}


//NSInteger count = kWith/kItemWidth;
//NSInteger reste = (NSInteger)kWith % kItemWidth;
//float gap = reste/(count + 1);
//
//CGFloat height;
//if ((_imageArray.count) % count == 0) {
//    height = (kItemWidth+gap)*((_imageArray.count)/count)+4*gap;
//}else
//{
//    height = (kItemWidth+gap)*((_imageArray.count)/count) + kItemWidth+gap*4;
//}
//
//UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//layout.sectionInset = UIEdgeInsetsMake(gap, gap, gap, gap);
//layout.minimumLineSpacing = gap;
//layout.minimumInteritemSpacing = gap;
//layout.itemSize = CGSizeMake(kItemWidth, kItemWidth);
//
//ShowPick *picK = [[ShowPick alloc]initWithFrame:CGRectMake(0, 0, superView.frame.size.width, height) collectionViewLayout:layout];
//picK.arryData = _imageArray;
//[superView addSubview:picK];

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
