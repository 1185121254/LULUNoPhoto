//
//  ImageBrowseViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/4/8.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ImageBrowseViewController.h"
#define PIC_COUNT self.PicArr.count
#define SCROLLVIEW_W self.scView.frame.size.width
@interface ImageBrowseViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *PicArr;
@property (strong, nonatomic) UIScrollView *scView;
@property (strong, nonatomic) UIImageView *PicView;
@end

@implementation ImageBrowseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
//    NSLog(@"%d",self.PicArr.count);
    //滚动试图
    [self createScrollerView];
    //图片试图
    [self createPicView];
    //导航栏标题位置
    self.title=[NSString stringWithFormat:@"%d/%d",[self calculateScrollPage]+1,(int)PIC_COUNT];
}

#pragma mark - 创建滚动试图
-(void)createScrollerView
{
    self.scView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.scView.delegate=self;
    self.scView.contentSize =CGSizeMake(PIC_COUNT*SCREEN_W, SCREEN_H-64);
    self.scView.bounces=NO;
    self.scView.pagingEnabled=YES;
    self.scView.userInteractionEnabled=YES;
//    self.scView.backgroundColor=[UIColor brownColor];
    [self.view addSubview:self.scView];
}

/**
 *  计算滚动试图在当前页面的第几页
 *
 *  @param int 当前的页面
 */
-(int)calculateScrollPage
{
    int page=floor((self.scView.contentOffset.x - SCREEN_W/2)/SCREEN_W)+1;
    return page;
}


#pragma mark - 创建图片浏览器
-(void)createPicView
{
    self.PicView=[[UIImageView alloc]initWithFrame:CGRectMake(0, SCROLLVIEW_W/PIC_COUNT, SCREEN_W, SCREEN_H)];
    
    for (int i=0; i<self.PicArr.count; i++)
    {
        UIImageView *imageview=[[UIImageView alloc]init];
       imageview=[self setImageURL:self.PicArr[i]];
        imageview.frame=CGRectMake(SCREEN_W*i, 0, SCREEN_W, SCREEN_H/2);
        [self.scView addSubview:imageview];
    }
}

/**
 *  传入图片地址返回图片
 *
 *  @param url 图片地址
 *
 *  @return 图片对象
 */
-(UIImageView *)setImageURL:(NSString *)url
{
    UIImageView *imageViewPic=[[UIImageView alloc]init];
    url=[NSString stringWithFormat:@"%@%@",NET_URLSTRING,url];
    NSString *strUrl=[url stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
//    [imageViewPic sd_setImageWithURL:[NSURL URLWithString:strUrl]];
    [imageViewPic sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"NULL"]];
//    NSLog(@"%@",imageViewPic);
    return imageViewPic;
}

#pragma mark - 代理传值方法
-(void)sendImageViewArr:(NSMutableArray *)picArr
{
    self.PicArr=picArr;
}

//移动结束时调用这个方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.title=[NSString stringWithFormat:@"%d/%d",[self calculateScrollPage]+1,PIC_COUNT];
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
