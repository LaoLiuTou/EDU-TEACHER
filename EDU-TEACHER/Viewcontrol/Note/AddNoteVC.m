//
//  AddNoteVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/5.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AddNoteVC.h"
#import "DEFINE.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AddNoteView.h"
#import "NoteVC.h"
#import "SelectStudentVC.h"
#import "ScrollAddLabel.h"
@interface AddNoteVC ()<AddNoteDelegate,UIScrollViewDelegate,UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) AddNoteView *addNoteView;
@property (nonatomic, strong) UIButton *publishBtn;

@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIScrollView *scrollView;


@property (nonatomic, strong) NSMutableArray *attaFileNames;//附件名
@property (nonatomic, strong) NSMutableArray *attaFileTypes;//附件类型
@property (nonatomic, strong) NSMutableArray *attaFileData;//附件地址
@property (nonatomic, strong) NSMutableArray *attaFileResult;//上传结果
@end

@implementation AddNoteVC{
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
    notificationName=@"SelectStudentNote";
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
    self.gk_navTitle=@"创建日志";
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
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(40);
    }];
  
    
    AddNoteView *addNoteView = [[AddNoteView alloc]init];
    _addNoteView=addNoteView;
    //_addStudentTalkingView.frame = CGRectMake(0, 0, kWidth, kHeight);
    _addNoteView.delegate = self;
    int height=[_addNoteView initView];
    //[self.view addSubview:_addStudentTalkingView];
    [self.scrollView addSubview:_addNoteView];
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
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        _saveBtn.layer.cornerRadius=12;
        _saveBtn.layer.masksToBounds=YES;
        _saveBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _saveBtn;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
}

#pragma mark - 创建
-(void)addNote{
//    if([self.addNoteView.nameText.text isEqualToString:@""]){
//        [[LTAlertView new] showOneChooseAlertViewMessage:@"日志名称不能为空！"];
//    }
//    else if(self.addNoteView.nameText.text.length>50){
//        [[LTAlertView new] showOneChooseAlertViewMessage:@"日志名称最多可输入50个汉字！"];
//    }
//    else
    if(self.addNoteView.commentText.text.length>1000){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"内容最多可输入1000个汉字！"];
    }
    else{
        
        [SVProgressHUD showWithStatus:@"加载中"];
        [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSMutableDictionary *paramDic =[NSMutableDictionary new];
        [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
        //[paramDic setObject:self.addNoteView.nameText.text forKey:@"name"];
        if(![self.addNoteView.commentText.text isEqualToString:@"添加日志内容"]){
            [paramDic setObject:self.addNoteView.commentText.text forKey:@"comment"];
        }
        if(![xs_ids isEqualToString:@""]){
            [paramDic setObject:xs_ids forKey:@"xs_ids"];
        }
        if([self.attaFileResult count]>0){
                [paramDic setObject:[self.attaFileResult componentsJoinedByString:@","] forKey:@"files"];
           }
        //[paramDic setObject:@[@"日常管理",@"谈心谈话"][self.addNoteView.typeSegment.selectedSegmentIndex] forKey:@"type"];
 
        NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"addRizhi"];
        LTHTTPManager * manager = [LTHTTPManager manager];
        [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *resultDic=responseObject;
            if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
                
                [SVProgressHUD dismiss];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[resultDic objectForKey:@"Point"] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NoteVC *jumpVC=[NoteVC new];
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


#pragma mark - 选择学生
- (void)clickSelectStu{
    NSLog(@"clickSelectStuBtn");
    
    SelectStudentVC *jumpVC=[SelectStudentVC new];
    //{tag:@{1:[1,2,3]},class:@{2:[1,2]}}
    if([xs_type isEqualToString:@"tag"]){
        jumpVC.values=@{@"tag":tempStudentDic};
    }
    else if([xs_type isEqualToString:@"class"]){
        jumpVC.selectIndex=1;
        jumpVC.values=@{@"class":tempStudentDic};
    }
    jumpVC.notificationName=notificationName;
    [self.navigationController pushViewController:jumpVC animated:YES];
    
}
- (void)returnSelectDic:(NSNotification *)notification{
    NSLog(@"SelectDic%@",notification.userInfo);
    
    //移除
    xs_names=@"";
    xs_ids=@"";
    xs_type=@"";
    NSArray *views = [self.addNoteView.stuScrollView subviews];
    for(UIView *view in views)
    {
        [view removeFromSuperview];
    }
    
    NSArray *stuIdArray=[notification.userInfo objectForKey:@"studentId"];
    NSArray *stuNameArray=[notification.userInfo objectForKey:@"studentName"];
    tempStudentDic=[notification.userInfo objectForKey:@"tempValue"];
    
    xs_type=[notification.userInfo objectForKey:@"type"];
    xs_ids=[stuIdArray count]>0?[stuIdArray componentsJoinedByString:@","]:@"";
    xs_names=[stuNameArray count]>0?[stuNameArray componentsJoinedByString:@","]:@"";
    //self.addNoteView.studentLabel.text=xs_names;
    [self.addNoteView.selectImage setHidden:YES];
    [[ScrollAddLabel new] addLabelToScrollView:self.addNoteView.stuScrollView labels:stuNameArray];
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
                      [self.addNoteView.attaImage setHidden:YES];
                      self.attaFileResult=[tempArray mutableCopy];
                      //self.addNoticeView.filesLabel.text=[filenames componentsJoinedByString:@","];
                      [[ScrollAddLabel new] addLabelToScrollView:self.addNoteView.filesScrollView labels:filenames];
 
 
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
#pragma mark - 保存
- (void)clickSaveBtn:(UIButton *)btn {
    
    [self addNote];
    
    
}
 

@end


