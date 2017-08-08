//
//  UUInputFunctionView.h
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UUInputFunctionView;

@protocol UUInputFunctionViewDelegate <NSObject>

// text
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message;

//View
-(void)UUInputView;

// audio
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second;
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoicePath:(NSString *)path time:(NSInteger)second;

- (void)textViewBecomFirst;

@end

@interface UUInputFunctionView : UIView <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, retain) UIButton *btnSendMessage;
@property (nonatomic, retain) UIButton *btnChangeVoiceState;
@property (nonatomic, retain) UIButton *btnVoiceRecord;
@property (nonatomic, retain) UITextView *TextViewInput;


@property (nonatomic, assign) BOOL isAbleToSendTextMessage;

@property (nonatomic, assign) UIViewController *superVC;

@property (nonatomic, assign) id<UUInputFunctionViewDelegate>delegate;


- (id)initWithSuperVC:(UIViewController *)superVC;

//- (void)changeSendBtnWithPhoto:(BOOL)isPhoto;

@end
