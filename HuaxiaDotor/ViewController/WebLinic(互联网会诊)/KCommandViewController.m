//
//  KCommandViewController.m
//  HuaxiaDotor
//
//  Created by kock on 16/6/1.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "KCommandViewController.h"

@interface KCommandViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *txtView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_text;

@end

@implementation KCommandViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_txtView becomeFirstResponder];
    // Do any additional setup after loading the view.
    //    NSLog(@"%@",_dic_command);
}

-(void)textViewDidChange:(UITextView *)textView
{
    _lbl_text.hidden = YES;
}

- (IBAction)cannal:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSend:(UIBarButtonItem *)sender
{
    if ([_txtView.text isEqualToString:@""])
    {
        [showAlertView showAlertViewWithMessage:@"评论内容不能为空"];
    }
    else
    {
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        NSString *strType =[[NSString alloc]init];
        strType = @"2";
        
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        //获取用户秘钥
        NSString *verifyCode;
        verifyCode=[userDefaults objectForKey:@"verifyCode"];
        NSDictionary *heads=@{RESPONSE_KEY_VERIFYCODE:verifyCode};
        NSString *userID;
        
        //----
        NSString *strUrl = [[NSString alloc]init];
        if (_isCircle==YES)//眼科圈
        {
            [parameters setObject:_topID forKey:@"topicId"];
            strUrl = CIRCLEVIEWFINFO_COMMENTS;
        }
        else//互联网会诊
        {
            [parameters setObject:_topID forKey:@"consulId"];
            strUrl = COMMENTADD;
        }
        //---
        
        userID = [userDefaults objectForKey:@"id"];
        if (_str_reviewerName == nil)
        {
            _str_reviewerName = userID;
        }
        [parameters setObject:userID forKey:@"doctorId"];
        [parameters setObject:strType forKey:@"commentType"];
        [parameters setObject:_txtView.text forKey:@"commentDetail"];
        if (_isCopy==2)//有回复人
        {
            [parameters setObject:_str_reviewerName forKey:@"reviewerId"];
        }
        [RequestManager postWithURLString:strUrl heads:heads parameters:parameters success:^(id responseObject)
         {
             [self.navigationController popViewControllerAnimated:YES];
         } failure:^(NSError *error) {
             NSLog(@"%@",error);
         }];
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
