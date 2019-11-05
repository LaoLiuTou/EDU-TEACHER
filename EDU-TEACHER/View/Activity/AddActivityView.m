//
//  AddActivityView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//
#define kSHWeak(VAR) \
try {} @finally {} \
__weak __typeof__(VAR) VAR##_myWeak_ = (VAR)
#define kSHStrong(VAR) \
try {} @finally {} \
__strong __typeof__(VAR) VAR = VAR##_myWeak_;\
if(VAR == nil) return
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
#import "AddActivityView.h"
@interface AddActivityView ()<UITextViewDelegate,UIImagePickerControllerDelegate,LTPickerDelegate,UINavigationControllerDelegate>

@end
@implementation AddActivityView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, 780+260);
        self.backgroundColor=GKColorRGB(246, 246, 246);
        //[self initView];
    }
    return self;
}


#pragma mark - initView
- (int)initView{
    
    //标题
    UIView *nameback=[[UIView alloc] initWithFrame:CGRectMake(0, 6, kWidth, 50)];
    nameback.backgroundColor=[UIColor whiteColor];
    [self addSubview:nameback];
    
    UIView *leftview=[[UIView alloc] init];
    leftview.backgroundColor=GKColorHEX(0x2c92f5,1);
    UITextField *nameText=[[UITextField alloc] init];
    _nameText=nameText;
    _nameText.backgroundColor=[UIColor whiteColor];
    _nameText.font=[UIFont systemFontOfSize:14];
    _nameText.textColor=[UIColor darkGrayColor];
    _nameText.placeholder=@"添加活动名称";
    
    [nameback addSubview:leftview];
    [leftview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameback).offset(15);
        make.centerY.equalTo(nameback);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(18);
    }];
    [nameback addSubview:_nameText];
    [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameback).offset(25);
        make.centerY.equalTo(nameback);
        make.width.mas_equalTo(kWidth-45);
        make.height.mas_equalTo(50.0f);
    }];
    
    //关注级别
    UIButton *typeBack=[[UIButton alloc] init];
    typeBack.backgroundColor=[UIColor whiteColor];
    [self addSubview:typeBack];
    [typeBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameback.mas_bottom).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *levelTitle=[[UILabel alloc] init];
    levelTitle.textColor=[UIColor blackColor];
    levelTitle.font=[UIFont systemFontOfSize:14];
    levelTitle.text=@"活动类型";
    [typeBack addSubview:levelTitle];
    [levelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeBack).offset(15);
        make.centerY.equalTo(typeBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UISegmentedControl *typeSegment = [[UISegmentedControl alloc]initWithItems:@[@"报名类",@"签到类"]];
    [typeSegment addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventValueChanged];
    _typeSegment=typeSegment;
    _typeSegment.selectedSegmentIndex=0;
    [typeBack addSubview:_typeSegment];
    [_typeSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(typeBack).offset(-15);
        make.centerY.equalTo(typeBack);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30.0f);
    }];
    
    
    
    //截止时间
    UIButton *baomingTimeBack=[[UIButton alloc] init];
    baomingTimeBack.backgroundColor=[UIColor whiteColor];
    baomingTimeBack.tag=100;
    [baomingTimeBack addTarget:self action:@selector(clickTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:baomingTimeBack];
    [baomingTimeBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeBack.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *baomingTitle=[[UILabel alloc] init];
    baomingTitle.textColor=[UIColor blackColor];
    baomingTitle.font=[UIFont systemFontOfSize:14];
    baomingTitle.text=@"报名截止时间";
    [baomingTimeBack addSubview:baomingTitle];
    [baomingTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baomingTimeBack).offset(15);
        make.centerY.equalTo(baomingTimeBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *baomingTimeLabel=[[UILabel alloc] init];
    _baomingTimeLabel=baomingTimeLabel;
    _baomingTimeLabel.font=[UIFont systemFontOfSize:14];
    _baomingTimeLabel.textColor=[UIColor darkGrayColor];
    _baomingTimeLabel.textAlignment=NSTextAlignmentRight;
    _baomingTimeLabel.text=@"";
    [baomingTimeBack addSubview:_baomingTimeLabel];
    [_baomingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baomingTimeBack).offset(115);
        make.centerY.equalTo(baomingTimeBack);
        make.width.mas_equalTo(kWidth-130);
        make.height.mas_equalTo(50.0f);
    }];
    
    
    //开始时间
    UIButton *startTimeBack=[[UIButton alloc] init];
    startTimeBack.backgroundColor=[UIColor whiteColor];
    startTimeBack.tag=101;
    [startTimeBack addTarget:self action:@selector(clickTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:startTimeBack];
    [startTimeBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(baomingTimeBack.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *stratTimeTitle=[[UILabel alloc] init];
    stratTimeTitle.textColor=[UIColor blackColor];
    stratTimeTitle.font=[UIFont systemFontOfSize:14];
    stratTimeTitle.text=@"活动开始时间";
    [startTimeBack addSubview:stratTimeTitle];
    [stratTimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startTimeBack).offset(15);
        make.centerY.equalTo(startTimeBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *startTimeLabel=[[UILabel alloc] init];
    _startTimeLabel=startTimeLabel;
    _startTimeLabel.font=[UIFont systemFontOfSize:14];
    _startTimeLabel.textColor=[UIColor darkGrayColor];
    _startTimeLabel.textAlignment=NSTextAlignmentRight;
    _startTimeLabel.text=@"";
    [startTimeBack addSubview:_startTimeLabel];
    [_startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startTimeBack).offset(115);
        make.centerY.equalTo(startTimeBack);
        make.width.mas_equalTo(kWidth-130);
        make.height.mas_equalTo(50.0f);
    }];
    
    //结束时间
    UIButton *endTimeBack=[[UIButton alloc] init];
    endTimeBack.backgroundColor=[UIColor whiteColor];
    endTimeBack.tag=102;
    [endTimeBack addTarget:self action:@selector(clickTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:endTimeBack];
    [endTimeBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(startTimeBack.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *endTimeTitle=[[UILabel alloc] init];
    endTimeTitle.textColor=[UIColor blackColor];
    endTimeTitle.font=[UIFont systemFontOfSize:14];
    endTimeTitle.text=@"活动结束时间";
    [endTimeBack addSubview:endTimeTitle];
    [endTimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(endTimeBack).offset(15);
        make.centerY.equalTo(endTimeBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *endTimeLabel=[[UILabel alloc] init];
    _endTimeLabel=endTimeLabel;
    _endTimeLabel.font=[UIFont systemFontOfSize:14];
    _endTimeLabel.textColor=[UIColor darkGrayColor];
    _endTimeLabel.textAlignment=NSTextAlignmentRight;
    _endTimeLabel.text=@"";
    [endTimeBack addSubview:_endTimeLabel];
    [_endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(endTimeBack).offset(115);
        make.centerY.equalTo(endTimeBack);
        make.width.mas_equalTo(kWidth-130);
        make.height.mas_equalTo(50.0f);
    }];
    
    
    //限制人数
    UIButton *numberBack=[[UIButton alloc] init];
    numberBack.backgroundColor=[UIColor whiteColor];
    [numberBack addTarget:self action:@selector(clickTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:numberBack];
    [numberBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(endTimeBack.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *numberTitle=[[UILabel alloc] init];
    numberTitle.textColor=[UIColor blackColor];
    numberTitle.font=[UIFont systemFontOfSize:14];
    numberTitle.text=@"限制人数";
    [numberBack addSubview:numberTitle];
    [numberTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberBack).offset(15);
        make.centerY.equalTo(numberBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UITextField *numberLabel=[[UITextField alloc] init];
    _numberLabel=numberLabel;
    _numberLabel.font=[UIFont systemFontOfSize:14];
    _numberLabel.textColor=[UIColor darkGrayColor];
    _numberLabel.textAlignment=NSTextAlignmentRight;
    _numberLabel.keyboardType=UIKeyboardTypeNumberPad;
    UILabel *paddingLb=[[UILabel alloc] initWithFrame:CGRectMake(0,0,20,25)];
    paddingLb.font=[UIFont systemFontOfSize:14];
    paddingLb.text=@"人";
    paddingLb.textColor=[UIColor darkGrayColor];
    paddingLb.backgroundColor=[UIColor clearColor];
    _numberLabel.rightView=paddingLb;
    _numberLabel.rightViewMode= UITextFieldViewModeAlways;//必不可少
    [numberBack addSubview:_numberLabel];
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberBack).offset(115);
        make.centerY.equalTo(numberBack);
        make.width.mas_equalTo(kWidth-130);
        make.height.mas_equalTo(50.0f);
    }];
    
    
    //活动地址
    UIButton *addressBack=[[UIButton alloc] init];
    addressBack.backgroundColor=[UIColor whiteColor];
    [self addSubview:addressBack];
    [addressBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numberBack.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(80.0f);
    }];
    UILabel *addressTitle=[[UILabel alloc] init];
    addressTitle.textColor=[UIColor blackColor];
    addressTitle.font=[UIFont systemFontOfSize:14];
    addressTitle.text=@"活动地址";
    [addressBack addSubview:addressTitle];
    [addressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressBack).offset(15);
        make.top.equalTo(addressBack).offset(15);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(14.0f);
    }];
    UITextView *addressText=[[UITextView alloc] init];
    _addressText=addressText;
    _addressText.font=[UIFont systemFontOfSize:14];
    _addressText.textColor=[UIColor darkGrayColor];
    _addressText.textAlignment=NSTextAlignmentRight;
    [addressBack addSubview:_addressText];
    [_addressText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressBack).offset(115);
        make.centerY.equalTo(addressBack);
        make.width.mas_equalTo(kWidth-130);
        make.height.mas_equalTo(80.0f);
    }];
    
    
    
    //////////////////////////////////
    //签到活动 view
    UIView *signView=[[UIView alloc] init];
    _signView=signView;
    _signView.backgroundColor=[UIColor clearColor];
    [self addSubview:_signView];
    [_signView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressBack.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(0);//0  260
    }];
    //名称
    UIView *sign_nameBack=[[UIView alloc] init];
    sign_nameBack.backgroundColor=[UIColor whiteColor];
    [_signView addSubview:sign_nameBack];
    [sign_nameBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signView).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *sign_nameTitle=[[UILabel alloc] init];
    sign_nameTitle.textColor=[UIColor blackColor];
    sign_nameTitle.font=[UIFont systemFontOfSize:14];
    sign_nameTitle.text=@"签到名称";
    [sign_nameBack addSubview:sign_nameTitle];
    [sign_nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sign_nameBack).offset(15);
        make.centerY.equalTo(sign_nameBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UITextField *sign_nameText=[[UITextField alloc] init];
    _sign_nameText=sign_nameText;
    _sign_nameText.font=[UIFont systemFontOfSize:14];
    _sign_nameText.textColor=[UIColor darkGrayColor];
    _sign_nameText.textAlignment=NSTextAlignmentRight;
    [sign_nameBack addSubview:_sign_nameText];
    [_sign_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sign_nameBack).offset(115);
        make.centerY.equalTo(sign_nameBack);
        make.width.mas_equalTo(kWidth-130);
        make.height.mas_equalTo(50.0f);
    }];
    
    //签到方式
    UIButton *sign_methodback=[[UIButton alloc] init];
    sign_methodback.backgroundColor=[UIColor whiteColor];
    //[sign_methodback addTarget:self action:@selector(clickSelectAttaBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_signView addSubview:sign_methodback];
    [sign_methodback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sign_nameBack.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50);
    }];
    UILabel *sign_methodTitle=[[UILabel alloc] init];
    sign_methodTitle.text=@"签到方式";
    sign_methodTitle.font=[UIFont systemFontOfSize:14];
    sign_methodTitle.textColor=[UIColor blackColor];
    sign_methodTitle.textAlignment=NSTextAlignmentLeft;
    [sign_methodback addSubview:sign_methodTitle];
    [sign_methodTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sign_methodback).offset(15);
        make.centerY.equalTo(sign_methodback);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    UILabel *sign_methodLabel=[[UILabel alloc] init];
    _sign_methodLabel=sign_methodLabel;
    _sign_methodLabel.font=[UIFont systemFontOfSize:14];
    _sign_methodLabel.textColor=[UIColor grayColor];
    _sign_methodLabel.textAlignment=NSTextAlignmentRight;
    _sign_methodLabel.text=@"蓝牙";
    [sign_methodback addSubview:_sign_methodLabel];
    [_sign_methodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sign_methodback).offset(115);
        make.centerY.equalTo(sign_methodback);
        make.width.mas_equalTo(kWidth-150);
        make.height.mas_equalTo(50);
    }];
    UIImageView *sign_methodRightImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youjiantou"]];
    [sign_methodback addSubview:sign_methodRightImage];
    [sign_methodRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sign_methodback).offset(-10);
        make.centerY.equalTo(sign_methodback);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    
    //选择签到设备
    UIButton *sign_deviceback=[[UIButton alloc] init];
    sign_deviceback.backgroundColor=[UIColor whiteColor];
    [sign_deviceback addTarget:self action:@selector(clickSelectDevice) forControlEvents:UIControlEventTouchUpInside];
    [_signView addSubview:sign_deviceback];
    [sign_deviceback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sign_methodback.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50);
    }];
    UILabel *sign_deviceTitle=[[UILabel alloc] init];
    sign_deviceTitle.text=@"选择签到设备";
    sign_deviceTitle.font=[UIFont systemFontOfSize:14];
    sign_deviceTitle.textColor=[UIColor blackColor];
    sign_deviceTitle.textAlignment=NSTextAlignmentLeft;
    [sign_deviceback addSubview:sign_deviceTitle];
    [sign_deviceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sign_deviceback).offset(15);
        make.centerY.equalTo(sign_deviceback);
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(50);
    }];
 
    //选择结果
    UIScrollView *signScrollView=[[UIScrollView alloc] init];
    _signScrollView=signScrollView;
    _signScrollView.showsHorizontalScrollIndicator = NO;
    _signScrollView.backgroundColor=[UIColor whiteColor];
    _signScrollView.bounces = YES;
    [sign_deviceback addSubview:_signScrollView];
    UITapGestureRecognizer *selectDevice= [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(clickSelectDevice)];
    [_signScrollView addGestureRecognizer:selectDevice];
    [_signScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sign_deviceback).offset(115);
        make.centerY.equalTo(sign_deviceback);
        make.width.mas_equalTo(kWidth-145);
        make.height.mas_equalTo(50);
    }];
    
    UIImageView *sign_deviceImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiahao"]];
    _sign_deviceImage=sign_deviceImage;
    [sign_deviceback addSubview:_sign_deviceImage];
    [_sign_deviceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sign_deviceback).offset(-30);
        make.centerY.equalTo(sign_deviceback);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    UIImageView *sign_deviceRightImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youjiantou"]];
    [sign_deviceback addSubview:sign_deviceRightImage];
    [sign_deviceRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sign_deviceback).offset(-10);
        make.centerY.equalTo(sign_deviceback);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    //签到开始时间
    UIButton *sign_start_timeBack=[[UIButton alloc] init];
    sign_start_timeBack.backgroundColor=[UIColor whiteColor];
    sign_start_timeBack.tag=200;
    [sign_start_timeBack addTarget:self action:@selector(clickTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_signView addSubview:sign_start_timeBack];
    [sign_start_timeBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sign_deviceback.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *sign_start_timeTitle=[[UILabel alloc] init];
    sign_start_timeTitle.textColor=[UIColor blackColor];
    sign_start_timeTitle.font=[UIFont systemFontOfSize:14];
    sign_start_timeTitle.text=@"签到开始时间";
    [sign_start_timeBack addSubview:sign_start_timeTitle];
    [sign_start_timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sign_start_timeBack).offset(15);
        make.centerY.equalTo(sign_start_timeBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *sign_start_timeLabel=[[UILabel alloc] init];
    _sign_start_timeLabel=sign_start_timeLabel;
    _sign_start_timeLabel.font=[UIFont systemFontOfSize:14];
    _sign_start_timeLabel.textColor=[UIColor darkGrayColor];
    _sign_start_timeLabel.textAlignment=NSTextAlignmentRight;
    _sign_start_timeLabel.text=@"";
    [sign_start_timeBack addSubview:_sign_start_timeLabel];
    [_sign_start_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sign_start_timeBack).offset(115);
        make.centerY.equalTo(sign_start_timeBack);
        make.width.mas_equalTo(kWidth-130);
        make.height.mas_equalTo(50.0f);
    }];
    
    //签到结束时间
    UIButton *sign_end_timeBack=[[UIButton alloc] init];
    sign_end_timeBack.backgroundColor=[UIColor whiteColor];
    sign_end_timeBack.tag=201;
    [sign_end_timeBack addTarget:self action:@selector(clickTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_signView addSubview:sign_end_timeBack];
    [sign_end_timeBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sign_start_timeBack.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *sign_end_timeTitle=[[UILabel alloc] init];
    sign_end_timeTitle.textColor=[UIColor blackColor];
    sign_end_timeTitle.font=[UIFont systemFontOfSize:14];
    sign_end_timeTitle.text=@"签到结束时间";
    [sign_end_timeBack addSubview:sign_end_timeTitle];
    [sign_end_timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sign_end_timeBack).offset(15);
        make.centerY.equalTo(sign_end_timeBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *sign_end_timeLabel=[[UILabel alloc] init];
    _sign_end_timeLabel=sign_end_timeLabel;
    _sign_end_timeLabel.font=[UIFont systemFontOfSize:14];
    _sign_end_timeLabel.textColor=[UIColor darkGrayColor];
    _sign_end_timeLabel.textAlignment=NSTextAlignmentRight;
    _sign_end_timeLabel.text=@"";
    [sign_end_timeBack addSubview:_sign_end_timeLabel];
    [_sign_end_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sign_end_timeBack).offset(115);
        make.centerY.equalTo(sign_end_timeBack);
        make.width.mas_equalTo(kWidth-130);
        make.height.mas_equalTo(50.0f);
    }];
   //////////////////////////////////////////////////////////
    
    
    
    
    //内容
    UIView *commentback=[[UIView alloc] init];
    commentback.backgroundColor=[UIColor whiteColor];
    [self addSubview:commentback];
    [commentback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(signView.mas_bottom).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(120);
    }];
    UITextView *commentText=[[UITextView alloc] init];
    _commentText=commentText;
    _commentText.backgroundColor=[UIColor whiteColor];
    _commentText.font=[UIFont systemFontOfSize:14];
    _commentText.text = @"添加活动内容";
    _commentText.textColor = GKColorRGB(197, 197, 197);
    _commentText.delegate=self;
    _commentText.tag=100;
    [commentback addSubview:_commentText];
    [_commentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(10);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(100);
    }];
    
    UILabel *commentLine=[[UILabel alloc] init];
    commentLine.backgroundColor=GKColorRGB(246, 246, 246);
    [self addSubview:commentLine];
    [commentLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback.mas_bottom);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(1);
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
    
    UILabel *addimageLine=[[UILabel alloc] init];
    addimageLine.backgroundColor=GKColorRGB(246, 246, 246);
    [self addSubview:addimageLine];
    [addimageLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addimageback.mas_bottom);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(1);
    }];
    
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
    UILabel *attaLine=[[UILabel alloc] init];
    attaLine.backgroundColor=GKColorRGB(246, 246, 246);
    [self addSubview:attaLine];
    [attaLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(attaback.mas_bottom);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(1);
    }];
    //选择通知范围
    UIButton *selectback=[[UIButton alloc] init];
    selectback.backgroundColor=[UIColor whiteColor];
    [selectback addTarget:self action:@selector(clickSelectStu) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectback];
    [selectback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(attaback.mas_bottom).offset(1);
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
    
    
    
    
    return  780;
}


#pragma mark - changeType
-(void)changeType:(UISegmentedControl  *)typeSegment{
   
    if(self.typeSegment.selectedSegmentIndex==0){
        [_signView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);//0  260
        }];
        
    }
    else{
        [_signView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(260);//0  260
        }];
        
    }
    if([self.delegate respondsToSelector:@selector(changeType:)]){
        [self.delegate changeType:typeSegment];
    }
   
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
#pragma mark - 时间
-(void)clickTimeBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickTimeBtn:)]){
        [self.delegate clickTimeBtn:sender];
    }
}
#pragma mark - 选择设备
-(void)clickSelectDevice{
    if([self.delegate respondsToSelector:@selector(clickSelectDevice)]){
        [self.delegate clickSelectDevice];
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
    if(textView.tag==100){
        if(textView.text.length < 1){
            self.commentText.text = @"添加活动内容";
            self.commentText.textColor = GKColorRGB(197, 197, 197);
        }
    }
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView.tag==100){
        if([self.commentText.text isEqualToString:@"添加活动内容"]){
            self.commentText.text=@"";
            self.commentText.textColor=[UIColor darkGrayColor];
        }
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}
@end
