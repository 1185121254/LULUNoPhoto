//
//  UUInputView.h
//  HuaxiaDotor
//
//  Created by ydz on 16/5/5.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZImagePickerController.h"

@class UUInputView;

@protocol UUInputViewDelegate <NSObject>

// image
- (void)UUInputView:(UUInputView *)funcView sendPicture:(UIImage *)image;
//自定义消息
-(void)UUinputCustom:(UUInputView *)custom;
@end

@interface UUInputView : UIView<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, assign) UIViewController *superVC;
@property (nonatomic, assign) id<UUInputViewDelegate>delegate;


- (id)initWithSuperVC:(UIViewController *)superVC TipCount:(NSInteger )count;

@end
