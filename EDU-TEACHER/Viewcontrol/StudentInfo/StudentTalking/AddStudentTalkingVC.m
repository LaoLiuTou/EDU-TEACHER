//
//  AddStudentTalkingVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/22.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AddStudentTalkingVC.h"
#import "DEFINE.h" 
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "AddStudentTalkingView.h"
#import "SelectStudentVC.h"
#import "DateTimePickerView.h"
#import "StudentTalkingVC.h"
#import "ScrollAddLabel.h"
@interface AddStudentTalkingVC ()<AddStudentTalkingDelegate,UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate,UIScrollViewDelegate,DateTimePickerViewDelegate>
@property (nonatomic, strong) AddStudentTalkingView *addStudentTalkingView;
@property (nonatomic, strong) NSMutableArray *attaFileNames;//附件名
@property (nonatomic, strong) NSMutableArray *attaFileTypes;//附件类型
@property (nonatomic, strong) NSMutableArray *attaFileData;//附件地址
@property (nonatomic, strong) NSMutableArray *attaFileResult;//上传结果
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DateTimePickerView *datePickerView;
@end

@implementation AddStudentTalkingVC{
    NSString *xs_names;
    NSString *xs_ids;
    NSString *xs_type;
    NSDictionary *tempStudentDic;
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
    xs_type=@"";
    tempStudentDic=[NSDictionary new];
    //注册通知：
    //注册通知：
    notificationName=@"SelectStudentTalking";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnSelectDic:) name:notificationName object:nil];
    
    if(self.xs_id!=nil){
        xs_ids=self.xs_id;
    }
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
    self.gk_navTitle=@"创建谈心谈话";
    self.gk_navTitleColor=[UIColor blackColor];
}

- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化视图
- (void)initView{
    
    [self.view addSubview:self.scrollView];
    [self.view sendSubviewToBack:_scrollView];
    
    AddStudentTalkingView *addStudentTalkingView = [[AddStudentTalkingView alloc]init];
    _addStudentTalkingView=addStudentTalkingView;
    //_addStudentTalkingView.frame = CGRectMake(0, 0, kWidth, kHeight);
    _addStudentTalkingView.delegate = self;
    [_addStudentTalkingView initViewWithId:self.xs_id Name:self.xs_name];
    //[self.view addSubview:_addStudentTalkingView];
    [self.scrollView addSubview:_addStudentTalkingView];
   
    
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
#pragma mark - 选择附件
- (void)clickSelectAtta {
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
    documentPicker.modalPresentationStyle = UIModalPresentationFullScreen;
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
                      
                      //self.addStudentTalkingView.filesLabel.text=[filenames componentsJoinedByString:@","];
                      [self.addStudentTalkingView.attaImage setHidden:YES];
                      [[ScrollAddLabel new] addLabelToScrollView:self.addStudentTalkingView.filesScrollView labels:filenames];
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
-(void)addTalking{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [paramDic setObject:xs_ids forKey:@"xs_ids"];
    
    [paramDic setObject:self.addStudentTalkingView.talk_timeLabel.text forKey:@"talk_time"];
    [paramDic setObject:self.addStudentTalkingView.addressText.text forKey:@"address"];
    if(![self.addStudentTalkingView.reasonText.text isEqualToString:@"添加谈话事由"]){
        [paramDic setObject:self.addStudentTalkingView.reasonText.text forKey:@"reason"];
    }
    if(![self.addStudentTalkingView.commentText.text isEqualToString:@"添加谈话内容"]){
        [paramDic setObject:self.addStudentTalkingView.commentText.text forKey:@"comment"];
    }
    
    if(![self.addStudentTalkingView.reasonText.text isEqualToString:@"添加后续关注措施"]){
        [paramDic setObject:self.addStudentTalkingView.followText.text forKey:@"follow"];
    }
    if(self.attaFileResult.count>0){
        [paramDic setObject:[self.attaFileResult componentsJoinedByString:@","] forKey:@"files"];
    }
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"addTh"];
    
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
                StudentTalkingVC *jumpVC=[StudentTalkingVC new];
                jumpVC.xs_id=self.xs_id;
                jumpVC.xs_name=self.xs_name;
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
- (void)clickSelectStu{
    NSLog(@"clickSelectStuBtn");
    if(self.xs_id==nil){
       
        SelectStudentVC *jumpVC=[SelectStudentVC new];
        jumpVC.select=@"0";
        
        if([xs_type isEqualToString:@"tag"]){
            jumpVC.values=@{@"tag":tempStudentDic};
        }
        else if([xs_type isEqualToString:@"class"]){
            jumpVC.selectIndex=1;
            jumpVC.values=@{@"class":tempStudentDic};
        }
        jumpVC.notificationName=notificationName; 
        //xs_names=@"";
        //xs_ids=@"";
        [self.navigationController pushViewController:jumpVC animated:YES];
    }
   
}
- (void)returnSelectDic:(NSNotification *)notification{
    NSLog(@"SelectDic%@",notification.userInfo);
    NSArray *stuIdArray=[notification.userInfo objectForKey:@"studentId"];
    NSArray *stuNameArray=[notification.userInfo objectForKey:@"studentName"];
    xs_ids=[stuIdArray count]>0?[stuIdArray componentsJoinedByString:@","]:@"";
    xs_names=[stuNameArray count]>0?[stuNameArray componentsJoinedByString:@","]:@"";
    xs_type=[notification.userInfo objectForKey:@"type"];
    tempStudentDic=[notification.userInfo objectForKey:@"tempValue"];
    self.addStudentTalkingView.nameLabel.text=xs_names;
    [self.addStudentTalkingView.selectImage setHidden:YES];
}
#pragma mark - 发布
- (void)clickPublishBtn:(UIButton *)btn {
    NSLog(@"clickPublishBtn");
    if([xs_ids isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择学生！"];
    }
    else if([self.addStudentTalkingView.talk_timeLabel.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择谈话时间！"];
    }
//    else if([self.addStudentTalkingView.addressText.text isEqualToString:@""]){
//        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入谈话地址！"];
//    }
    else if(self.addStudentTalkingView.addressText.text.length>100){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"谈话地址最多可输入100个汉字！"];
    }
    else if(self.addStudentTalkingView.reasonText.text.length>1000){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"谈话事由最多可输入1000个汉字！"];
    }
//    else if([self.addStudentTalkingView.commentText.text isEqualToString:@"添加谈话内容"]){
//        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入谈话内容！"];
//    }
    else if(self.addStudentTalkingView.commentText.text.length>2000){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"谈话内容最多可输入2000个汉字！"];
    }
    else if(self.addStudentTalkingView.followText.text.length>2000){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"后续关注措施最多可输入2000个汉字！"];
    }
    else{
        [self addTalking];
    }
}

- (void)clickTimeBtn:(UIButton *)btn {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    DateTimePickerView *pickerView = [[DateTimePickerView alloc] init];
    _datePickerView = pickerView;
    _datePickerView.delegate = self;
    _datePickerView.pickerViewMode = DatePickerViewDateTimeMode;
    [self.view addSubview:_datePickerView]; 
    [pickerView showDateTimePickerView];
}
#pragma mark - delegate
- (void)didClickFinishDateTimePickerView:(NSString *)date{
    self.addStudentTalkingView.talk_timeLabel.text = date;
}

@end
