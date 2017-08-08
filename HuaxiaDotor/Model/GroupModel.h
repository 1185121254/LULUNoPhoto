//
//  GroupModel.h
//  HuaxiaDotor
//
//  Created by ydz on 16/6/6.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupModel : NSObject

@property(nonatomic,copy)NSString *groupName;
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *orderby;
@property(nonatomic,copy)NSString *doctorId;
@property(nonatomic,strong)NSMutableArray *groupDetail;

@property(nonatomic,copy)NSString *departName;
@property(nonatomic,copy)NSString *departId;
@property(nonatomic,copy)NSString *count;



@end
