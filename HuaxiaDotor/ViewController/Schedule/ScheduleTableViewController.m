
//
//  ScheduleTableViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/12.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ScheduleTableViewController.h"
#import "ScheduleTableCollectionViewCell.h"
#import "AddSchedTableViewController.h"

@interface ScheduleTableViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *_arrySectionheader;
    
    NSMutableDictionary *_sumDicData;
    
    NSInteger _selectedSecton;

}
@end

@implementation ScheduleTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    
    NSMutableDictionary *parea = [NSMutableDictionary dictionary];
    [parea setObject:[kUserDefatuel objectForKey:@"id"] forKey:@"doctorId"];
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/GetVasDutyRoster",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:parea viewConroller:self success:^(id responseObject) {

        [self setDataDefutal:(NSMutableArray *)responseObject];
    } failure:^(NSError *error) {

    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电话咨询";
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:248/255.0 blue:250/255.0 alpha:1];
    _arrySectionheader = [[NSArray alloc]initWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
    
    _sumDicData = [NSMutableDictionary dictionary];
    
    _lbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, kWith-20, 35)];
    NSDictionary *dicPrice = [kUserDefatuel objectForKey:@"VasSet1"];
    _lbl.text = [NSString stringWithFormat:@"单次价格：  %@    元",[dicPrice objectForKey:@"price"]];
    _lbl.backgroundColor = [UIColor whiteColor];
    _lbl.layer.cornerRadius = 5;
    _lbl.layer.masksToBounds = YES;
    _lbl.layer.borderWidth = 1;
    _lbl.layer.borderColor = [kBoradColor CGColor];
    _lbl.textAlignment = 1;
    [self.view addSubview:_lbl];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    float width = (kWith-20-3)/4;
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.itemSize = CGSizeMake(width, 30);
    layout.headerReferenceSize = CGSizeMake(kWith, 30);

    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 110, kWith-20, kHeight-110) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self.view addSubview:_collectionView];
    
    if ([self.from isEqualToString:@"dreged"]) {
        self.view.frame = CGRectMake(0, 254, kWith, kHeight-259);
        self.collectionView.frame = CGRectMake(10, 0, kWith-20, kHeight - 259);
        self.view.backgroundColor = kBackgroundColor;
        [self.lbl removeFromSuperview];
        
    }else{
        self.view.frame = CGRectMake(0, 0 , kWith, kHeight-260);
        
    }
    
    [_collectionView registerClass:[ScheduleTableCollectionViewCell class] forCellWithReuseIdentifier:@"collect"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
         withReuseIdentifier:@"HeaderView"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNoify:) name:@"Sched" object:nil];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        for (UIView *view in reusableView.subviews) {
            [view removeFromSuperview];
        }
        [reusableView addSubview:[self creatCollectionHeader:indexPath]];
    }
    return reusableView;
}

-(UIView *)creatCollectionHeader:(NSIndexPath *)index{
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kWith-20, 30)];
    lbl.layer.cornerRadius = 3;
    lbl.layer.masksToBounds = YES;
    lbl.layer.borderWidth = 1;
    lbl.layer.borderColor = [kBoradColor CGColor];
    lbl.font = [UIFont systemFontOfSize:15];
    lbl.textAlignment =  1;
    lbl.backgroundColor =[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    lbl.text = _arrySectionheader[index.section];
    return lbl;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 7;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSString *key = _arrySectionheader[section];
    NSArray *arry = _sumDicData[key];
    return arry.count+1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    ScheduleTableCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collect" forIndexPath:indexPath];

    UILabel *lbl = [cell viewWithTag:600];
    [lbl removeFromSuperview];
    UIButton *btn = [cell viewWithTag:601];
    btn.hidden = YES;
    
    NSString *key = _arrySectionheader[indexPath.section];
    NSArray *arry = _sumDicData[key];
    if (indexPath.item == arry.count) {
        cell.lblTime.text = @"";
        cell.btnAdd.hidden = NO;
    }
    else
    {
        NSDictionary *dic = arry[indexPath.item];
        cell.lblTime.text = dic[@"dutyTime"];
    }
    
    return cell;
}

-(void)onNoify:(NSNotification *)notify{
    
    ScheduleTableCollectionViewCell *cell = notify.object;
    
    NSIndexPath *index = [_collectionView indexPathForCell:cell];
    
    NSString *key = _arrySectionheader[index.section];
    NSArray *arry = _sumDicData[key];
    
    AddSchedTableViewController *addSched = [[AddSchedTableViewController alloc]init];
    addSched.week = [NSString stringWithFormat:@"%ld",index.section + 1];
    addSched.arryDataSourceAdd = [NSMutableArray arrayWithArray:arry];
    [self.navigationController pushViewController:addSched animated:YES];
}

#pragma mark----设置数据
-(void)setDataDefutal:(NSArray *)array{

    for (NSString *key in _arrySectionheader) {

        NSMutableArray *datArr = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            
            if ([[self getWeekChina:[dic[@"week"] integerValue]] isEqualToString:key]) {
                [datArr addObject:dic];
            }
            
        }
        [_sumDicData setObject:datArr forKey:key];
    }
    [_collectionView reloadData];

}

-(NSString *)getWeekChina:(NSInteger )week{
    
    NSString *weekDayStr;
    switch (week) {
        case 1:
            weekDayStr = @"周一";
            break;
        case 2:
            weekDayStr = @"周二";
            break;
        case 3:
            weekDayStr = @"周三";
            break;
        case 4:
            weekDayStr = @"周四";
            break;
        case 5:
            weekDayStr = @"周五";
            break;
        case 6:
            weekDayStr = @"周六";
            break;
        case 7:
            weekDayStr = @"周日";
            break;
        default:
            weekDayStr = @"";
            break;
    }
    return weekDayStr;
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
