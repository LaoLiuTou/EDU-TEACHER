//
//  MyVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "MyVC.h"
#import "DEFINE.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "MyView.h"
#import "LoginViewController.h"
#import "MyinfoVC.h"
#import "LabelVC.h"
#import "SettingVC.h"
#import "AboutVC.h"
@interface MyVC ()<UIScrollViewDelegate,MyDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) MyView *myView;
@property (nonatomic,strong) MyModel *myModel;

@end

@implementation MyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self.view addSubview:self.scrollView];
    [self.view sendSubviewToBack:_scrollView];
    [_scrollView addSubview:self.imageView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self getNetworkData];
}
#pragma mark - nav设置
- (void)initNavBar {
    
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    
    self.gk_navLineHidden=YES;
     
    //self.gk_navBackgroundColor=[UIColor clearColor];
    self.gk_navBackgroundColor=GKColorHEX(0x2c92f5, 1);
    self.gk_navTitleColor=[UIColor whiteColor];
    self.gk_navBarAlpha = 0.0f;
}
 

- (void)initView{
    
    
    MyView *myView = [[MyView alloc]init];
    self.myView=myView;
    //self.myView.frame = CGRectMake(0, 0, kWidth, kHeight+60);
    self.myView.delegate = self;
    [self.myView initViewModel:self.myModel];
    [self.scrollView addSubview:self.myView];
    
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, kWidth, kHeight)];
        _scrollView.backgroundColor=[UIColor whiteColor];
        _scrollView.contentSize =CGSizeMake(0,kHeight+10);
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        // 设置代理人
        _scrollView.delegate =self;
        
    }
    return _scrollView;
}
//顶部图片
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, kWidth, headerHeight)];
        _imageView.image = [UIImage imageNamed:@"txl-bg1"];
    }
    return _imageView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat alpha = 0;
    // 偏移量y的变化
    CGFloat dy = scrollView.contentOffset.y;
    //NSLog(@"%f", dy);
    // 判断拉倒方向
    if (dy < 0) {
        // 利用公式
        _imageView.frame =CGRectMake(-(-dy * ((kWidth) /headerHeight)) / 2, dy,(kWidth) - dy * ((kWidth) /headerHeight), headerHeight - dy);
        self.gk_navBarAlpha = 0.0f;
        self.gk_navTitle=@"";
    }
    else if (dy <= 60.0f&&dy > 0) {
        alpha = dy/60;
        self.gk_navBarAlpha =alpha;
    }
    else if (dy > 60.0f) {
        
        self.gk_navTitle=self.myModel.name;
        self.gk_navBarAlpha = 1.0f;
    }
}

#pragma mark - 网络请求获取数据
-(void)getNetworkData{
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *paramDic = @{@"USER_ID":[jbad.userInfoDic objectForKey:@"USER_ID"]};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"querySelfInfo"];
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            MyModel *model=[[MyModel alloc] initWithDic:[resultDic objectForKey:@"Result"]];
            self.myModel=model;
            [self initView];
        }
        else{
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败----%@", error);
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败！"];
    }];
    
    
}
- (void)clickMenuBtn:(UIButton *)btn {
    NSLog(@"btn.tag:%ld",(long)btn.tag);
    switch (btn.tag) {
        case 100:
        {
            LabelVC *jumpVC=[[LabelVC alloc] init];
            [self.navigationController pushViewController:jumpVC animated:YES];
        }
            break;
            
        case 101:
        {
            SettingVC *jumpVC=[[SettingVC alloc] init];
            [self.navigationController pushViewController:jumpVC animated:YES];
            
        }
            break;
            
        case 102:
        {
            AboutVC *jumpVC=[AboutVC new];
             [self.navigationController pushViewController:jumpVC animated:YES];
        }
            break;
         
        default:
            break;
            
    }
}

- (void)clickMyInfoBtn:(UIButton *)btn {
    
    MyinfoVC *myinfoVC= [[MyinfoVC alloc] init];
    myinfoVC.myModel=self.myModel;
    [self.navigationController pushViewController:myinfoVC animated:YES];
}

- (void)clickLogOutBtn:(UIButton *)btn {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要退出吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"configInfo.plist"];
        
        NSMutableDictionary *localConfigDic=[[[NSMutableDictionary alloc]initWithContentsOfFile:filename] mutableCopy];
        if([localConfigDic count]==0){
            localConfigDic=[[NSMutableDictionary alloc] init];
        }
        [localConfigDic setValue:@{} forKey:@"userInfo"];
        [localConfigDic setValue:@"false" forKey:@"isLogin"];
        [localConfigDic writeToFile:filename  atomically:YES]; 
        //[self presentViewController:[LoginViewController new] animated:YES completion:nil];
        NSMutableArray *ViewCtr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers]; 
        [ViewCtr removeAllObjects];
        [ViewCtr addObject:[LoginViewController new]];
        [self.navigationController setViewControllers:ViewCtr animated:YES];
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}


@end
