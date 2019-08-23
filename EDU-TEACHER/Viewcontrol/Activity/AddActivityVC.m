//
//  AddActivityVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AddActivityVC.h"
#import "DEFINE.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "AddActivityView.h"
#import "SelectStudentVC.h"
#import "DateTimePickerView.h"
#import "DevicesVC.h"
#import "ActivityVC.h"
#import "ScrollAddLabel.h"
@interface AddActivityVC ()<AddActivityDelegate,UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate,UIScrollViewDelegate,DateTimePickerViewDelegate>
@property (nonatomic, strong) AddActivityView *addActivityView;
@property (nonatomic, strong) UIButton *publishBtn;
@property (nonatomic, strong) NSMutableArray *attaFileNames;//附件名
@property (nonatomic, strong) NSMutableArray *attaFileTypes;//附件类型
@property (nonatomic, strong) NSMutableArray *attaFileData;//附件地址
@property (nonatomic, strong) NSMutableArray *attaFileResult;//上传结果
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DateTimePickerView *datePickerView;

@end

@implementation AddActivityVC{
    NSString *xs_names;
    NSString *xs_ids;
    NSString *device_names;
    NSString *device_ids;
    NSString *xs_type;
    int tempTimeTag;
    int height;
    NSString *notificationName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [self initView];
    
    //附件
    _attaFileNames=[NSMutableArray new];
    _attaFileTypes=[NSMutableArray new];
    _attaFileData=[NSMutableArray new];
    _attaFileResult=[NSMutableArray new];
    //选择学生
    xs_names=@"";
    xs_ids=@"";
    //选择设备
    device_names=@"";
    device_ids=@"";
    //注册通知：
    //注册通知：
    notificationName=@"SelectStudentActivity";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnSelectDic:) name:notificationName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnDevicesDic:) name:@"SelectDevices" object:nil];
    
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
    self.gk_navTitle=@"创建活动";
    self.gk_navTitleColor=[UIColor blackColor];
}

- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化视图
- (void)initView{
    self.view.backgroundColor=GKColorRGB(246, 246, 246);
    [self.view addSubview:self.publishBtn];
    [self.view addSubview:self.scrollView];
    [self.view sendSubviewToBack:_scrollView];
    
    [_publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-10-BottomPaddingHeight);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(40);
    }];
    
    AddActivityView *addActivityView = [[AddActivityView alloc]init];
    _addActivityView=addActivityView;
    //_addStudentTalkingView.frame = CGRectMake(0, 0, kWidth, kHeight);
    _addActivityView.delegate = self;
    height=[_addActivityView initView];
    //[self.view addSubview:_addStudentTalkingView];
    [self.scrollView addSubview:_addActivityView];
    _scrollView.contentSize =CGSizeMake(0,height);
    
    
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
-(UIButton *)publishBtn{
    if (!_publishBtn) {
        UIButton *publishBtn=[[UIButton alloc] init];
        _publishBtn=publishBtn;
        _publishBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [_publishBtn addTarget:self action:@selector(clickPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_publishBtn setTitle:@"保存" forState:UIControlStateNormal];
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
#pragma mark - 选择附件
- (void)clickSelectAtta{
    NSLog(@"clickSelectAttaBtn");
    NSArray *types = @[@"com.microsoft.powerpoint.​ppt",
                       @"com.microsoft.word.doc",
                       @"com.microsoft.excel.xls",
                       @"com.microsoft.powerpoint.​pptx",
                       @"com.microsoft.word.docx",
                       @"com.microsoft.excel.xlsx",
                       @"public.avi",
                       @"public.3gpp",
                       @"public.mpeg-4",
                       @"com.compuserve.gif",
                       @"public.jpeg",
                       @"public.png",
                       @"public.plain-text",
                       @"com.adobe.pdf"
                       ]; // 可以选择的文件类型
    UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:types inMode:UIDocumentPickerModeOpen];
    documentPicker.delegate = self;
    documentPicker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    if (@available(iOS 11.0, *)) {
        [documentPicker setAllowsMultipleSelection:YES];
    } else {
        // Fallback on earlier versions
    }
    [self presentViewController:documentPicker animated:YES completion:nil];
    
    
}

#pragma mark - UIDocumentPickerDelegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls {
    for(NSURL *fileUrl in urls){
        //获取授权
        BOOL fileUrlAuthozied = [fileUrl startAccessingSecurityScopedResource];
        if (fileUrlAuthozied) {
            //通过文件协调工具来得到新的文件地址，以此得到文件保护功能
            NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] init];
            NSError *error;
            
            [fileCoordinator coordinateReadingItemAtURL:fileUrl options:0 error:&error byAccessor:^(NSURL *newURL) {
                //读取文件
                NSString *fileName = [newURL lastPathComponent];
                NSError *error = nil;
                NSData *fileData = [NSData dataWithContentsOfURL:newURL options:NSDataReadingMappedIfSafe error:&error];
                if (error) {
                    //读取出错
                } else {
                    
                    [self.attaFileNames addObject:fileName];
                    [self.attaFileData addObject:fileData];
                }
                
                
            }];
            [fileUrl stopAccessingSecurityScopedResource];
        } else {
            //授权失败
        }
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self uploadFilesByDatas:self.attaFileData fileNames:self.attaFileNames fileTypes:self.attaFileTypes];
}

#pragma mark - 附件上传
- (void)uploadFilesByDatas:(NSArray *) imageDatas fileNames:(NSArray *)filenames fileTypes:(NSArray *) fileTypes{
    
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSData *imageData = UIImagePNGRepresentation(registerModel.idImage);
    NSDictionary *paramDic = @{@"project":@"edu"};
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:jbad.urlUpload parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(int index=0;index<[imageDatas count];index++){
            [formData appendPartWithFileData:imageDatas[index] name:@"files" fileName:filenames[index] mimeType:@""];
        }
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //显示进度
            //[self.progress setProgress:uploadProgress.fractionCompleted];
        });
    }
      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
          if (error) {
              [[LTAlertView new] showOneChooseAlertViewMessage:@"附件上传失败"];
          } else {
              NSDictionary *result=responseObject;
              if([[result objectForKey:@"status"] isEqualToString:@"0"]){
                  NSArray *tempArray=[result objectForKey:@"data"];
                  if([tempArray count]>0){
                      //registerModel.idImageUrl=tempArray[0];
                      //[self reg:registerModel];
                      self.attaFileResult=[tempArray mutableCopy];
                      [self.addActivityView.attaImage setHidden:YES];
                      [[ScrollAddLabel new] addLabelToScrollView:self.addActivityView.filesScrollView labels:filenames];
                      //self.addActivityView.filesLabel.text=[filenames componentsJoinedByString:@","];
                  }
                  else{
                      [[LTAlertView new] showOneChooseAlertViewMessage:@"附件上传失败"];
                  }
                  
              }
              else{
                  [[LTAlertView new] showOneChooseAlertViewMessage:@"附件上传失败"];
              }
          }
      }];
    
    [uploadTask resume];
}


#pragma mark - 网络请求获取数据
-(void)addActivity{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [paramDic setObject:self.addActivityView.nameText.text forKey:@"name"];
    [paramDic setObject:@[@"报名类",@"签到类"][self.addActivityView.typeSegment.selectedSegmentIndex] forKey:@"type"];
    if(![self.addActivityView.startTimeLabel.text isEqualToString:@""]){
        [paramDic setObject:self.addActivityView.startTimeLabel.text forKey:@"start_time"];
    }
    if(![self.addActivityView.endTimeLabel.text isEqualToString:@""]){
        [paramDic setObject:self.addActivityView.endTimeLabel.text forKey:@"end_time"];
    }
    [paramDic setObject:self.addActivityView.baomingTimeLabel.text forKey:@"baoming_endtime"];
    if(![self.addActivityView.addressText.text isEqualToString:@""]){
        [paramDic setObject:self.addActivityView.addressText.text forKey:@"address"];
    }
    if(![self.addActivityView.numberLabel.text isEqualToString:@""]){
        [paramDic setObject:self.addActivityView.numberLabel.text forKey:@"limit_num"];
    }
    if(![self.addActivityView.commentText.text isEqualToString:@"添加活动内容"]){
        [paramDic setObject:self.addActivityView.commentText.text forKey:@"comment"];
    }
    if([xs_type isEqualToString:@"class"]){
        [paramDic setObject:xs_ids forKey:@"class_ids"];
    }
    else{
        [paramDic setObject:xs_ids forKey:@"tag_ids"];
    }
    if(self.addActivityView.selectedImage !=nil){
        [paramDic setObject:self.addActivityView.selectedImage forKey:@"image"];
    }
    if(self.attaFileResult.count>0){
        [paramDic setObject:[self.attaFileResult componentsJoinedByString:@","] forKey:@"files"];
    }
    if(self.addActivityView.typeSegment.selectedSegmentIndex==1){
        
        [paramDic setObject:self.addActivityView.sign_nameText.text forKey:@"sign_name"];
        [paramDic setObject:self.addActivityView.sign_methodLabel.text forKey:@"sign_method"];
        [paramDic setObject:device_ids forKey:@"sign_deviceids"];
        [paramDic setObject:self.addActivityView.sign_start_timeLabel.text forKey:@"sign_start_time"];
        [paramDic setObject:self.addActivityView.sign_end_timeLabel.text forKey:@"sign_end_time"];
        
    }
  
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"addHd"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[resultDic objectForKey:@"Point"] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSMutableArray *navViewArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                int index = (int)[navViewArray indexOfObject:self];
                [navViewArray removeObjectAtIndex:index];
                [navViewArray removeObjectAtIndex:index-1];
                [navViewArray addObject:[ActivityVC new]];
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
    
    xs_names=@"";
    xs_ids=@"";
    xs_type=@"";
    SelectStudentVC *jumpVC=[SelectStudentVC new];
    jumpVC.notificationName=notificationName;
    jumpVC.sub=@"1";
    [self.navigationController pushViewController:jumpVC animated:YES];
    
    //移除 
    NSArray *views = [self.addActivityView.stuScrollView subviews];
    for(UIView *view in views)
    {
        [view removeFromSuperview];
    }
}
- (void)returnSelectDic:(NSNotification *)notification{
    NSLog(@"SelectDic%@",notification.userInfo);
    NSArray *stuIdArray=[notification.userInfo objectForKey:@"titleId"];
    NSArray *stuNameArray=[notification.userInfo objectForKey:@"title"];
    xs_type=[notification.userInfo objectForKey:@"type"];
    xs_ids=[stuIdArray count]>0?[stuIdArray componentsJoinedByString:@","]:@"";
    xs_names=[stuNameArray count]>0?[stuNameArray componentsJoinedByString:@","]:@"";
    //self.addActivityView.studentLabel.text=xs_names;
    [self.addActivityView.selectImage setHidden:YES];
    [[ScrollAddLabel new] addLabelToScrollView:self.addActivityView.stuScrollView labels:stuNameArray];
}
#pragma mark - 发布
- (void)clickPublishBtn:(UIButton *)btn {
    NSLog(@"clickPublishBtn%@",self.addActivityView.baomingTimeLabel.text);
    if([self.addActivityView.nameText.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入活动名称！"];
    }
    else if(self.addActivityView.nameText.text.length>50){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"活动名称最多可输入50个汉字！"];
    }
    
    else if([self.addActivityView.baomingTimeLabel.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择报名截止时间！"];
    } 
    else if(self.addActivityView.addressText.text.length>50){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"活动地址最多可输入50个汉字！"];
    }
    else if(self.addActivityView.commentText.text.length>1000){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"活动内容最多可输入1000个汉字！"];
    }
    else if(self.addActivityView.typeSegment.selectedSegmentIndex==1&&[self.addActivityView.sign_nameText.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入签到名称！"];
    }
    else if(self.addActivityView.typeSegment.selectedSegmentIndex==1&&self.addActivityView.sign_nameText.text.length>50){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"签到名称最多可输入50个汉字！"];
    }
    else if(self.addActivityView.typeSegment.selectedSegmentIndex==1&&[device_ids isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择签到设备！"];
    }
    else if(self.addActivityView.typeSegment.selectedSegmentIndex==1&&[self.addActivityView.sign_start_timeLabel.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择签到开始时间！"];
    }
    else if(self.addActivityView.typeSegment.selectedSegmentIndex==1&&[self.addActivityView.sign_end_timeLabel.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择签到截止时间！"];
    }
   
    else if([xs_ids isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择签到范围！"];
    }
    else{
        [self addActivity];
    }
 
}

- (void)clickTimeBtn:(UIButton *)btn {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    tempTimeTag=(int)btn.tag;
    DateTimePickerView *pickerView = [[DateTimePickerView alloc] init];
    _datePickerView = pickerView;
    _datePickerView.delegate = self;
    _datePickerView.pickerViewMode = DatePickerViewDateTimeMode;
    [self.view addSubview:_datePickerView];
    [pickerView showDateTimePickerView];
}

- (void)changeType:(UISegmentedControl *)typeSegment {
    
    if(typeSegment.selectedSegmentIndex==0){ 
        _scrollView.contentSize =CGSizeMake(0,height);
    }
    else{
        _scrollView.contentSize =CGSizeMake(0,height+260);
    }
    
}

- (void)clickSelectDevice {
    DevicesVC *jumpVC=[DevicesVC new];
    jumpVC.value=[device_ids componentsSeparatedByString:@","];
    [self.navigationController pushViewController:jumpVC animated:YES];
    //移除
    NSArray *views = [self.addActivityView.signScrollView subviews];
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
    //self.addActivityView.sign_deviceLabel.text=device_names;
    [self.addActivityView.sign_deviceImage setHidden:YES];
    [[ScrollAddLabel new] addLabelToScrollView:self.addActivityView.signScrollView labels:deviceNameArray];
}

#pragma mark - delegate
- (void)didClickFinishDateTimePickerView:(NSString *)date{
    //tempTimeLabel.text = date;
    switch (tempTimeTag) {
        case 100:
            self.addActivityView.baomingTimeLabel.text=date;
            break;
        case 101:
            self.addActivityView.startTimeLabel.text=date;
            break;
        case 102:
            self.addActivityView.endTimeLabel.text=date;
            break;
        case 200:
            self.addActivityView.sign_start_timeLabel.text=date;
            break;
        case 201:
            self.addActivityView.sign_end_timeLabel.text=date;
            break;
        default:
            break;
            
    }
    
}



@end


