//
//  MainViewController.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/28.
//  Copyright © 2019 Jiubai. All rights reserved.
//



#import "MainViewController.h"
#import "DEFINE.h"
#import "MainView.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "LeaveViewController.h"
#import "SignInViewController.h"
#import "NoticeVC.h"
#import "StudentTalkingVC.h"
#import "ActivityVC.h"
#import "NoteVC.h"
#import "StudentStatusVC.h"
#import "StatisVC.h"
@interface MainViewController ()<UIScrollViewDelegate,MainDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,retain) MainView *mainView;

@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;
@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [self initView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshMain:) name:@"refreshMain" object:nil];
}

-(void) initNavBar{
    self.gk_navBarAlpha = 0.0f;
 
   
}
- (void)initView{
    [self.view addSubview:self.scrollView];
    [_scrollView addSubview:self.imageView];
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator bringSubviewToFront:self.view];
    [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
        if(IS_iPhoneX){
             make.top.equalTo(self.view).offset(0);
        }
        else{
             make.top.equalTo(self.view).offset(-20);
        }
       
        make.centerX.equalTo(self.view) ;
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(100);
    }];
    
    //初始数据
    NSMutableDictionary *mainData=[NSMutableDictionary new];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *title=[NSString stringWithFormat:@"%@(%@)",[jbad.userInfoDic objectForKey:@"SC_NAME"],[jbad.userInfoDic objectForKey:@"AC_NAME"]];
    [mainData setObject:title forKey:@"title"];
    [mainData setObject:@[@"0",@"0",@"0",@"0"] forKey:@"statistic"];
    [mainData setObject:@"0" forKey:@"sign_did"];
    [mainData setObject:@"0" forKey:@"sign_undo"];
    [mainData setObject:@"0" forKey:@"leave_did"];
    [mainData setObject:@"0" forKey:@"leave_undo"];
    [mainData setObject:@"0" forKey:@"record_undo"];
    MainView *mainView = [[MainView alloc]init];
    self.mainView=mainView;
    self.mainView.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.mainView.delegate = self;
    [self.mainView initData:mainData];
    [self.scrollView addSubview:self.mainView];
    
    [self getMainData];
    
}
- (void)refreshMain:(NSNotification *)notification{
   [self getMainData];
    
    
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
//loading
- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        //[_scrollView addSubview:self.activityIndicator];
        //设置小菊花的frame
        //self.activityIndicator.frame= CGRectMake(100, 100, 50, 50);
        //设置小菊花颜色
        _activityIndicator.color = [UIColor whiteColor];
        //设置背景颜色
        _activityIndicator.backgroundColor = [UIColor clearColor];
        //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
        _activityIndicator.hidesWhenStopped = YES;
        
    }
    return _activityIndicator;
}
//顶部图片 
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, kWidth, headerHeight)];
        _imageView.image = [UIImage imageNamed:@"indeximh"];
    }
    return _imageView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 偏移量y的变化
    CGFloat dy = scrollView.contentOffset.y;
    //NSLog(@"%f", dy);
    // 判断拉倒方向
    if (dy < 0) {
        // 利用公式
        _imageView.frame =CGRectMake(-(-dy * ((kWidth) /headerHeight)) / 2, dy,(kWidth) - dy * ((kWidth) /headerHeight), headerHeight - dy);
        if(dy<-80){
            [self.activityIndicator startAnimating];
        }
    }
}

//即将结束拖拽

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if([self.activityIndicator isAnimating]){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getMainData];
        });
    }
    
    
    
}
- (void)clickMainBtn:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1000:
            [self.navigationController pushViewController:[NoticeVC new] animated:YES];
            break;
            
        case 1001:
            [self.navigationController pushViewController:[ActivityVC new] animated:YES];
            break;
            
        case 1002:
            [self.navigationController pushViewController:[StudentTalkingVC new] animated:YES];
            break;
        case 1003:
            [self.navigationController pushViewController:[StatisVC new] animated:YES];
            break;
           
        default:
            break;
    }
}

- (void)clickLeave {
    NSLog(@"clickLeave");
    LeaveViewController *tempVC=[LeaveViewController new] ;
    tempVC.selectIndex=0;
    [self.navigationController pushViewController:tempVC animated:YES];
}


- (void)clickRecord {
    NSLog(@"clickRecord");
    [self.navigationController pushViewController:[NoteVC new] animated:YES];
    
}


- (void)clickSign {
    NSLog(@"clickSign");
    SignInViewController *tempVC=[SignInViewController new] ;
    [self.navigationController pushViewController:tempVC animated:YES];
}

- (void)clickStatisticBtn:(UIButton *)sender {
    
    StudentStatusVC *jumpVC=[StudentStatusVC new];
    switch (sender.tag) {
        case 10000:
            jumpVC.status=@"上课中";
            [self.navigationController pushViewController:jumpVC animated:YES];
            break;
            
        case 10001:
            jumpVC.status=@"异动中";
            [self.navigationController pushViewController:jumpVC animated:YES];
            break;
            
        case 10002:
            jumpVC.status=@"在假中";
            [self.navigationController pushViewController:jumpVC animated:YES];
            break;
        case 10003:{
            //jumpVC.status=@"待销假";
            //[self.navigationController pushViewController:jumpVC animated:YES];
            LeaveViewController *tempVC=[LeaveViewController new] ;
            tempVC.selectIndex=2;
            [self.navigationController pushViewController:tempVC animated:YES];
            break;
        }
            
        default:
            break;
    }
    
}








#pragma mark - 首页数据
-(void)getMainData{
    
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *userInfoDic =jbad.userInfoDic;
    NSDictionary *paramDic = @{@"USER_ID":[userInfoDic objectForKey:@"USER_ID"]};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryHomeInfo"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.activityIndicator stopAnimating];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            
            resultDic=[resultDic objectForKey:@"Result"];
            NSString *title=[NSString stringWithFormat:@"%@(%@)",[userInfoDic objectForKey:@"SC_NAME"],[userInfoDic objectForKey:@"AC_NAME"]];
            NSMutableDictionary *mainData=[NSMutableDictionary new];
            [mainData setObject:title forKey:@"title"];
            [mainData setObject:@[[resultDic objectForKey:@"inclassCount"],[resultDic objectForKey:@"unusualActionCount"],[resultDic objectForKey:@"onLeaveCount"],[resultDic objectForKey:@"pendingCount"]] forKey:@"statistic"];
            [mainData setObject:[resultDic objectForKey:@"alreadylaunghCount"] forKey:@"sign_did"];
            [mainData setObject:[resultDic objectForKey:@"waitingLaunghCount"] forKey:@"sign_undo"];
            [mainData setObject:[resultDic objectForKey:@"alreadyLeaveCount"] forKey:@"leave_did"];
            [mainData setObject:[resultDic objectForKey:@"waitLeaveCount"] forKey:@"leave_undo"];
            
            //日志
            [mainData setObject:[[resultDic allKeys] containsObject:@"waitDealBeiwangCount"]?[resultDic objectForKey:@"waitDealBeiwangCount"]:@"0" forKey:@"record_undo"];
            [self.mainView removeFromSuperview];
            MainView *mainView = [[MainView alloc]init];
            self.mainView=mainView;
            self.mainView.frame = CGRectMake(0, 0, kWidth, kHeight);
            self.mainView.delegate = self;
            [self.mainView initData:mainData];
            [self.scrollView addSubview:self.mainView];
            
        }
        else{
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.activityIndicator stopAnimating];
        NSLog(@"请求失败----%@", error);
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败！"];
    }];
    
    
    
}

@end
