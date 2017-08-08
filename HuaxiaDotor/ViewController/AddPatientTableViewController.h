//
//  AddPatientTableViewController.h
//  HuaxiaDotor
//
//  Created by kock on 16/3/15.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPatientTableViewController : UITableViewController

//verifyCode身份验证秘钥
@property (strong, nonatomic) NSString *verifyCode;
@property(strong,nonatomic)NSDictionary *dicData;

@end
