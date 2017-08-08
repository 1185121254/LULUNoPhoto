//
//  AddviceMedTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/5/9.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AddviceMedTableViewCell.h"

@implementation AddviceMedTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _lblName = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, kWith-20-130, 40)];
        [self.contentView addSubview:_lblName];
        
        _btnReduce = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnReduce.frame = CGRectMake(kWith-130, 5, 40, 40);
        _btnReduce.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btnReduce setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnReduce setTitle:@"－" forState:UIControlStateNormal];
        [_btnReduce addTarget:self action:@selector(onReduce) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btnReduce];
        
        _lblCount = [[UILabel alloc]initWithFrame:CGRectMake(kWith-90, 5, 40, 40)];
        _lblCount.font = [UIFont systemFontOfSize:15];
        _lblCount.textAlignment = 1;
        [self.contentView addSubview:_lblCount];
        
        _btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAdd.frame = CGRectMake(kWith-50, 5, 40, 40);
        _btnAdd.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btnAdd setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnAdd addTarget:self action:@selector(onAdd) forControlEvents:UIControlEventTouchUpInside];
        [_btnAdd setTitle:@"＋" forState:UIControlStateNormal];
        [self.contentView addSubview:_btnAdd];
        
    }
    
    return self;
}

-(void)setText:(NSString *)name{
    
    NSArray *arry = [name componentsSeparatedByString:@"    "];
    NSString *strUnit = arry[1];
    
    NSMutableAttributedString *medStr = [[NSMutableAttributedString alloc]initWithString:name];
    [medStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:[name rangeOfString:strUnit]];
    _lblName.attributedText = medStr;
    
}


-(void)onReduce{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reduce" object:self];
}

-(void)onAdd{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"add" object:self];

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
