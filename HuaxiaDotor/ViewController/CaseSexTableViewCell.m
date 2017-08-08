//
//  CaseSexTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/25.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "CaseSexTableViewCell.h"

@implementation CaseSexTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _lblDes= [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 60, 30)];
        _lblDes.text  = @"性别";
        _lblDes.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_lblDes];
        
        _btnMan = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnMan.frame = CGRectMake(100, 10, 20, 20);
        [_btnMan setBackgroundImage:[UIImage imageNamed:@"i圈"] forState:UIControlStateNormal];
        _btnMan.tag = 1250;
        [_btnMan setBackgroundImage:[UIImage imageNamed:@"i圈_h"] forState:UIControlStateSelected];
        [_btnMan addTarget:self action:@selector(onMan:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnMan];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(130, 10, 20, 20)];
        lbl.text = @"男";
        lbl.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:lbl];
        
        _btnWoman = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnWoman.frame = CGRectMake(160, 10, 20, 20);
        [_btnWoman setBackgroundImage:[UIImage imageNamed:@"i圈"] forState:UIControlStateNormal];
        [_btnWoman setBackgroundImage:[UIImage imageNamed:@"i圈_h"] forState:UIControlStateSelected];
        _btnWoman.tag = 1251;
        [_btnWoman addTarget:self action:@selector(onWoman:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnWoman];
        
        UILabel *lblW = [[UILabel alloc]initWithFrame:CGRectMake(190, 10, 20, 20)];
        lblW.text = @"女";
        lblW.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:lblW];
        
        
    }
    return self;
}

-(void)onMan:(UIButton *)btn{

    btn.selected = YES;
    _btnWoman.selected = NO;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CaseSex" object:btn];
    
}


-(void)onWoman:(UIButton *)btn{

    btn.selected = YES;
    _btnMan.selected = NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CaseSex" object:btn];

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
