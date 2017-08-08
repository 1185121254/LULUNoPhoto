//
//  UUInputView.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/5.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "UUInputView.h"

@implementation UUInputView

- (id)initWithSuperVC:(UIViewController *)superVC TipCount:(NSInteger )count
{
    self.superVC = superVC;
    CGRect frame = CGRectMake(0, kHeight, kWith, 120);
    
    NSArray *arry = [[NSArray alloc]initWithObjects:@"bk_media_picture_normal",@"bk_media_shoot_normal",@"btn_bk_media_video_chat_normal", nil];
    self = [super initWithFrame:frame];
    if (self) {
        
        float reste = kWith - kItemWidth*count;
        float gap = reste/(count + 1);
        for (NSInteger i =0; i<count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [btn setImage:[UIImage imageNamed:arry[i]] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:arry[i]] forState:UIControlStateNormal];
            btn.frame = CGRectMake(gap+(kItemWidth+gap)*i , 20, kItemWidth, kItemWidth);
            [btn addTarget:self action:@selector(onBTnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i+70;
            [self addSubview:btn];
        }
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)onBTnClick:(UIButton *)btn{
    switch (btn.tag) {
        case 70:
        {
            [self openPicLibrary];
        }
            break;
        case 71:
        {
            [self addCarema];
        }
            break;
        case 72:
        {
            [self.delegate UUinputCustom:self];
        }
            break;
        default:
            break;
    }    
}

-(void)openPicLibrary{
    
//    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
//    imagePickerVc.allowPickingVideo = NO;
//    imagePickerVc.allowPickingOriginalPhoto = NO;
//    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto)
//     {
//
//         [self.delegate UUInputView:self sendPicture:photos];
//         
//     }];
//    
//    [self.superVC presentViewController:imagePickerVc animated:YES completion:nil];
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.superVC presentViewController:picker animated:YES completion:^{
        }];
    }
}

-(void)addCarema{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.superVC presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备没有相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *editImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.superVC dismissViewControllerAnimated:YES completion:^{
        [self.delegate UUInputView:self sendPicture:editImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.superVC dismissViewControllerAnimated:YES completion:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
