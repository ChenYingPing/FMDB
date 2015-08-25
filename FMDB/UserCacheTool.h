//
//  UserCacheTool.h
//  FMDB
//
//  Created by Chen on 15/7/28.
//  Copyright (c) 2015年 Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCacheTool : NSObject

/**
 *  增加t_users表中一条用户的记录
 */
+ (void)addUsersWithUid:(NSString *)uid avatar:(NSString *)avatar;

/**
 *  从数据库中取出t_users表的数据
 */
+ (NSArray *)usersWithSqlite;

/**
 *  从数据库中取出t_newUsers表的数据
 */
+ (NSArray *)usersFromT_newUsers;

/**
 *  添加表属性
 */
+ (void)addKeyWithUid:(NSString *)uid avatar:(NSString *)avatar nickname:(NSString *)nickname dateline:(NSString *)dateline;

/**
 *  删除表
 */
+ (void) deleteTable:(NSString *)tableName;

@end
