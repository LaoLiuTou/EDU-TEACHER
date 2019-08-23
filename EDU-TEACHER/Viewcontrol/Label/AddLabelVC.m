//
//  AddLabelVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AddLabelVC.h"
#import "DEFINE.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "AddLabelView.h"
#import "SelectStudentVC.h"
#import "LabelVC.h"
#import "ScrollAddLabel.h"
@interface AddLabelVC ()<AddLabelDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) AddLabelView *addLabelView;
@property (nonatomic, strong) UIScrollView *scrollView; 

@end

@implementation AddLabelVC{
    NSString *xs_names;
    NSString *xs_ids;
    NSDictionary *tempStudentDic;
    NSString *notificationName;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [self initView];
    //选择学生
    xs_names=@"";
    xs_ids=@"";
    tempStudentDic=[NSDictionary new];
    //注册通知：
    //注册通知：
    notificationName=@"SelectStudentAddLabel";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnSelectDic:) name:notificationName object:nil];
}

#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_black") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    self.gk_navBackgroundColor=[UIColor whiteColor];
    self.gk_navTitle=@"创建标签";
    self.gk_navTitleColor=[UIColor blackColor];
}

- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化视图
- (void)initView{
    
    [self.view addSubview:self.scrollView];
    [self.view sendSubviewToBack:_scrollView];
    
    AddLabelView *addLabelView = [[AddLabelView alloc]init];
    _addLabelView=addLabelView;
    //_addStudentTalkingView.frame = CGRectMake(0, 0, kWidth, kHeight);
    _addLabelView.delegate = self;
    //[self.view addSubview:_addStudentTalkingView];
    [self.scrollView addSubview:_addLabelView];
    
    
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kNavBarHeight, kWidth, kHeight-kNavBarHeight)];
        _scrollView.contentSize =CGSizeMake(0,kHeight-kNavBarHeight+1);
        _scrollView.backgroundColor=GKColorRGB(246, 246, 246);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        //_scrollView.contentSize =CGSizeMake(0,kHeight+10);
        // 设置代理人
        _scrollView.delegate =self;
        
    }
    return _scrollView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}
#pragma mark - 选择学生
- (void)clickSelectStu {
    NSLog(@"clickSelectStuBtn");
    
    xs_names=@"";
    xs_ids=@"";
    SelectStudentVC *jumpVC= [SelectStudentVC new];
    jumpVC.type=@"class";
    jumpVC.values=@{@"class":tempStudentDic};
    jumpVC.notificationName=notificationName;
    [self.navigationController pushViewController:jumpVC animated:YES];
    
    
}
- (void)returnSelectDic:(NSNotification *)notification{
    NSLog(@"SelectDic%@",notification.userInfo);
    //移除
    xs_names=@"";
    xs_ids=@"";
    NSArray *views = [self.addLabelView.stuScrollView subviews];
    for(UIView *view in views)
    {
        [view removeFromSuperview];
    }
    
    
    NSArray *stuIdArray=[notification.userInfo objectForKey:@"studentId"];
    NSArray *stuNameArray=[notification.userInfo objectForKey:@"studentName"];
    xs_ids=[stuIdArray count]>0?[stuIdArray componentsJoinedByString:@","]:@"";
    xs_names=[stuNameArray count]>0?[stuNameArray componentsJoinedByString:@","]:@"";
    tempStudentDic=[notification.userInfo objectForKey:@"tempValue"];
    //self.addLabelView.stuLabel.text=xs_names;
    [self.addLabelView.selectImage setHidden:YES];
    [[ScrollAddLabel new] addLabelToScrollView:self.addLabelView.stuScrollView labels:stuNameArray];
}

#pragma mark - 网络请求获取数据
-(void)addItem{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [paramDic setObject:xs_ids forKey:@"xs_ids"];
    [paramDic setObject:self.addLabelView.nameLabel.text forKey:@"name"];
    if(![self.addLabelView.remarkTextView.text isEqualToString:@""]){
        [paramDic setObject:self.addLabelView.remarkTextView.text forKey:@"remark"];
    }
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"addTag"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[resultDic objectForKey:@"Point"] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //[self.navigationController popViewControllerAnimated:YES];
                NSMutableArray *navViewArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                int index = (int)[navViewArray indexOfObject:self];
                [navViewArray removeObjectAtIndex:index];
                [navViewArray removeObjectAtIndex:index-1];
                [navViewArray addObject:[LabelVC new]];
                [self.navigationController setViewControllers:navViewArray animated:YES];
            }])];
            
            [self presentViewController:alertController animated:YES completion:nil];
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

#pragma mark - 发布
- (void)clickPublishBtn:(UIButton *)btn {
    NSLog(@"clickPublishBtn");
    if([self.addLabelView.nameLabel.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入标签名称！"];
    }
    else if(self.addLabelView.nameLabel.text.length>50){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"标签名称最多能输入50个汉字！"];
    }
    else if([xs_ids isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择标签对象！"];
    }
    else{
        [self addItem];
    }
    
}

 
@end
