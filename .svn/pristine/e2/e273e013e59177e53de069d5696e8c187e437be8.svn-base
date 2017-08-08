//
//  SeachFriendViewController.h
//  HuaxiaDotor
//
//  Created by kock on 16/5/9.
//  Copyright © 2016年 kock. All rights reserved.
//  搜索医生

#import <UIKit/UIKit.h>

@protocol DoctorInfoDataDelegate <NSObject>

-(void)sendDoctorDicData:(NSMutableDictionary *)dic;

@end

@interface SeachFriendViewController : UIViewController

@property (strong, nonatomic) id<DoctorInfoDataDelegate> delegate;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSeach;


@end
