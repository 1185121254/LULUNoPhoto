//
//  ShowPic.h
//  HuaxiaDotor
//
//  Created by ydz on 16/8/9.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPic : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)NSMutableArray *arryData;
@property(nonatomic,copy)NSString *from;


-(void)refreshCollection:(NSMutableArray *)arry;

@end
