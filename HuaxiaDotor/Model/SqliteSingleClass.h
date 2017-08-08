//
//  SqliteSingleClass.h
//  HuaxiaDotor
//
//  Created by ydz on 16/6/1.
//  Copyright © 2016年 kock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface SqliteSingleClass : NSObject

+(FMDatabase *)singleClassSqlite:(NSString *)name;

@end
