//
//  AdviceTableViewCell.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/7.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdviceTableViewCell : UITableViewCell<UITextViewDelegate>
{
    NSMutableDictionary *_dicText;
}
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)UILabel *lbl;

-(void)textViewHeightTxt:(NSString *)text place:(NSString *)place Source:(NSString *)from Advice:(AdviewDetail *)advice;

@end
