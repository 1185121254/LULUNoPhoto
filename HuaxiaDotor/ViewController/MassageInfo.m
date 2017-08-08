//
//  MassageInfo.m
//  HuaxiaDotor
//
//  Created by kock on 16/7/7.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "MassageInfo.h"

@interface MassageInfo ()

@end

@implementation MassageInfo

- (void)viewDidLoad
{
    [super viewDidLoad];

    int i = (int)[_dic[@"type"] integerValue];
    _lbl_title.text = _dic[@"messageTitle"];
    _lbl_time.text = _dic[@"createDate"];
    if (i==1)
    {
        _lbl_form.text = @"系统广播";
    }
    else if (i==2)
    {
        _lbl_form.text = [NSString stringWithFormat:@"来自:%@的群发通知",_dic[@"publisherName"]];
    }
    else if (i==3)
    {
        _lbl_form.text = @"停诊通知";
    }
    _lbl_info.text = _dic[@"messageDetail"];

    _lbl_info.userInteractionEnabled = NO;
    
    //未读变已读
    if ([[self.dic objectForKey:@"isRead"] integerValue] == 0) {
        [self changIsRead];
    }
    
}

-(void)changIsRead{

    NSDictionary *dic = @{@"messageId":[self.dic objectForKey:@"messageId"]};
    [RequestManager getWithURLStringALL:[NSString stringWithFormat:@"%@/api/Share/MessageRead",NET_URLSTRING] heads:DICTIONARY_VERIFYCODE parameters:dic viewConroller:self success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
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