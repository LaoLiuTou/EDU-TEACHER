//
//  AddStudentPunishVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/24.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AddStudentPunishVC.h"
#import "DateTimePickerView.h"
#import "DEFINE.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "AddStudentPunishView.h"
@interface AddStudentPunishVC ()<AddStudentPunishDelegate,UIScrollViewDelegate,DateTimePickerViewDelegate>
@property (nonatomic, strong) AddStudentPunishView *addStudentPunishView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DateTimePickerView *datePickerView;
@end


@implementation AddStudentPunishVC

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.gk_navTitle=@"创建学生处分";
    self.gk_navTitleColor=[UIColor blackColor];
}

- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化视图
- (void)initView{
    
    [self.view addSubview:self.scrollView];
    [self.view sendSubviewToBack:_scrollView];
    
    AddStudentPunishView *addStudentPunishView = [[AddStudentPunishView alloc]init];
    _addStudentPunishView=addStudentPunishView;
    //_addStudentTalkingView.frame = CGRectMake(0, 0, kWidth, kHeight);
    _addStudentPunishView.delegate = self;
    [_addStudentPunishView initViewWithId:self.xs_id Name:self.xs_name];
    //[self.view addSubview:_addStudentTalkingView];
    [self.scrollView addSubview:_addStudentPunishView];
    
    
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

#pragma mark - 网络请求获取数据
-(void)addItem{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [paramDic setObject:self.xs_id forKey:@"xs_id"];
    [paramDic setObject:self.addStudentPunishView.titleTextField.text forKey:@"name"];
    [paramDic setObject:self.addStudentPunishView.dateLabel.text forKey:@"date"];
    [paramDic setObject:self.addStudentPunishView.commentText.text forKey:@"comment"];
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"addStudentCf"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[resultDic objectForKey:@"Point"] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
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
    
    if([self.addStudentPunishView.titleTextField.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入处分标题！"];
    }
    else if(self.addStudentPunishView.titleTextField.text.length>50){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"处分标题不能超过50个汉字！"];
    }
    else if([self.addStudentPunishView.dateLabel.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择获得日期！"];
    }
    else if([self.addStudentPunishView.commentText.text isEqualToString:@"添加描述"]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入描述！"];
    }
    else if(self.addStudentPunishView.commentText.text.length>100){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"处分描述不能超过100个汉字！"];
    }
    else{
        [self addItem];
    }
}

- (void)clickTimeBtn:(UIButton *)btn {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    DateTimePickerView *pickerView = [[DateTimePickerView alloc] init];
    _datePickerView = pickerView;
    _datePickerView.delegate = self;
    _datePickerView.pickerViewMode = DatePickerViewDateMode;
    [self.view addSubview:_datePickerView];
    [pickerView showDateTimePickerView];
}
#pragma mark - delegate
- (void)didClickFinishDateTimePickerView:(NSString *)date{
    self.addStudentPunishView.dateLabel.text = date;
}

@end
