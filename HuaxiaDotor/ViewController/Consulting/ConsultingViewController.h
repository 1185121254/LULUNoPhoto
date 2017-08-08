//
//  ConsultingViewController.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/3.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsultingViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITableView *tableView;

//全局通知刷新表
-(void)reciveNotifyToRefreshConsult;
//未读消息变已读
//-(void)mesUnRead:(PatientModel *)patient State:(NSString *)state;
@end
