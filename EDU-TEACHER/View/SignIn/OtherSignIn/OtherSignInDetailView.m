//
//  OtherSignInDetailView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/2.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "OtherSignInDetailView.h"
#import "DEFINE.h" 
@implementation OtherSignInDetailView{
    int viewHeight;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor=GKColorRGB(246, 246, 246);
        
    }
    return self;
}
-(int)initModel:(OtherSignInModel *)model{
    self.otherSignInModel=model;
    [self initView];
    NSLog(@"height:%d",viewHeight);
    return viewHeight;
}
#pragma mark - initView
- (void)initView{
    NSString *content=_otherSignInModel.comment;
    UIFont *font=[UIFont systemFontOfSize:14];
    CGFloat contentHeight = [content boundingRectWithSize:CGSizeMake(kWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size.height;
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
    [typeLabel setText:@"其他"];
    [typeLabel setBackgroundColor:GKColorRGB(0 , 130 , 243)];
    
    UILabel *nameLabel=[[UILabel alloc] init];
    _nameLabel=nameLabel;
    _nameLabel.backgroundColor=[UIColor whiteColor];
    _nameLabel.font=[UIFont systemFontOfSize:16];
    _nameLabel.textColor=[UIColor blackColor];
    _nameLabel.text =_otherSignInModel.name;
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
    timeLabel.text=_otherSignInModel.start_time;
    timeLabel.textColor=[UIColor grayColor];
    [commentback addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(35);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    
    //签到结束时间
    UILabel *adderTitleLabel=[[UILabel alloc] init];
    adderTitleLabel.backgroundColor=[UIColor whiteColor];
    adderTitleLabel.font=[UIFont systemFontOfSize:16];
    adderTitleLabel.text=@"签到结束时间";
    adderTitleLabel.textColor=GKColorHEX(0x2c92f5, 1);
    [commentback addSubview:adderTitleLabel];
    [adderTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(10);
        make.left.equalTo(commentback).offset(kWidth/2);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(20);
    }];
    UILabel *adderLabel=[[UILabel alloc] init];
    adderLabel.backgroundColor=[UIColor whiteColor];
    adderLabel.font=[UIFont systemFontOfSize:14];
    adderLabel.text=_otherSignInModel.end_time;
    adderLabel.textColor=[UIColor grayColor];
    [commentback addSubview:adderLabel];
    [adderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(35);
        make.left.equalTo(commentback).offset(kWidth/2);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    viewHeight+=50;
    //内容
    UILabel *commentTitle=[[UILabel alloc] init];
    commentTitle.backgroundColor=[UIColor whiteColor];
    commentTitle.font=[UIFont systemFontOfSize:16];
    commentTitle.text=@"签到说明";
    commentTitle.textColor=[UIColor blackColor];
    [commentback addSubview:commentTitle];
    [commentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(65);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(20);
    }];
    viewHeight+=20;
    UILabel *commentLabel=[[UILabel alloc] init];
    _commentLabel=commentLabel;
    _commentLabel.backgroundColor=[UIColor whiteColor];
    _commentLabel.font=[UIFont systemFontOfSize:14];
    _commentLabel.text =content;
    _commentLabel.textColor =[UIColor grayColor];
    [_commentLabel setTextAlignment:NSTextAlignmentLeft];
    [_commentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_commentLabel setNumberOfLines:0];
    [_commentLabel sizeToFit];
    [commentback addSubview:_commentLabel];
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(85);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(contentHeight);
    }];
    viewHeight+=contentHeight+25;
    [commentback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameback.mas_bottom).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(self->viewHeight);
    }];
    viewHeight=kNavBarHeight+50+3*6+viewHeight;
}

@end
