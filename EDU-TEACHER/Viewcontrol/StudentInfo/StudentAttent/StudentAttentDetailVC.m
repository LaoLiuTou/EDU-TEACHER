//
//  StudentAttentDetailVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "StudentAttentDetailVC.h"
#import "DEFINE.h"
#import "AppDelegate.h"
#import "YYKit.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "StudentAttentDetailView.h"
#import "StudentAttentModel.h"
@interface StudentAttentDetailVC ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) StudentAttentDetailView *studentAttentDetailView;
@property (nonatomic, strong) StudentAttentModel *studentAttentModel;
@end

@implementation StudentAttentDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initNavBar];
    [self getNetworkData];
}
#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_black") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    self.gk_navBackgroundColor=[UIColor whiteColor];
    self.gk_navTitle=@"心理关注查看";
    self.gk_navTitleColor=[UIColor blackColor];
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initView{
    [self.view addSubview:self.scrollView];
    [self.view sendSubviewToBack:_scrollView];
    
    StudentAttentDetailView *studentAttentDetailView = [[StudentAttentDetailView alloc]init];
    self.studentAttentDetailView=studentAttentDetailView;
    //self.studentView.frame = CGRectMake(0, 0, kWidth, kHeight);
    int y=[self.studentAttentDetailView initModel:self.studentAttentModel];
    [self.scrollView addSubview:self.studentAttentDetailView];
    _scrollView.contentSize =CGSizeMake(0,y+10);
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kNavBarHeight, kWidth, kHeight-kNavBarHeight)];
        _scrollView.backgroundColor=GKColorRGB(246, 246, 246);
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        // 设置代理人
        _scrollView.delegate =self;
        
    }
    return _scrollView;
}

#pragma mark - 网络请求获取数据
-(void)getNetworkData{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *paramDic = @{@"id":_detailId};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryStudentXlDetail"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            
            StudentAttentModel *model=[[StudentAttentModel alloc] initWithDic:[resultDic objectForKey:@"Result"]];
            self.studentAttentModel=model;
            [self initView];
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

@end
