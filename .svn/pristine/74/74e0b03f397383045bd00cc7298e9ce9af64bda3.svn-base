//
//  GuideViewController.m
//  HuaxiaDotor
//
//  Created by ydz on 16/7/4.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "GuideViewController.h"
#import "HomeViewController.h"

@interface GuideViewController ()<UIScrollViewDelegate>

{
    UIScrollView *_scroll;
}

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    float width = [UIScreen mainScreen].bounds.size.width;
    float height  = [UIScreen mainScreen].bounds.size.height;
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    _scroll.delegate = self;
    [self.view addSubview:_scroll];
    _scroll.pagingEnabled = YES;
    _scroll.contentSize = CGSizeMake(width*3, height);

    for (NSInteger i = 0; i<3; i++) {
    
        UIImageView *image = [[UIImageView alloc]init];
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.frame = CGRectMake(width*i, 0, width, height);
        if (width == 320&&height == 480) {
            image.image = [UIImage imageNamed:[NSString stringWithFormat:@"医生4 %ld",i+1]];
        }else if(width == 375&&height == 667){
            image.image = [UIImage imageNamed:[NSString stringWithFormat:@"医生6 %ld",i+1]];
        }else if(width == 320&&height == 568){
            image.image = [UIImage imageNamed:[NSString stringWithFormat:@"医生5 %ld",i+1]];
        }else
        {
            image.image = [UIImage imageNamed:[NSString stringWithFormat:@"医生 6s %ld",i+1]];
        }
        image.userInteractionEnabled = YES;
        [_scroll addSubview:image];
        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame = CGRectMake(20, height-60, width-40, 40);
//        [btn setTitle:@"进入" forState:UIControlStateNormal];
//        btn.backgroundColor = BLUECOLOR_STYLE;
//        [btn addTarget:self action:@selector(onBtnGoHome) forControlEvents:UIControlEventTouchUpInside];
//        if (i == 2) {
//            btn.hidden = NO;
//        }else
//        {
//            btn.hidden = YES;
//        }
//        [image addSubview:btn];
    }
}

-(void)onBtnGoHome{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    self.view.window.backgroundColor = [UIColor whiteColor];
    float width = [UIScreen mainScreen].bounds.size.width;
    float heigh = [UIScreen mainScreen].bounds.size.height;
    if (scrollView.contentOffset.x > width*2) {
        
        UIStoryboard *HomeView=[UIStoryboard storyboardWithName:@"HomeView" bundle:[NSBundle mainBundle]];
        HomeViewController *HomeViewController=[HomeView instantiateViewControllerWithIdentifier:@"HomeView"];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:HomeViewController];
        [nav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        nav.navigationBar.tintColor = [UIColor whiteColor];
        [[UIBarButtonItem appearance]
         setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
        
        
        CABasicAnimation *anima=[CABasicAnimation animation];
        anima.keyPath=@"position";
        anima.fromValue=[NSValue valueWithCGPoint:CGPointMake(width+width/2, heigh/2)];
        anima.toValue=[NSValue valueWithCGPoint:CGPointMake(width/2, heigh/2)];
        anima.removedOnCompletion=NO;
        anima.fillMode=kCAFillModeForwards;
        anima.duration = 0.2;
        [nav.view.layer addAnimation:anima forKey:nil];
        self.view.window.rootViewController = nav;
        
//        [UIView animateWithDuration:1 animations:^{
//            
//        } completion:^(BOOL finished) {
//            
//            [UIView transitionWithView:self.view.window duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:nil completion:nil];
//            self.view.window.rootViewController = nav;
//
//        }];
        
//        CATransition *transition = [CATransition animation];
//        transition.duration = 1;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//        transition.type = kCATransitionFade;
//        [nav.view.layer addAnimation:transition forKey:nil];
    }
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
