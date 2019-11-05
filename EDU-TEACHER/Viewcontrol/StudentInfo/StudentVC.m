//
//  StudentVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/19.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "StudentVC.h"
#import "DEFINE.h" 
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "StudentView.h"
#import "StudentModel.h"
#import "MessageModel.h"
#import "SHChatMessageViewController.h"
#import "StudentInfoVC.h"
#import <MessageUI/MessageUI.h>
#import "SchoolReportVC.h"
#import "StudentTalkingVC.h"
#import "StudentAttentVC.h"
#import "StudentHelpVC.h"
#import "StudentPunishVC.h"
#import "StudentHonorVC.h"
#import "StudentClassVC.h"
#import <WebKit/WebKit.h>
@interface StudentVC ()<UIScrollViewDelegate,StudentDelegate,MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic, strong)  StudentView *studentView;
@property (nonatomic, strong) StudentModel *studentModel;
@property (nonatomic, strong) UIBarButtonItem *rightitem;
@property (nonatomic, strong) UIButton *rightButton;
@end

@implementation StudentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self.view addSubview:self.scrollView];
    [self.view sendSubviewToBack:_scrollView];
    [_scrollView addSubview:self.imageView];
    //[self initView];
    [self getNetworkData];
}
#pragma mark - nav设置
- (void)initNavBar {
    
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_white") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
//    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarClick)];
//    _rightitem=rightitem;
//    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//    [rightitem setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    
    //文字加图片
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton=rightButton;
    UIImage *addImage = [self reSizeImage:[UIImage imageNamed:@"xinjian"] toSize:CGSizeMake(16, 16)];
    [_rightButton setImage:addImage forState:UIControlStateNormal];
    [_rightButton setTitle:@"特别关注" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _rightButton.frame = CGRectMake(0,0,80,20);
    [_rightButton addTarget:self action:@selector(rightBarClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    _rightitem=barButtonItem;
    self.gk_navRightBarButtonItem = barButtonItem;
    
    
    //self.gk_navBackgroundColor=[UIColor clearColor];
    self.gk_navBackgroundColor=GKColorHEX(0x2c92f5, 1);
    self.gk_navTitleColor=[UIColor whiteColor];
    self.gk_navBarAlpha = 0.0f;
}
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContextWithOptions(reSize, NO, [[UIScreen mainScreen] scale]);
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarClick {
    //[self.navigationController pushViewController:[AddNoticeVC new] animated:YES];
    
    
    if([_rightButton.titleLabel.text isEqualToString:@"特别关注"]){
        [self attentionType:@"1"];
    }
    else{
         [self attentionType:@"2"];
    }
    
}


- (void)initView{
    
    
    StudentView *studentView = [[StudentView alloc]init];
    self.studentView=studentView;
    self.studentView.frame = CGRectMake(0, 0, kWidth, kHeight+60);
    self.studentView.delegate = self;
    [self.studentView initViewModel:self.studentModel];
    [self.scrollView addSubview:self.studentView];
    
    [self addBottomButton];
}

//底部button
-(void) addBottomButton{
    UIView *btnView=[[UIView alloc] init];
    btnView.backgroundColor=GKColorHEX(0xf7f7f7, 1);
    [self.view addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-60-BottomPaddingHeight);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(60);
    }];
    UIButton *chatBtn=[[UIButton alloc] init];
    chatBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [chatBtn addTarget:self action:@selector(clickChatBtn:) forControlEvents:UIControlEventTouchUpInside];
    [chatBtn setTitle:@"发送消息" forState:UIControlStateNormal];
    chatBtn.layer.cornerRadius=14;
    chatBtn.layer.masksToBounds=YES;
    chatBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
    [chatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnView addSubview:chatBtn];
    [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnView).offset(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo((kWidth-50)/3);
        make.height.mas_equalTo(40);
    }];
    UIButton *telBtn=[[UIButton alloc] init];
    telBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [telBtn addTarget:self action:@selector(clickTelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [telBtn setTitle:@"拨打电话" forState:UIControlStateNormal];
    telBtn.layer.cornerRadius=14;
    telBtn.layer.masksToBounds=YES;
    telBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
    [telBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnView addSubview:telBtn];
    [telBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnView).offset(10);
        make.left.equalTo(chatBtn.mas_right).offset(10);
        make.width.mas_equalTo((kWidth-50)/3);
        make.height.mas_equalTo(40);
    }];
    UIButton *messageBtn=[[UIButton alloc] init];
    messageBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [messageBtn addTarget:self action:@selector(clickMessageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [messageBtn setTitle:@"发送短信" forState:UIControlStateNormal];
    messageBtn.layer.cornerRadius=14;
    messageBtn.layer.masksToBounds=YES;
    messageBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
    [messageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnView addSubview:messageBtn];
    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnView).offset(10);
        make.left.equalTo(telBtn.mas_right).offset(10);
        make.width.mas_equalTo((kWidth-50)/3);
        make.height.mas_equalTo(40);
    }];
    
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, kWidth, kHeight-60)];
        _scrollView.backgroundColor=[UIColor whiteColor];
        _scrollView.contentSize =CGSizeMake(0,kHeight+70);
        
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
  
        self.gk_navTitle=self.studentModel.NM_T;
        self.gk_navBarAlpha = 1.0f;
    }
}




#pragma mark - 网络请求获取数据
-(void)getNetworkData{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *paramDic = @{@"USER_ID":[jbad.userInfoDic objectForKey:@"USER_ID"],@"xs_id": self.studentId};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryStudentDetail"];
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            
            StudentModel *model=[[StudentModel alloc] initWithDic:[resultDic objectForKey:@"Result"]];
            self.studentModel=model;
            //[self.pageScrollView refreshHeaderView];
            if([model.att_status isEqualToString:@"已关注"]){
                [self.rightButton setImage:nil forState:UIControlStateNormal];
                [self.rightButton setTitle:@"取消关注" forState:UIControlStateNormal];
                
            }
            else{
                UIImage *addImage = [self reSizeImage:[UIImage imageNamed:@"xinjian"] toSize:CGSizeMake(16, 16)];
                [self.rightButton setImage:addImage forState:UIControlStateNormal];
                [self.rightButton setTitle:@"特别关注" forState:UIControlStateNormal];
            }
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

#pragma mark - 关注取消
-(void)attentionType:(NSString *) type{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *paramDic = @{@"USER_ID":[jbad.userInfoDic objectForKey:@"USER_ID"],@"xs_id": self.studentId,@"type":type};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"attentionStudent"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            if([type isEqualToString:@"1"]){
                
                [self.rightButton setImage:nil forState:UIControlStateNormal];
                [self.rightButton setTitle:@"取消关注" forState:UIControlStateNormal];
            }
            else{
                UIImage *addImage = [self reSizeImage:[UIImage imageNamed:@"xinjian"] toSize:CGSizeMake(16, 16)];
                [self.rightButton setImage:addImage forState:UIControlStateNormal];
                [self.rightButton setTitle:@"特别关注" forState:UIControlStateNormal];
            }
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

- (void)clickChatBtn:(UIButton *)btn {
    
    MessageModel *messageModel=[[MessageModel alloc] init];
    messageModel.FRIEND_ID=self.studentModel.USER_ID;
    messageModel.FRIEND_NAME=self.studentModel.NM_T;
    messageModel.FRIEND_IMAGE=self.studentModel.I_UPIMG;
    SHChatMessageViewController *chatView= [[SHChatMessageViewController alloc] init];
    chatView.model=messageModel;
    [self.navigationController pushViewController:chatView animated:YES];
}
- (void)clickTelBtn:(UIButton *)btn {
    NSLog(@"btn.tag:%ld",(long)btn.tag);
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.studentModel.PH_P];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
 
}
- (void)clickMessageBtn:(UIButton *)btn {
    NSLog(@"btn.tag:%ld",(long)btn.tag);
    if( [MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = @[self.studentModel.PH_P];//发送短信的号码，数组形式入参
        //controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = @""; //此处的body就是短信将要发生的内容
        controller.messageComposeDelegate = self;
        controller.modalPresentationStyle=UIModalPresentationFullScreen;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:[NSString stringWithFormat:@"发短信给%@",self.studentModel.PH_P]];//修改短信界面标题
    }
    else {
        [[LTAlertView new] showOneChooseAlertViewMessage:@"该设备不支持短信功能！"];
    }
}
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            break;
        default:
            break;
    }
}
- (void)clickMenuBtn:(UIButton *)btn {
    NSLog(@"btn.tag:%ld",(long)btn.tag);
    switch (btn.tag) {
        case 100:
        {
            SchoolReportVC *jumpVC=[[SchoolReportVC alloc] init];
            jumpVC.xs_id=self.studentModel.id;
            [self.navigationController pushViewController:jumpVC animated:YES];
        }
            break;
            
        case 101:
        {
            StudentTalkingVC *jumpVC=[[StudentTalkingVC alloc] init];
            jumpVC.xs_id=self.studentModel.id;
            jumpVC.xs_name=self.studentModel.NM_T;
            [self.navigationController pushViewController:jumpVC animated:YES];
        }
            break;
            
        case 102:
        {
            StudentAttentVC *jumpVC=[[StudentAttentVC alloc] init];
            jumpVC.xs_id=self.studentModel.id;
            jumpVC.xs_name=self.studentModel.NM_T;
            [self.navigationController pushViewController:jumpVC animated:YES];
        }
            break;
        case 103:
        {
            StudentHelpVC *jumpVC=[[StudentHelpVC alloc] init];
            jumpVC.xs_id=self.studentModel.id;
            jumpVC.xs_name=self.studentModel.NM_T;
            [self.navigationController pushViewController:jumpVC animated:YES];
        }
            break;
        case 104:
        {
            StudentHonorVC *jumpVC=[[StudentHonorVC alloc] init];
            jumpVC.xs_id=self.studentModel.id;
            jumpVC.xs_name=self.studentModel.NM_T;
            [self.navigationController pushViewController:jumpVC animated:YES];
            
        }
            break;
        case 105:
        {
            StudentPunishVC *jumpVC=[[StudentPunishVC alloc] init];
            jumpVC.xs_id=self.studentModel.id;
            jumpVC.xs_name=self.studentModel.NM_T;
            [self.navigationController pushViewController:jumpVC animated:YES];
        }
            break;
        case 106:
        {
            StudentClassVC *jumpVC=[[StudentClassVC alloc] init];
            jumpVC.xs_id=self.studentModel.id;
            jumpVC.xs_name=self.studentModel.NM_T;
            [self.navigationController pushViewController:jumpVC animated:YES];
        }
            break;
        default:
            break;
            
    }
}

- (void)clickStudentInfoBtn:(UIButton *)btn {
    
    StudentInfoVC *studentInfoVC= [[StudentInfoVC alloc] init];
    studentInfoVC.studentModel=self.studentModel;
    [self.navigationController pushViewController:studentInfoVC animated:YES];
}

 

@end
