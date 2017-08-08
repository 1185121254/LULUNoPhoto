//
//  KockImagePickSelect.m
//  SelectImagePick
//
//  Created by kock on 16/5/18.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "KockImagePickSelect.h"

@interface KockImagePickSelect ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btn_photograph;
@property (weak, nonatomic) IBOutlet UIButton *btn_picture;

@end

@implementation KockImagePickSelect

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.200];
    
    _btn_photograph.backgroundColor = [UIColor colorWithRed:0.231 green:0.686 blue:0.851 alpha:1.000];
    _btn_photograph.layer.cornerRadius = 25;
    _btn_photograph.layer.masksToBounds = YES;
    
    _btn_picture.backgroundColor = [UIColor colorWithRed:0.231 green:0.686 blue:0.851 alpha:1.000];
    _btn_picture.layer.cornerRadius = 25;
    _btn_picture.layer.masksToBounds = YES;
    
}
#pragma mark - 拍照
- (IBAction)photograph:(UIButton *)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Your device don't have camera" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - 本地照片
- (IBAction)picture:(UIButton *)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        [picker.navigationBar setTintColor:[UIColor whiteColor]];
        
        picker.delegate = self;
        picker.allowsEditing = YES;
        [picker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
}


#pragma mark -  相册或相机完成后执行
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self dismissViewControllerAnimated:YES completion:^{
    
        //制作通知消息
        NSDictionary *dict = @{@"imageHead":editImage};
        //创建通知对象
        NSNotification *notificationHead = [NSNotification notificationWithName:@"setImageForHead" object:self userInfo:dict];
        NSNotification *notificationDoctor = [NSNotification notificationWithName:@"setImageForDoctor" object:self userInfo:dict];
        
        //发送通知
        [[NSNotificationCenter defaultCenter]postNotification:notificationHead];
        [[NSNotificationCenter defaultCenter]postNotification:notificationDoctor];
    }];
}

#pragma mark - 取消按钮退出图片选择器
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
