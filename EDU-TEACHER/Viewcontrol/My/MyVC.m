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
#import "ScanRegisterVC.h"
#import "SELUpdateAlert.h"
#import "SVProgressHUD.h"
#import "CIImage+Extension.h"
#import "YYKit.h"
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
            [self createQrcodeImage];
        }
            break;
        case 101:
        {
            LabelVC *jumpVC=[[LabelVC alloc] init];
            [self.navigationController pushViewController:jumpVC animated:YES];
        }
            break;
            
        case 102:
        {
            SettingVC *jumpVC=[[SettingVC alloc] init];
            [self.navigationController pushViewController:jumpVC animated:YES];
            
        }
            break;
            
        case 103:
        {
            AboutVC *jumpVC=[AboutVC new];
             [self.navigationController pushViewController:jumpVC animated:YES];
        }
            break;
         
        default:
            break;
            
    }
}


#pragma mark - 生成二维码
-(void)createQrcodeImage{
    
    
    //原来机密验证信息生成二维码，取消了
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
//    //{"type":"scan","fdid":"149","sign":"379c9230ba9ffddfb2aa74259f680290"}
//    NSString *signStr=[NSString stringWithFormat:@"(scan:%@)",[jbad.userInfoDic objectForKey:@"USER_ID"]];
//    NSString *info = [NSString stringWithFormat:@"{\"type\":\"scan\",\"fdid\":\"%@\",\"sign\":\"%@\"}",[jbad.userInfoDic objectForKey:@"USER_ID"],signStr.md5String];
    NSString *info =[NSString stringWithFormat:@"%@scanning_login.html?teacher_id=%@",jbad.schoolLiftUrl,[jbad.userInfoDic objectForKey:@"USER_ID"]];  
    [SELUpdateAlert showUpdateAlertWithVersion:@"" Descriptions:@[@"扫描二维码，注册在校园"] Image:[self createImgQRCodeWithString:info centerImage:[UIImage imageNamed:@"round_icon"]]];
     
}
/**

 生成二维码(中间有小图片)
 QRStering：所需字符串
 centerImage：二维码中间的image对象 
 */

- (UIImage *)createImgQRCodeWithString:(NSString *)QRString centerImage:(UIImage *)centerImage{

    // 创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 恢复滤镜的默认属性
    [filter setDefaults];
    // 将字符串转换成 NSdata
    NSData *dataString = [QRString dataUsingEncoding:NSUTF8StringEncoding];
    // 设置过滤器的输入值, KVC赋值
    [filter setValue:dataString forKey:@"inputMessage"];
    // 获得滤镜输出的图像
    CIImage *outImage = [filter outputImage];
    // 图片小于(27,27),我们需要放大
    outImage = [outImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    // 将CIImage类型转成UIImage类型
    UIImage *startImage = [UIImage imageWithCIImage:outImage];
    // 开启绘图, 获取图形上下文
    UIGraphicsBeginImageContext(startImage.size);
    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
    [startImage drawInRect:CGRectMake(0, 0, startImage.size.width, startImage.size.height)];
    // 再把小图片画上去
    CGFloat icon_imageW = 200;
    CGFloat icon_imageH = icon_imageW;
    CGFloat icon_imageX = (startImage.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (startImage.size.height - icon_imageH) * 0.5;
    [centerImage drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    // 获取当前画得的这张图片
    UIImage *qrImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    //返回二维码图像
    return qrImage;

}

- (void)clickMyInfoBtn:(UIButton *)btn {
    
    MyinfoVC *myinfoVC= [[MyinfoVC alloc] init];
    myinfoVC.myModel=self.myModel;
    [self.navigationController pushViewController:myinfoVC animated:YES];
}

- (void)clickLogOutBtn:(UIButton *)btn {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要退出吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //退出
        LGSocketServe *socketServe = [LGSocketServe sharedSocketServe];
        [socketServe logOutSocket];
        //[socketServe cutOffSocket];
        
        
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
