//
//  CollecDocAddViewController.h
//  HuaxiaDotor
//
//  Created by ydz on 16/6/20.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollecDocAddViewController : UIViewController

@property(nonatomic,strong)UICollectionView *collection;
@property(nonatomic,strong)NSMutableArray *arryData;

-(void)refreshNSArray:(NSMutableArray *)arry;

@end
