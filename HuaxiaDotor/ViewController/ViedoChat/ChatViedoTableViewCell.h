//
//  ChatViedoTableViewCell.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/17.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViedoTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *avater;
@property(nonatomic,strong)UILabel *lblName;
@property(nonatomic,strong)UILabel *lblTime;
@property(nonatomic,strong)UILabel *lblState;
@property(nonatomic,strong)UIButton *btnCallNow;
//@property(nonatomic,strong)UIButton *btnOutTime;
@end
