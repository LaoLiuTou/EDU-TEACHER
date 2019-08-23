//
//  DataBaseHelper.h
//  Application
//
//  Created by JiubaiMac on 15/10/15.
//  Copyright © 2015年 lt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseHelper : NSObject


#pragma mark 创建数据库
- (BOOL)createDataBase:(NSString *)dataBaseName;

#pragma mark 创建表
- (BOOL)createTable:(NSString *)dataBaseName tableName:(NSString *)tableName columns:(NSArray *)columns;

#pragma mark 插入数据
- (BOOL)insertTable:(NSString *)dataBaseName tableName:(NSString *)tableName columns:(NSArray *)columns values:(NSArray *)values;
#pragma mark 同步插入数据
- (BOOL)asyInsertTable:(NSString *)dataBaseName tableName:(NSString *)tableName columns:(NSArray *)columns values:(NSArray *)values;
#pragma mark 修改数据
- (BOOL)updateTable:(NSString *)dataBaseName tableName:(NSString *)tableName columns:(NSArray *)columns  conditionColumns:(NSArray *)conditionColumns values:(NSArray *)values;
#pragma mark 同步修改数据
- (BOOL)asyUpdateTable:(NSString *)dataBaseName tableName:(NSString *)tableName columns:(NSArray *)columns  conditionColumns:(NSArray *)conditionColumns values:(NSArray *)values;
#pragma mark 删除数据
- (BOOL)deleteTable:(NSString *)dataBaseName tableName:(NSString *)tableName conditionColumns:(NSArray *)conditionColumns values:(NSArray *)values;

#pragma mark 获得表的数据条数
- (NSInteger)selectCountTable:(NSString *)dataBaseName tableName:(NSString *)tableName conditionColumns:(NSArray *)conditionColumns values:(NSArray *)values;

#pragma mark 获得表的数据
- (NSArray *)selectTable:(NSString *)dataBaseName tableName:(NSString *)tableName columns:(NSArray *)columns conditionColumns:(NSArray *)conditionColumns values:(NSArray *)values order:(NSString *) order;
- (NSArray *)selectAllTable:(NSString *)dataBaseName tableName:(NSString *)tableName order:(NSString *) order;
#pragma mark 分页查询表的数据
- (NSMutableArray *)selectDataBase:(NSString *)dataBaseName tableName:(NSString *)tableName columns:(NSArray *)columns conditionColumns:(NSArray *)conditionColumns values:(NSArray *)values orderBy:(NSString *) order offset:(int)offset limit:(int) limit;

#pragma mark 模糊查询
- (NSMutableDictionary *)selectLikeTable:(NSString *)dataBaseName tableName:(NSString *)tableName columns:(NSArray *)columns  param:(NSString *)param;

#pragma mark 删除数据库
- (BOOL)deleteDataBase:(NSString *)dataBaseName;

#pragma mark 删除表
- (BOOL) dropTable:(NSString *)dataBaseName tableName:(NSString *)tableName;

#pragma mark 根据表名获取列
- (NSArray *)selectColumns:(NSString *)dataBaseName tableName:(NSString *)tableName;

#pragma mark 表是否包含列
- (BOOL)containColums:(NSString *)dataBaseName tableName:(NSString *)tableName column:(NSString *)column;

    
#pragma mark 查询所有表
- (NSArray *)getTables:(NSString *)dataBaseName ;   


#pragma mark 执行完整sql
- (BOOL)queueWithSql:(NSString *)dataBaseName sql:(NSString *)sqlStr;

@end
