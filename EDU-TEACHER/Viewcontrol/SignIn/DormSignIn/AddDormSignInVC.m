//
//  AddDormASignInVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/31.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AddDormSignInVC.h"
#import "DEFINE.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "AddDormSignInView.h"
#import "SelectStudentVC.h"
#import "DateTimePickerView.h"
#import "DevicesVC.h"
#import "SelectClassVC.h"
#import "SignInViewController.h"
#import "ResigninVC.h"
#import "ScrollAddLabel.h"
@interface AddDormSignInVC ()<AddDormSignInDelegate,UIScrollViewDelegate,DateTimePickerViewDelegate>
@property (nonatomic, strong) AddDormSignInView *addDormSignInView;
@property (nonatomic, strong) UIButton *publishBtn;

@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DateTimePickerView *datePickerView;
@end

@implementation AddDormSignInVC{
    NSString *xs_names;
    NSString *xs_ids;
    NSString *device_names;
    NSString *device_ids;
    NSString *xs_type;
    int tempTimeTag;
    NSString *resignin_value;
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
    xs_type=@"";
    tempStudentDic=[NSDictionary new];
    //选择设备
    device_names=@"";
    device_ids=@"";
    //重复
    resignin_value=@"";
    //注册通知：
    notificationName=@"SelectStudentDormSign";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnSelectDic:) name:notificationName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnDevicesDic:) name:@"SelectDevices" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnResigninDic:) name:@"SelectResignin" object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:@"SelectStudent" object:nil];
}
#pragma mark - nav设置
- (void)initNavBar {
    self.gk_navBarAlpha = 1.0f;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:GKImage(@"btn_back_black") target:self action:@selector(leftBarClick)];
    self.gk_navLineHidden=YES;
    self.gk_navBackgroundColor=[UIColor whiteColor];
    self.gk_navTitle=@"创建宿舍签到";
    self.gk_navTitleColor=[UIColor blackColor];
}

- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化视图
- (void)initView{
    self.view.backgroundColor=GKColorRGB(246, 246, 246);
    [self.view addSubview:self.publishBtn];
    [self.view addSubview:self.saveBtn];
    [self.view addSubview:self.scrollView];
    [self.view sendSubviewToBack:_scrollView];
    
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10-BottomPaddingHeight);
        make.width.mas_equalTo((kWidth-50)/2);
        make.height.mas_equalTo(40);
    }];
    [_publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset((kWidth/2)+10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10-BottomPaddingHeight);
        make.width.mas_equalTo((kWidth-50)/2);
        make.height.mas_equalTo(40);
    }];
    
    AddDormSignInView *addDormSignInView = [[AddDormSignInView alloc]init];
    _addDormSignInView=addDormSignInView;
    //_addStudentTalkingView.frame = CGRectMake(0, 0, kWidth, kHeight);
    _addDormSignInView.delegate = self;
    int height=[_addDormSignInView initView];
    //[self.view addSubview:_addStudentTalkingView];
    [self.scrollView addSubview:_addDormSignInView];
    _scrollView.contentSize =CGSizeMake(0,height>kHeight?height:kHeight+1);
    
    
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kNavBarHeight, kWidth, kHeight-kNavBarHeight-60-BottomPaddingHeight)];
        
        _scrollView.backgroundColor=GKColorRGB(246, 246, 246);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        //_scrollView.contentSize =CGSizeMake(0,kHeight+10);
        // 设置代理人
        _scrollView.delegate =self;
        
    }
    return _scrollView;
}
-(UIButton *)saveBtn{
    if (!_saveBtn) {
        UIButton *saveBtn=[[UIButton alloc] init];
        _saveBtn=saveBtn;
        _saveBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [_saveBtn addTarget:self action:@selector(clickSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_saveBtn setTitle:@"创建" forState:UIControlStateNormal];
        _saveBtn.layer.cornerRadius=12;
        _saveBtn.layer.masksToBounds=YES;
        _saveBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _saveBtn;
    
}
-(UIButton *)publishBtn{
    if (!_publishBtn) {
        UIButton *publishBtn=[[UIButton alloc] init];
        _publishBtn=publishBtn;
        _publishBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [_publishBtn addTarget:self action:@selector(clickPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_publishBtn setTitle:@"创建并发起" forState:UIControlStateNormal];
        _publishBtn.layer.cornerRadius=12;
        _publishBtn.layer.masksToBounds=YES;
        _publishBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
        [_publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _publishBtn;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}

#pragma mark - 创建
-(void)addActivity:(NSString *)type{
    if([self.addDormSignInView.nameText.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"签到名称不能为空！"];
    }
    else if(self.addDormSignInView.nameText.text.length>50){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"签到名称最多可输入50个汉字！"];
    }
    else if([device_ids isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择签到设备！"];
    }
    else if([self.addDormSignInView.sign_start_timeLabel.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择签到开始时间！"];
    }
    else if([self.addDormSignInView.sign_end_timeLabel.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择签到截止时间！"];
    }
    
    else if([xs_ids isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择签到范围！"];
    }
    else if(self.addDormSignInView.commentText.text.length>1000){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"活动内容最多可输入1000个汉字！"];
    }
    else if(![self.addDormSignInView.timesSwitch isOn]&&[resignin_value isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择重复时间！"];
    }
    else{
        
        [SVProgressHUD showWithStatus:@"加载中"];
        [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSMutableDictionary *paramDic =[NSMutableDictionary new];
        [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
        [paramDic setObject:self.addDormSignInView.nameText.text forKey:@"sign_name"];
        [paramDic setObject:self.addDormSignInView.sign_methodLabel.text forKey:@"sign_method"];
        [paramDic setObject:device_ids forKey:@"sign_deviceids"];
        
        if(![self.addDormSignInView.commentText.text isEqualToString:@"添加签到说明"]){
            [paramDic setObject:self.addDormSignInView.commentText.text forKey:@"comment"];
        }
        if([xs_type isEqualToString:@"class"]){
            [paramDic setObject:xs_ids forKey:@"class_ids"];
        }
        else{
            [paramDic setObject:xs_ids forKey:@"tag_ids"];
        }
        
        if([self.addDormSignInView.timesSwitch isOn]){
            [paramDic setObject:@"0" forKey:@"is_repeat"];
            [paramDic setObject:self.addDormSignInView.sign_start_timeLabel.text forKey:@"sign_start_time"];
            [paramDic setObject:self.addDormSignInView.sign_end_timeLabel.text forKey:@"sign_end_time"];
        }
        else{
            [paramDic setObject:@"1" forKey:@"is_repeat"];
            [paramDic setObject:self.addDormSignInView.sign_start_timeLabel.text forKey:@"repeat_start_time"];
            [paramDic setObject:self.addDormSignInView.sign_end_timeLabel.text forKey:@"repeat_end_time"];
        }
        if(![self.addDormSignInView.stoptimeLabel.text isEqualToString:@""]){
            [paramDic setObject:self.addDormSignInView.stoptimeLabel.text forKey:@"repeat_jiezhi_date"];
        }
        [paramDic setObject:resignin_value forKey:@"repeat_weekdays"];
        NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"addSsqSign"];
        
        LTHTTPManager * manager = [LTHTTPManager manager];
        [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *resultDic=responseObject;
            if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
                if([type isEqualToString:@"save"]){
                    [SVProgressHUD dismiss];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[resultDic objectForKey:@"Point"] preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        SignInViewController *jumpVC=[SignInViewController new];
                        jumpVC.selectIndex=2;
                        NSMutableArray *navViewArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                        int index = (int)[navViewArray indexOfObject:self];
                        [navViewArray removeObjectAtIndex:index];
                        [navViewArray removeObjectAtIndex:index-1];
                        [navViewArray addObject:jumpVC];
                        [self.navigationController setViewControllers:navViewArray animated:YES];
                        
                    }])];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
                else{
                    [self publishActivitySignIn:[resultDic objectForKey:@"Result"]];
                }
            }
            else{
                [SVProgressHUD dismiss];
                [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];
            NSLog(@"请求失败----%@", error);
            [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败！"];
        }];
        
    }
    
}


#pragma mark - 发布
-(void)publishActivitySignIn:(NSString *)idStr{
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [paramDic setObject:idStr forKey:@"id"];
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"publishSsqSign"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[resultDic objectForKey:@"Point"] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SignInViewController *jumpVC=[SignInViewController new];
                jumpVC.selectIndex=2;
                NSMutableArray *navViewArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                int index = (int)[navViewArray indexOfObject:self];
                [navViewArray removeObjectAtIndex:index];
                [navViewArray removeObjectAtIndex:index-1];
                [navViewArray addObject:jumpVC];
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
#pragma mark - 选择学生
- (void)clickSelectStu  {
    NSLog(@"clickSelectStuBtn");
   
    SelectStudentVC *jumpVC=[SelectStudentVC new];
    jumpVC.notificationName=notificationName;
    jumpVC.sub=@"1";
    if([xs_type isEqualToString:@"tag"]){
        jumpVC.values=@{@"tag":tempStudentDic};
    }
    else if([xs_type isEqualToString:@"class"]){
        jumpVC.selectIndex=1;
        jumpVC.values=@{@"class":tempStudentDic};
    }
    [self.navigationController pushViewController:jumpVC animated:YES];
    
}
- (void)returnSelectDic:(NSNotification *)notification{
    NSLog(@"SelectDic%@",notification.userInfo);
    xs_names=@"";
    xs_ids=@"";
    xs_type=@"";
    //移除
    NSArray *views = [self.addDormSignInView.stuScrollView subviews];
    for(UIView *view in views)
    {
        [view removeFromSuperview];
    }
    NSArray *stuIdArray=[notification.userInfo objectForKey:@"titleId"];
    NSArray *stuNameArray=[notification.userInfo objectForKey:@"title"];
    xs_type=[notification.userInfo objectForKey:@"type"];
    xs_ids=[stuIdArray count]>0?[stuIdArray componentsJoinedByString:@","]:@"";
    xs_names=[stuNameArray count]>0?[stuNameArray componentsJoinedByString:@","]:@"";
    tempStudentDic=[notification.userInfo objectForKey:@"tempValue"];
    //self.addDormSignInView.studentLabel.text=xs_names;
    [self.addDormSignInView.selectImage setHidden:YES];
    [[ScrollAddLabel new] addLabelToScrollView:self.addDormSignInView.stuScrollView labels:stuNameArray];
}

#pragma mark - 保存
- (void)clickSaveBtn:(UIButton *)btn {
    
    [self addActivity:@"save"];
    
}

#pragma mark - 发布
- (void)clickPublishBtn:(UIButton *)btn {
    
    if([self.addDormSignInView.timesSwitch isOn]){
        [self addActivity:@"publish"];
        
    }
    else{
        [self addActivity:@"save"];
    }
}

- (void)clickTimeBtn:(UIButton *)btn {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    tempTimeTag=(int)btn.tag;
    DateTimePickerView *pickerView = [[DateTimePickerView alloc] init];
    _datePickerView = pickerView;
    _datePickerView.delegate = self;
    if(tempTimeTag==301){
        _datePickerView.pickerViewMode = DatePickerViewDateMode;
    }
    else{
        if([self.addDormSignInView.timesSwitch isOn]){
            _datePickerView.pickerViewMode = DatePickerViewDateTimeMode;
        }
        else{
            _datePickerView.pickerViewMode = DatePickerViewTimeMode;
        }
        
    }
    
    [self.view addSubview:_datePickerView];
    [pickerView showDateTimePickerView];
}
#pragma mark -选择设备
- (void)clickSelectDevice  {
    DevicesVC *jumpVC=[DevicesVC new];
    jumpVC.value=[device_ids componentsSeparatedByString:@","];
    [self.navigationController pushViewController:jumpVC animated:YES];
    //移除
    NSArray *views = [self.addDormSignInView.signScrollView subviews];
    for(UIView *view in views)
    {
        [view removeFromSuperview];
    }
}

- (void)returnDevicesDic:(NSNotification *)notification{
    NSLog(@"SelectDic%@",notification.userInfo);
    NSArray *deviceIdArray=[notification.userInfo objectForKey:@"titleId"];
    NSArray *deviceNameArray=[notification.userInfo objectForKey:@"title"];
    device_ids=[deviceIdArray count]>0?[deviceIdArray componentsJoinedByString:@","]:@"";
    device_names=[deviceNameArray count]>0?[deviceNameArray componentsJoinedByString:@","]:@"";
    //self.addDormSignInView.sign_deviceLabel.text=device_names;
    [self.addDormSignInView.sign_deviceImage setHidden:YES];
    [[ScrollAddLabel new] addLabelToScrollView:self.addDormSignInView.signScrollView labels:deviceNameArray];
}
#pragma mark - 选择重复时间
- (void)clickResignin  {
    ResigninVC *jumpVC=[ResigninVC new];
    jumpVC.value=[resignin_value componentsSeparatedByString:@","];
    [self.navigationController pushViewController:jumpVC animated:YES];
    //移除
    NSArray *views = [self.addDormSignInView.resigninScrollView subviews];
    for(UIView *view in views)
    {
        [view removeFromSuperview];
    }
}

- (void)returnResigninDic:(NSNotification *)notification{
    NSLog(@"SelectDic%@",notification.userInfo);
    NSArray *resigninArray=[notification.userInfo objectForKey:@"values"];
    NSArray *titleArray=[notification.userInfo objectForKey:@"titles"];
    resignin_value=[resigninArray count]>0?[resigninArray componentsJoinedByString:@","]:@"";
    //self.addDormSignInView.resigninLabel.text=[titleArray count]>0?[titleArray componentsJoinedByString:@","]:@"";;
    [self.addDormSignInView.resigninImage setHidden:YES];
    [[ScrollAddLabel new] addLabelToScrollView:self.addDormSignInView.resigninScrollView labels:titleArray];
}


- (void) timesSwitchAction:(UISwitch *)timesSwitch{
    if (![timesSwitch isOn]){
        [_saveBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.bottom.equalTo(self.view.mas_bottom).offset(-10-BottomPaddingHeight);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
        [_publishBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.bottom.equalTo(self.view.mas_bottom).offset(-10-BottomPaddingHeight);
            make.width.mas_equalTo(kWidth-30);
            make.height.mas_equalTo(40);
        }];
    }
    else{
        [_saveBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.bottom.equalTo(self.view.mas_bottom).offset(-10-BottomPaddingHeight);
            make.width.mas_equalTo((kWidth-50)/2);
            make.height.mas_equalTo(40);
        }];
        [_publishBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset((kWidth/2)+10);
            make.bottom.equalTo(self.view.mas_bottom).offset(-10-BottomPaddingHeight);
            make.width.mas_equalTo((kWidth-50)/2);
            make.height.mas_equalTo(40);
        }];
    }
}

#pragma mark - delegate
- (void)didClickFinishDateTimePickerView:(NSString *)date{
    //tempTimeLabel.text = date;
    switch (tempTimeTag) {
            
        case 200:
            self.addDormSignInView.sign_start_timeLabel.text=date;
            break;
        case 201:
            self.addDormSignInView.sign_end_timeLabel.text=date;
            break;
        case 301:
            self.addDormSignInView.stoptimeLabel.text=date;
            break;
        default:
            break;
            
    }
    
}



@end



