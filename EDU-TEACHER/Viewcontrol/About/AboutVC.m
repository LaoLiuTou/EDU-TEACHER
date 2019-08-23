//
//  AboutVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/7.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AboutVC.h"
#import "AppDelegate.h"
#import "DEFINE.h" 
@interface AboutVC ()

@end

@implementation AboutVC

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
     
}

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
    self.gk_navLineHidden=NO;
    self.gk_navBackgroundColor=[UIColor whiteColor];
    self.gk_navTitle=@"关于在校园";
    self.gk_navTitleColor=[UIColor blackColor];
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)initView {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //CFShow(infoDictionary);
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    
    
    //手机序列号
    //  NSString* identifierNumber = [[UIDevice currentDevice] uniqueIdentifier];
    //  NSLog(@"手机序列号: %@",identifierNumber);
    //手机别名： 用户定义的名称
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    NSLog(@"手机别名: %@", userPhoneName);
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSLog(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSLog(@"手机型号: %@",phoneModel );
    //地方型号  （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    NSLog(@"国际化区域名称: %@",localPhoneModel );
    
    //    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSLog(@"当前应用名称：%@",appCurName);
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSLog(@"当前应用版本号码：%@",appCurVersionNum);
    
    
    NSLog(@"");
    
    
    UIView * backView=[[UIView alloc] init];
    [self.view addSubview:backView];
    backView.backgroundColor=[UIColor whiteColor];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kWidth);
        make.top.equalTo(self.view).offset(kNavBarHeight+1);
        make.height.mas_equalTo(kHeight-kNavBarHeight);
        
    }];
    
    
    
    UIImageView * logoImage=[[UIImageView alloc] init];
    logoImage.layer.cornerRadius = 12;
    logoImage.layer.masksToBounds = YES;
    [backView addSubview:logoImage];
    
    UILabel * titleLabel=[[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30.f];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    
    UILabel * versionLabel=[[UILabel alloc] init];
    [backView addSubview:versionLabel];
    versionLabel.textColor=GKColorHEX(0x999999,1);
    versionLabel.font=[UIFont systemFontOfSize:15];
    versionLabel.textAlignment=NSTextAlignmentCenter;
    
    UILabel * otherLabel=[[UILabel alloc] init];
    
    otherLabel.textColor=GKColorHEX(0x999999,1);
    otherLabel.numberOfLines=0;
    otherLabel.font=[UIFont systemFontOfSize:15];
    otherLabel.textAlignment=NSTextAlignmentCenter;
    
    [backView addSubview:otherLabel];
    
    
    [logoImage setImage:[UIImage imageNamed:@"logo"]];
    titleLabel.text=app_Name;
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    versionLabel.text=[NSString stringWithFormat:@"版本号: %@",jbad.ourVersion];
    otherLabel.text=@"在校园平台 免费客户端。辅导员日常事务管理，学生360度信息追踪。";
    
    
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(80);
        make.top.mas_equalTo(100);
        make.centerX.equalTo(backView.mas_centerX);
        
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(kWidth);
        make.centerX.equalTo(backView.mas_centerX);
        make.top.mas_equalTo(logoImage.mas_bottom).offset(20);
    }];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(kWidth);
        make.centerX.equalTo(backView.mas_centerX);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(20);
    }];
    
    CGFloat height = [otherLabel.text boundingRectWithSize:CGSizeMake(kWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil].size.height;
    [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height+5);
        make.width.mas_equalTo(kWidth-60);
        make.top.mas_equalTo(versionLabel.mas_bottom).offset(10);
        make.centerX.equalTo(backView.mas_centerX);
        
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.hidesBottomBarWhenPushed=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.hidesBottomBarWhenPushed=NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
