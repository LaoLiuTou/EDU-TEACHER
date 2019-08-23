//
//  AddClassSignInVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/31.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AddClassSignInVC.h"
#import "DEFINE.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "AddClassSignInView.h"
#import "SelectStudentVC.h"
#import "DateTimePickerView.h"
#import "DevicesVC.h"
#import "SelectClassVC.h"
#import "SignInViewController.h"
#import "LTPickerView.h"
#import "ScrollAddLabel.h"
@interface AddClassSignInVC ()<AddClassSignInDelegate,UIScrollViewDelegate,DateTimePickerViewDelegate,LTPickerDelegate>
@property (nonatomic, strong) AddClassSignInView *addClassSignInView;
@property (nonatomic, strong) UIButton *publishBtn;

@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DateTimePickerView *datePickerView;
@end

@implementation AddClassSignInVC{
    NSString *xs_names;
    NSString *xs_ids;
    NSString *device_names;
    NSString *device_ids;
    NSString *xs_type;
    NSMutableDictionary *tempStudentDic;
    int tempTimeTag;
    
    NSString *class_id;
    NSArray *xs_List;
    NSArray *timetableArray;
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
    tempStudentDic=[NSMutableDictionary new];
    //选择设备
    device_names=@"";
    device_ids=@"";
    //课程
    class_id=@"";
    timetableArray=[NSArray new];
    //课程中学生
    xs_List=@[];
    //注册通知：
    //注册通知：
    notificationName=@"SelectStudentClassSign";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnSelectDic:) name:notificationName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnDevicesDic:) name:@"SelectDevices" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnClassDic:) name:@"SelectClass" object:nil];
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
    self.gk_navTitle=@"创建课程签到";
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
    
    AddClassSignInView *addClassSignInView = [[AddClassSignInView alloc]init];
    _addClassSignInView=addClassSignInView;
    //_addStudentTalkingView.frame = CGRectMake(0, 0, kWidth, kHeight);
    _addClassSignInView.delegate = self;
    int height=[_addClassSignInView initView];
    //[self.view addSubview:_addStudentTalkingView];
    [self.scrollView addSubview:_addClassSignInView];
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
    if([self.addClassSignInView.nameText.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"签到名称不能为空！"];
    }
    else if(self.addClassSignInView.nameText.text.length>50){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"签到名称最多可输入50个汉字！"];
    }
    else if([class_id isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择签到课程！"];
    }
    
    else if([device_ids isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择签到设备！"];
    }
    else if(![self.addClassSignInView.timeTableSwitch isOn]&&[self.addClassSignInView.sign_start_timeLabel.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择签到开始时间！"];
    }
    else if(![self.addClassSignInView.timeTableSwitch isOn]&&[self.addClassSignInView.sign_end_timeLabel.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择签到截止时间！"];
    }
//    else if([self.addClassSignInView.timeTableSwitch isOn]&&[self.addClassSignInView.stoptimeLabel.text isEqualToString:@""]){
//        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择重复签到截止日期！"];
//    }
    else if([self.addClassSignInView.timeTableSwitch isOn]&&[self.addClassSignInView.autoSignTimeBtn.titleLabel.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择自动签到时间类型！"];
    }
    else if([self.addClassSignInView.timeTableSwitch isOn]&&[self.addClassSignInView.autoSignTimeText.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入自动签到时间！"];
    }
    else if([xs_ids isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择签到范围！"];
    }
    else if(self.addClassSignInView.commentText.text.length>1000){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"活动内容最多可输入1000个汉字！"];
    }
    else{
        
        [SVProgressHUD showWithStatus:@"加载中"];
        [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSMutableDictionary *paramDic =[NSMutableDictionary new];
        [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
        [paramDic setObject:class_id forKey:@"lesson_id"];
        [paramDic setObject:self.addClassSignInView.nameText.text forKey:@"sign_name"];
        [paramDic setObject:self.addClassSignInView.sign_methodLabel.text forKey:@"sign_method"];
        [paramDic setObject:device_ids forKey:@"sign_deviceids"];
        if([self.addClassSignInView.timeTableSwitch isOn]){
            
            [paramDic setObject:@"1" forKey:@"is_repeat"];
            //[paramDic setObject:self.addClassSignInView.stoptimeLabel.text forKey:@"repeat_jiezhi_date"];
            [paramDic setObject:self.addClassSignInView.autoSignTimeBtn.titleLabel.text forKey:@"auto_type"];
            [paramDic setObject:self.addClassSignInView.autoSignTimeText.text forKey:@"auto_time"];
            
            
            //课程ID
            NSMutableArray *timetable_ids=[NSMutableArray new];
            for(NSDictionary *temp in timetableArray){
                [timetable_ids addObject:[temp objectForKey:@"id"]];
            }
            [paramDic setObject:[timetable_ids componentsJoinedByString:@","] forKey:@"timetable_ids"];
            
            
        }
        else{
            [paramDic setObject:@"0" forKey:@"is_repeat"];
            [paramDic setObject:self.addClassSignInView.sign_start_timeLabel.text forKey:@"sign_start_time"];
            [paramDic setObject:self.addClassSignInView.sign_end_timeLabel.text forKey:@"sign_end_time"];
        }
        
        if(![self.addClassSignInView.commentText.text isEqualToString:@"添加签到说明"]){
            [paramDic setObject:self.addClassSignInView.commentText.text forKey:@"comment"];
        }
        [paramDic setObject:xs_ids forKey:@"xs_ids"];
        
        NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"addKqSign"];
        
        LTHTTPManager * manager = [LTHTTPManager manager];
        [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *resultDic=responseObject;
            if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
                if([type isEqualToString:@"save"]){
                    [SVProgressHUD dismiss];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[resultDic objectForKey:@"Point"] preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        SignInViewController *jumpVC=[SignInViewController new];
                        jumpVC.selectIndex=1;
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
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"publishKqSign"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[resultDic objectForKey:@"Point"] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SignInViewController *jumpVC=[SignInViewController new];
                jumpVC.selectIndex=1;
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
- (void)clickSelectStu {
    NSLog(@"clickSelectStuBtn");
   
    //[self.navigationController pushViewController:[SelectStudentVC new] animated:YES];
    SelectStudentVC *jumpVC= [SelectStudentVC new];
    jumpVC.type=@"class";
    
   
    
    
    jumpVC.values=@{@"class":tempStudentDic};
    jumpVC.notificationName=notificationName; 
    //jumpVC.values=@{@"class":tempArray};
    [self.navigationController pushViewController:jumpVC animated:YES];
    
}
- (void)returnSelectDic:(NSNotification *)notification{
    NSLog(@"SelectDic%@",notification.userInfo);
    //移除
    xs_names=@"";
    xs_ids=@"";
    xs_type=@"";
    NSArray *views = [self.addClassSignInView.stuScrollView subviews];
    for(UIView *view in views)
    {
        [view removeFromSuperview];
    }
    NSArray *stuIdArray=[notification.userInfo objectForKey:@"studentId"];
    NSArray *stuNameArray=[notification.userInfo objectForKey:@"studentName"];
    
    xs_type=[notification.userInfo objectForKey:@"type"];
    xs_ids=[stuIdArray count]>0?[stuIdArray componentsJoinedByString:@","]:@"";
    xs_names=[stuNameArray count]>0?[stuNameArray componentsJoinedByString:@","]:@"";
     tempStudentDic=[notification.userInfo objectForKey:@"tempValue"];
    //self.addClassSignInView.studentLabel.text=xs_names;
    [self.addClassSignInView.selectImage setHidden:YES];
    [[ScrollAddLabel new] addLabelToScrollView:self.addClassSignInView.stuScrollView labels:stuNameArray];
    
}
#pragma mark - 自动签到时间
-(void)clickAutoSignTimeBtn:(UIButton *)sender{
    LTPickerView *picker  = [[LTPickerView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    picker.dataArray = @[@{@"NM_T":@"上课前"},@{@"NM_T":@"上课后"},@{@"NM_T":@"下课后"}];
    picker.delegate = self;
    [self.view addSubview:picker];
}
#pragma mark - 选择学院
- (void)pickViewSureBtnClick:(NSDictionary *)selectDic{
    
    [self.addClassSignInView.autoSignTimeBtn setTitle:[selectDic objectForKey:@"NM_T"] forState:UIControlStateNormal];
    
    NSLog(@"%@",selectDic);
}
#pragma mark - 保存
- (void)clickSaveBtn:(UIButton *)btn {
    [self addActivity:@"save"];
    
    
}

#pragma mark - 发布
- (void)clickPublishBtn:(UIButton *)btn {
    if([self.addClassSignInView.timeTableSwitch isOn]){
        [self addActivity:@"save"];
    }
    else{
       [self addActivity:@"publish"];
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
        
        _datePickerView.pickerViewMode = DatePickerViewDateTimeMode;
        
    }
    [self.view addSubview:_datePickerView];
    [pickerView showDateTimePickerView];
}



- (void)clickSelectDevice {
    DevicesVC *jumpVC=[DevicesVC new];
    jumpVC.value=[device_ids componentsSeparatedByString:@","];
    [self.navigationController pushViewController:jumpVC animated:YES];
    //移除
    NSArray *views = [self.addClassSignInView.signScrollView subviews];
    for(UIView *view in views)
    {
        [view removeFromSuperview];
    }
}

- (void)clickSelectClassBtn:(UIButton *)btn {
    [self.navigationController pushViewController:[SelectClassVC new] animated:YES];
}

- (void)timeTableSwitchAction:(UISwitch *)timeTableSwitch {
     if ([timeTableSwitch isOn]){
         if([class_id isEqualToString:@""]){
             [SVProgressHUD showErrorWithStatus:@"请先选择课程！"];
             [timeTableSwitch setOn:NO];
             return;
         }
         if(timetableArray.count==0){
              [SVProgressHUD showErrorWithStatus:@"该课程无法开启课表签到！"];
             [timeTableSwitch setOn:NO];
             return;
         }
         
         [self.addClassSignInView.timeTableSwitch setThumbTintColor:GKColorHEX(0x2c92f5, 1)];
         [self.addClassSignInView.timeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
             make.height.mas_equalTo(self.addClassSignInView.classStartTimeLabel.frame.size.height+80+20);//0  260
             //make.height.mas_equalTo(262);//0  260
         }];
         
         [self.addClassSignInView.timeTableView setHidden:NO];
         [self.addClassSignInView.timesView mas_updateConstraints:^(MASConstraintMaker *make) {
             make.height.mas_equalTo(0);//0  260
         }];
         [self.addClassSignInView.timesView setHidden:YES];
         [self.addClassSignInView.selectback mas_updateConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self.addClassSignInView.timeTableView.mas_bottom).offset(6);
         }];
         
         
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
         
         [self.addClassSignInView.timeTableSwitch setThumbTintColor:[UIColor grayColor]];
         [self.addClassSignInView.timeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
             make.height.mas_equalTo(0);//0  260
         }];
         [self.addClassSignInView.timeTableView setHidden:YES];
         [self.addClassSignInView.timesView mas_updateConstraints:^(MASConstraintMaker *make) {
             make.height.mas_equalTo(101);//0  260
         }];
//         [self.addClassSignInView.selectback mas_updateConstraints:^(MASConstraintMaker *make) {
//             make.top.equalTo(self.addClassSignInView.timesView.mas_bottom).offset(6);//0  260
//         }];
         [self.addClassSignInView.selectback mas_updateConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self.addClassSignInView.timeTableView.mas_bottom).offset(106);//0  260
         }];
         [self.addClassSignInView.timesView setHidden:NO];
       
         
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


- (void)returnClassDic:(NSNotification *)notification{
    NSLog(@"SelectDic%@",notification.userInfo);
    
  
    
    
    
    //移除
    xs_names=@"";
    xs_ids=@"";
    xs_type=@"";
    NSArray *views = [self.addClassSignInView.stuScrollView subviews];
    for(UIView *view in views)
    {
        [view removeFromSuperview];
    }
    
    class_id=[NSString stringWithFormat:@"%@",[notification.userInfo objectForKey:@"class_id"]];
    self.addClassSignInView.activityLabel.text=[notification.userInfo objectForKey:@"class_name"];
    
    [self.addClassSignInView.classInfoView setHidden:NO];
    self.addClassSignInView.fdLabel.text=[NSString stringWithFormat:@"任课老师：%@",[notification.userInfo objectForKey:@"teacher"]];
    self.addClassSignInView.addressLabel.text=[NSString stringWithFormat:@"上课地址：%@",[notification.userInfo objectForKey:@"room"]];
    
    xs_List=[notification.userInfo objectForKey:@"xs_info"];
    timetableArray=[notification.userInfo objectForKey:@"timetable"];
    NSString *classStr=@"";
    NSMutableArray *contentArray=[NSMutableArray new];
    
    for(NSDictionary *temp in timetableArray){
        classStr=[NSString stringWithFormat:@"%@-%@",[temp objectForKey:@"ST_CLASS_ORDER"],[temp objectForKey:@"ED_CLASS_ORDER"]];
        NSString *weekStr=[temp objectForKey:@"WEEKDAYS"];
        weekStr=[weekStr stringByReplacingOccurrencesOfString:@"1" withString:@"一"];
        weekStr=[weekStr stringByReplacingOccurrencesOfString:@"2" withString:@"二"];
        weekStr=[weekStr stringByReplacingOccurrencesOfString:@"3" withString:@"三"];
        weekStr=[weekStr stringByReplacingOccurrencesOfString:@"4" withString:@"四"];
        weekStr=[weekStr stringByReplacingOccurrencesOfString:@"5" withString:@"五"];
        weekStr=[weekStr stringByReplacingOccurrencesOfString:@"6" withString:@"六"];
        weekStr=[weekStr stringByReplacingOccurrencesOfString:@"7" withString:@"日"];
        weekStr=[weekStr stringByReplacingOccurrencesOfString:@"," withString:@",周"];
        [contentArray addObject:[NSString stringWithFormat:@"第%@周 周%@ 第%@节",[temp objectForKey:@"WEEKS"],weekStr,classStr]];
        
    }
 
   
    self.addClassSignInView.classStartTimeLabel.text=[contentArray componentsJoinedByString:@"\n\n"];
 
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.addClassSignInView.timeTableSwitch isOn]){
            if(self->timetableArray.count==0){
                [SVProgressHUD showErrorWithStatus:@"该课程无法开启课表签到！"];
                [self.addClassSignInView.timeTableSwitch setOn:NO];
                [self.addClassSignInView.timeTableSwitch setThumbTintColor:[UIColor grayColor]];
                [self.addClassSignInView.timeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);//0  260
                }];
                [self.addClassSignInView.timeTableView setHidden:YES];
                [self.addClassSignInView.timesView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(101);//0  260
                }];
             
                [self.addClassSignInView.timesView setHidden:NO];
                 
                [self.addClassSignInView.selectback mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.addClassSignInView.timeTableView.mas_bottom).offset(106);//0  260
                }];
                [self.saveBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view).offset(15);
                    make.bottom.equalTo(self.view.mas_bottom).offset(-10-BottomPaddingHeight);
                    make.width.mas_equalTo((kWidth-50)/2);
                    make.height.mas_equalTo(40);
                }];
                [self.publishBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view).offset((kWidth/2)+10);
                    make.bottom.equalTo(self.view.mas_bottom).offset(-10-BottomPaddingHeight);
                    make.width.mas_equalTo((kWidth-50)/2);
                    make.height.mas_equalTo(40);
                }];
                
            }
            else{
                [self.addClassSignInView.timeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(self.addClassSignInView.classStartTimeLabel.frame.size.height+80+20);//0  260
                }];
                
                [self.addClassSignInView.selectback mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.addClassSignInView.timeTableView.mas_bottom).offset(6);
                }];
            }
            
           
        }
    });

    
   
 
    
    //显示学生
    //课程中学生
    NSMutableArray *stuIdArray=[NSMutableArray new];
    NSMutableArray *stuNameArray=[NSMutableArray new];
    
    for(int i=0;i<xs_List.count;i++){
        NSString *class_id=[NSString stringWithFormat:@"%@",[xs_List[i] objectForKey:@"class_id"]];
        if([[tempStudentDic allKeys] containsObject:class_id]){
            NSMutableArray *tempArray=[tempStudentDic objectForKey:class_id];
            [tempArray addObject:[NSString stringWithFormat:@"%@",[xs_List[i] objectForKey:@"id"]]];
        }
        else{
            NSMutableArray *tempArray=[NSMutableArray new];
            [tempArray addObject:[NSString stringWithFormat:@"%@",[xs_List[i] objectForKey:@"id"]]];
            [tempStudentDic setObject:tempArray forKey:class_id];
        }
        [stuIdArray addObject:[xs_List[i] objectForKey:@"id"]];
        [stuNameArray addObject:[xs_List[i] objectForKey:@"NM_T"]];
    }
    
    xs_ids=[stuIdArray count]>0?[stuIdArray componentsJoinedByString:@","]:@"";
    xs_names=[stuNameArray count]>0?[stuNameArray componentsJoinedByString:@","]:@"";
    if(stuIdArray.count>0){
        [self.addClassSignInView.selectImage setHidden:YES];
        [[ScrollAddLabel new] addLabelToScrollView:self.addClassSignInView.stuScrollView labels:stuNameArray];
    }
    
    
}


- (void)returnDevicesDic:(NSNotification *)notification{
    NSLog(@"SelectDic%@",notification.userInfo);
    NSArray *deviceIdArray=[notification.userInfo objectForKey:@"titleId"];
    NSArray *deviceNameArray=[notification.userInfo objectForKey:@"title"];
    device_ids=[deviceIdArray count]>0?[deviceIdArray componentsJoinedByString:@","]:@"";
    device_names=[deviceNameArray count]>0?[deviceNameArray componentsJoinedByString:@","]:@"";
    //self.addClassSignInView.sign_deviceLabel.text=device_names;
    [self.addClassSignInView.sign_deviceImage setHidden:YES];
    [[ScrollAddLabel new] addLabelToScrollView:self.addClassSignInView.signScrollView labels:deviceNameArray];
}

#pragma mark - delegate
- (void)didClickFinishDateTimePickerView:(NSString *)date{
    //tempTimeLabel.text = date;
    switch (tempTimeTag) {
            
        case 200:
            self.addClassSignInView.sign_start_timeLabel.text=date;
            break;
        case 201:
            self.addClassSignInView.sign_end_timeLabel.text=date;
            break;
        case 301:
            self.addClassSignInView.stoptimeLabel.text=date;
            break;
        default:
            break;
            
    }
    
}



@end


