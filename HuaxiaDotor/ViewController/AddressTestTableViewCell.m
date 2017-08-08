//
//  AddressTestTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/15.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AddressTestTableViewCell.h"

@implementation AddressTestTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _avater = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 60, 60)];
        _avater.layer.cornerRadius = 30;
        _avater.layer.masksToBounds = YES;
        [self.contentView addSubview:_avater];
        
        _lblName = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 200, 20)];
        [self.contentView addSubview:_lblName];
        
        _lblIllness = [[UILabel alloc]initWithFrame:CGRectMake(80, 25, 200, 20)];
        _lblIllness.font = [UIFont systemFontOfSize:15];
        _lblIllness.textColor = kBoradColor;
        [self.contentView addSubview:_lblIllness];
        
        _lblHospical = [[UILabel alloc]initWithFrame:CGRectMake(80, 45, 200, 20)];
        _lblHospical.font = [UIFont systemFontOfSize:15];
        _lblHospical.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.7];
        [self.contentView addSubview:_lblHospical];
        
        _btnAgree = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAgree.frame = CGRectMake(kWith-120, 20, 40, 25);
        _btnAgree.titleLabel.font = [UIFont systemFontOfSize:15];
        _btnAgree.backgroundColor = [UIColor colorWithRed:66/255.0 green:171/255.0 blue:64/255.0 alpha:1];
        _btnAgree.layer.cornerRadius = 3;
        _btnAgree.layer.masksToBounds = YES;
        [_btnAgree addTarget:self action:@selector(onAgreeAddressTest) forControlEvents:UIControlEventTouchUpInside];
        [_btnAgree setTitle:@"同意" forState:UIControlStateNormal];
        [self.contentView addSubview:_btnAgree];
        
        _btnRefuse = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRefuse.frame = CGRectMake(kWith-60, 20, 40, 25);
        _btnRefuse.backgroundColor = [UIColor redColor];
        _btnRefuse.layer.cornerRadius = 3;
        _btnRefuse.layer.masksToBounds = YES;
        _btnRefuse.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btnRefuse addTarget:self action:@selector(onRefuseAddressTest) forControlEvents:UIControlEventTouchUpInside];
        [_btnRefuse setTitle:@"拒绝" forState:UIControlStateNormal];
        [self.contentView addSubview:_btnRefuse];
        
        _lblState = [[UILabel alloc]initWithFrame:CGRectMake(kWith-70, 20, 60, 25)];
        _lblState.font = [UIFont systemFontOfSize:15];
        _lblState.textAlignment = 1;
        _lblState.textColor = kBoradColor;
        [self.contentView addSubview:_lblState];
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, kWith-20, 1)];
        line.backgroundColor = kBackgroundColor;
        [self.contentView addSubview:line];
        
    }
    return self;
}

-(void)onAgreeAddressTest{
   [[NSNotificationCenter defaultCenter]postNotificationName:@"addressTestAgree" object:self];
}

-(void)onRefuseAddressTest{

    [[NSNotificationCenter defaultCenter]postNotificationName:@"addressTestRefuse" object:self];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
