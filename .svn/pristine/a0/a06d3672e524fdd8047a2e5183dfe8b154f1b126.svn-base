//
//  BaseViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/7/4.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (_noData == nil) {
    _noData               = [[UILabel alloc]init];
    }
    self.noData.hidden    = YES;
    _noData.frame         = CGRectMake(0, (self.view.bounds.size.height-60)/3, kWith, 60);
    _noData.font          = [UIFont systemFontOfSize:20];
    _noData.textColor     = [[UIColor grayColor]   colorWithAlphaComponent:0.7];
    _noData.text          = @"无记录";
    _noData.textAlignment = 1;
    [self.view addSubview:_noData];
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
