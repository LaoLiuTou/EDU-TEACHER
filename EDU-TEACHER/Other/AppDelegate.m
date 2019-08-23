//
//  AppDelegate.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/11.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AppDelegate.h"
#import "LTTabBarController.h" 
#import "AFNetworking.h"
#import "LoginViewController.h"
#import "GKCommon.h"
#import "GKNavigationBarConfigure.h"
#import "UINavigationController+GKCategory.h"
@interface AppDelegate () 
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   [NSThread sleepForTimeInterval:2.0];
    int environ=2;  //1生产,2测试,3开发
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(environ==1){
        //生产
        jbad.url=@"http://life.54atu.com/public/api.php/Api/";
        jbad.urlUpload=@"http://39.98.203.32:8088/FileUS/filesUpload";
        jbad.statisUrl=[NSString stringWithFormat:@"%@signStatistics",jbad.url];
        jbad.socketIp=@"39.98.203.32";
        jbad.socketPort=@"8890";
    }
    else if(environ==2){
        //测试
        jbad.url=@"http://test.jiubaisoft.com/jida_life/public/api.php/Api/";
        jbad.urlUpload=@"http://39.98.201.40:8090/FileUS/filesUpload";
        jbad.statisUrl=[NSString stringWithFormat:@"%@signStatistics",jbad.url];
        jbad.socketIp=@"39.98.201.40";
        jbad.socketPort=@"8891";
    }
    else if(environ==3){
        //开发
        //jbad.url=@"http://192.168.1.169/life/public/api.php/Api/";
        jbad.url=@"http://dev.jiubaisoft.com/jida_life/public/api.php/Api/";
        jbad.urlUpload=@"http://192.168.1.144/FileUS/filesUpload";
        jbad.statisUrl=[NSString stringWithFormat:@"%@signStatistics",jbad.url];
        jbad.socketIp=@"192.168.1.144";
        jbad.socketPort=@"8888";
    }
    jbad.ourVersion=@"3.1.1.0819_beta";
 
    
    //是否在聊天界面
    _isChatPage=@1;
    [self replyPushNotificationAuthorization:application];
    
    AFNetworkReachabilityManager *NetManager = [AFNetworkReachabilityManager sharedManager];
    [NetManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusNotReachable) [self noneNetwork];
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G");
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                
                break;
                
            default:
                break;
        }
    }];
    [NetManager startMonitoring];
    
    
    [GKConfigure setupCustomConfigure:^(GKNavigationBarConfigure *configure) {
        configure.titleColor = [UIColor blackColor];
        configure.titleFont = [UIFont systemFontOfSize:18.0f];
        configure.gk_navItemLeftSpace = 4.0f;
        configure.gk_navItemRightSpace = 4.0f;
        configure.backStyle = GKNavigationBarBackStyleWhite;
        
    }];
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"configInfo.plist"];
    NSMutableDictionary *localConfigDic=[[[NSMutableDictionary alloc]initWithContentsOfFile:filename] mutableCopy];
   
    if([[localConfigDic objectForKey:@"isLogin"] isEqual:@"true"]){
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.backgroundColor = [UIColor whiteColor];
        self.window.rootViewController = [UINavigationController rootVC:[LTTabBarController new] translationScale:NO];
        [self.window makeKeyAndVisible];
        
     
    }
    else{
        //self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        //self.window.rootViewController=[LoginViewController new];
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.backgroundColor = [UIColor whiteColor];
        self.window.rootViewController = [UINavigationController rootVC:[LoginViewController new] translationScale:NO];
        [self.window makeKeyAndVisible];
    }
    
    
    LGSocketServe *socketServe = [LGSocketServe sharedSocketServe];
    socketServe.logOutBlcok = ^(){ // 1
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的账号在其他设备上登录，此设备将退出" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"configInfo.plist"];
            
            NSMutableDictionary *localConfigDic=[[[NSMutableDictionary alloc]initWithContentsOfFile:filename] mutableCopy];
            if([localConfigDic count]==0){
                localConfigDic=[[NSMutableDictionary alloc] init];
            }
            [localConfigDic setValue:@{} forKey:@"userInfo"];
            [localConfigDic setValue:@"false" forKey:@"isLogin"];
            [localConfigDic writeToFile:filename  atomically:YES];
            //[self presentViewController:[LoginViewController new] animated:YES completion:nil];
            self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            self.window.backgroundColor = [UIColor whiteColor];
            self.window.rootViewController = [UINavigationController rootVC:[LoginViewController new] translationScale:NO];
            [self.window makeKeyAndVisible];
            
            
        }])];
        [[self currentViewController] presentViewController:alertController animated:YES completion:nil];
        
    };
    
     
    return YES;
}
#pragma mark - 申请通知权限
- (void)replyPushNotificationAuthorization:(UIApplication *)application{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                NSLog(@"注册通知成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    
                }];
            } else {
                //点击不允许
                NSLog(@"注册通知失败");
            }
        }];
        //注册推送（同iOS8）
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else if ([UIDevice currentDevice].systemVersion.doubleValue >=8.0) {
        //请求用户授权给用户发送通知
        UIUserNotificationSettings * settings=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound|UIUserNotificationTypeBadge|UIUserNotificationTypeAlert categories:nil];
        [application registerUserNotificationSettings:settings];
        //注册远程通知
        [application registerForRemoteNotifications];
        
    }
    
}

- (void)noneNetwork{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"当前网络不可用，请检查网络后再次尝试" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:okAction];
    
    [[self currentViewController] presentViewController:alertController animated:YES completion:nil];
}

//获取Window当前显示的ViewController
- (UIViewController *)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [UIApplication sharedApplication].idleTimerDisabled = false; // 程序常亮
    
    // 直接打开app时，图标上的数字清零
    //application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    LGSocketServe *socketServe = [LGSocketServe sharedSocketServe];
    [socketServe startConnectSocket];
}

#pragma  mark - 获取device Token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"DeviceToken: {%@}",deviceToken.description);
    
    NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"configInfo.plist"];
    NSMutableDictionary *localConfigDic=[[[NSMutableDictionary alloc]initWithContentsOfFile:filename] mutableCopy];
    if([localConfigDic count]==0){
        localConfigDic=[[NSMutableDictionary alloc] init];
    } 
    [localConfigDic setValue:[NSString stringWithFormat:@"%@",deviceToken] forKey:@"deviceToken"];
    [localConfigDic writeToFile:filename  atomically:YES];
    
}
#pragma mark - iOS10 推送代理
//App处于前台接收通知时
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    
    //收到推送的请求
    UNNotificationRequest *request = notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    //收到推送消息body
    NSString *body = content.body;
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    // 推送消息的标题
    NSString *title = content.title;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
    }else {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
    
}


//App通知的点击事件
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    //收到推送消息body
    NSString *body = content.body;
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    // 推送消息的标题
    NSString *title = content.title;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
    }else {
        // 判断为本地通知
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    //2016-09-27 14:42:16.353978 UserNotificationsDemo[1765:800117] Warning: UNUserNotificationCenter delegate received call to -userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: but the completion handler was never called.
    completionHandler(); // 系统要求执行这个方法
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"iOS7及以上系统，收到通知:%@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    LGSocketServe *socketServe = [LGSocketServe sharedSocketServe];
    [socketServe cutOffSocket];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
