//
//  RegisterViewController.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterView.h"
#import "DEFINE.h"
#import "ConverseTool.h"
#import "Register2ViewController.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "VerifyUtil.h"
@interface RegisterViewController ()<RegisterDelegate>
@property (nonatomic,strong) RegisterView *registerView;
@property (nonatomic,strong) UIButton *codeBtn;
@end

@implementation RegisterViewController{
    NSInteger secondsCountDown;
    NSString *reciveCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"1/2  " style:(UIBarButtonItemStyleDone) target:self action:nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.gk_navRightBarButtonItem = rightitem; 
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) initView{
     self.view.backgroundColor = [UIColor whiteColor];
    RegisterView *registerView = [[RegisterView alloc]init];
    _registerView=registerView;
    _registerView.frame = CGRectMake(0, 0, kWidth, kHeight);
    _registerView.delegate = self;
    [self.view addSubview:_registerView];
}
 
- (void)clickNextBtn:(UIButton *)btn registerModel:(RegisterModel *)registerModel {
    if(![VerifyUtil isVaildRealName:registerModel.username]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入真实姓名！"];
    }
    else if(![VerifyUtil isVaildMobileNo: registerModel.phone]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入正确的手机号码！"];
    }
    else if([registerModel.code isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入验证码！"];
    }
    else if(![reciveCode isEqual:registerModel.code]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"验证码不正确！"];
    }
    
//    else if([registerModel.password isEqualToString:@""]){
//        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入密码！"];
//    }
    
    else if(![self checkPassword:registerModel.password]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"密码必须为8-16位数字与字母组合！"];
    }
    else if(![registerModel.password isEqual: registerModel.repassword]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"两次输入密码不一致！"];
    }
    else{
        Register2ViewController *rvc=[Register2ViewController new];
        rvc.registerModel=registerModel;
        [self.navigationController pushViewController:rvc animated:YES];
    }
    
}
-(BOOL)checkPassword:(NSString *) password
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{8,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
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
            self->reciveCode=[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"Result"]];
        }
        else{
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败----%@", error);
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败"];
    }];
    
}

@end
