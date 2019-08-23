//
//  ClassSignInDetailView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/2.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "ClassSignInDetailView.h"
 

#import "DEFINE.h"
@implementation ClassSignInDetailView{
    int viewHeight;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor=GKColorRGB(246, 246, 246);
        
    }
    return self;
}
-(int)initModel:(ClassSignInModel *)model{
    self.classSignInModel=model;
    [self initView];
    NSLog(@"height:%d",viewHeight);
    return viewHeight;
}
#pragma mark - initView
- (void)initView{
    
    //标题
    UIView *nameback=[[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+6, kWidth, 50)];
    nameback.backgroundColor=[UIColor whiteColor];
    [self addSubview:nameback];
    
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
    
    UILabel *nameLabel=[[UILabel alloc] init];
    _nameLabel=nameLabel;
    _nameLabel.backgroundColor=[UIColor whiteColor];
    _nameLabel.font=[UIFont systemFontOfSize:16];
    _nameLabel.textColor=[UIColor blackColor];
    _nameLabel.text =_classSignInModel.name;
    [nameback addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(60);
        make.centerY.equalTo(nameback);
        make.width.mas_equalTo(kWidth-75);
        make.height.mas_equalTo(50.0f);
    }];
    
    viewHeight=0;
    //通知内容
    UIView *commentback=[[UIView alloc] init];
    commentback.backgroundColor=[UIColor whiteColor];
    [self addSubview:commentback];
    
    
    //签到开始时间
    UILabel *timeTitleLabel=[[UILabel alloc] init];
    timeTitleLabel.backgroundColor=[UIColor whiteColor];
    timeTitleLabel.font=[UIFont systemFontOfSize:16];
    timeTitleLabel.text=@"签到开始时间";
    timeTitleLabel.textColor=GKColorHEX(0x2c92f5, 1);
    [commentback addSubview:timeTitleLabel];
    [timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(10);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    UILabel *timeLabel=[[UILabel alloc] init];
    timeLabel.backgroundColor=[UIColor whiteColor];
    timeLabel.font=[UIFont systemFontOfSize:14];
    timeLabel.text=_classSignInModel.start_time;
    timeLabel.textColor=[UIColor grayColor];
    [commentback addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(35);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    
    //签到结束时间
    UILabel *endTimeTitle=[[UILabel alloc] init];
    endTimeTitle.backgroundColor=[UIColor whiteColor];
    endTimeTitle.font=[UIFont systemFontOfSize:16];
    endTimeTitle.text=@"签到结束时间";
    endTimeTitle.textColor=GKColorHEX(0x2c92f5, 1);
    [commentback addSubview:endTimeTitle];
    [endTimeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(10);
        make.left.equalTo(commentback).offset(kWidth/2);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    UILabel *endTimeLabel=[[UILabel alloc] init];
    endTimeLabel.backgroundColor=[UIColor whiteColor];
    endTimeLabel.font=[UIFont systemFontOfSize:14];
    endTimeLabel.text=_classSignInModel.end_time;
    endTimeLabel.textColor=[UIColor grayColor];
    [commentback addSubview:endTimeLabel];
    [endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(35);
        make.left.equalTo(commentback).offset(kWidth/2);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    viewHeight+=50;
    //老师
    UILabel *teacherTitleLabel=[[UILabel alloc] init];
    teacherTitleLabel.backgroundColor=[UIColor whiteColor];
    teacherTitleLabel.font=[UIFont systemFontOfSize:16];
    teacherTitleLabel.text=@"任课老师";
    teacherTitleLabel.textColor=[UIColor blackColor];
    [commentback addSubview:teacherTitleLabel];
    [teacherTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(65);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    UILabel *teacherLabel=[[UILabel alloc] init];
    teacherLabel.backgroundColor=[UIColor whiteColor];
    teacherLabel.font=[UIFont systemFontOfSize:14];
    teacherLabel.text=_classSignInModel.teacher;
    teacherLabel.textColor=[UIColor grayColor];
    [commentback addSubview:teacherLabel];
    [teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(90);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    
    //任课地点
    UILabel *adderTitleLabel=[[UILabel alloc] init];
    adderTitleLabel.backgroundColor=[UIColor whiteColor];
    adderTitleLabel.font=[UIFont systemFontOfSize:16];
    adderTitleLabel.text=@"任课地点";
    adderTitleLabel.textColor=[UIColor blackColor];
    [commentback addSubview:adderTitleLabel];
    [adderTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(65);
        make.left.equalTo(commentback).offset(kWidth/2);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    UILabel *adderLabel=[[UILabel alloc] init];
    adderLabel.backgroundColor=[UIColor whiteColor];
    adderLabel.font=[UIFont systemFontOfSize:14];
    adderLabel.text=_classSignInModel.room;
    adderLabel.textColor=[UIColor grayColor];
    [commentback addSubview:adderLabel];
    [adderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(90);
        make.left.equalTo(commentback).offset(kWidth/2);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    viewHeight+=50+20; 
    [commentback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameback.mas_bottom).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(self->viewHeight);
    }];
    viewHeight=kNavBarHeight+50+3*6+viewHeight;
}

@end

