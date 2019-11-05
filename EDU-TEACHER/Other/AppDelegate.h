//
//  AppDelegate.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/11.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "LGSocketServe.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,strong) NSString *isLogin;//true or false
@property (nonatomic,strong) NSMutableDictionary *userInfoDic;
@property (strong,nonatomic)LGSocketServe *socketServe;

@property (nonatomic,strong) NSNumber *isChatPage;//0-YES ;1_NO
@property (nonatomic,strong) NSString *chatUserId;
@property (nonatomic,strong) NSString *pushToken;

@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *urlUpload;
@property (nonatomic,strong) NSString *statisUrl;
@property (nonatomic,strong) NSString *schoolLiftUrl;

@property (nonatomic,strong) NSString *socketIp;
@property (nonatomic,strong) NSString *socketPort;

@property (nonatomic,strong) NSString *ourVersion;

@end

