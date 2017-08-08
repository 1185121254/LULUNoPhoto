//
//  ShowPic.m
//  HuaxiaDotor
//
//  Created by ydz on 16/8/9.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ShowPic.h"
#import "ShowPicCollectionViewCell.h"

@implementation ShowPic

-(id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{

    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.collectionViewLayout = layout;
        self.dataSource = self;
        self.delegate = self;
        self.frame = frame;
        
        [self registerNib:[UINib nibWithNibName:@"ShowPicCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"showPic"];
    }
    return self;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _arryData.count+1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ShowPicCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"showPic" forIndexPath:indexPath];
    if (indexPath.item < _arryData.count) {
        if ([self isFromDoc]) {
            cell.btnDelete.hidden = YES;
            NSDictionary *dic = _arryData[indexPath.item];
            NSString *yrl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,[dic objectForKey:@"picFileName"]];
            NSString *url = [yrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"默认婷婷"]];
        }else
        {
            cell.btnDelete.hidden = NO;
            if ([_arryData[indexPath.item] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = _arryData[indexPath.item];
                NSString *picUrl = [dic objectForKey:@"microPicUrl"];
                NSString *newUrl = [picUrl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
                [cell.picImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",NET_URLSTRING,newUrl]] placeholderImage:[UIImage imageNamed:@"感叹号"]];
            }
            else if([_arryData[indexPath.item] isKindOfClass:[UIImage class]])
            {
                cell.picImageView.image = _arryData[indexPath.item];
            }
        }

    }else
    {
        cell.btnDelete.hidden = YES;
        if ([self isFromDoc]) {
            cell.picImageView.image = [UIImage imageNamed:@"l+"];
        }else
        {
            cell.picImageView.image = [UIImage imageNamed:@"添加照片"];
        }

    }
    if ([self isFromDoc]) {
        cell.picImageView.layer.cornerRadius = 60/2;
        cell.picImageView.layer.masksToBounds = YES;
    }else
    {
        cell.picImageView.layer.cornerRadius = 0;
        cell.picImageView.layer.masksToBounds = NO;
    }
    return cell;
}

-(void)refreshCollection:(NSMutableArray *)arry{
    _arryData = arry;
    [self reloadData];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.item == _arryData.count) {
        
        if ([self isFromDoc]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"addDoc" object:self];
        }else
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"addPic" object:@(indexPath.item)];
        }
    }
    else
    {
        if ([self isFromDoc]) {
        }else
        {

            MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
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
            brower.currentPhotoIndex = indexPath.item;
            brower.photos = photos;
            [brower show];

        }
    }
}

-(BOOL)isFromDoc{
    if ([self.from isEqualToString:@"doc"]) {
        return YES;
    }
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
