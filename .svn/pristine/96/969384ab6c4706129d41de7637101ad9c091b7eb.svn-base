//
//  FriendvalidationTableViewCell.m
//  HuaxiaDotor
//
//  Created by kock on 16/5/6.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "FriendvalidationTableViewCell.h"
#import "AddFriendsViewController.h"

@implementation FriendvalidationTableViewCell


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

////同意提示
//@property (weak, nonatomic) IBOutlet UILabel *lbl_agree;
////职称
//@property (weak, nonatomic) IBOutlet UILabel *lbl_Subtitles;
//@property (weak, nonatomic) IBOutlet UIImageView *image_head;
//@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
////科室
//@property (weak, nonatomic) IBOutlet UILabel *lbl_department;
////医院
//@property (weak, nonatomic) IBOutlet UILabel *lbl_hospital;
////不同意
//@property (weak, nonatomic) IBOutlet UIButton *btn_unAgree;
////同意
//@property (weak, nonatomic) IBOutlet UIButton *btn_agree;

-(void)setCell:(NSDictionary *)dic
{
    int agree =[[NSString stringWithFormat:@"%@",dic[@"validateState"]] intValue];
    if (agree==0)
    {
        _lbl_agree.hidden = YES;
        _btn_unAgree.hidden = NO;
        _btn_agree.hidden = NO;
    }
    else if (agree==1)
    {
        _lbl_agree.text = @"已通过";
        _btn_unAgree.hidden = YES;
        _btn_agree.hidden = YES;
    }
    else if (agree==2)
    {
        _lbl_agree.text = @"已拒绝";
        _btn_unAgree.hidden = YES;
        _btn_agree.hidden = YES;
    }
    
    _lbl_Subtitles.text = dic[@"title"];
    
    NSString *imageURl = [NSString stringWithFormat:@"%@%@",NET_URLSTRING,dic[@"picFileName"]];
    imageURl = [imageURl stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
    [_image_head sd_setImageWithURL:[NSURL URLWithString:imageURl]];
    _image_head.layer.cornerRadius=_image_head.frame.size.height/2;
    [_image_head.layer setMasksToBounds:YES];

    _lbl_name.text = dic[@"userName"];
    
//    _lbl_department.text = dic[@""];
    
    _str_aboutID = dic[@"id"];
    
    _str_applyId = dic[@"applyId"];
}

//是否同意
//拒绝10001 同意10000
- (IBAction)btnAction_unagree:(UIButton *)sender
{
    {
        //获取verifyCode 和 ID
        //获取已添加页面的数据
        NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
        //获取用户秘钥
        _verifyCode=[userDefaults objectForKey:@"verifyCode"];
        //获取登录医生数据字典
        NSMutableDictionary *userDic=[NSMutableDictionary new];
        userDic=[userDefaults objectForKey:@"DoctorDataDic"];

        //获取当前用户ID
        _userID=userDic[@"id"];
        
        //BODY
        NSMutableDictionary *parameters=[[NSMutableDictionary alloc]init];
        //关联ID
        [parameters setObject:_str_aboutID forKey:@"friendId"];
        //当前用户ID
        [parameters setObject:_userID forKey:@"doctorId"];
        //申请者ID
        [parameters setObject:_str_applyId forKey:@"applyId"];
        //是否同意
        if (sender.tag==10001)
        {
            [parameters setObject:@"2" forKey:@"state"];
        }
        else
        {
             [parameters setObject:@"1" forKey:@"state"];
        }
        
        //获取需要上传的数据
        //POST
        [self.reloadDelegate reloadTableViewWithData:parameters];
    }
}


@end
