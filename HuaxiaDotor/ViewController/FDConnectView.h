//
//  FDConnectView.h
//  HuaxiaDotor
//
//  Created by ydz on 17/3/2.
//  Copyright © 2017年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecurityCodeView.h"
@interface FDConnectView : UIView

{
    SecurityCodeView *sec;

}

@property (weak, nonatomic) IBOutlet UIView *viewCodeConnect;
@property (nonatomic, copy) NSMutableString *strCodeSecurity;

@property (weak, nonatomic) IBOutlet UITextField *securityCodeFiled;


@end
