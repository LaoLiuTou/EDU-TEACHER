//
//  DataBaseHelper.m
//  Application
//
//  Created by JiubaiMac on 15/10/15.
//  Copyright © 2015年 lt. All rights reserved.
//

#import "DataBaseHelper.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "AppDelegate.h"
@implementation DataBaseHelper

 NSString *fileName= @"DataBaseHelper";

#pragma mark 创建数据库
- (BOOL)createDataBase:(NSString *)dataBaseName{
    
    BOOL flag=false;
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"%@:create database %@ failed",fileName,dataBaseName);
    }
    else{
        flag=true;
        //NSLog(@"%@:create database %@ success",fileName,dataBaseName);
    }
    return flag;
}


#pragma mark 创建表
- (BOOL)createTable:(NSString *)dataBaseName tableName:(NSString *)tableName columns:(NSArray *)columns{
    
    BOOL flag=false;
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
  
//    NSString *string=@"";
//   dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",[NSString stringWithFormat:@"chat%@",[jbad.userInfoDic objectForKey:@"ROW_ID"]]]];
//    db = [FMDatabase databaseWithPath:dbpath];
   NSString *string=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,",tableName];
     
    
    //拼接列名
    NSString *str=[columns componentsJoinedByString:@"' TEXT,'"];
    
    //拼接SQL语句
    NSString *sqlCreateTable= [NSString stringWithFormat:@"%@ '%@' TEXT)",string,str];
    
    if ([db open]) {
        
        BOOL res = [db executeUpdate:sqlCreateTable];
        if (!res) {
            NSLog(@"%@:create table %@ failed",fileName,tableName);
        } else {
            flag=true;
            //NSLog(@"%@:create table %@ success",fileName,tableName);
        }
        [db close];
        
    }
    else{
        
        NSLog(@"%@:open database db failed when create table",fileName);
    }
    return flag;
}

#pragma mark 异步插入数据
- (BOOL)insertTable:(NSString *)dataBaseName tableName:(NSString *)tableName columns:(NSArray *)columns values:(NSArray *)values{
    //value 为二维数组
    BOOL flag=false;
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    
    NSString *string=[NSString stringWithFormat:@"INSERT INTO %@ ",tableName];
    
    if ([columns count] >0) {
        //自定义插入列
        NSString *str=[columns componentsJoinedByString:@" ,"];
        string= [NSString stringWithFormat:@"%@( %@) VALUES (",string,str];
    }
    else{
        //插入全部列
        string= [NSString stringWithFormat:@"%@ VALUES (",string];
    }
    
    for(int index=0;index<[[values objectAtIndex:0] count];index++) {
        string= [NSString stringWithFormat:@"%@ ?,",string];
    }
    //拼接Sql语句
    NSString *insertSql=[NSString stringWithFormat:@"%@)",[string substringToIndex:string.length-1]];
    //NSLog(@"")
    if ([db open]) {
        
        FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:dbpath];
        dispatch_queue_t insertQueue = dispatch_queue_create("insertQueue", NULL);
        for (NSArray *array in values) {
            dispatch_async(insertQueue, ^{
                [queue inDatabase:^(FMDatabase *db2) {
                    
                    BOOL res = [db2 executeUpdate:insertSql withArgumentsInArray: array];
                    if (!res) {
                        NSLog(@"%@:insert into table %@ failed",fileName,tableName);
                    } else {
                        //NSLog(@"%@:insert into %@ success",fileName,tableName);
                    }
                }];
           
           });
        }
        [db close];
        //???
        flag =true;
    }
    else{
        
        NSLog(@"%@:open database db failed when create table",fileName);
    }
    
    return flag;
}
#pragma mark 同步插入数据
- (BOOL)asyInsertTable:(NSString *)dataBaseName tableName:(NSString *)tableName columns:(NSArray *)columns values:(NSArray *)values{
    //value 为二维数组
    BOOL flag=false;
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    
    NSString *string=[NSString stringWithFormat:@"INSERT INTO %@ ",tableName];
    
    if ([columns count] >0) {
        //自定义插入列
        NSString *str=[columns componentsJoinedByString:@" ,"];
        string= [NSString stringWithFormat:@"%@( %@) VALUES (",string,str];
    }
    else{
        //插入全部列
        string= [NSString stringWithFormat:@"%@ VALUES (",string];
    }
    
    for(int index=0;index<[[values objectAtIndex:0] count];index++) {
        string= [NSString stringWithFormat:@"%@ ?,",string];
    }
    //拼接Sql语句
    NSString *insertSql=[NSString stringWithFormat:@"%@)",[string substringToIndex:string.length-1]];
    
    //NSLog(@"")
    if ([db open]) {
        
        FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:dbpath];
        
        for (NSArray *array in values) {
            
                [queue inDatabase:^(FMDatabase *db2) {
                    
                    BOOL res = [db2 executeUpdate:insertSql withArgumentsInArray: array];
                    if (!res) {
                        NSLog(@"%@:insert into table %@ failed",fileName,tableName);
                    } else {
                        //NSLog(@"%@:insert into %@ success",fileName,tableName);
                    }
                }];
            
        }
        [db close];
        //???
        flag =true;
    }
    else{
        
        NSLog(@"%@:open database db failed when create table",fileName);
    }
    
    return flag;
}
#pragma mark 修改数据
- (BOOL)updateTable:(NSString *)dataBaseName tableName:(NSString *)tableName columns:(NSArray *)columns  conditionColumns:(NSArray *)conditionColumns values:(NSArray *)values{
    //value 为二维数组
    BOOL flag=false;
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    
    NSString *string=[NSString stringWithFormat:@"UPDATE %@ SET ",tableName];
    //拼接列名
    NSString *columnStr=[columns componentsJoinedByString:@" =?, "];
    //拼接查询条件
    NSString *conditionStr=[conditionColumns componentsJoinedByString:@" =? AND "];
    
    //拼接SQL语句
    NSString *updateSql= [NSString stringWithFormat:@"%@ %@=? WHERE %@=?",string,columnStr,conditionStr];
    NSLog(@"updateSql:%@",updateSql);
    if ([db open]) {
        
        FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:dbpath];
        dispatch_queue_t updateQueue = dispatch_queue_create("updateQueue", NULL);
        for (NSArray *array in values) {
           
            dispatch_async(updateQueue, ^{
                [queue inDatabase:^(FMDatabase *db2) {
                    
                    BOOL res = [db2 executeUpdate:updateSql withArgumentsInArray: array];
                    if (!res) {
                        NSLog(@"%@:update table %@ failed",fileName,tableName);
                    } else {
                        //NSLog(@"%@:update table %@ success",fileName,tableName);
                    }
                }];
                
            });
        }
        [db close];
        //???
        flag =true;
    }
    else{
        
        NSLog(@"%@:open database db failed when create table",fileName);
    }

    return flag;
}
#pragma mark 同步修改数据
- (BOOL)asyUpdateTable:(NSString *)dataBaseName tableName:(NSString *)tableName columns:(NSArray *)columns  conditionColumns:(NSArray *)conditionColumns values:(NSArray *)values{
    //value 为二维数组
    BOOL flag=false;
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    
    NSString *string=[NSString stringWithFormat:@"UPDATE %@ SET ",tableName];
    //拼接列名
    NSString *columnStr=[columns componentsJoinedByString:@" =?, "];
    //拼接查询条件
    NSString *conditionStr=[conditionColumns componentsJoinedByString:@" =? AND "];
    
    //拼接SQL语句
    NSString *updateSql= [NSString stringWithFormat:@"%@ %@=? WHERE %@=?",string,columnStr,conditionStr];
    NSLog(@"updateSql:%@",updateSql);
    if ([db open]) {
        
        FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:dbpath];
        for (NSArray *array in values) {
            [queue inDatabase:^(FMDatabase *db2) {
                
                BOOL res = [db2 executeUpdate:updateSql withArgumentsInArray: array];
                if (!res) {
                    NSLog(@"%@:update table %@ failed",fileName,tableName);
                } else {
                    //NSLog(@"%@:update table %@ success",fileName,tableName);
                }
            }]; 
        }
        [db close];
        //???
        flag =true;
    }
    else{
        
        NSLog(@"%@:open database db failed when create table",fileName);
    }
    
    return flag;
}
#pragma mark 删除数据
- (BOOL)deleteTable:(NSString *)dataBaseName tableName:(NSString *)tableName conditionColumns:(NSArray *)conditionColumns values:(NSArray *)values{
    
    BOOL flag=false;
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    
    NSString *string=[NSString stringWithFormat:@"DELETE FROM %@ WHERE",tableName];
     NSString *columnStr=@"";
    //拼接列名
    if([conditionColumns count] ==1){
        columnStr=[NSString stringWithFormat:@"%@ = ? ",conditionColumns[0]];
    }
    else{
        columnStr=[conditionColumns componentsJoinedByString:@" =? AND "];
    }
    
    //拼接SQL语句
    NSString *deleteSql= [NSString stringWithFormat:@"%@ %@",string,columnStr];
    NSLog(@"deleteSql:%@",deleteSql);
    if ([db open]) {
        
        BOOL res = [db executeUpdate:deleteSql withArgumentsInArray:values];
        if (!res) {
            NSLog(@"%@:delete from table %@ failed",fileName,tableName);
        } else {
            flag=true;
            NSLog(@"%@:delete from table %@ success",fileName,tableName);
        }
        [db close];
        
    }
    else{
        
        NSLog(@"%@:open database db failed when create table",fileName);
    }
    return flag;
}

#pragma mark 获得表的数据条数
- (NSInteger)selectCountTable:(NSString *)dataBaseName tableName:(NSString *)tableName conditionColumns:(NSArray *)conditionColumns values:(NSArray *)values{
    NSInteger count=-1;
    
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    NSString *selectCountSql=@"";
    if ([conditionColumns count] >0) {
        NSString *string=[NSString stringWithFormat:@"SELECT COUNT(*) AS 'COUNT' FROM %@ WHERE ",tableName];
        //拼接列名
        NSString *columnStr=[conditionColumns componentsJoinedByString:@" =? AND "];
        //拼接SQL语句
        selectCountSql= [NSString stringWithFormat:@"%@ %@=?",string,columnStr];
    }
    else{
        //拼接SQL语句
        selectCountSql= [NSString stringWithFormat:@"SELECT COUNT(*) AS 'COUNT' FROM %@",tableName];
    }
    
    if ([db open]) {
        
        FMResultSet *rs = [db executeQuery:selectCountSql withArgumentsInArray:values];
        while ([rs next])
        {
            count = [rs intForColumn:@"COUNT"];
            //NSLog(@"%@:select count from table %@ success",fileName,tableName);
           
        }
        [db close];
    }
    else{
        
        NSLog(@"%@:open database db failed when create table",fileName);
    }
    return count;
}


#pragma mark 获得表的数据
- (NSArray *)selectTable:(NSString *)dataBaseName tableName:(NSString *)tableName columns:(NSArray *)columns conditionColumns:(NSArray *)conditionColumns values:(NSArray *)values order:(NSString *) order{
  
    
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    
    NSString *selectSql=@"";
    if ([columns count] >0) {
        //拼接列名
        NSString *columnStr=[columns componentsJoinedByString:@" , "];
        //拼接列名
        NSString *conditionStr=[conditionColumns componentsJoinedByString:@" =? AND "];
        NSString *string=[NSString stringWithFormat:@"SELECT %@  FROM %@ WHERE ",columnStr,tableName];
        //拼接SQL语句
        selectSql= [NSString stringWithFormat:@"%@ %@=?",string,conditionStr];
    }
    else{
        NSString *string=[NSString stringWithFormat:@"SELECT *  FROM %@ WHERE ",tableName];
        //拼接列名
        NSString *conditionStr=[conditionColumns componentsJoinedByString:@" =? AND "];
        //拼接SQL语句
        selectSql= [NSString stringWithFormat:@"%@ %@=?",string,conditionStr];
    }
    if (![order isEqual:@""] && order != nil) {
        selectSql = [NSString stringWithFormat:@"%@ ORDER BY %@ ",selectSql ,order];
    }
    NSLog(@"selectSQL:%@",selectSql);
    NSMutableArray *resultArray = [NSMutableArray new];
    
    if ([db open]) {
        
        FMResultSet *rs = [db executeQuery:selectSql withArgumentsInArray:values];
        
        while ([rs next])
        {
            [resultArray addObject:[rs resultDictionary]];
            
        }
        [db close];
    }
    else{
        NSLog(@"%@:open database db failed when create table",fileName);
    }
    
    return [resultArray copy];
}

#pragma mark 获得表的数据
- (NSArray *)selectAllTable:(NSString *)dataBaseName tableName:(NSString *)tableName order:(NSString *) order{
    
    
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    
    NSString *selectSql=[NSString stringWithFormat:@"SELECT *  FROM %@  ",tableName];
    if (![order isEqual:@""] && order != nil) {
        selectSql = [NSString stringWithFormat:@"%@ ORDER BY %@ ",selectSql ,order];
    }
    NSLog(@"selectSQL:%@",selectSql);
    NSMutableArray *resultArray = [NSMutableArray new];
    
    if ([db open]) {
        
        FMResultSet *rs = [db executeQuery:selectSql  ];
       
        while ([rs next])
        {
            [resultArray addObject:[rs resultDictionary]];
            
        }
        [db close];
    }
    else{
        NSLog(@"%@:open database db failed when create table",fileName);
    }
    
    return [resultArray copy];
}
#pragma mark 分页查询表的数据
- (NSMutableArray *)selectDataBase:(NSString *)dataBaseName tableName:(NSString *)tableName columns:(NSArray *)columns conditionColumns:(NSArray *)conditionColumns values:(NSArray *)values orderBy:(NSString *) order offset:(int)offset limit:(int) limit{
    
    
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    
    NSString *selectSql=@"";
    if ([columns count] >0) {
        //拼接列名
        NSString *columnStr=[columns componentsJoinedByString:@" , "];
        //拼接列名
        NSString *conditionStr=[conditionColumns componentsJoinedByString:@" =? AND "];
        NSString *string=[NSString stringWithFormat:@"SELECT %@  FROM %@ WHERE ",columnStr,tableName];
        //拼接SQL语句
        selectSql= [NSString stringWithFormat:@"%@ %@=?",string,conditionStr];
    }
    else{
        NSString *string=[NSString stringWithFormat:@"SELECT *  FROM %@ WHERE ",tableName];
        //拼接列名
        NSString *conditionStr=[conditionColumns componentsJoinedByString:@" =? AND "];
        //拼接SQL语句
        selectSql= [NSString stringWithFormat:@"%@ %@=?",string,conditionStr];
    }
    if (![order isEqual:@""] && order != nil) {
        selectSql = [NSString stringWithFormat:@"%@ ORDER BY %@ DESC",selectSql ,order];
    }
    selectSql = [NSString stringWithFormat:@"%@ LIMIT %d OFFSET %d ",selectSql,limit,offset];
    
    NSLog(@"selectSQL:%@",selectSql);
    NSMutableArray *resultDict = [[NSMutableArray alloc] init];
    
    if ([db open]) {
        
        FMResultSet *rs = [db executeQuery:selectSql withArgumentsInArray:values];
        
        while ([rs next])
        {
            [resultDict addObject:[rs resultDictionary]];
             ;
        }
        [db close];
    }
    else{
        NSLog(@"%@:open database db failed when create table",fileName);
    }
    
    return resultDict;
}

#pragma mark 日程搜索分页查询表的数据
- (NSMutableDictionary *)searchCalendarDataBase:(NSString *)dataBaseName tableName:(NSString *)tableName class:(NSString *)classStr date:(NSString *)dateStr orderBy:(NSString *) order offset:(int)offset limit:(int) limit{
    
    
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    
    NSString *selectSql=[NSString stringWithFormat:@"SELECT *  FROM %@ WHERE ",tableName];
    NSMutableArray *tempArray=[[NSMutableArray alloc] init];
    if(classStr.length !=0){
       
        [tempArray addObject:[NSString stringWithFormat:@"W_N_TYPE_LV_30='%@' ",classStr]];
    }
    
    if(dateStr.length !=0){
        
        [tempArray addObject:[NSString stringWithFormat:@"W_Y_PLAN_DT_20 >='%@' ",[NSString stringWithFormat:@"%@ 00:00:00",dateStr]]];
        [tempArray addObject:[NSString stringWithFormat:@"W_Y_OVER_DT_20 <='%@' ",[NSString stringWithFormat:@"%@ 23:59:59",dateStr]]];
    }
    selectSql = [NSString stringWithFormat:@"%@%@",selectSql,[tempArray componentsJoinedByString:@" and "]];
    selectSql = [NSString stringWithFormat:@"%@ LIMIT %d OFFSET %d ",selectSql,limit,offset];
    
    NSLog(@"selectSQL:%@",selectSql);
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    
    if ([db open]) {
        
        FMResultSet *rs = [db executeQuery:selectSql ];
        int index = offset+1;
        while ([rs next])
        {
            [resultDict setObject:[rs resultDictionary] forKey:[NSString stringWithFormat:@"%d",index]];
            index++;
        }
        [db close];
    }
    else{
        NSLog(@"%@:open database db failed when create table",fileName);
    }
    
    return resultDict;
}

#pragma mark 模糊查询
- (NSMutableDictionary *)selectLikeTable:(NSString *)dataBaseName tableName:(NSString *)tableName columns:(NSArray *)columns  param:(NSArray *)param{
    
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    //拼接列名
    NSString *columnStr=[columns componentsJoinedByString:@" , "];
    NSString *selectSql=[NSString stringWithFormat:@"SELECT %@  FROM %@ WHERE SEARCHSTR LIKE '%%%@%%' ",columnStr,tableName,param];
 
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:selectSql];
        int index = 1;
        while ([rs next])
        {
            [resultDict setObject:[rs resultDictionary] forKey:[NSString stringWithFormat:@"%d",index]];
            index++;
        }
        [db close];
    }
    else{
        NSLog(@"%@:open database db failed when create table",fileName);
    }
    return resultDict;
}


#pragma mark 删除数据库
- (BOOL)deleteDataBase:(NSString *)dataBaseName
{
    BOOL flag=false;
    NSError *error;
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // delete the old db.
    if ([fileManager fileExistsAtPath:dataBaseName])
    {
        
        [db close];
        flag = [fileManager removeItemAtPath:dataBaseName error:&error];
        if (!flag) {
            NSAssert1(0, @"Failed to delete old database file with message '%@'.", [error localizedDescription]);
            NSLog(@"%@:delete database db failed",fileName);
        }
        else{
            NSLog(@"%@:delete database db success",fileName);
        }
    }
    
    return flag;
}
#pragma mark 删除表
- (BOOL) dropTable:(NSString *)dataBaseName tableName:(NSString *)tableName
{
    BOOL flag=false;
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];

    NSString *dropStr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    if ([db open]) {
        
        BOOL res = [db executeUpdate:dropStr];
        if (!res) {
            NSLog(@"%@:drop table %@ failed",fileName,tableName);
        } else {
            flag=true;
            //NSLog(@"%@:drop table %@ success",fileName,tableName);
        }
        [db close];
        
    }
    else{
        
        NSLog(@"%@:open database db failed when create table",fileName);
    }
    return flag;
}

#pragma mark 根据表名获取列
- (NSArray *)selectColumns:(NSString *)dataBaseName tableName:(NSString *)tableName{

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"InitTableList" ofType:@"plist"];
    NSMutableDictionary *tableDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    //NSEnumerator * enumeratorKey = [tableDic keyEnumerator];
   
    return [tableDic objectForKey:tableName];
}
#pragma mark 表是否包含列
- (BOOL)containColums:(NSString *)dataBaseName tableName:(NSString *)tableName column:(NSString *)column{
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    
    if ([db open]) {
        NSString * sqlstr = [NSString stringWithFormat:@"select * from %@",tableName];
        
        FMResultSet * result = [db executeQuery:sqlstr];
        [result columnIndexForName:column];
        
        
        NSDictionary * dict =   [result columnNameToIndexMap];
        if (dict) {
            for (NSString * keystr in [dict allKeys]) {
                if([keystr containsString:column.lowercaseString]) {
                    return YES;
                }
            }
        }
        
        [db close];
    }
    else{
        NSLog(@"%@:open database db failed when create table",fileName);
    }
    
    
    
    return NO;
    
}





#pragma mark 查询所有表
- (NSArray *)getTables:(NSString *)dataBaseName {
    
    
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
    
    NSString *selectSql=@"SELECT name FROM sqlite_master WHERE type='table' ORDER BY name";
    
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    if ([db open]) {
        
        FMResultSet *rs = [db executeQuery:selectSql];
        
        while ([rs next])
        {
            [resultArray addObject:[rs stringForColumn:@"name"]];
            
        }
        [db close];
    }
    else{
        NSLog(@"%@:open database db failed when select table",fileName);
    }
    return [resultArray copy];
}


#pragma mark 执行完整sql
- (BOOL)queueWithSql:(NSString *)dataBaseName sql:(NSString *)sqlStr{
    //value 为二维数组
    BOOL flag=false;
    NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString* dbpath = [docsdir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",dataBaseName]];
    FMDatabase *db = [FMDatabase databaseWithPath:dbpath];
  
    if ([db open]) {
        
        FMDatabaseQueue * queue = [FMDatabaseQueue databaseQueueWithPath:dbpath];
        dispatch_queue_t insertQueue = dispatch_queue_create("insertQueue", NULL);
       
        dispatch_async(insertQueue, ^{
            [queue inDatabase:^(FMDatabase *db2) {
                
                BOOL res = [db2 executeUpdate:sqlStr];
                if (!res) {
                    NSLog(@"%@:insert into table %@ failed",fileName,sqlStr);
                } else {
                    //NSLog(@"%@:insert into %@ success",fileName,tableName);
                }
            }];
        });
        [db close];
        //???
        flag =true;
    }
    else{
        NSLog(@"%@:open database db failed when create table",fileName);
    }
    return flag;
}
@end
