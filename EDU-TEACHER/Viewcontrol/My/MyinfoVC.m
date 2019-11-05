//
//  MyinfoVC.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "MyinfoVC.h"
#import "DEFINE.h"
#import "MyinfoView.h"
#import "CropImageController.h"
#import "UIImage+Crop.h"
#import "LTAlertView.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
@interface MyinfoVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate,MyInfoDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) MyinfoView *myinfoView ;
@property (nonatomic, strong) UIImagePickerController * pickerController;
@end

@implementation MyinfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
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
    self.gk_navTitle=@"个人信息";
    self.gk_navTitleColor=[UIColor blackColor];
}
- (void)leftBarClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initView{
    [self.view addSubview:self.scrollView];
    [self.view sendSubviewToBack:_scrollView];
    
    MyinfoView *myinfoView = [[MyinfoView alloc]init];
    self.myinfoView=myinfoView;
    //self.studentView.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.myinfoView.delegate = self;
    int y=[self.myinfoView initViewModel:self.myModel];
    [self.scrollView addSubview:self.myinfoView];
    _scrollView.contentSize =CGSizeMake(0,y+10);
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,kNavBarHeight, kWidth, kHeight-kNavBarHeight)];
        _scrollView.backgroundColor=[UIColor whiteColor];
        
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        // 设置代理人
        _scrollView.delegate =self;
        
    }
    return _scrollView;
}
- (void)clickSelectImage:(UITapGestureRecognizer *)tap {
    UIAlertController * con = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction * camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
        [con addAction:camera];
    }
    UIAlertAction * photo = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [con addAction:photo];
    [con addAction:cancel];
    [self presentViewController:con animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        CropImageController * con = [[CropImageController alloc] initWithImage:image delegate:self];
        [self.navigationController pushViewController:con animated:YES];
    }];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = image.size.height * (width/image.size.width);
    UIImage * orImage = [image resizeImageWithSize:CGSizeMake(width, height)];
    CropImageController * con = [[CropImageController alloc] initWithImage:orImage delegate:self];
    con.ovalClip = YES;
    [self.navigationController pushViewController:con animated:YES];
}
#pragma mark -- CropImageDelegate
- (void)cropImageDidFinishedWithImage:(UIImage *)image {
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleLight)];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showProgress:0.0];
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *paramDic = @{@"project":@"edu"};
    NSData *imageData = UIImagePNGRepresentation(image);
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:jbad.urlUpload parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"files" fileName:@"filename.png" mimeType:@"image/png"];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //显示进度
            //[self.progress setProgress:uploadProgress.fractionCompleted];
            [SVProgressHUD showProgress:uploadProgress.fractionCompleted];
        });
    }
      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
          if (error) {
              
              [[LTAlertView new] showOneChooseAlertViewMessage:@"图片上传失败"];
              [SVProgressHUD dismiss];
              [self.pickerController dismissViewControllerAnimated:YES completion:nil];
          } else {
              NSDictionary *result=responseObject;
              if([[result objectForKey:@"status"] isEqualToString:@"0"]){
                  
                  NSArray *tempArray=[result objectForKey:@"data"];
                  if([tempArray count]>0){
                      [self.myinfoView.header setImage:image];
                      [self updateMyInfo:tempArray[0]];
                  }
                  else{
                      [SVProgressHUD dismiss];
                      [self.pickerController dismissViewControllerAnimated:YES completion:nil];
                      [[LTAlertView new] showOneChooseAlertViewMessage:@"图片上传失败"];
                  }
              }
              else{
                  [SVProgressHUD dismiss];
                  [self.pickerController dismissViewControllerAnimated:YES completion:nil];
                  [[LTAlertView new] showOneChooseAlertViewMessage:@"图片上传失败"];
              }
          }
      }];
    
    [uploadTask resume];
    
}


#pragma mark - 网络请求获取数据
-(void)updateMyInfo:(NSString *)imageUrl{
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *paramDic =[NSMutableDictionary new];
    [paramDic setObject:[jbad.userInfoDic objectForKey:@"USER_ID"] forKey:@"USER_ID"];
    [paramDic setObject:imageUrl forKey:@"image"];
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"updateFdInfo"];
    
    LTHTTPManager * manager = [LTHTTPManager manager];
    [manager LTPost:postUrl param:paramDic success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];
        [self.pickerController dismissViewControllerAnimated:YES completion:nil];
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            ////
            NSString *filename = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"configInfo.plist"];
            
            NSMutableDictionary *localConfigDic=[[[NSMutableDictionary alloc]initWithContentsOfFile:filename] mutableCopy];
            if([localConfigDic count]==0){
                localConfigDic=[[NSMutableDictionary alloc] init];
            }
            [jbad.userInfoDic setValue:imageUrl forKey:@"IMG"];
            [localConfigDic setValue:jbad.userInfoDic forKey:@"userInfo"];
            [localConfigDic writeToFile:filename  atomically:YES];
        }
        else{
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];
        [self.pickerController dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"请求失败----%@", error);
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败！"];
    }];
    
     
}

@end
