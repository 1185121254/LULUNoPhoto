//
//  BasePickerView.m
//  HuaxiaDotor
//
//  Created by ydz on 16/7/11.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "BasePickerView.h"

@implementation BasePickerView


-(id)init{
    if (self = [super init]) {
        
        self.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.2];
        self.frame = CGRectMake(0, 0, kWith, kHeight);
        self.hidden = YES;
        
        if (ViewB == nil) {
            ViewB = [[UIView alloc]init];
        }
        ViewB.frame = CGRectMake(0, kHeight, kWith, 240);
        ViewB.backgroundColor = kBackgroundColor;
        [self addSubview:ViewB];
        
         _lblSelected= [[UILabel alloc]initWithFrame:CGRectMake(80, 0, kWith-80-80, 40)];
        _lblSelected.font = [UIFont systemFontOfSize:15];
        _lblSelected.textAlignment = 1;
        [ViewB addSubview:_lblSelected];
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeSystem];
        btnCancel.frame = CGRectMake(0, 0, 80, 40);
        [btnCancel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btnCancel.titleLabel.font = [UIFont systemFontOfSize:18];
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(onCancelDoc) forControlEvents:UIControlEventTouchUpInside];
        [ViewB addSubview:btnCancel];
        
        UIButton *btnSure = [UIButton buttonWithType:UIButtonTypeSystem];
        btnSure.frame = CGRectMake(kWith-80, 0, 80, 40);
        [btnSure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btnSure.titleLabel.font = [UIFont systemFontOfSize:18];
        [btnSure setTitle:@"确定" forState:UIControlStateNormal];
        [btnSure addTarget:self action:@selector(onSureDoc) forControlEvents:UIControlEventTouchUpInside];
        [ViewB addSubview:btnSure];
        
        if (_picker== nil) {
            _picker  = [[UIPickerView alloc]init];
        }
        _picker.dataSource = self;
        _picker.delegate =self;
        _picker.backgroundColor = [UIColor whiteColor];
        _picker.frame= CGRectMake(0, 40, kWith, 200);
        [ViewB addSubview:_picker];        
    }
    return self;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return _arrydate.count;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_arrydate[component] count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _arrydate[component][row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (_arrydate.count==1) {
        _lblSelected.text = _arrydate[component][row];
    }
    else if (_arrydate.count==2){
        if (component==0) {
            _hour = _arrydate[0][row];
        }
        else if(component==1)
        {
            _min = _arrydate[1][row];
        }
        _lblSelected.text =[NSString stringWithFormat:@"%@:%@", _hour, _min];
    }
}

-(void)pickerDelegateShow:(NSArray *)arry{
    _arrydate = arry;
    [_picker reloadAllComponents];
    if (arry.count==1) {
        _lblSelected.text = _arrydate[0][0];
        [_picker selectRow:0 inComponent:0 animated:YES];
    }
    else if (arry.count==2){
        _hour = _arrydate[0][0];
        _min = _arrydate[1][0];
        _lblSelected.text =[NSString stringWithFormat:@"%@:%@", _arrydate[0][0], _arrydate[1][0]];
        [_picker selectRow:0 inComponent:0 animated:YES];
        [_picker selectRow:0 inComponent:1 animated:YES];
    }

    self.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    ViewB.frame = CGRectMake(0, kHeight-240, kWith, 240);
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
}

-(void)onCancelDoc{
    [UIView beginAnimations:@"remove" context:nil];
    ViewB.frame = CGRectMake(0, kHeight, kWith, 240);
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

-(void)onSureDoc{
    
    [self.delegate setPicker:_lblSelected.text];
    [UIView beginAnimations:@"remove" context:nil];
    ViewB.frame = CGRectMake(0, kHeight, kWith, 240);
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch=[touches anyObject];
    CGPoint point=[touch locationInView:[touch view]];
    
    if (CGRectContainsPoint(CGRectMake(0, 0, kWith, kHeight-230),point)) {
        [UIView beginAnimations:@"remove" context:nil];
        ViewB.frame = CGRectMake(0, kHeight, kWith, 240);
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
    }
}

-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    
    if ([animationID isEqualToString:@"remove"]) {
        self.hidden = YES;
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
