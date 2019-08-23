//
//  ViewController.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/11.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "DataBaseHelper.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.\
    
    
    DataBaseHelper *dbh = [[DataBaseHelper alloc] init];
    //建表
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"InitChatTable" ofType:@"plist"];
    NSMutableDictionary *tableDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    [dbh createDataBase:@"Chat_userid"];
    NSEnumerator * enumeratorKey = [tableDic keyEnumerator];
    //快速枚举遍历所有KEY的值
    for (NSString *object in enumeratorKey) {
        NSArray *array =[tableDic objectForKey:object];
        [dbh createTable:@"Chat_userid" tableName:object columns:array];
    }
    
}


@end
