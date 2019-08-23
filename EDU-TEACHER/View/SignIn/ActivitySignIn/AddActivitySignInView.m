//
//  AddActivitySignInView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/31.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "AddActivitySignInView.h"
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

@interface AddActivitySignInView ()<UITextViewDelegate>

@end

@implementation AddActivitySignInView



-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, 500);
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
    
    [typeLabel setText:@"活动"];
    [typeLabel setBackgroundColor:GKColorRGB(234 , 58 , 50)];
    
    UITextField *nameText=[[UITextField alloc] init];
    _nameText=nameText;
    _nameText.backgroundColor=[UIColor whiteColor];
    _nameText.font=[UIFont systemFontOfSize:14];
    _nameText.textColor=[UIColor darkGrayColor];
    _nameText.placeholder=@"添加活动签到名称";
    [nameback addSubview:_nameText];
    [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameback).offset(60);
        make.centerY.equalTo(nameback);
        make.width.mas_equalTo(kWidth-75);
        make.height.mas_equalTo(50.0f);
    }];
    
    //签到活动
    
    UIButton *activityBack=[[UIButton alloc] init];
    activityBack.backgroundColor=[UIColor whiteColor];
    [activityBack addTarget:self action:@selector(clickSelectActivityBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:activityBack];
    [activityBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameback.mas_bottom).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50);
    }];
    UILabel *activityTitle=[[UILabel alloc] init];
    activityTitle.text=@"签到活动";
    activityTitle.font=[UIFont systemFontOfSize:14];
    activityTitle.textColor=[UIColor blackColor];
    activityTitle.textAlignment=NSTextAlignmentLeft;
    [activityBack addSubview:activityTitle];
    [activityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(activityBack).offset(15);
        make.centerY.equalTo(activityBack);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
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
        make.centerY.equalTo(activityBack);
        make.width.mas_equalTo(kWidth-150);
        make.height.mas_equalTo(50);
    }];
    UIImageView *activityRightImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youjiantou"]];
    [activityBack addSubview:activityRightImage];
    [activityRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(activityBack).offset(-10);
        make.centerY.equalTo(activityBack);
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
    //签到开始时间
    UIButton *sign_start_timeBack=[[UIButton alloc] init];
    sign_start_timeBack.backgroundColor=[UIColor whiteColor];
    sign_start_timeBack.tag=200;
    [sign_start_timeBack addTarget:self action:@selector(clickTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sign_start_timeBack];
    [sign_start_timeBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sign_deviceback.mas_bottom).offset(6);
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
    [self addSubview:sign_end_timeBack];
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
    /*
    UIButton *selectback=[[UIButton alloc] init];
    selectback.backgroundColor=[UIColor whiteColor];
    [selectback addTarget:self action:@selector(clickSelectStuBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectback];
    [selectback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sign_end_timeBack.mas_bottom).offset(6);
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
        make.left.equalTo(selectback).offset(15);
        make.centerY.equalTo(selectback);
        make.width.mas_equalTo(kWidth/2);
        make.height.mas_equalTo(50);
    }];
    UILabel *studentLabel=[[UILabel alloc] init];
    _studentLabel=studentLabel;
    _studentLabel.font=[UIFont systemFontOfSize:14];
    _studentLabel.textColor=[UIColor darkGrayColor];
    _studentLabel.textAlignment=NSTextAlignmentRight;
    [selectback addSubview:_studentLabel];
    [_studentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectLabel).offset(115);
        make.centerY.equalTo(selectback);
        make.width.mas_equalTo(kWidth-85);
        make.height.mas_equalTo(50.0f);
    }];
    UIImageView *selectImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiahao"]];
    [selectback addSubview:selectImage];
    [selectImage mas_makeConstraints:^(MASConstraintMaker *make) {
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
    */
    
    //内容
    UIView *commentback=[[UIView alloc] init];
    commentback.backgroundColor=[UIColor whiteColor];
    [self addSubview:commentback];
    [commentback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sign_end_timeBack.mas_bottom).offset(6);
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
    
  
    
    return  450 +40;
}



#pragma mark - 选择人员
-(void)clickSelectStu{
    if([self.delegate respondsToSelector:@selector(clickSelectStu)]){
        [self.delegate clickSelectStu];
    }
}
#pragma mark - 选择活动
-(void)clickSelectActivityBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickSelectActivityBtn:)]){
        [self.delegate clickSelectActivityBtn:sender];
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
