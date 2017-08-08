//
//  FDConnectView.m
//  HuaxiaDotor
//
//  Created by ydz on 17/3/2.
//  Copyright © 2017年 kock. All rights reserved.
//

#import "FDConnectView.h"



@implementation FDConnectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)drawRect:(CGRect)rect{

    
}

-(void)setStrCodeSecurity:(NSMutableString *)strCodeSecurity{

    if (sec== nil) {
        sec = [[SecurityCodeView alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        sec.backgroundColor = [UIColor redColor];
        [self.viewCodeConnect addSubview:sec];
    }
    sec.authCodeStr = strCodeSecurity;;

}

- (IBAction)sureBtn:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sureCodeSecurity" object: self.securityCodeFiled.text];

}

- (IBAction)btnCancel:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelCodeSecurity" object:nil];
    
}


@end
