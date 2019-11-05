//
//  Register2ViewController.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "Register2ViewController.h"
#import "Register2View.h"
#import "DEFINE.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
#import "VerifyUtil.h"
#import "SVProgressHUD.h"
#import "LoginViewController.h"
@interface Register2ViewController ()<Register2Delegate>
@property (nonatomic,strong) Register2View *register2View;
@end

@implementation Register2ViewController

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
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"2/2  " style:(UIBarButtonItemStyleDone) target:self action:nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
    [rightitem setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.gk_navRightBarButtonItem = rightitem;
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) initView{
    self.view.backgroundColor = [UIColor whiteColor];
    Register2View *register2View = [[Register2View alloc]init];
    _register2View=register2View;
    _register2View.registerModel=self.registerModel;
    _register2View.frame = CGRectMake(0, 0, kWidth, kHeight);
    _register2View.delegate = self;
    [self.view addSubview:_register2View];
}



- (void)clickRegBtn:(UIButton *)btn registerModel:(RegisterModel *)registerModel{
    if(registerModel.schoolId ==nil){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择学校！"];
    }
    else if(registerModel.academyId ==nil){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请选择院系！"];
    }
    else if([registerModel.count isEqualToString:@""]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"输入学生数量"];
    }
    else if(![VerifyUtil isVaildIDCardNo:registerModel.idNumber]){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请输入正确的身份证号码！"];
    }
    else if(registerModel.idImage==nil){
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请上传身份证照片！"];
    }
    else{
        [self uploadImage:registerModel];
    }
    
    NSLog(@"%@",registerModel);
}


- (void)uploadImage:(RegisterModel *)registerModel{
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
     NSDictionary *paramDic = @{@"project":@"edu"};
    NSData *imageData = UIImagePNGRepresentation(registerModel.idImage);
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:jbad.urlUpload parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:imageData name:@"files" fileName:@"filename.png" mimeType:@"image/png"];
        //第二种方式
        //[formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/Users/xieyang/Code/AFN/AFN/timg.jpeg"] name:@"file" fileName:@"xxxx.png" mimeType:@"image/png" error:nil];
        //第三种方式
        //[formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/Users/xieyang/Code/AFN/AFN/timg.jpeg"] name:@"file" error:nil];
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
              [SVProgressHUD dismiss];
              [[LTAlertView new] showOneChooseAlertViewMessage:@"图片上传失败"];
          } else {
              NSDictionary *result=responseObject;
              if([[result objectForKey:@"status"] isEqualToString:@"0"]){
                  NSArray *tempArray=[result objectForKey:@"data"];
                  if([tempArray count]>0){
                      registerModel.idImageUrl=tempArray[0];
                      [self reg:registerModel];
                  }
                  else{
                      [SVProgressHUD dismiss];
                      [[LTAlertView new] showOneChooseAlertViewMessage:@"图片上传失败"];
                  }
                  
              }
              else{
                  [SVProgressHUD dismiss];
                  [[LTAlertView new] showOneChooseAlertViewMessage:@"图片上传失败"];
              }
          }
      }];
    
    [uploadTask resume];
}

#pragma mark - 申请
-(void)reg:(RegisterModel *)registerModel{
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    // 将数据转模型
    //[RegisterModel modelWithDictionary:dic];
    // 将模型转数据
    //NSDictionary *paramDic = [registerModel modelToJSONObject];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    [paramDic setObject:registerModel.username forKey:@"name"];
    [paramDic setObject:registerModel.phone forKey:@"phone"];
    [paramDic setObject:registerModel.password forKey:@"password"];
    [paramDic setObject:registerModel.schoolId forKey:@"sc_id"];
    [paramDic setObject:registerModel.academyId forKey:@"ac_id"];
    [paramDic setObject:registerModel.count forKey:@"student_num"];
    [paramDic setObject:registerModel.idNumber forKey:@"card"];
    [paramDic setObject:registerModel.idImageUrl forKey:@"card_img"];
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"registFd"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            //[[LTAlertView new] showOneChooseAlertViewMessage:@"审核将在3-7个工作日内完成，请耐心等待。加速审核请联系微信jlucat"];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"审核将在3-7个工作日内完成，请耐心等待。加速审核请联系微信jlucat" preferredStyle:UIAlertControllerStyleAlert];
               [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   
                   AppDelegate *jbad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                   LoginViewController *jumpVC = [[LoginViewController alloc]init]; 
                   jbad.window.rootViewController = jumpVC;
                   
               }])];
               
               [self presentViewController:alertController animated:YES completion:nil];
            
            
        }
        else{
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"请求失败----%@", error);
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败"];
    }];
    
     
}

@end
