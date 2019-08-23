//
//  AddClassSignInView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/31.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AddClassSignInView.h"
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

@interface AddClassSignInView ()<UITextViewDelegate>

@end

@implementation AddClassSignInView



-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, 700);
        self.backgroundColor=GKColorRGB(246, 246, 246);
        //[self initView];
    }
    return self;
}


#pragma mark - initView
- (int)initView{
    
    //标题
    UIView *nameback=[[UIView alloc] init];
    nameback.backgroundColor=[UIColor whiteColor];
    [self addSubview:nameback];
    [nameback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50);
    }];
    
    
    UILabel *typeLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, 40, 20)];
    [typeLabel setFont:[UIFont systemFontOfSize:12.0]];
    
    UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:typeLabel.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ] init];
    cornerRadiusLayer.frame = typeLabel.bounds;
    cornerRadiusLayer.path = cornerRadiusPath.CGPath;
    typeLabel.layer.mask = cornerRadiusLayer;
    typeLabel.textColor=[UIColor whiteColor];
    typeLabel.textAlignment=NSTextAlignmentCenter;
    [nameback addSubview:typeLabel];
    
    [typeLabel setText:@"课程"];
    [typeLabel setBackgroundColor:GKColorRGB(120 , 180 , 50)];
    
    UITextField *nameText=[[UITextField alloc] init];
    _nameText=nameText;
    _nameText.backgroundColor=[UIColor whiteColor];
    _nameText.font=[UIFont systemFontOfSize:14];
    _nameText.textColor=[UIColor darkGrayColor];
    _nameText.placeholder=@"添加签到名称";
    [nameback addSubview:_nameText];
    [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameback).offset(60);
        make.centerY.equalTo(nameback);
        make.width.mas_equalTo(kWidth-75);
        make.height.mas_equalTo(50.0f);
    }];
    
    //签到课程
    UIButton *activityBack=[[UIButton alloc] init];
    activityBack.backgroundColor=[UIColor whiteColor];
    [activityBack addTarget:self action:@selector(clickSelectClassBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:activityBack];
    [activityBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameback.mas_bottom).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(80);
    }];
    UILabel *activityTitle=[[UILabel alloc] init];
    activityTitle.text=@"签到课程";
    activityTitle.font=[UIFont systemFontOfSize:14];
    activityTitle.textColor=[UIColor blackColor];
    activityTitle.textAlignment=NSTextAlignmentLeft;
    [activityBack addSubview:activityTitle];
    [activityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(activityBack).offset(15);
        make.top.equalTo(activityBack).offset(15);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(15);
    }];
    UILabel *activityLabel=[[UILabel alloc] init];
    _activityLabel=activityLabel;
    _activityLabel.font=[UIFont systemFontOfSize:14];
    _activityLabel.textColor=[UIColor grayColor];
    _activityLabel.textAlignment=NSTextAlignmentRight;
    _activityLabel.text=@"";
    [activityBack addSubview:_activityLabel];
    [_activityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(activityBack).offset(115);
        make.top.equalTo(activityBack);
        make.width.mas_equalTo(kWidth-165);
        make.height.mas_equalTo(50);
    }];
    
    
    //课程信息
    UIView *classInfoView = [[UIView alloc] init];
    _classInfoView=classInfoView;
    [_classInfoView setHidden:YES];
    [activityBack addSubview:_classInfoView];
    [_classInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(activityBack).offset(70);
        make.top.equalTo(self.activityLabel.mas_bottom);
        make.width.mas_equalTo(kWidth-100);
        make.height.mas_equalTo(24);
    }];
    
    UILabel *addressLabel=[[UILabel alloc] init];
    _addressLabel=addressLabel;
    _addressLabel.font=[UIFont systemFontOfSize:12];
    _addressLabel.textColor=[UIColor grayColor];
    _addressLabel.textAlignment=NSTextAlignmentRight;
    _addressLabel.text=@"地址";
    //_addressLabel.preferredMaxLayoutWidth =180;
    _addressLabel.numberOfLines = 0;
    [classInfoView addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(classInfoView.mas_right).offset(15);
        make.centerY.equalTo(classInfoView);
        //make.width.mas_equalTo(150);
        make.height.mas_equalTo(24);
    }];
    UIImageView *ddImage=[[UIImageView alloc] init];
    [ddImage setImage:[UIImage imageNamed:@"didian"] ];
    [classInfoView addSubview:ddImage];
    [ddImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addressLabel.mas_left);
        make.centerY.equalTo(classInfoView);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    UILabel *fdLabel=[[UILabel alloc] init];
    _fdLabel=fdLabel;
    _fdLabel.font=[UIFont systemFontOfSize:12];
    _fdLabel.textColor=[UIColor grayColor];
    _fdLabel.textAlignment=NSTextAlignmentRight;
    _fdLabel.text=@"老师";
    //_fdLabel.preferredMaxLayoutWidth =100;
    _fdLabel.numberOfLines = 0;
    [classInfoView addSubview:_fdLabel];
    [_fdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ddImage.mas_left).offset(-10);
        make.centerY.equalTo(classInfoView);
        //make.width.mas_equalTo(150);
        make.height.mas_equalTo(24);
    }];
    UIImageView *fdImage=[[UIImageView alloc] init];
    [fdImage setImage:[UIImage imageNamed:@"laoshi"] ];
    [classInfoView addSubview:fdImage];
    [fdImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fdLabel.mas_left);
        make.centerY.equalTo(classInfoView);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    ///////////////////
    
    
    UIImageView *activityRightImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youjiantou"]];
    [activityBack addSubview:activityRightImage];
    [activityRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(activityBack).offset(-10);
        make.top.equalTo(activityBack).offset(13);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    
    
    //签到方式
    UIButton *sign_methodback=[[UIButton alloc] init];
    sign_methodback.backgroundColor=[UIColor whiteColor];
    //[sign_methodback addTarget:self action:@selector(clickSelectAttaBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sign_methodback];
    [sign_methodback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(activityBack.mas_bottom).offset(6);
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
    [self addSubview:sign_deviceback];
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
    
    
    //课表
    UIButton *switchBack=[[UIButton alloc] init];
    _switchBack=switchBack;
    _switchBack.backgroundColor=[UIColor whiteColor];
    [self addSubview:_switchBack];
    [_switchBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sign_deviceback.mas_bottom).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *switchTitle=[[UILabel alloc] init];
    switchTitle.textColor=[UIColor blackColor];
    switchTitle.font=[UIFont systemFontOfSize:14];
    switchTitle.text=@"课表签到";
    [self.switchBack addSubview:switchTitle];
    [switchTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.switchBack).offset(15);
        make.centerY.equalTo(self.switchBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UISwitch *timeTableSwitch=[[UISwitch alloc] init];
    _timeTableSwitch=timeTableSwitch;
    [_timeTableSwitch setBackgroundColor:GKColorRGB(246, 246, 246)];
    [_timeTableSwitch setOnTintColor:GKColorRGB(246, 246, 246)];
    [_timeTableSwitch setThumbTintColor:[UIColor grayColor]];
    _timeTableSwitch.on=NO;
    _timeTableSwitch.layer.cornerRadius = 15.5f;
    _timeTableSwitch.layer.masksToBounds = YES;
    [_timeTableSwitch addTarget:self action:@selector(timeTableSwitchAction:) forControlEvents:UIControlEventValueChanged];
    [self.switchBack addSubview:_timeTableSwitch];
    [_timeTableSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.switchBack.mas_right).offset(-15);
        make.centerY.equalTo(self.switchBack);
    }];
    
    
    
    //课表签到
    UIView *timeTableView=[[UIView alloc] init];
    _timeTableView=timeTableView;
    [_timeTableView setHidden:YES];
    [self addSubview:_timeTableView];
    [_timeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(switchBack.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(0);//0,152
    }];
    //上课时间
    UIButton *classStartTimeBack=[[UIButton alloc] init];
    _classStartTimeBack=classStartTimeBack;
    _classStartTimeBack.backgroundColor=[UIColor whiteColor];
    [_timeTableView addSubview:_classStartTimeBack];
    [_classStartTimeBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeTableView);
        make.width.mas_equalTo(kWidth);
        //make.height.mas_equalTo(80.0f);
    }];
    UILabel *classStartTimeTitle=[[UILabel alloc] init];
    classStartTimeTitle.textColor=[UIColor blackColor];
    classStartTimeTitle.font=[UIFont systemFontOfSize:14];
    classStartTimeTitle.text=@"上课时间";
    
    [_classStartTimeBack addSubview:classStartTimeTitle];
    [classStartTimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.classStartTimeBack).offset(15);
        make.top.equalTo(self.classStartTimeBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *classStartTimeLabel=[[UILabel alloc] init];
    _classStartTimeLabel=classStartTimeLabel;
    _classStartTimeLabel.font=[UIFont systemFontOfSize:14];
    _classStartTimeLabel.textColor=[UIColor darkGrayColor];
    _classStartTimeLabel.textAlignment=NSTextAlignmentRight;
    [_classStartTimeLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_classStartTimeLabel setNumberOfLines:0];
    [_classStartTimeLabel sizeToFit];
    //[_classStartTimeLabel setEditable:NO];
    [self.classStartTimeBack addSubview:_classStartTimeLabel];
    [_classStartTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.classStartTimeBack).offset(115);
        make.top.equalTo(self.classStartTimeBack).offset(10);  
        make.width.mas_equalTo(kWidth-130); 
    }];
    [_classStartTimeBack mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.classStartTimeLabel.mas_bottom).offset(10);
    }];
    
    //自动签到时间
    UIButton *autoSignTimeBack=[[UIButton alloc] init];
    autoSignTimeBack.backgroundColor=[UIColor whiteColor];
    [_timeTableView addSubview:autoSignTimeBack];
    [autoSignTimeBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classStartTimeBack.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(80.0f);
    }];
    UILabel *autoSignTimeTitle=[[UILabel alloc] init];
    autoSignTimeTitle.textColor=[UIColor blackColor];
    autoSignTimeTitle.font=[UIFont systemFontOfSize:14];
    autoSignTimeTitle.text=@"自动签到时间";
    [autoSignTimeBack addSubview:autoSignTimeTitle];
    [autoSignTimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(autoSignTimeBack).offset(15);
        make.top.equalTo(autoSignTimeBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UIButton *autoSignTimeBtn=[[UIButton alloc] init];
    autoSignTimeBtn.backgroundColor=[UIColor whiteColor];
    _autoSignTimeBtn=autoSignTimeBtn;
    _autoSignTimeBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [_autoSignTimeBtn addTarget:self action:@selector(clickAutoSignTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_autoSignTimeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [autoSignTimeBack addSubview:_autoSignTimeBtn];
    [_autoSignTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(autoSignTimeBack).offset(-35);
        make.top.equalTo(autoSignTimeBack);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(50.0f);
    }];
    UIImageView *autoSignTimeImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youjiantou"]];
    [autoSignTimeBack addSubview:autoSignTimeImage];
    [autoSignTimeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(autoSignTimeBack).offset(-10);
        make.top.equalTo(autoSignTimeBack).offset(13);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    UITextField *autoSignTimeText=[[UITextField alloc] init];
    _autoSignTimeText=autoSignTimeText;
    _autoSignTimeText.textColor=[UIColor darkGrayColor];
    _autoSignTimeText.font=[UIFont systemFontOfSize:14];
    _autoSignTimeText.textAlignment=NSTextAlignmentRight;
    _autoSignTimeText.keyboardType=UIKeyboardTypeNumberPad;
    UILabel *paddingLb=[[UILabel alloc] initWithFrame:CGRectMake(0,0,20,25)];
    paddingLb.text=@"分";
    paddingLb.textColor=[UIColor darkGrayColor];
    paddingLb.backgroundColor=[UIColor clearColor];
    paddingLb.font=[UIFont systemFontOfSize:14];
    _autoSignTimeText.rightView=paddingLb;
    _autoSignTimeText.rightViewMode= UITextFieldViewModeAlways;//必不可少
    [autoSignTimeBack addSubview:_autoSignTimeText];
    [_autoSignTimeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(autoSignTimeBack).offset(-15);
        make.top.equalTo(autoSignTimeBack).offset(50);
        make.width.mas_equalTo(kWidth-130);
        make.height.mas_equalTo(15.0f);
    }];
    //签到截止时间
    /*
    UIButton *stoptimeBack=[[UIButton alloc] init];
    stoptimeBack.backgroundColor=[UIColor whiteColor];
    stoptimeBack.tag=301;
    [stoptimeBack addTarget:self action:@selector(clickTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_timeTableView addSubview:stoptimeBack];
    [stoptimeBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(autoSignTimeBack.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50.0f);
    }];
    
    UILabel *stoptimeTitle=[[UILabel alloc] init];
    stoptimeTitle.textColor=[UIColor blackColor];
    stoptimeTitle.font=[UIFont systemFontOfSize:14];
    stoptimeTitle.text=@"签到截止日期";
    [stoptimeBack addSubview:stoptimeTitle];
    [stoptimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(stoptimeBack).offset(15);
        make.centerY.equalTo(stoptimeBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50.0f);
    }];
    UILabel *stoptimeLabel=[[UILabel alloc] init];
    _stoptimeLabel=stoptimeLabel;
    _stoptimeLabel.font=[UIFont systemFontOfSize:14];
    _stoptimeLabel.textColor=[UIColor darkGrayColor];
    _stoptimeLabel.textAlignment=NSTextAlignmentRight;
    _stoptimeLabel.text=@"";
    [stoptimeBack addSubview:_stoptimeLabel];
    [_stoptimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(stoptimeBack).offset(115);
        make.centerY.equalTo(stoptimeBack);
        make.width.mas_equalTo(kWidth-130);
        make.height.mas_equalTo(50.0f);
    }];
    */
   
    
    
    
    
    
     //签到时间
    UIView *timesView=[[UIView alloc] init];
    _timesView=timesView;
    [self addSubview:_timesView];
    [_timesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeTableView.mas_bottom);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(101);//0,101
    }];
    //签到开始时间
    UIButton *sign_start_timeBack=[[UIButton alloc] init];
    sign_start_timeBack.backgroundColor=[UIColor whiteColor];
    sign_start_timeBack.tag=200;
    [sign_start_timeBack addTarget:self action:@selector(clickTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_timesView addSubview:sign_start_timeBack];
    [sign_start_timeBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timesView);
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
    [_timesView addSubview:sign_end_timeBack];
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
    
    
    
    
    
    
    
    
    
    
    
    //选择签到范围
     UIButton *selectback=[[UIButton alloc] init];
     _selectback=selectback;
     _selectback.backgroundColor=[UIColor whiteColor];
     [_selectback addTarget:self action:@selector(clickSelectStu) forControlEvents:UIControlEventTouchUpInside];
     [self addSubview:_selectback];
     [_selectback mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(self.timesView.mas_bottom).offset(6);
         make.width.mas_equalTo(kWidth);
         make.height.mas_equalTo(50);
     }];
     UILabel *selectLabel=[[UILabel alloc] init];
     selectLabel.text=@"选择签到范围";
     selectLabel.font=[UIFont systemFontOfSize:14];
     selectLabel.textColor=[UIColor blackColor];
     selectLabel.textAlignment=NSTextAlignmentLeft;
     [selectback addSubview:selectLabel];
     [selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(self.selectback).offset(15);
         make.centerY.equalTo(self.selectback);
         make.width.mas_equalTo(100);
         make.height.mas_equalTo(50.0f);
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
     [self.selectback addSubview:selectRightImage];
     [selectRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.equalTo(self.selectback).offset(-10);
         make.centerY.equalTo(self.selectback);
         make.width.mas_equalTo(24);
         make.height.mas_equalTo(24);
     }];
    
    
    //内容
    UIView *commentback=[[UIView alloc] init];
    commentback.backgroundColor=[UIColor whiteColor];
    [self addSubview:commentback];
    [commentback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(selectback.mas_bottom).offset(1);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(120);
    }];
    UITextView *commentText=[[UITextView alloc] init];
    _commentText=commentText;
    _commentText.backgroundColor=[UIColor whiteColor];
    _commentText.font=[UIFont systemFontOfSize:14];
    _commentText.text = @"添加签到说明";
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
    
    
    
    return  700;
}



#pragma mark - 选择人员
-(void)clickSelectStu{
    if([self.delegate respondsToSelector:@selector(clickSelectStu)]){
        [self.delegate clickSelectStu];
    }
}
#pragma mark - 选择活动
-(void)clickSelectClassBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickSelectClassBtn:)]){
        [self.delegate clickSelectClassBtn:sender];
    }
}
#pragma mark - 自动签到时间
-(void)clickAutoSignTimeBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickAutoSignTimeBtn:)]){
        [self.delegate clickAutoSignTimeBtn:sender];
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
- (void) timeTableSwitchAction:(UISwitch *)timeTableSwitch {
//    if ([timeTableSwitch isOn]){
//        NSLog(@"The switch is turned on.");
//        [_timeTableSwitch setThumbTintColor:GKColorHEX(0x2c92f5, 1)];
//        [_timeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(162);//0  260
//        }];
//        [_timeTableView setHidden:NO];
//        [_timesView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(0);//0  260
//        }];
//        [_timesView setHidden:YES];
//        
//        [_selectback mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.switchBack.mas_bottom).offset(168);
//        }];
//        
//    } else {
//        [_timeTableSwitch setThumbTintColor:[UIColor grayColor]];
//        [_timeTableView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(0);//0  260
//        }];
//        [_timeTableView setHidden:YES];
//        [_timesView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(101);//0  260
//        }];
//        
//        [_timesView setHidden:NO];
//        [_selectback mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.switchBack.mas_bottom).offset(107);
//        }];
//        NSLog(@"The switch is turned off.");
//    }
    
    if([self.delegate respondsToSelector:@selector(timeTableSwitchAction:)]){
        [self.delegate timeTableSwitchAction:timeTableSwitch];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.tag==100){
        if(textView.text.length < 1){
            self.commentText.text = @"添加签到说明";
            self.commentText.textColor = GKColorRGB(197, 197, 197);
        }
    }
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView.tag==100){
        if([self.commentText.text isEqualToString:@"添加签到说明"]){
            self.commentText.text=@"";
            self.commentText.textColor=[UIColor darkGrayColor];
        }
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}
@end

