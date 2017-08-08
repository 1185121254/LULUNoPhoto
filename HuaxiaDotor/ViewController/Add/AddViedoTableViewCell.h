//
//  AddViedoTableViewCell.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/17.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddViedoTableViewCell : UITableViewCell
{
    NSMutableDictionary *_dicData;
}
@property(nonatomic,strong)UIImageView *avater;
@property(nonatomic,strong)UILabel *lblName;
@property(nonatomic,strong)UILabel *lblTime;
@property(nonatomic,strong)UILabel *lblAppTime;
@property(nonatomic,strong)UIButton *btnAgree;
@property(nonatomic,strong)UIButton *btnRefuse;
@property(nonatomic,strong)UILabel *lblState;

@end
