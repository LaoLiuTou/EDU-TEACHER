//
//  RegisterView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/6/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//
#define kSHWeak(VAR) \
try {} @finally {} \
__weak __typeof__(VAR) VAR##_myWeak_ = (VAR)
#define kSHStrong(VAR) \
try {} @finally {} \
__strong __typeof__(VAR) VAR = VAR##_myWeak_;\
if(VAR == nil) return

#import "Register2View.h"
#import "DEFINE.h"
#import "SHShortVideoViewController.h"
#import "SHFileHelper.h"
#import "SelectSchoolViewController.h"
#import "LTPickerView.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "LTAlertView.h"
@interface Register2View ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,LTPickerDelegate>
@property (nonatomic,strong)UIView *textFiledView;
@property (nonatomic,strong)UITextField * school;
@property (nonatomic,strong)UITextField * academy;
@property (nonatomic,strong)UITextField * count;
@property (nonatomic,strong)UITextField * idNumber;
@property (nonatomic,strong)UIButton * idImage;
@property (nonatomic,strong)UIButton * regBtn;
@property (nonatomic,strong)UIImageView *idView;
@property (nonatomic,strong)NSString *selectSchoolId;
@property (nonatomic,strong)NSString *selectAcademyId; 
@end

@implementation Register2View

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        [self initView];
        _registerModel = [[RegisterModel alloc] init];
    }
    return self;
}
-(void) initView{
    
    //标题
    UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(30, 90, kWidth-30*2, 40)];
    title.text=@"账号申请";
    title.font=[UIFont systemFontOfSize:22];
    title.textColor=[UIColor blackColor];
    title.textAlignment=NSTextAlignmentLeft;
    [self addSubview:title];
    
    //输入框背景
    UIView *textFiledView = [[UIView alloc]init];
    _textFiledView=textFiledView;
    _textFiledView.frame = CGRectMake(30, 150, kWidth-30*2, 55*5+80);
    _textFiledView.backgroundColor = [UIColor whiteColor];
    _textFiledView.layer.shadowColor = [UIColor blackColor].CGColor;
    _textFiledView.layer.shadowOffset = CGSizeMake(0,0);
    _textFiledView.layer.shadowOpacity = 0.2;
    _textFiledView.layer.shadowRadius = 4;
    _textFiledView.layer.cornerRadius = 4;
    _textFiledView.layer.masksToBounds = YES;
    _textFiledView.clipsToBounds = NO;
    [self addSubview:_textFiledView];
    
    
    //图标 and 线
    NSArray *iconArray=@[@"xuexiao",@"xueyuan",@"renshu",@"zhenshixingming",@"zhaopian"];
    for(int i=0;i<5;i++){
        if(i!=4){
            UIView * line=[[UIView alloc] initWithFrame:CGRectMake(10, (50+5)*(i+1), kWidth-10*2-30*2, 1)];
            line.backgroundColor=GKColorHEX(0xeeeeee, 1);
            [_textFiledView addSubview: line];
        }
        UIView * hline=[[UIView alloc] initWithFrame:CGRectMake(55, 55*i+15, 1, 25)];
        hline.backgroundColor=GKColorHEX(0xeeeeee, 1);
        [_textFiledView addSubview: hline];
        
        UIImageView *iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(15, 55*i+13, 29, 29)];
        iconImageView.image = [UIImage imageNamed:[iconArray objectAtIndex:i]];
        [_textFiledView addSubview: iconImageView];
        
        
        if(i==0||i==1){
            UIImageView *iconImageView=[[UIImageView alloc] initWithFrame:CGRectMake(kWidth-30-60, 55*i+13, 29, 29)];
            iconImageView.image = [UIImage imageNamed:@"youjiantou"];
            [_textFiledView addSubview: iconImageView];
        }
      
        
    }
 
    
    [_textFiledView addSubview:self.school];
    [_textFiledView addSubview:self.academy];
    [_textFiledView addSubview:self.count];
    [_textFiledView addSubview:self.idNumber];
    [_textFiledView addSubview:self.idImage];
    
    //身份证
    CGFloat viewWidth = 180;
    CGFloat viewHeight = 110;
    _idView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 55*4+13, viewWidth, viewHeight)];
    _idView.backgroundColor = GKColorRGB(249,249,247);
    _idView.layer.cornerRadius = 8;
    _idView.userInteractionEnabled = YES;
    _idView.contentMode = UIViewContentModeScaleAspectFill;
    _idView.clipsToBounds = YES; // 裁剪边缘
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, viewWidth, viewHeight);
    borderLayer.position = CGPointMake(CGRectGetMidX(_idView.bounds), CGRectGetMidY(_idView.bounds));
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:8].CGPath;
    borderLayer.lineWidth = 1. / [[UIScreen mainScreen] scale];
    borderLayer.lineDashPattern = @[@4, @4];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = GKColorRGB(232,232,232).CGColor;
    [_idView.layer addSublayer:borderLayer];
    [_textFiledView addSubview:_idView];
  
    UIButton *selectImageBtn=[[UIButton alloc] init];
    _idImage=selectImageBtn;
    [_idImage setBackgroundImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    [_idImage addTarget:self action:@selector(clickSelectImageBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_idView addSubview:_idImage];
    [_idImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.idView).offset(15);
        make.centerX.equalTo(self.idView);
        make.width.mas_equalTo(50.0f);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *selectImageLabel=[[UILabel alloc] init];
    selectImageLabel.text=@"上传身份证照片";
    selectImageLabel.font=[UIFont systemFontOfSize:14];
    selectImageLabel.textColor=GKColorRGB(191,191,191);
    [_idView addSubview:selectImageLabel];
    [selectImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.idView).offset(70);
        make.centerX.equalTo(self.idView);
        make.width.mas_equalTo(100.0f);
        make.height.mas_equalTo(30.0f);
    }];
    [self addSubview:self.regBtn];
    
}

#pragma mark - 懒加载
- (UITextField *)school{
    if (!_school) {
        _school=[[UITextField alloc] init];
        _school.backgroundColor=[UIColor clearColor];
        _school.font=[UIFont systemFontOfSize:16];
        _school.textColor=[UIColor darkGrayColor];
        _school.frame=CGRectMake(70, 15, kWidth-30*2-80, 30);
        _school.placeholder=@"选择学校";
        _school.delegate=self;
        
        
    }
    return _school;
}

- (UITextField *)academy{
    if (!_academy) {
        _academy=[[UITextField alloc] init];
        _academy.backgroundColor=[UIColor clearColor];
        _academy.font=[UIFont systemFontOfSize:16];
        _academy.textColor=[UIColor darkGrayColor];
        _academy.frame=CGRectMake(70, 55*1+15, kWidth-30*2-80, 30);
        _academy.placeholder=@"选择已有学院";
        _academy.delegate=self;
    }
    return _academy;
}


- (UITextField *)count{
    if (!_count) {
        _count=[[UITextField alloc] init];
        _count.backgroundColor=[UIColor clearColor];
        _count.font=[UIFont systemFontOfSize:16];
        _count.textColor=[UIColor darkGrayColor];
        _count.keyboardType=UIKeyboardTypeNumberPad;
        _count.frame=CGRectMake(70, 55*2+15, kWidth-30*2-80, 30);
        _count.placeholder=@"学生数量";
    }
    return _count;
}
- (UITextField *)idNumber{
    if (!_idNumber) {
        _idNumber=[[UITextField alloc] init];
        _idNumber.backgroundColor=[UIColor clearColor];
        _idNumber.font=[UIFont systemFontOfSize:16];
        _idNumber.textColor=[UIColor darkGrayColor];
        _idNumber.frame=CGRectMake(70, 55*3+15, kWidth-30*2-80, 30);
        _idNumber.placeholder=@"身份证号码";
    }
    return _idNumber;
}

- (UIButton *)regBtn{
    if (!_regBtn) {
        _regBtn=[[UIButton alloc] initWithFrame:CGRectMake(40, 540, kWidth-40*2, 40)];
        _regBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [_regBtn addTarget:self action:@selector(clickRegBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_regBtn setTitle:@"申请" forState:UIControlStateNormal];
        _regBtn.layer.cornerRadius=16;
        _regBtn.layer.masksToBounds=YES;
        _regBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
        [_regBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _regBtn;
}
#pragma mark - 文本框点击
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField ==_school){
        SelectSchoolViewController * ssVC=[[SelectSchoolViewController alloc] init];
        
        ssVC.seletedSchool=^(NSDictionary *schoolDic){
            textField.text=[schoolDic objectForKey:@"name"];
            self.selectSchoolId=[schoolDic objectForKey:@"id"];
            self.academy.text=@"";
            self.selectAcademyId=nil;
        };
        [[self currentViewController].navigationController pushViewController:ssVC animated:YES ];
        return NO;
    }
    else if(textField ==_academy){
        if(_selectSchoolId!=nil){
            [self getAcademyList:_selectSchoolId];
        }
        else{
            [[LTAlertView new] showOneChooseAlertViewMessage:@"请先选择学校！"];
        }
        
        return NO;
    }
    return YES;
}
#pragma mark - 选择学院
- (void)pickViewSureBtnClick:(NSDictionary *)selectSchoole{
    _academy.text=[selectSchoole objectForKey:@"NM_T"];
    _selectAcademyId=[selectSchoole objectForKey:@"ID"];
    NSLog(@"%@",selectSchoole);
}

#pragma mark - 显示选择照片提示Sheet
-(void)clickSelectImageBtn:(UIButton *)sender{
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
                self.idView.image=content;
                
            }
        };
        [[self currentViewController] presentViewController:vc animated:YES completion:nil];
        
    }];
    UIAlertAction *actionAlbum = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"相册"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.view.backgroundColor = [UIColor whiteColor];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
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
        _idView.image=image;
        
        [[self currentViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}


-(void)clickRegBtn:(UIButton *)sender{
    self.registerModel.schoolId=_selectSchoolId;
    self.registerModel.academyId=_selectAcademyId;
    self.registerModel.count=_count.text;
    self.registerModel.idNumber=_idNumber.text;
    self.registerModel.idImage=self.idView.image;
    if([self.delegate respondsToSelector:@selector(clickRegBtn:registerModel:)]){
        [self.delegate clickRegBtn:sender registerModel:_registerModel];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

#pragma mark - 获取院系
-(void)getAcademyList:(NSString *)schoolId{
    AppDelegate *jbad=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *paramDic = @{@"sc_id":schoolId};
    NSString *postUrl=[NSString stringWithFormat:@"%@%@",jbad.url,@"queryRegistAcList"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:postUrl parameters:paramDic headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *resultDic=responseObject;
        if([[resultDic objectForKey:@"Code"] isEqualToString:@"1"]){
            NSArray *result=[resultDic objectForKey:@"Result"];
            if([result count]>0){
                LTPickerView *picker  = [[LTPickerView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
                picker.dataArray = result;
                picker.delegate = self;
                [self addSubview:picker];
            }
            else{
                [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
            }
            
        }
        else{
            [[LTAlertView new] showOneChooseAlertViewMessage:[resultDic objectForKey:@"Point"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败----%@", error);
        [[LTAlertView new] showOneChooseAlertViewMessage:@"请求失败"];
        
    }];
    
}



@end
