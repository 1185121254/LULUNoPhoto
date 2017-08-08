//
//  AddImage.h
//  image
//
//  Created by kock on 16/4/19.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewSendImageArrDelegate <NSObject>

-(void)ViewSendImageArr:(NSMutableArray *)imageArr andMaxCount:(NSInteger)maxCount;

@end


@interface AddImage : UIView

@property (strong, nonatomic)id <ViewSendImageArrDelegate>delegate;

/**
 *  存储所有的照片(UIImage)
 */
@property (nonatomic, strong) NSMutableArray *selectPhotos;

/**
 *  创建的试图对象
 *
 *  @param frame          试图的大小
 *  @param viewController 新的试图
 *
 *  @return 视图对象
 */
- (instancetype)initWithFrame:(CGRect)frame withViewController:(UIViewController *)viewController;

@end
