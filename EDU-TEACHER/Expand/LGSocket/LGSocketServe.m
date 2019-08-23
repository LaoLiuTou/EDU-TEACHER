//
//  LGSocketServe.m
//  AsyncSocketDemo
//
//  Created by ligang on 15/4/3.
//  Copyright (c) 2015年 ligang. All rights reserved.
//

#import "LGSocketServe.h"
#import "ConverseTool.h"
#import "AppDelegate.h"
#import "DataBaseHelper.h"
#import "AppDelegate.h"

//设置连接超时
#define TIME_OUT -1

//设置读取超时 -1 表示不会使用超时
#define READ_TIME_OUT -1

//设置写入超时 -1 表示不会使用超时
#define WRITE_TIME_OUT -1

//每次最多读取多少
#define MAX_BUFFER 102400000


@implementation LGSocketServe{
    NSString *tempContent;
}


static LGSocketServe *socketServe = nil;

#pragma mark public static methods


+ (LGSocketServe *)sharedSocketServe {
    @synchronized(self) {
        if(socketServe == nil) {
            socketServe = [[[self class] alloc] init];
        }
    }
    return socketServe;
}


+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (socketServe == nil)
        {
            socketServe = [super allocWithZone:zone];
            return socketServe;
        }
    }
    return nil;
}


- (void)startConnectSocket
{
    self.socket = [[AsyncSocket alloc] initWithDelegate:self];
    [self.socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
   
    if ( ![self SocketOpen:jbad.socketIp port:[jbad.socketPort integerValue] ] )
    {
        
    }
    NSLog(@"Socket地址：%@：%@",jbad.socketIp ,jbad.socketPort);
 }




- (NSInteger)SocketOpen:(NSString*)addr port:(NSInteger)port
{
    
    if (![self.socket isConnected])
    {
        NSError *error = nil;
        [self.socket connectToHost:addr onPort:port withTimeout:TIME_OUT error:&error];
    }
    
    return 0;
}


-(void)cutOffSocket
{
    self.socket.userData = SocketOfflineByUser;
    [self.socket disconnect];
    
}


- (void)sendMessage:(id)message
{
    
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    //像服务器发送数据
    NSData *cmdData = [message dataUsingEncoding:gbkEncoding];
    [self.socket writeData:cmdData withTimeout:WRITE_TIME_OUT tag:1];
}





#pragma mark - Delegate

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    
    // NSLog(@"7878 sorry the connect is failure %ld",sock.userData);
    
    if (sock.userData == SocketOfflineByServer) {
        // 服务器掉线，重连
        [self startConnectSocket];
    }
    else if (sock.userData == SocketOfflineByUser) {
        
        // 如果由用户断开，不进行重连
        return;
    }else if (sock.userData == SocketOfflineByWifiCut) {
        
        // wifi断开，不进行重连
        return;
    }
    
}



- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSData * unreadData = [sock unreadData]; // ** This gets the current buffer
    if(unreadData.length > 0) {
        [self onSocket:sock didReadData:unreadData withTag:0]; // ** Return as much data that could be collected
    } else {
        
        //  NSLog(@" willDisconnectWithError %ld   err = %@",sock.userData,[err description]);
        if (err.code == 57) {
            self.socket.userData = SocketOfflineByWifiCut;
        }
    }
    
}



- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
    NSLog(@"didAcceptNewSocket");
}


- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    tempContent=@"";
    //这是异步返回的连接成功，
    NSLog(@"socket 连接成功");
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"configInfo.plist"];
    
    NSMutableDictionary *localConfigDic=[[[NSMutableDictionary alloc]initWithContentsOfFile:filename] mutableCopy];
    if([localConfigDic count]>0){
        NSDictionary *userInfoDic =[localConfigDic objectForKey:@"userInfo"];
        //offine message number
        NSMutableDictionary *socketParam=[[NSMutableDictionary alloc]init];
        [socketParam setObject:@"1" forKey:@"T"];
        if (userInfoDic==nil||userInfoDic.count==0) {
            return;
        }
        [socketParam setObject:[userInfoDic objectForKey:@"ROW_ID"] forKey:@"UI"];
        [socketParam setObject:[userInfoDic objectForKey:@"USER_NAME"] forKey:@"UN"];
        [socketParam setObject:[userInfoDic objectForKey:@"IMG"] forKey:@"HI"];
        if([[localConfigDic allKeys]  containsObject :@"deviceToken"]){
            [socketParam setObject:[localConfigDic objectForKey:@"deviceToken"] forKey:@"TK"];
        }
        
        NSString  *paramStr=[NSString stringWithFormat:@"%@\n",[ConverseTool DataTOjsonString:socketParam]];
        [socketServe sendMessage:paramStr];
        //通过定时器不断发送消息，来检测长连接
        self.heartTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(checkLongConnectByServe) userInfo:nil repeats:YES];
        [self.heartTimer fire];
    }
    
}

- (void)logOutSocket
{
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"configInfo.plist"];
    NSMutableDictionary *localConfigDic=[[[NSMutableDictionary alloc]initWithContentsOfFile:filename] mutableCopy];
    NSDictionary *userInfoDic =[NSJSONSerialization JSONObjectWithData:[localConfigDic objectForKey:@"userInfo"] options:NSJSONReadingMutableLeaves error:nil];
    //offine message number
    NSMutableDictionary *socketParam=[[NSMutableDictionary alloc]init];
    [socketParam setObject:@"2" forKey:@"T"];
    [socketParam setObject:[userInfoDic objectForKey:@"ROW_ID"] forKey:@"UI"];
    [socketParam setObject:[userInfoDic objectForKey:@"USER_NAME"] forKey:@"UN"];
    NSString  *paramStr=[NSString stringWithFormat:@"%@\n",[ConverseTool DataTOjsonString:socketParam]];
    [socketServe sendMessage:paramStr];
    [self performSelector:@selector(cutOffSocket) withObject:nil afterDelay:1];
}


// 心跳连接
-(void)checkLongConnectByServe{
    @try {
        // 向服务器发送固定可是的消息，来检测长连接
        NSMutableDictionary *socketParam=[[NSMutableDictionary alloc]init];
        [socketParam setObject:@"0" forKey:@"T"];
        //NSString  *paramStr=[NSString stringWithFormat:@"%@&end==",[ConverseTool DataTOjsonString:socketParam]];
        NSString  *paramStr=[NSString stringWithFormat:@"%@&end==\n",[ConverseTool DataTOjsonString:socketParam]];
        [socketServe sendMessage:paramStr];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    
}



//接受消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    //服务端返回消息数据量比较大时，可能分多次返回。所以在读取消息的时候，设置MAX_BUFFER表示每次最多读取多少，当data.length < MAX_BUFFER我们认为有可能是接受完一个完整的消息，然后才解析
    if( data.length < MAX_BUFFER )
    {
        
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *result = [[NSString alloc] initWithData:data  encoding:gbkEncoding];
        //判断消息结尾
        NSString *contentStr=[NSString stringWithFormat:@"%@%@",tempContent,result];
        
        NSMutableArray *contentArray=[[contentStr componentsSeparatedByString:@"&end=="] mutableCopy];
        if([contentStr hasSuffix:@"&end=="]){
            [contentArray removeLastObject];
        }
        else{
            tempContent=contentArray.lastObject;
            [contentArray removeLastObject];
        }
        
        for(NSString *messageStr in contentArray){
            
            NSData* resultData = [messageStr dataUsingEncoding:NSUTF8StringEncoding];
            //收到结果解析...
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:nil];
            
            NSLog(@"%@",dic);
            if([dic count]>0){
                if([[dic objectForKey:@"T"] isEqual:@"1"]){
                    
                }
                else if([[dic objectForKey:@"T"] isEqual:@"2"]){
                    
                }
                else if([[dic objectForKey:@"T"] isEqual:@"3"]){
                    
                    NSLog(@"%@--%@",jbad.isChatPage,jbad.chatUserId);
                    
                    if([jbad.isChatPage isEqualToNumber:@0] && [jbad.chatUserId isEqual:[dic objectForKey:@"UI"]]){
                        
                        //解析出来的消息，可以通过通知、代理、block等传出去
                        [self operateDatabase:dic flag:@"0"] ;//flag==0  chat page
                        
                        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"RefreshChatView" object:nil userInfo:nil]];
                        
                    }
                    else{
                        //推送
                        NSLog(@"TuisongReturn:%@",[dic objectForKey:@"CT"] );
                        [self operateDatabase:dic flag:@"1"] ;
                        [self scheduleLocalNotification:dic];
                        
                    }
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"RefreshMessage" object:nil userInfo:nil]];
                    
                }
                else if([[dic objectForKey:@"T"] isEqual:@"4"]){
                    
                }
                else if([[dic objectForKey:@"T"] isEqual:@"5"]){
                    
                }
                else if([[dic objectForKey:@"T"] isEqual:@"6"]){
                    [jbad.socketServe cutOffSocket];
                    self.logOutBlcok();
                    
                }
                else if([[dic objectForKey:@"T"] isEqual:@"7"]){
                    //推送
                    NSLog(@"TuisongReturn:%@",[dic objectForKey:@"CT"] );
                    
                    [self operateDatabase:dic flag:@"1"] ;
                    [self scheduleLocalNotification:dic];
                    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"RefreshMessage" object:nil userInfo:nil]];
                }
            }
            
        }
        
       
        
    }
    else{
        //长度超出
    }
    
    
    [self.socket readDataWithTimeout:READ_TIME_OUT buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
    
}

//发送消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //读取消息
    [self.socket readDataWithTimeout:-1 buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
}

//insert into database
- (void)operateDatabase:(NSDictionary *)dic flag:(NSString *) flag
{
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *values=[NSMutableArray new];
    
    [values addObject:[dic objectForKey:@"UI"]];
        
    DataBaseHelper *dbh=[[DataBaseHelper alloc] init];
    NSString *chatDatabaseName=[NSString stringWithFormat:@"chat_%@",[jbad.userInfoDic objectForKey:@"ROW_ID"] ];
    NSArray *resultArray =[dbh selectDataBase:chatDatabaseName tableName:@"CHAT_USER" columns:nil conditionColumns:[NSArray arrayWithObjects:@"FRIEND_ID", nil] values:values orderBy:@"ID" offset:0 limit:1];
    
    NSMutableArray *columns=[NSMutableArray new];
    NSMutableArray *conditionColumns=[NSMutableArray new];
    
    //最后一条信息   记录id  通知类型（删除用）
    NSString *lastContent=@"";
    NSString *itemId=@"";
    NSString *chatType=@"";
    NSString *userName=@"";
    if(![[dic objectForKey:@"T"] isEqualToString:@"3"]){
        NSString *content=[ConverseTool formBase64Str:[dic objectForKey:@"CT"]];
        NSDictionary *messageDic=[NSJSONSerialization JSONObjectWithData:[content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        lastContent=[ConverseTool getBase64Str:[messageDic objectForKey:@"content"]];
        itemId=[messageDic objectForKey:@"id"];
        chatType=[messageDic objectForKey:@"stype"];
        userName=[messageDic objectForKey:@"username"];
    }
    else{
        if([[dic objectForKey:@"TP"] isEqual:@"0"]){
            lastContent=[dic objectForKey:@"CT"];
        }
        else if([[dic objectForKey:@"TP"] isEqual:@"1"]){
            lastContent=[ConverseTool getBase64Str:@"[图片]"];
        }
        else if([[dic objectForKey:@"TP"] isEqual:@"2"]){
            lastContent=[ConverseTool getBase64Str:@"[语音]"];
        }
        else if([[dic objectForKey:@"TP"] isEqual:@"3"]){
            lastContent=[ConverseTool getBase64Str:@"[视频]"];
        }
        else if([[dic objectForKey:@"TP"] isEqual:@"4"]){
            lastContent=[ConverseTool getBase64Str:@"[文件]"];
        }
    }
    
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    values=[NSMutableArray new];
    //save user
    if([resultArray count]>0){
        //update
        [columns addObject:@"FRIEND_NAME"];
        [columns addObject:@"FRIEND_IMAGE"];
        [columns addObject:@"ISONLINE"];
        [columns addObject:@"ISGROUP"];
        [columns addObject:@"UNREAD"];
        [columns addObject:@"LAST_TIME"];
        [columns addObject:@"LAST_CONTEXT"];
        [columns addObject:@"UPDATE_TIME"];
        [columns addObject:@"FLAG"];
        
        [conditionColumns addObject:@"FRIEND_ID"];
        [values addObject:[dic objectForKey:@"UN"]];
        [values addObject:[[dic allKeys] containsObject:@"UH"]?[dic objectForKey:@"UH"]:@""];
        [values addObject:@"0"];
        [values addObject:@"1"];
        if([flag isEqual:@"0"]){
           [values addObject:@"0"];
        }
        else{
            NSInteger unreadNumber=[[resultArray[0] objectForKey:@"UNREAD"] integerValue];
            [values addObject:[NSString stringWithFormat:@"%ld",(unreadNumber+1)]];
        }
        [values addObject:[formatter stringFromDate:date]];
        [values addObject:lastContent];
        [values addObject:[formatter stringFromDate:date]];
        [values addObject:[dic objectForKey:@"T"]];
        [values addObject:[dic objectForKey:@"UI"]];
        
        [dbh asyUpdateTable:chatDatabaseName tableName:@"CHAT_USER" columns:columns conditionColumns:conditionColumns values:[NSArray arrayWithObjects:values, nil]];
    }else{
        //insert
        //[columns addObject:@"ID"];
        [columns addObject:@"FRIEND_ID"];
        [columns addObject:@"FRIEND_NAME"];
        [columns addObject:@"FRIEND_IMAGE"];
        [columns addObject:@"ISONLINE"];
        [columns addObject:@"ISGROUP"];
        [columns addObject:@"UNREAD"];
        [columns addObject:@"LAST_TIME"];
        [columns addObject:@"LAST_CONTEXT"];
        [columns addObject:@"UPDATE_TIME"];
        [columns addObject:@"FLAG"];
        
        
        [values addObject:[dic objectForKey:@"UI"]];
        [values addObject:[dic objectForKey:@"UN"]]; 
        //[values addObject:[dic objectForKey:@"UH"]];
        [values addObject:[[dic allKeys] containsObject:@"UH"]?[dic objectForKey:@"UH"]:@""];
        [values addObject:@"0"];
        [values addObject:@"1"];
        if([flag isEqual:@"0"]){
            [values addObject:@"0"];
        }
        else{
            [values addObject:@"1"];
        }
        [values addObject:[formatter stringFromDate:date]];
        [values addObject:lastContent];
        [values addObject:[formatter stringFromDate:date]];
        [values addObject:[dic objectForKey:@"T"]];
        [dbh asyInsertTable:chatDatabaseName tableName:@"CHAT_USER" columns:columns values:[NSArray arrayWithObjects:values, nil]];
    }
    
    
    
    //sava message
    columns=[NSMutableArray new];
    conditionColumns=[NSMutableArray new];
    values=[NSMutableArray new];
    //聊天信息
    [columns addObject:@"FRIEND_ID"];
    [values addObject:[dic objectForKey:@"UI"]];
    [columns addObject:@"CHAT_TYPE"];
    [values addObject:@"1"];
    [columns addObject:@"CONTENT_TYPE"];
    [values addObject:[dic objectForKey:@"TP"]];
    [columns addObject:@"CONTEXT"];
    [values addObject:[dic objectForKey:@"CT"]];
    [columns addObject:@"ADD_TIME"];
    [values addObject:[formatter stringFromDate:date]];
    [columns addObject:@"SEND_STATUS"];
    [values addObject:@"0"];
    [columns addObject:@"READ_STATUS"];
    if([flag isEqualToString:@"0"]){
        [values addObject:@"0"];
    }
    else{
        [values addObject:@"1"];
    }
    [columns addObject:@"FLAG"];//待用
    [values addObject:[dic objectForKey:@"T"]]; 
    
    [columns addObject:@"MI"];
    [values addObject:[dic objectForKey:@"MI"]]; 
    
    //通知
    if(![[dic objectForKey:@"T"] isEqualToString:@"3"]){
        if ([chatType isEqualToString:@"tongzhidelete"]) {
            [dbh deleteTable:chatDatabaseName tableName:@"CHAT_TABLE" conditionColumns:[NSArray arrayWithObjects:@"FLAG", nil] values:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",itemId], nil]];
        }
        else{
            [columns addObject:@"LAST_CONTEXT"];
            [values addObject:lastContent];
            [columns addObject:@"MESSAGE_TYPE"];
            [values addObject:chatType];
            [columns addObject:@"ITEM_ID"];
            [values addObject:itemId];
            [columns addObject:@"TITLE"];
            [values addObject:userName];
        }
    }
    else{
        [columns addObject:@"TITLE"];
        [values addObject:[dic objectForKey:@"UN"]];
        [columns addObject:@"MESSAGE_TYPE"];
        [values addObject:@"CHAT"];
    }
    
    
    [dbh asyInsertTable:chatDatabaseName tableName:@"CHAT_TABLE" columns:columns values:[NSArray arrayWithObjects:values, nil]];
    
}



- (void)scheduleLocalNotification:(NSDictionary *) dic {
    
    NSArray *conditionColumns= [[NSArray alloc] initWithObjects:@"READ_STATUS",nil];
    NSArray *countValues= [[NSArray alloc] initWithObjects:@"1",nil];
     AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    DataBaseHelper *dbh=[[DataBaseHelper alloc] init];
    
     NSInteger count=[dbh selectCountTable:[NSString stringWithFormat:@"chat_%@",[jbad.userInfoDic objectForKey:@"ROW_ID"]] tableName:@"CHAT_TABLE" conditionColumns:conditionColumns values:countValues];
     
    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 1.创建一个本地通知
        UILocalNotification *localNote = [[UILocalNotification alloc] init];
        // 1.1.设置通知发出的时间
        localNote.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
        // 1.2.设置通知内容
        localNote.alertBody = @"你有一条新消息！！";
        // 1.3.设置锁屏时,字体下方显示的一个文字
        localNote.alertAction = @"在校园：你有一条新消息！";
        localNote.hasAction = YES;
        // 1.4.设置启动图片(通过通知打开的)
        localNote.alertLaunchImage = @"AppIcon";
        // 1.5.设置通过到来的声音
        localNote.soundName = UILocalNotificationDefaultSoundName;
        // 1.6.设置应用图标左上角显示的数字
        localNote.applicationIconBadgeNumber = count;
         NSString *notificationId = [NSString stringWithFormat:@"notificationId_%@",[dic objectForKey:@"UI"]];
        // 1.7.设置一些额外的信息
        localNote.userInfo = @{@"id" : notificationId};
        // 2.执行通知
        [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
    //});
   
}

 


@end
