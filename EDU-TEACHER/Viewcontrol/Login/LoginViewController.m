//
//  LoginViewController.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/18.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "LoginViewController.h"
#import "DEFINE.h"
#import "LTTabBarController.h"
#import "DataBaseHelper.h"
#import "AppDelegate.h"
#import "YYKit.h"
#import "LoginView.h"
#import "RegisterViewController.h"
#import "ResetPassViewController.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
@interface LoginViewController ()<LoginDelegate>
@property (nonatomic,strong) LoginView *loginView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self initView];
    
}

-(void) initNavBar{
    self.gk_navigationBar.hidden = YES;
}
-(void) initView{
    self.view.backgroundColor = [UIColor whiteColor]; 
    LoginView *loginView = [[LoginView alloc]init];
    _loginView=loginView;
    _loginView.frame = CGRectMake(0, 0, kWidth, kHeight);
    _loginView.delegate = self;
    [self.view addSubview:_loginView];
}


#pragma mark - 登录
-(void)clickLoginBtnName:(NSString *)username AndPass:(NSString *)password{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if([username isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入用户名！"];
        return;
    }
    else if([password isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入密码！"];
         return;
    }
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    //2 发送post请求
    NSDictionary *paramDic = @{@"username":username,@"password":password.md5String,@"type":@"辅导员"};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"login"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSLog(@"%@----%@", [responseObject class], responseObject);
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"configInfo.plist"];
            
            NSMutableDictionary *localConfigDic=[[[NSMutableDictionary alloc]initWithContentsOfFile:filename] mutableCopy];
            if([localConfigDic count]==0){
                localConfigDic=[[NSMutableDictionary alloc] init];
            }
            [localConfigDic setValue:[resultDic objectForKey:@"Result"] forKey:@"userInfo"];
            [localConfigDic setValue:@"true" forKey:@"isLogin"];
            [localConfigDic writeToFile:filename  atomically:YES];
            
            DataBaseHelper *dbh = [[DataBaseHelper alloc] init];
            //建表
            NSString *chatDatabaseName=[NSString stringWithFormat:@"chat_%@",[[resultDic objectForKey:@"Result"] objectForKey:@"ROW_ID"] ];
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"InitChatTable" ofType:@"plist"];
            NSMutableDictionary *tableDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
            [dbh createDataBase:chatDatabaseName];
            NSEnumerator * enumeratorKey = [tableDic keyEnumerator];
            //快速枚举遍历所有KEY的值
            for (NSString *object in enumeratorKey) {
                NSArray *array =[tableDic objectForKey:object];
                [dbh createTable:chatDatabaseName tableName:object columns:array];
            }
            [UIApplication sharedApplication].keyWindow.rootViewController=[[UINavigationController alloc] initWithRootViewController:[LTTabBarController new]];
            
        }
        else{
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"请求失败----%@", error);
        [[LTAlertView new] showOneChooseAlertViewMessage:@"登录失败！"];
    }];
    
    
}

- (void)clickForgetPassBtn:(UIButton *)btn {
    
    [self.navigationController pushViewController:[ResetPassViewController new] animated:YES];
}


- (void)clickRegBtn:(UIButton *)btn {
    [self.navigationController pushViewController:[RegisterViewController new] animated:YES];
}

  
@end
