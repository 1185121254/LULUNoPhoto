//
//  AddViedoTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/17.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AddViedoTableViewCell.h"

@implementation AddViedoTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _dicData = [NSMutableDictionary dictionary];
        
        _avater = [[UIImageView alloc]initWithFrame:CGRectMake(13, 10, 56, 56)];
        _avater.layer.cornerRadius = 28;
        _avater.layer.masksToBounds = YES;
        [self.contentView addSubview:_avater];
        
        _lblName = [[UILabel alloc]initWithFrame:CGRectMake(79, 10, kWith-79, 20)];
        _lblName.textColor = [UIColor colorWithRed:67/255.0 green:74/255.0 blue:84/255.0 alpha:1];
        _lblName.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_lblName];
        
        _lblAppTime = [[UILabel alloc]initWithFrame:CGRectMake(79, 40, 60, 20)];
        _lblAppTime.font = [UIFont systemFontOfSize:15];
        _lblAppTime.text = @"申请时间";
        _lblAppTime.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.7];
        [self.contentView addSubview:_lblAppTime];
        
        _lblTime = [[UILabel alloc]initWithFrame:CGRectMake(159, 40, kWith-159, 20)];
        _lblTime.font = [UIFont systemFontOfSize:15];
        _lblTime.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.7];
        [self.contentView addSubview:_lblTime];
        
        
        _btnAgree = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAgree.frame = CGRectMake(kWith-180, 70, 70, 25);
        _btnAgree.titleLabel.font = [UIFont systemFontOfSize:15];
        _btnAgree.backgroundColor = [UIColor colorWithRed:66/255.0 green:171/255.0 blue:64/255.0 alpha:1];
        _btnAgree.tag = 101;
        [_btnAgree addTarget:self action:@selector(agreeOrRefuse:) forControlEvents:UIControlEventTouchUpInside];
        [_btnAgree setTitle:@"同意" forState:UIControlStateNormal];
        [self.contentView addSubview:_btnAgree];
        
        _btnRefuse = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRefuse.frame = CGRectMake(kWith-80, 70, 70, 25);
        _btnRefuse.backgroundColor = [UIColor redColor];
        _btnRefuse.titleLabel.font = [UIFont systemFontOfSize:15];
        _btnRefuse.tag = 102;
        [_btnRefuse addTarget:self action:@selector(agreeOrRefuse:) forControlEvents:UIControlEventTouchUpInside];
        [_btnRefuse setTitle:@"拒绝" forState:UIControlStateNormal];
        [self.contentView addSubview:_btnRefuse];
        
        _lblState = [[UILabel alloc]initWithFrame:CGRectMake(kWith-80, 70, 70, 25)];
        _lblState.backgroundColor = kBackgroundColor;
        _lblState.font = [UIFont systemFontOfSize:15];
        _lblState.textAlignment = 1;
        [self.contentView addSubview:_lblState];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, kWith-20, 1)];
        line.backgroundColor = kBoradColor;
        [self.contentView addSubview:line];
    }
    return self;
}


-(void)agreeOrRefuse:(UIButton *)btn{
    [_dicData setObject:self forKey:@"cell"];
    [_dicData setObject:@(btn.tag) forKey:@"tag"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"agreeOrRefuse" object:nil userInfo:_dicData];
}

//-(void)onRefuse{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"agree" object:self];
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
