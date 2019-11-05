//
//  AddNoticeVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/11.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AddNoticeVC.h"
#import "DEFINE.h"
#import "AddNoticeView.h"
#import "SelectStudentVC.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "NoticeVC.h"
#import "ScrollAddLabel.h"
@interface AddNoticeVC ()<AddNoticeDelegate,UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate >
@property (nonatomic, strong) AddNoticeView *addNoticeView;
@property (nonatomic, strong) NSMutableArray *attaFileNames;//附件名
@property (nonatomic, strong) NSMutableArray *attaFileTypes;//附件类型
@property (nonatomic, strong) NSMutableArray *attaFileData;//附件地址
@property (nonatomic, strong) NSMutableArray *attaFileResult;//上传结果
@end

@implementation AddNoticeVC{
    NSString *xs_names;
    NSString *xs_ids; 
    NSString *xs_type;
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
    //注册通知：
    //注册通知：
    notificationName=@"SelectStudentNotice";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(returnSelectDic:) name:notificationName object:nil];
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
    self.gk_navTitle=@"创建通知";
    self.gk_navTitleColor=[UIColor blackColor];
}

- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}
 
#pragma mark - 初始化视图
- (void)initView{
    AddNoticeView *addNoticeView = [[AddNoticeView alloc]init];
    _addNoticeView=addNoticeView;
    _addNoticeView.frame = CGRectMake(0, 0, kWidth, kHeight);
    _addNoticeView.delegate = self;
    [self.view addSubview:_addNoticeView];
    
    
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
                      [self.addNoticeView.attaImage setHidden:YES];
                      self.attaFileResult=[tempArray mutableCopy];
                      //self.addNoticeView.filesLabel.text=[filenames componentsJoinedByString:@","];
                      [[ScrollAddLabel new] addLabelToScrollView:self.addNoticeView.filesScrollView labels:filenames];
 
 
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
-(void)addNotice:(NSString *)type{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [paramDic setObject:self.addNoticeView.nameText.text forKey:@"name"];
     
    if(![self.addNoticeView.commentText.text isEqualToString:@"添加通知内容"]){
        [paramDic setObject:self.addNoticeView.commentText.text forKey:@"comment"];
    }
    if( self.addNoticeView.selectedImage !=nil){
        [paramDic setObject:self.addNoticeView.selectedImage forKey:@"image"];
    }
    if([self.attaFileResult count]>0){
         [paramDic setObject:[self.attaFileResult componentsJoinedByString:@","] forKey:@"files"];
    }
    if([xs_type isEqualToString:@"class"]){
        [paramDic setObject:xs_ids forKey:@"class_ids"];
    }
    else{
        [paramDic setObject:xs_ids forKey:@"tag_ids"];
    }
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"addTongzhi"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            if([type isEqualToString:@"save"]){
                [SVProgressHUD dismiss];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[resultDic objectForKey:@"Point"] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //[self.navigationController popViewControllerAnimated:YES];
                    NSMutableArray *navViewArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                    int index = (int)[navViewArray indexOfObject:self];
                    [navViewArray removeObjectAtIndex:index];
                    [navViewArray removeObjectAtIndex:index-1];
                    [navViewArray addObject:[NoticeVC new]];
                    [self.navigationController setViewControllers:navViewArray animated:YES];
                }])];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
            else{
                NSString *noticeId=[resultDic objectForKey:@"Result"];
                [self publishNotice:noticeId];
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
#pragma mark - 网络请求获取数据
-(void)publishNotice:(NSString *)noticeId{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [paramDic setObject:noticeId forKey:@"id"];
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"publishTongzhi"];
    
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
                [navViewArray addObject:[NoticeVC new]];
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
    jumpVC.sub=@"1";
    jumpVC.notificationName=notificationName; 
    [self.navigationController pushViewController:jumpVC animated:YES];
    //移除文件
    NSArray *views = [self.addNoticeView.stuScrollView subviews];
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
    
    [self.addNoticeView.selectImage setHidden:YES];  
    [[ScrollAddLabel new] addLabelToScrollView:self.addNoticeView.stuScrollView labels:stuNameArray];
    
}
#pragma mark - 发布
- (void)clickPublishBtn:(UIButton *)btn {
    NSLog(@"clickPublishBtn");
    if([self.addNoticeView.nameText.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入通知名称！"];
    }
    else if([self textLength:self.addNoticeView.nameText.text]>100){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"通知名称最多可输入50个汉字，100个字符！"];
    }
    else if([xs_ids isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择签到范围！"];
    }
    else{
        [self addNotice:@"publish"];
    }
}

#pragma mark - 保存
- (void)clickSaveBtn:(UIButton *)btn {
    NSLog(@"clickSaveBtn：%lu",(unsigned long)[self textLength:self.addNoticeView.nameText.text]);
    if([self.addNoticeView.nameText.text isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入通知名称！"];
    }
    else if([self textLength:self.addNoticeView.nameText.text]>100){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"通知名称最多可输入50个汉字，100个字符！"];
    }
    else if([xs_ids isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择签到范围！"];
    }
    else{
        [self addNotice:@"save"];
    }
}
#pragma mark - 字符长度
- (NSUInteger)textLength:(NSString *)text{
    
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    
    NSUInteger unicodeLength = asciiLength;
    return unicodeLength;
}

@end
