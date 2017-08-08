//
//  SqliteSingleClass.m
//  HuaxiaDotor
//
//  Created by ydz on 16/6/1.
//  Copyright © 2016年 kock. All rights reserved.
//

#import "SqliteSingleClass.h"


static FMDatabase *_sqliteDB =nil;

@implementation SqliteSingleClass

+(FMDatabase *)singleClassSqlite:(NSString *)name{

    @synchronized(self)
    {
        if (_sqliteDB == nil)
        {
            NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/db.sqlite"];
            NSLog(@"========%@",filePath);
            _sqliteDB = [[FMDatabase alloc]initWithPath:filePath];
            [_sqliteDB open];
            FMResultSet *rs = [_sqliteDB executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", name];
            while ([rs next])
            {
                NSInteger count = [rs intForColumn:@"count"];
                if (count ==0) {
                    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (Advice_id INTEGER PRIMARY KEY,date TEXT, advice TEXT,eyes TEXT,drugUnit TEXT,singNum TEXT,freqence TEXT,firstDayNum TEXT,user TEXT,totalNum TEXT,price TEXT,proprety TEXT,doctor TEXT,state TEXT,yzqx TEXT,type TEXT)",name];
                    [_sqliteDB executeUpdate:sql];
                }
            }
            [_sqliteDB close];
        }else
        {
            [_sqliteDB open];
            FMResultSet *rs = [_sqliteDB executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", name];
            while ([rs next])
            {
                NSInteger count = [rs intForColumn:@"count"];
                if (count ==0) {
                    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (Advice_id INTEGER PRIMARY KEY,date TEXT, advice TEXT,eyes TEXT,drugUnit TEXT,singNum TEXT,freqence TEXT,firstDayNum TEXT,user TEXT,totalNum TEXT,price TEXT,proprety TEXT,doctor TEXT,state TEXT,yzqx TEXT,type TEXT)",name];
                    [_sqliteDB executeUpdate:sql];
                }
            }
            [_sqliteDB close];
        }
        
    }
    return _sqliteDB;
    
}



@end
