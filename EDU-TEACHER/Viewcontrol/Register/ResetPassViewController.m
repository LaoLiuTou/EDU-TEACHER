//
//  ResetPassViewController.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/28.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "ResetPassViewController.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "VerifyUtil.h"
#import "ResetPassView.h"
#import "DEFINE.h"
#import "YYKit.h"
#import "SVProgressHUD.h"
@interface ResetPassViewController ()<ResetPassDelegate>
@property (nonatomic,strong) ResetPassView *resetPassView;
@property (nonatomic,strong) UIButton *codeBtn;
@end

@implementation ResetPassViewController{
    NSInteger secondsCountDown;
    NSString *reciveCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [self initView];
}

#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_black") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) initView{
    self.view.backgroundColor = [UIColor whiteColor];
    ResetPassView *resetPassView = [[ResetPassView alloc]init];
    _resetPassView=resetPassView;
    _resetPassView.frame = CGRectMake(0, 0, kWidth, kHeight);
    _resetPassView.delegate = self;
    [self.view addSubview:_resetPassView];
}


- (void)clickSubmitBtn:(UIButton *)btn paramDic:(NSDictionary *)paramDic {
    if(![VerifyUtil isVaildMobileNo: [paramDic objectForKey:@"phone"] ]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入正确的手机号码！"];
    }
    else if([[paramDic objectForKey:@"code"] isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入验证码！"];
    }
    else if(![reciveCode isEqual:[paramDic objectForKey:@"code"]]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"验证码不正确！"];
    }
    else if([[paramDic objectForKey:@"password"] isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入密码！"];
    }
    else if(![[paramDic objectForKey:@"password"] isEqual: [paramDic objectForKey:@"repassword"]]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"两次输入密码不一致！"];
    }
    else{
        [self resetPassword:paramDic];
    }
    
}
#pragma 验证码
- (void)clickCodeBtn:(UIButton *)btn phone:(NSString *)phone {
    if([VerifyUtil isVaildMobileNo:phone]){
        secondsCountDown=60;
        _codeBtn=btn;
        _codeBtn.userInteractionEnabled = NO;
        [_codeBtn setTitle:@"60s" forState:UIControlStateNormal];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod:) userInfo:nil repeats:YES];
        [self getCode:phone];
    }
    else{
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入正确的手机号！"];
    }
    
}
-(void)timeFireMethod:(NSTimer *)countDownTimer{
    secondsCountDown--;
    [_codeBtn setTitle:[NSString stringWithFormat:@"%lds",secondsCountDown] forState:UIControlStateNormal];
    if(secondsCountDown == 0){
        [countDownTimer invalidate];
        [_codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        _codeBtn.userInteractionEnabled = YES;
    }
}

#pragma mark - 获取验证码
-(void)getCode:(NSString *)phone{
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *paramDic = @{@"PH_P":phone};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"sendMessageCode"];
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            
            self->reciveCode=[resultDic objectForKey:@"Result"];
        }
        else{
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败----%@", error);
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败"];
    }];

}

#pragma mark - 修改密码
-(void)resetPassword:(NSDictionary *)resetDic{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *newPassword=[NSString stringWithFormat:@"%@",[resetDic objectForKey:@"password"]];
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    [paramDic setObject:[resetDic objectForKey:@"phone"] forKey:@"phone"];
    [paramDic setObject:newPassword.md5String forKey:@"newpassword"];
    [paramDic setObject:@"辅导员" forKey:@"type"];
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"recoverPassword"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码重置成功！" preferredStyle:UIAlertControllerStyleAlert];
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
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败"];
    }];
    
    
}
@end

