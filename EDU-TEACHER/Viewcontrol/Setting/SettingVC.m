//
//  SettingVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "SettingVC.h"
#import "DEFINE.h"
#import "SettingView.h"
#import "ChangePasswordVC.h"
#import "SDImageCache.h"
#import <WebKit/WebKit.h>
@interface SettingVC ()<SettingDelegate>
@property (nonatomic,retain) SettingView *settingView;
@end

@implementation SettingVC

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
    self.gk_navTitle=@"设置";
    self.gk_navTitleColor=[UIColor blackColor];
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initView{
    
    SettingView *settingView = [[SettingView alloc]init];
    self.settingView=settingView;
    self.settingView.frame = CGRectMake(0, kNavBarHeight, kWidth, kHeight-kNavBarHeight);
    self.settingView.delegate = self;
    [self.view addSubview:self.settingView];
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    NSString *cochSize=[self getCacheSizeWithFilePath:cachPath];
    UILabel *cochLabel=[self.settingView viewWithTag:1001];
    cochLabel.text=cochSize;
    
}


- (void)clickMenuBtn:(UIButton *)btn {
    NSLog(@"btn.tag:%ld",(long)btn.tag);
    switch (btn.tag) {
        case 100:
        {
            ChangePasswordVC *jumpVC=[ChangePasswordVC new];
            [self.navigationController pushViewController:jumpVC animated:YES];
        }
            break;
            
        case 101:
        {
            UILabel *temp= [self.settingView viewWithTag:1000+(btn.tag-100)];
            NSLog(@"btn.value%@",temp.text);
            UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"缓存数据有助于再次浏览或离线查看，你确定要清除缓存吗？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定清除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
                NSString *cochSize=@"0.0";
                UILabel *cochLabel=[self.settingView viewWithTag:1001];
                cochLabel.text=[NSString stringWithFormat:@"%@M",cochSize ];
                [self clearCacheWithFilePath:cachPath];
                [self deleteWebCache];
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [actionSheet addAction:action1];
            [actionSheet addAction:action2];
            //相当于之前的[actionSheet show];
            [self presentViewController:actionSheet animated:YES completion:nil];
        }
            break;
            
        case 102:
        {
            
        }
            break;
            
        default:
            break;
            
    }
}

/**
 *  计算沙盒相关路径的缓存
 *
 *  @param path 沙盒的路径
 *
 *  @return 缓存的大小（字符串）
 */
- (NSString *)getCacheSizeWithFilePath:(NSString *)path{
    NSArray *subPathArr = [[NSFileManager defaultManager] subpathsAtPath:path];
    NSString *filePath  = nil;
    NSInteger totleSize = 0;
    for (NSString *subPath in subPathArr){
        filePath =[path stringByAppendingPathComponent:subPath];
        BOOL isDirectory = NO;
        BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        if (!isExist || isDirectory || [filePath containsString:@".DS"]){
            continue;
        }
        NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        NSInteger size = [dict[@"NSFileSize"] integerValue];
        totleSize += size;
    }
    NSString *totleStr = nil;
    if (totleSize > 1000 * 1000){
        totleStr = [NSString stringWithFormat:@"%.2fM",totleSize / 1000.00f /1000.00f];
    }else if (totleSize > 1000){
        totleStr = [NSString stringWithFormat:@"%.2fKB",totleSize / 1000.00f ];
    }else{
        totleStr = [NSString stringWithFormat:@"%.2fB",totleSize / 1.00f];
    }
    return totleStr;
}


/**
 *  清除沙盒相关路径的缓存
 *
 *  @param path 沙盒相关路径
 *
 *  @return 是否清除成功
 */

- (BOOL)clearCacheWithFilePath:(NSString *)path{
    
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    NSString *filePath = nil;
    NSError *error = nil;
    for (NSString *subPath in subPathArr)
    {
        filePath = [path stringByAppendingPathComponent:subPath];
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"-----清除缓存的错误信息------%@",error);
            return NO;
        }
    }
    return YES;
}
/**
 *  清除webView控件的缓存
 */

- (void)deleteWebCache {
    
    /**
     *  清除WKWebView的缓存
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {//版本判断 >= iOS9,只有iOS9的WKWebView才有清除下面的方法
        
        NSSet *websiteDataTypes
        
        = [NSSet setWithArray:@[
                                
                                WKWebsiteDataTypeDiskCache,
                                //WKWebsiteDataTypeOfflineWebApplicationCache,
                                WKWebsiteDataTypeMemoryCache,
                                //WKWebsiteDataTypeLocalStorage,
                                //WKWebsiteDataTypeCookies,
                                //WKWebsiteDataTypeSessionStorage,
                                //WKWebsiteDataTypeIndexedDBDatabases,
                                //WKWebsiteDataTypeWebSQLDatabases
                                
                                ]];
        
        //清除所有的web信息
        //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
        
    } else {
        
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
    /**
     *  清除UIWebView的缓存
     */
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    /**
     *  清除cookies
     */
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        
        [storage deleteCookie:cookie];
    }
}

@end
