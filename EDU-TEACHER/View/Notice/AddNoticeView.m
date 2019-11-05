//
//  AddNoticeView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/11.
//  Copyright © 2019 Jiubai. All rights reserved.
//
#define kSHWeak(VAR) \
try {} @finally {} \
__weak __typeof__(VAR) VAR##_myWeak_ = (VAR)
#define kSHStrong(VAR) \
try {} @finally {} \
__strong __typeof__(VAR) VAR = VAR##_myWeak_;\
if(VAR == nil) return

#import "AddNoticeView.h"
#import "DEFINE.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ImageZoomView.h"
#import "SHShortVideoViewController.h"
#import "SHFileHelper.h" 
#import "LTPickerView.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
@interface AddNoticeView ()<UITextViewDelegate,UIImagePickerControllerDelegate,LTPickerDelegate,UINavigationControllerDelegate>
 
@end
@implementation AddNoticeView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor=GKColorRGB(246, 246, 246);
        [self initView];
    }
    return self;
}
#pragma mark - initView
- (void)initView{
    
    //标题
    UIView *nameback=[[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+6, kWidth, 50)];
    nameback.backgroundColor=[UIColor whiteColor];
    [self addSubview:nameback];
    
    UIView *leftview=[[UIView alloc] init];
    leftview.backgroundColor=GKColorHEX(0x2c92f5,1);
    UITextField *nameText=[[UITextField alloc] init];
    _nameText=nameText;
    _nameText.backgroundColor=[UIColor whiteColor];
    _nameText.font=[UIFont systemFontOfSize:14];
    _nameText.textColor=[UIColor darkGrayColor];
    _nameText.placeholder=@"添加通知名称";
    
    [nameback addSubview:leftview];
    [leftview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameback).offset(15);
        make.centerY.equalTo(nameback);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(18);
    }];
    [self addSubview:_nameText];
    [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameback).offset(25);
        make.centerY.equalTo(nameback);
        make.width.mas_equalTo(kWidth-45);
        make.height.mas_equalTo(50.0f);
    }];
    
    
    //内容
    UIView *commentback=[[UIView alloc] init];
    commentback.backgroundColor=[UIColor whiteColor];
    [self addSubview:commentback];
    [commentback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameback.mas_bottom);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(120);
    }];
    UITextView *commentText=[[UITextView alloc] init];
    _commentText=commentText;
    _commentText.backgroundColor=[UIColor whiteColor];
    _commentText.font=[UIFont systemFontOfSize:14];
    _commentText.text = @"添加通知内容";
    _commentText.textColor = GKColorRGB(197, 197, 197);
    _commentText.delegate=self;
    [commentback addSubview:_commentText];
    [_commentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(10);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(100);
    }];
    
    //添加图片
    UIView *addimageback=[[UIView alloc] init];
    addimageback.backgroundColor=[UIColor whiteColor];
    [self addSubview:addimageback];
    [addimageback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(100);
    }];
    UIImageView *addImageView=[[UIImageView alloc] init];
    _addImageView=addImageView;
    _addImageView.layer.cornerRadius = 8;
    _addImageView.userInteractionEnabled = YES;
    _addImageView.contentMode = UIViewContentModeScaleAspectFill;
    _addImageView.clipsToBounds = YES; // 裁剪边缘
    
    [_addImageView setImage:[UIImage imageNamed:@"uploadimage"]];
    [addimageback addSubview:_addImageView];
    [_addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addimageback).offset(15);
        make.centerY.equalTo(addimageback);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(80.0f);
    }];
    
    UITapGestureRecognizer *selectImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSelectImage:)];
    
    [_addImageView addGestureRecognizer:selectImageTap];
    //添加附件
    UIButton *attaback=[[UIButton alloc] init];
    attaback.backgroundColor=[UIColor whiteColor];
    [attaback addTarget:self action:@selector(clickSelectAtta) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:attaback];
    [attaback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addimageback.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50);
    }];
    UILabel *attaLabel=[[UILabel alloc] init];
    attaLabel.text=@"添加文件";
    attaLabel.font=[UIFont systemFontOfSize:14];
    attaLabel.textColor=[UIColor blackColor];
    attaLabel.textAlignment=NSTextAlignmentLeft;
    [attaback addSubview:attaLabel];
    [attaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(attaback).offset(15);
        make.centerY.equalTo(attaback);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
//    UILabel *filesLabel=[[UILabel alloc] init];
//    _filesLabel=filesLabel;
//    _filesLabel.font=[UIFont systemFontOfSize:14];
//    _filesLabel.textColor=[UIColor grayColor];
//    _filesLabel.textAlignment=NSTextAlignmentRight;
//    [attaback addSubview:_filesLabel];
//    [_filesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(attaback).offset(115);
//        make.centerY.equalTo(attaback);
//        make.width.mas_equalTo(kWidth-170);
//        make.height.mas_equalTo(50);
//    }];
    //文件
    UIScrollView *filesScrollView=[[UIScrollView alloc] init];
    _filesScrollView=filesScrollView;
    _filesScrollView.showsHorizontalScrollIndicator = NO;
    _filesScrollView.backgroundColor=[UIColor whiteColor];
    _filesScrollView.bounces = YES;
    [attaback addSubview:_filesScrollView];
    UITapGestureRecognizer *selectAtta= [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(clickSelectAtta)];
    [_filesScrollView addGestureRecognizer:selectAtta];
    [_filesScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(attaback).offset(115);
        make.centerY.equalTo(attaback);
        make.width.mas_equalTo(kWidth-145);
        make.height.mas_equalTo(50);
    }];
    
    
    UIImageView *attaImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fujian_gray"]];
    _attaImage=attaImage;
    [attaback addSubview:_attaImage];
    [_attaImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(attaback).offset(-30);
        make.centerY.equalTo(attaback);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    
    UIImageView *attaRightImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youjiantou"]];
    [attaback addSubview:attaRightImage];
    [attaRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(attaback).offset(-10);
        make.centerY.equalTo(attaback);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    
    //选择通知范围
    UIButton *selectback=[[UIButton alloc] init];
    selectback.backgroundColor=[UIColor whiteColor];
    [selectback addTarget:self action:@selector(clickSelectStu) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectback];
    [selectback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(attaback.mas_bottom).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50);
    }];
    UILabel *selectLabel=[[UILabel alloc] init];
    selectLabel.text=@"选择通知范围";
    selectLabel.font=[UIFont systemFontOfSize:14];
    selectLabel.textColor=[UIColor blackColor];
    selectLabel.textAlignment=NSTextAlignmentLeft;
    [selectback addSubview:selectLabel];
    [selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectback).offset(15);
        make.centerY.equalTo(selectback);
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(50);
    }];
    
    UIScrollView *stuScrollView=[[UIScrollView alloc] init];
    _stuScrollView=stuScrollView;
    _stuScrollView.showsHorizontalScrollIndicator = NO;
    _stuScrollView.backgroundColor=[UIColor whiteColor];
    _stuScrollView.bounces = YES;
    [selectback addSubview:_stuScrollView];
    UITapGestureRecognizer *selectStu= [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(clickSelectStu)];
    [_stuScrollView addGestureRecognizer:selectStu];
    [_stuScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectback).offset(115);
        make.centerY.equalTo(selectback);
        make.width.mas_equalTo(kWidth-145);
        make.height.mas_equalTo(50);
    }];
    
    
    UIImageView *selectImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiahao"]];
    _selectImage=selectImage;
    [selectback addSubview:_selectImage];
    [_selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(selectback).offset(-30);
        make.centerY.equalTo(selectback);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    UIImageView *selectRightImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youjiantou"]];
    [selectback addSubview:selectRightImage];
    [selectRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(selectback).offset(-10);
        make.centerY.equalTo(selectback);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    
    UIButton *saveBtn=[[UIButton alloc] init];
    _saveBtn=saveBtn;
    [self addSubview:_saveBtn];
    _saveBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [_saveBtn addTarget:self action:@selector(clickSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    _saveBtn.layer.cornerRadius=12;
    _saveBtn.layer.masksToBounds=YES;
    _saveBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
    [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-10-BottomPaddingHeight);
        make.width.mas_equalTo((kWidth-40)/2);
        make.height.mas_equalTo(40);
    }];
    UIButton *publishBtn=[[UIButton alloc] init];
    _publishBtn=publishBtn;
    [self addSubview:_publishBtn];
    _publishBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [_publishBtn addTarget:self action:@selector(clickPublishBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_publishBtn setTitle:@"保存并发送" forState:UIControlStateNormal];
    _publishBtn.layer.cornerRadius=12;
    _publishBtn.layer.masksToBounds=YES;
    _publishBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
    [_publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset((kWidth/2)+10);
        make.bottom.equalTo(self).offset(-10-BottomPaddingHeight);
        make.width.mas_equalTo((kWidth-40)/2);
        make.height.mas_equalTo(40);
    }];
}



#pragma mark - 选择附件
-(void)clickSelectAtta{
    if([self.delegate respondsToSelector:@selector(clickSelectAtta)]){
        [self.delegate clickSelectAtta];
    }
}
#pragma mark - 选择人员
-(void)clickSelectStu{
    if([self.delegate respondsToSelector:@selector(clickSelectStu)]){
        [self.delegate clickSelectStu];
    }
}
#pragma mark - 发布
-(void)clickSaveBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickSaveBtn:)]){
        [self.delegate clickSaveBtn:sender];
    }
}
#pragma mark - 保存并发布
-(void)clickPublishBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickPublishBtn:)]){
        [self.delegate clickPublishBtn:sender];
    }
}
#pragma mark - 显示选择照片提示Sheet
-(void)clickSelectImage:(UITapGestureRecognizer *)tap{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"选择照片" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"拍照"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SHShortVideoViewController *vc = [[SHShortVideoViewController alloc]init];
        //    vc.maxSeconds = 15;
        @kSHWeak(self);
        vc.finishBlock = ^(id content) {
            @kSHStrong(self);
            if ([content isKindOfClass:[NSString class]]) {
                NSLog(@"视频路径：%@",content);
                //发送视频
            }else if ([content isKindOfClass:[UIImage class]]){
                NSLog(@"图片内容：%@",content);
                [self.addImageView setImage:content];
                [self uploadImage:content];
            }
        };
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [[self currentViewController] presentViewController:vc animated:YES completion:nil];
        
    }];
    UIAlertAction *actionAlbum = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"相册"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.view.backgroundColor = [UIColor whiteColor];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [[self currentViewController] presentViewController:picker animated:YES completion:nil];
         
    }];
    [alertController addAction:actionCancel];
    [alertController addAction:actionCamera];
    [alertController addAction:actionAlbum];
    [[self currentViewController] presentViewController:alertController animated:YES completion:nil];
    
}
#pragma mark - 获取Window当前显示的ViewController
- (UIViewController *)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.movie"]) {//如果是视频
        //视频路径
        //NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        [[self currentViewController] dismissViewControllerAnimated:YES completion:nil];
        
    }else if ([mediaType isEqualToString:@"public.image"]){
        UIImage *image = nil;
        //如果允许编辑则获得编辑后的照片，否则获取原始照片
        if (picker.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];//获取编辑后的照片
        }else{
            image = [info objectForKey:UIImagePickerControllerOriginalImage];//获取原始照片
        }
         [self.addImageView setImage:image];
        [self uploadImage:image];
        [[self currentViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 图片上传

- (void)uploadImage:(UIImage *)image{
    
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
        });
    }
      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
          if (error) {
              
              [[LTAlertView new] showOneChooseAlertViewMessage:@"图片上传失败"];
          } else {
              NSDictionary *result=responseObject;
              if([[result objectForKey:@"status"] isEqualToString:@"0"]){
                  NSArray *tempArray=[result objectForKey:@"data"];
                  if([tempArray count]>0){
                      self.selectedImage=tempArray[0];
                  }
                  else{
                      [[LTAlertView new] showOneChooseAlertViewMessage:@"图片上传失败"];
                  }
              }
              else{
                  [[LTAlertView new] showOneChooseAlertViewMessage:@"图片上传失败"];
              }
          }
      }];
    
    [uploadTask resume];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        self.commentText.text = @"添加通知内容";
        self.commentText.textColor = [UIColor lightGrayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([self.commentText.text isEqualToString:@"添加通知内容"]){
        self.commentText.text=@"";
        self.commentText.textColor=[UIColor darkGrayColor];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}
@end
