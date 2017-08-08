//
//  TextTDocableViewCell.h
//  HuaxiaDotor
//
//  Created by ydz on 16/6/20.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextTDocableViewCell : UITableViewCell<UITextViewDelegate>
{
    NSMutableDictionary *_dicData;
}
@property(nonatomic,strong)UITextView *textViewDoc;
@property(nonatomic,strong)UILabel *lbl;

@end
