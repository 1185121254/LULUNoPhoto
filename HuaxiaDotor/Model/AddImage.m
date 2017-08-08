//
//  AddImage.m
//  image
//
//  Created by kock on 16/4/19.
//  Copyright © 2016年 kock. All rights reserved.
//

#define imageH 70 // 图片高度
#define imageW 70 // 图片宽度
#define kMaxColumn  [UIScreen mainScreen].bounds.size.width/(imageW + 10) // 每行显示数量
#define MaxImageCount 9 // 最多显示图片个数
#define deleImageWH 70 // 删除按钮的宽高
#define kAdeleImage @"close.png" // 删除按钮图片
#define kAddImage @"ic_add_photo" // 添加按钮图片

#import <AssetsLibrary/AssetsLibrary.h>
#import "AddImage.h"
#import "LocalPhotoViewController.h"
#import "UUImageAvatarBrowser.h"

@interface AddImage()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,SelectPhotoDelegate>
{
     // 标识被编辑的按钮 -1 为添加新的按钮
        NSInteger editTag;
    //存储选择图片的数组
//    NSMutableArray *selectPhotos;
    //放图片的试图
    UIViewController *viewC;
    NSMutableArray *copyImages;
    NSInteger maxHeightColumn;
    
}
@end

@implementation AddImage    

- (id)initWithFrame:(CGRect)frame withViewController:(UIViewController *)viewController
{
    self = [self initWithFrame:frame];
    if (self)
    {
        UIButton *btn = [self createButtonWithImage:kAddImage andSeletor:@selector(addNew:)];
        [self addSubview:btn];
        viewC = viewController;
        viewController.view.frame = self.frame;
        self.delegate=viewController;
    }
    return self;
}

-(void)getSelectedPhoto:(NSMutableArray *)photos
{
    _selectPhotos=[NSMutableArray new];
    copyImages = photos;
//    NSLog(@"%@",_selectPhotos);
//    NSLog(@"供选择%lu张照片",(unsigned long)[photos count]);
    //代理传出图片
    [_delegate ViewSendImageArr:copyImages andMaxCount:kMaxColumn];
    
    NSArray *arr = self.subviews;
    for (NSInteger i=0; i<arr.count-1; i++)
    {
        UIButton *btn = arr[i];
        [btn removeFromSuperview];
    }
    for (int i=0; i<photos.count; i++)
    {
        ALAsset *asset=photos[i];
        CGImageRef posterImageRef=[asset defaultRepresentation].fullScreenImage;
        UIImage *posterImage=[UIImage imageWithCGImage:posterImageRef];
        UIImage *image = posterImage;
        if (editTag == -1)
        {
            // 创建一个新的控件
            UIButton *btn = [self createButtonWithImage:image andSeletor:@selector(viewImage:)];
            [self insertSubview:btn atIndex:self.subviews.count - 1];
            [self.selectPhotos addObject:image];
            if (self.subviews.count - 1 == MaxImageCount)
            {
                [[self.subviews lastObject] setHidden:NO];
            }
        }
        else
        {
            // 根据tag修改需要编辑的控件
            UIButton *btn = (UIButton *)[self viewWithTag:editTag];
            NSInteger index = [self.images indexOfObject:[btn imageForState:UIControlStateNormal]];
            [self.selectPhotos removeObjectAtIndex:index];
            [btn setImage:image forState:UIControlStateNormal];
            [self.images insertObject:image atIndex:index];
        }
    }
    NSInteger lineNum = (NSInteger)(photos.count /(int)(kMaxColumn))+1;
    maxHeightColumn = lineNum;
    CGRect frame = self.frame;
    frame.size.height = 85 * lineNum;
    self.frame = frame;
}

-(NSMutableArray *)images
{
    if (_selectPhotos == nil)
    {
        _selectPhotos = [NSMutableArray array];
    }
    
    return _selectPhotos;
}

// 添加新的控件
- (void)addNew:(UIButton *)btn
{
    // 标识为添加一个新的图片
    
    if (![self deleClose:btn])
    {
        editTag = -1;
        [self callImagePicker];
    }
}

//查看图片
-(void)viewImage:(UIButton *)sender
{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:_selectPhotos[sender.tag-1]];

    [UUImageAvatarBrowser showImage:imageView ImageURl:nil];
}

// 修改旧的控件
- (void)changeOld:(UIButton *)btn
{
    // 标识为修改(tag为修改标识)
//    if (![self deleClose:btn])
//    {
//        editTag = btn.tag;
//        [self callImagePicker];
//    }
}

// 删除"删除按钮"
- (BOOL)deleClose:(UIButton *)btn
{
    if (btn.subviews.count == 2)
    {
        [[btn.subviews lastObject] removeFromSuperview];
//        [self stop:btn];
        return YES;
    }
    return NO;
}

// 调用图片选择器
- (void)callImagePicker
{
//    UIImagePickerController *pc = [[UIImagePickerController alloc] init];
//    pc.allowsEditing = YES;
//    pc.delegate = self;
//    [self.window.rootViewController presentViewController:pc animated:YES completion:nil];
    
    LocalPhotoViewController *pick=[[LocalPhotoViewController alloc] init];
    pick.selectPhotoDelegate=self;
    pick.selectPhotos=copyImages;
    //    self.window.rootViewController.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [viewC.navigationController pushViewController:pick animated:YES];
}

// 根据图片名称或者图片创建一个新的显示控件
- (UIButton *)createButtonWithImage:(id)imageNameOrImage andSeletor:(SEL)selector
{
    UIImage *addImage = nil;
    if ([imageNameOrImage isKindOfClass:[NSString class]])
    {
        addImage = [UIImage imageNamed:imageNameOrImage];
    }
    else if([imageNameOrImage isKindOfClass:[UIImage class]])
    {
        addImage = imageNameOrImage;
    }
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:addImage forState:UIControlStateNormal];
    [addBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    addBtn.tag = self.subviews.count;
    
    // 添加长按手势,用作删除.加号按钮不添加
//    if(addBtn.tag != 0)
//    {
//        UILongPressGestureRecognizer *gester = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
//        [addBtn addGestureRecognizer:gester];
//    }
    return addBtn;
}

//// 长按添加删除按钮
//- (void)longPress : (UIGestureRecognizer *)gester
//{
//    if (gester.state == UIGestureRecognizerStateBegan)
//    {
//        UIButton *btn = (UIButton *)gester.view;
//        
//        UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
//        dele.bounds = CGRectMake(0, 0, deleImageWH, deleImageWH);
//        [dele setImage:[UIImage imageNamed:kAdeleImage] forState:UIControlStateNormal];
//        [dele addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
//        dele.frame = CGRectMake(btn.frame.size.width - dele.frame.size.width, 0, dele.frame.size.width, dele.frame.size.height);
//        
//        [btn addSubview:dele];
//        [self start : btn];
//    }
//}

// 长按开始抖动
//- (void)start : (UIButton *)btn {
//    double angle1 = -5.0 / 180.0 * M_PI;
//    double angle2 = 5.0 / 180.0 * M_PI;
//    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
//    anim.keyPath = @"transform.rotation";
//    
//    anim.values = @[@(angle1),  @(angle2), @(angle1)];
//    anim.duration = 0.25;
//    // 动画的重复执行次数
//    anim.repeatCount = MAXFLOAT;
//    
//    // 保持动画执行完毕后的状态
//    anim.removedOnCompletion = NO;
//    anim.fillMode = kCAFillModeForwards;
//    
//    [btn.layer addAnimation:anim forKey:@"shake"];
//}

// 停止抖动
//- (void)stop : (UIButton *)btn{
//    [btn.layer removeAnimationForKey:@"shake"];
//}

// 删除图片
- (void)deletePic : (UIButton *)btn
{
    [self.images removeObject:[(UIButton *)btn.superview imageForState:UIControlStateNormal]];
    [btn.superview removeFromSuperview];
    if ([[self.subviews lastObject] isHidden])
    {
        [[self.subviews lastObject] setHidden:NO];
    }
}

// 对所有子控件进行布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger count = self.subviews.count;
    CGFloat btnW = imageW;
    CGFloat btnH = imageH;
    int maxColumn = kMaxColumn > self.frame.size.width / imageW ? self.frame.size.width / imageW : kMaxColumn;
    CGFloat marginX = (self.frame.size.width - maxColumn * btnW) / (count + 1);
    CGFloat marginY = (self.frame.size.height - maxHeightColumn * btnW) / (maxHeightColumn + 1);
    if (count == 1)
    {
        marginY = (self.frame.size.height - btnW)/2;
        marginX = 10;
    }
    for (int i = 0; i < count; i++)
    {
        UIButton *btn = self.subviews[i];
        CGFloat btnX = (i % maxColumn) * (marginX + btnW) + marginX;
        CGFloat btnY = (i / maxColumn) * (marginY + btnH) + marginY;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

//#pragma mark - UIImagePickerController 代理方法
//-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    UIImage *image = info[UIImagePickerControllerEditedImage];
//    if (editTag == -1)
//    {
//        // 创建一个新的控件
//        UIButton *btn = [self createButtonWithImage:image andSeletor:@selector(changeOld:)];
//        [self insertSubview:btn atIndex:self.subviews.count - 1];
//        
//        [self.images addObject:image];
//        if (self.subviews.count - 1 == MaxImageCount)
//        {
//            [[self.subviews lastObject] setHidden:YES];
//        }
//    }
//    else
//    {
//        // 根据tag修改需要编辑的控件
//        UIButton *btn = (UIButton *)[self viewWithTag:editTag];
//        int index = [self.images indexOfObject:[btn imageForState:UIControlStateNormal]];
//        [self.images removeObjectAtIndex:index];
//        [btn setImage:image forState:UIControlStateNormal];
//        [self.images insertObject:image atIndex:index];
//    }
//    // 退出图片选择控制器
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}

@end
