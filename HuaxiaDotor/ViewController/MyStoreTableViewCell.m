//
//  MyStoreTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/21.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "MyStoreTableViewCell.h"

@implementation MyStoreTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        _lblType = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, kWith/2, 30)];
//        _lblType.textColor = kBoradColor;
//        _lblType.font = [UIFont systemFontOfSize:15];
//        [self.contentView addSubview:_lblType];
//        
//        _lblDate = [[UILabel alloc]initWithFrame:CGRectMake(kWith/2, 5, kWith/2-10, 30)];
//        _lblDate.textColor = kBoradColor;
//        _lblDate.textAlignment = 2;
//        _lblDate.font = [UIFont systemFontOfSize:15];
//        [self.contentView addSubview:_lblDate];
//        
//        UILabel *lblLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, kWith, 1)];
//        lblLine.backgroundColor = kBoradColor;
//        [self.contentView addSubview:lblLine];
        
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 90, 60)];
        [self.contentView addSubview:_image];
        
        _lblContext = [[UILabel alloc]init];
        _lblContext.numberOfLines = 0;
        _lblContext.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:_lblContext];
    }
    return self;
}

-(void)setcellHeight:(NSDictionary *)dic{

    if ([dic objectForKey:@"picUrl"] != nil) {
        _lblContext.frame = CGRectMake(110, 5, kWith-120, 60);
    }else
    {
        _lblContext.frame = CGRectMake(20, 5, kWith-40, 20);
    }
    _lblContext.text = [dic  objectForKey:@"title"];
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
