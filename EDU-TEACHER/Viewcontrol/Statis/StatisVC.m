//
//  StatisVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/13.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "StatisVC.h"
#import <WebKit/WebKit.h>
#import "DEFINE.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
@interface StatisVC ()<WKNavigationDelegate>
@property (nonatomic,strong) WKWebView * webView;
@end

@implementation StatisVC


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
    self.gk_navTitle=@"班级管理";
    self.gk_navTitleColor=[UIColor blackColor];
}
- (void)leftBarClick {
//    if ([self.webView canGoBack]) {
//        [self.webView goBack];
//
//    }else{
//        [self.view resignFirstResponder];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
    [self.view resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initView{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *statisUrl =[NSString stringWithFormat:@"%@?USER_ID=%@",jbad.statisUrl,[jbad.userInfoDic objectForKey:@"USER_ID"] ];
    if(statisUrl!=nil){
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+1, kWidth, kHeight - kNavBarHeight-1)];
       
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:statisUrl]];
        // 3.加载网页
        [_webView loadRequest:request];
        
        self.webView.navigationDelegate = self;
        // 最后将webView添加到界面
        [self.view addSubview:_webView];
        if(@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
} 

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    NSLog(@"webViewWebContentProcessDidTerminate:  当Web视图的网页内容被终止时调用。");
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [SVProgressHUD dismiss];
    NSLog(@"webView:didFinishNavigation:  响应渲染完成后调用该方法   webView : %@  -- navigation : %@  \n\n",webView,navigation);
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSLog(@"webView:didStartProvisionalNavigation:  开始请求  \n\n");
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSLog(@"webView:didCommitNavigation:   响应的内容到达主页面的时候响应,刚准备开始渲染页面应用 \n\n");
}


// error
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // 类似 UIWebView 的- webView:didFailLoadWithError:
    [SVProgressHUD dismiss];
    NSLog(@"webView:didFailProvisionalNavigation:withError: 启动时加载数据发生错误就会调用这个方法。  \n\n");
}



- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"webView:didFailNavigation: 当一个正在提交的页面在跳转过程中出现错误时调用这个方法。  \n\n");
}



#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *requestString = navigationAction.request.URL.absoluteString;
    NSLog(@"xxxxx%@",requestString);
    //[self dismissViewControllerAnimated:NO completion:nil];
    decisionHandler(WKNavigationActionPolicyAllow);
    
}
@end

