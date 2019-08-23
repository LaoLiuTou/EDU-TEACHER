//
//  LGSocketServe.h
//  AsyncSocketDemo
//
//  Created by ligang on 15/4/3.
//  Copyright (c) 2015年 ligang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"

enum{
    SocketOfflineByServer,      //服务器掉线
    SocketOfflineByUser,        //用户断开
    SocketOfflineByWifiCut,     //wifi 断开
};

typedef void(^LogOutBlcok) (void);//list
typedef void(^RefreshBackBlcok) (void);//list

typedef void(^ReciveBackBlcok) (NSDictionary *returnDic,NSNumber *rmType);//list

@interface LGSocketServe : NSObject<AsyncSocketDelegate>

@property (nonatomic, strong) AsyncSocket         *socket;       // socket
@property (nonatomic, retain) NSTimer             *heartTimer;   // 心跳计时器

+ (LGSocketServe *)sharedSocketServe;

//  socket连接
- (void)startConnectSocket;

// 断开socket连接
-(void)cutOffSocket;

// 发送消息
- (void)sendMessage:(id)message;

// 发送消息
- (void)logOutSocket;

@property (nonatomic,copy)LogOutBlcok logOutBlcok;//1
@property (nonatomic,strong)RefreshBackBlcok refreshBackBlcok;//1
@property (nonatomic,copy)ReciveBackBlcok reciveBackBlcok;//2
 

@end
