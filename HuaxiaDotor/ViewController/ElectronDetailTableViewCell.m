//
//  ElectronDetailTableViewCell.m
//  HuaxiaDotor
//
//  Created by ydz on 16/8/4.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "ElectronDetailTableViewCell.h"

@implementation ElectronDetailTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, kWith-20, 20)];
        _lblTitle.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_lblTitle];
                
        _lblSlter = [[UILabel alloc]init];
        _lblSlter.frame = CGRectMake(10, 25, 0, 20);
        [self.contentView addSubview:_lblSlter];
        
        _downLoadProgress = [[UILabel alloc]initWithFrame:CGRectMake(kWith-50, 25, 40, 20)];
        _downLoadProgress.userInteractionEnabled = YES;
        _downLoadProgress.font = [UIFont systemFontOfSize:13];
        _downLoadProgress.text = @"下载";
        _downLoadProgress.textColor = BLUECOLOR_STYLE;
        [self.contentView addSubview:_downLoadProgress];
        
    }
    return self;
}

-(void)setCellDetail:(CGFloat)progress Title:(NSString *)title patientName:(NSString *)patientName{

    _lblTitle.text = title;

    NSArray *arry =  [[NSFileManager defaultManager] subpathsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",patientName]]];

    if (arry) {
        
        for (NSString *str in arry) {
            NSArray *arrySep = [str componentsSeparatedByString:@"."];
            if ([title isEqualToString:arrySep[0]]) {
                
                progress = 1;
                break;
            }
        }
    }
    
    if ( progress ==0  ) {

        _lblSlter.hidden = YES;
        _lblTitle.textColor = [UIColor blackColor];
        _downLoadProgress.text = @"下载";
        _downLoadProgress.textColor = BLUECOLOR_STYLE;

    }
    else
    {
        _lblSlter.hidden = NO;

        if (progress < 1.0 && progress > 0) {
            
            _lblSlter.hidden = NO;
            _lblSlter.backgroundColor = [UIColor grayColor];
            _lblTitle.textColor = [UIColor blackColor];
            _lblSlter.frame = CGRectMake(10, 31, (kWith-70)*progress, 6);
            _downLoadProgress.text = @"下载";
            _downLoadProgress.textColor = BLUECOLOR_STYLE;

        }
        else
        {
            _lblSlter.hidden = YES;
            _lblSlter.backgroundColor = [UIColor greenColor];
            _lblSlter.frame = CGRectMake(10, 31, 0, 6);
            _lblTitle.textColor = BLUECOLOR_STYLE;
            _downLoadProgress.text = @"已下载";
            _downLoadProgress.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.8];

        }
    }
    
    
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
