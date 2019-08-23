//
//  AttaVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/15.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AttaVC.h"
#import <WebKit/WebKit.h>
#import "DEFINE.h"

@interface AttaVC ()<WKNavigationDelegate>
@property (nonatomic,strong) WKWebView * webView;
@end

@implementation AttaVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
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
    self.gk_navTitle=@"查看附件";
    self.gk_navTitleColor=[UIColor blackColor];
}
- (void)leftBarClick {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
        
    }else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)initView{
    if(self.url!=nil){
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+1, kWidth, kHeight - kNavBarHeight-1)];
        
        NSString *lastName =[[self.url lastPathComponent] lowercaseString];
        //先判断是 TXT 文件
        if ([lastName containsString:@".txt"]) {
            NSData *data = [NSData dataWithContentsOfURL:self.url];
            [self.webView loadData:data MIMEType:@"text/html" characterEncodingName:@"UTF-8" baseURL:self.url];
        }
        else{
            [_webView loadFileURL:self.url allowingReadAccessToURL:self.url];
        }
        
        self.webView.navigationDelegate = self;
        // 最后将webView添加到界面
        [self.view addSubview:_webView];
        if(@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
   
}



#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *requestString = navigationAction.request.URL.absoluteString;
    NSLog(@"xxxxx%@",requestString);
    decisionHandler(WKNavigationActionPolicyAllow);
}
@end
