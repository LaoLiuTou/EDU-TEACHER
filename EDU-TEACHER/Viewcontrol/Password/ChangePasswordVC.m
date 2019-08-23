//
//  ChangePasswordVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "DEFINE.h"
#import "ChangePasswordView.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "YYKit.h"
@interface ChangePasswordVC ()<ChangePassDelegate>
@property (nonatomic,retain) ChangePasswordView *changePasswordView;
@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self initView];
}
#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_black") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    self.gk_navBackgroundColor=[UIColor whiteColor];
    self.gk_navTitle=@"修改密码";
    self.gk_navTitleColor=[UIColor blackColor];
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initView{
    self.view.backgroundColor=GKColorRGB(246, 246, 246);
    ChangePasswordView *changePasswordView = [[ChangePasswordView alloc]init];
    self.changePasswordView=changePasswordView;
    self.changePasswordView.frame = CGRectMake(0, kNavBarHeight, kWidth, kHeight-kNavBarHeight);
    self.changePasswordView.delegate = self;
    [self.view addSubview:self.changePasswordView];
    
}

#pragma mark - 网络请求获取数据
-(void)updatePassword{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [paramDic setObject:self.changePasswordView.oldPassword.text.md5String forKey:@"oldPwd"];
    [paramDic setObject:self.changePasswordView.password.text.md5String forKey:@"newPwd"];
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"updateFdPwd"];
    
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            
            NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"configInfo.plist"];
            
            NSMutableDictionary *localConfigDic=[[[NSMutableDictionary alloc]initWithContentsOfFile:filename] mutableCopy];
            if([localConfigDic count]==0){
                localConfigDic=[[NSMutableDictionary alloc] init];
            }
            [jbad.userInfoDic setValue:self.changePasswordView.password.text.md5String forKey:@"PWD"];
            [localConfigDic setValue:jbad.userInfoDic forKey:@"userInfo"];
            [localConfigDic writeToFile:filename  atomically:YES];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[resultDic objectForKey:@"Point"] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }])];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else{
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"请求失败----%@", error);
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败！"];
    }];
    
 
    
}

- (void)clickChangeBtn:(UIButton *)btn {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([self.changePasswordView.oldPassword.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入旧密码！"];
    }
    else if(![self.changePasswordView.oldPassword.text.md5String isEqualToString:[jbad.userInfoDic objectForKey:@"PWD"]]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"您输入的旧密码错误！"];
    }
    else if(self.changePasswordView.password.text.length<6){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"新密码的长度需大于6位！"];
    }
    else if(![self.changePasswordView.password.text isEqualToString:self.changePasswordView.repassword.text]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"两次输入的新密码不一致！"];
    }
    
    else{
        [self updatePassword];
    }
}

@end
