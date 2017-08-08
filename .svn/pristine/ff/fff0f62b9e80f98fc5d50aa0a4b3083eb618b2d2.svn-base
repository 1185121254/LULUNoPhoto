//
//  AcadFrontTableView.m
//  HuaxiaDotor
//
//  Created by ydz on 16/9/14.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "AcadFrontTableView.h"
#import "AcademicTableViewCell.h"

@implementation AcadFrontTableView

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{

    if (self = [super initWithFrame:frame style:style]) {
        
        self.frame = frame;
        self.dataSource = self;
        self.delegate = self;
        self.rowHeight = 90;
        self.backgroundColor =[ UIColor clearColor];
    }
    return self;
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arryData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(AcademicTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ideffer = @"acadicCell";
    AcademicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ideffer];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"AcademicTableViewCell" owner:self options:nil] lastObject];
    }
    
    if (_arryData.count>0) {
        [cell setCell:_arryData[indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = _arryData[indexPath.row];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushWebView" object:dic];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
