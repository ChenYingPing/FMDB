//
//  UserCacheTool.m
//  FMDB
//
//  Created by Chen on 15/7/28.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import "UserCacheTool.h"
#import "FMDB.h"

#define PATH  [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"users.sqlite"]

@implementation UserCacheTool

static FMDatabaseQueue * _queue;

+ (void)setup
{
    // 0.获取沙盒中的数据库文件名
//    NSString * path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"users.sqlite"];
    
    // 1.创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:PATH];
    
    // 2.建立表
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_users (_id integer primary key autoincrement, uid text, avatar text);"];
    }];
}

//增加t_users表中一条用户的记录
+ (void)addUsersWithUid:(NSString *)uid avatar:(NSString *)avatar
{
    [self setup];
    
    [_queue inDatabase:^(FMDatabase *db) {
        //存储数据
        [db executeUpdate:@"insert into t_users (uid, avatar) values(? , ?)", uid, avatar];
    }];
    
    [_queue close];
}

//从数据库中取出t_users表的数据
+ (NSArray *)usersWithSqlite
{
    [self setup];
    
    //1.定义数组
    __block NSMutableArray *usersArray = nil;
    
    //2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        //创建数组
        usersArray = [NSMutableArray array];
        
        FMResultSet *rs = [db executeQuery:@"select * from t_users;"];
        
        while (rs.next) {
            int ID = [rs intForColumn:@"_id"];
            NSString * idStr = [NSString stringWithFormat:@"%d",ID];
            NSString *uid = [rs stringForColumn:@"uid"];
            NSString *avatar = [rs stringForColumn:@"avatar"];
            NSDictionary * dict = @{ @"_id" : idStr,
                                     @"uid" : uid,
                                     @"avatar" : avatar};
            [usersArray addObject:dict];
        }
    }];
    [_queue close];
    
    //3.返回数据
    return usersArray;
}

//从数据库中取出t_newUsers表的数据
+ (NSArray *)usersFromT_newUsers
{
    //1.定义数组
    __block NSMutableArray *usersArray = nil;
    
    //2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        //创建数组
        usersArray = [NSMutableArray array];
        
        FMResultSet *rs = [db executeQuery:@"select * from t_newUsers;"];
        
        while (rs.next) {
            int ID = [rs intForColumn:@"_id"];
            NSString * idStr = [NSString stringWithFormat:@"%d",ID];
            NSString *uid = [rs stringForColumn:@"uid"];
            NSString *avatar = [rs stringForColumn:@"avatar"];
            NSString *nickname = [rs stringForColumn:@"nickname"];
            NSString *dateline = [rs stringForColumn:@"dateline"];

            NSDictionary * dict = @{ @"_id" : idStr,
                                     @"uid" : uid,
                                     @"avatar" : avatar,
                                     @"dateline" : dateline,
                                     @"nickname" : nickname
                                     };
            [usersArray addObject:dict];
        }
    }];
    [_queue close];
    
    //3.返回数据
    return usersArray;
}
//创建一个新的t_newUsers表
+ (void)addKeyWithUid:(NSString *)uid avatar:(NSString *)avatar nickname:(NSString *)nickname dateline:(NSString *)dateline
{
    // 1.创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:PATH];
    
    // 2.建立新表
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_newUsers (_id integer primary key autoincrement, uid text, avatar text,  nickname text, dateline text);"];
        
        //添加数据
        //存储数据
        [db executeUpdate:@"insert into t_newUsers (uid, avatar, nickname, dateline) values(? , ? , ? , ?)", uid, avatar, nickname, dateline];
    }];
    
    [_queue close];
}

// 删除表
+ (void) deleteTable:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    // 1.创建队列
    _queue = [FMDatabaseQueue databaseQueueWithPath:PATH];
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sqlstr];
    }];
    
    [_queue close];
}

@end

















