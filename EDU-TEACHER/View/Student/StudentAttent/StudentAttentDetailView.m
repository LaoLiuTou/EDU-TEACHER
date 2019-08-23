//
//  StudentAttentDetailView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "StudentAttentDetailView.h"
#import "DEFINE.h"
@implementation StudentAttentDetailView

{
    int viewHeight;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        //self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        self.backgroundColor=GKColorRGB(246, 246, 246);
        
    }
    return self;
}
-(int)initModel:(StudentAttentModel *)studentAttentModel{
    self.studentAttentModel=studentAttentModel;
    [self initView];
    NSLog(@"height:%d",viewHeight);
    return viewHeight;
}
#pragma mark - initView
- (void)initView{
    
    //标题
    UIView *nameback=[[UIView alloc] initWithFrame:CGRectMake(0, 6, kWidth, 50)];
    nameback.backgroundColor=[UIColor whiteColor];
    [self addSubview:nameback];
    
    UIView *leftview=[[UIView alloc] init];
    leftview.backgroundColor=GKColorHEX(0x2c92f5,1);
    [nameback addSubview:leftview];
    [leftview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameback).offset(15);
        make.centerY.equalTo(nameback);
        make.width.mas_equalTo(3);
        make.height.mas_equalTo(18);
    }];
    
    UILabel *nameLabel=[[UILabel alloc] init];
    _nameLabel=nameLabel;
    _nameLabel.backgroundColor=[UIColor whiteColor];
    _nameLabel.font=[UIFont systemFontOfSize:16];
    _nameLabel.textColor=[UIColor blackColor];
    _nameLabel.text =_studentAttentModel.xs_name;
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(25);
        make.top.equalTo(self).offset(6);
        make.width.mas_equalTo(kWidth-45);
        make.height.mas_equalTo(50.0f);
    }];
    
    viewHeight=0;
    //内容
    UIView *commentback=[[UIView alloc] init];
    commentback.backgroundColor=[UIColor whiteColor];
    [self addSubview:commentback];
    
    
    
    //时间
    UILabel *timeTitleLabel=[[UILabel alloc] init];
    timeTitleLabel.backgroundColor=[UIColor whiteColor];
    timeTitleLabel.font=[UIFont systemFontOfSize:16];
    timeTitleLabel.text=@"关注时间";
    timeTitleLabel.textColor=[UIColor blackColor];
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
    timeLabel.text=_studentAttentModel.time;
    timeLabel.textColor=[UIColor grayColor];
    [commentback addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(38);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    
    //级别
    UILabel *adderTitleLabel=[[UILabel alloc] init];
    adderTitleLabel.backgroundColor=[UIColor whiteColor];
    adderTitleLabel.font=[UIFont systemFontOfSize:16];
    adderTitleLabel.text=@"关注级别";
    adderTitleLabel.textColor=[UIColor blackColor];
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
    adderLabel.text=_studentAttentModel.level;
    adderLabel.textColor=[UIColor grayColor];
    [commentback addSubview:adderLabel];
    [adderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentback).offset(38);
        make.left.equalTo(commentback).offset(kWidth/2);
        make.width.mas_equalTo((kWidth-30)/2);
        make.height.mas_equalTo(14);
    }];
    viewHeight+=50;
    
    UIView *topLine= [[UIView alloc] init];
    topLine.backgroundColor=GKColorHEX(0xf7f7f7, 1);
    [commentback addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adderLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(6);
    }];
    
    UIFont *font=[UIFont systemFontOfSize:14];
    //内容
    UILabel *commentTitleLabel=[[UILabel alloc] init];
    commentTitleLabel.backgroundColor=[UIColor whiteColor];
    commentTitleLabel.font=[UIFont systemFontOfSize:16];
    commentTitleLabel.text=@"内容";
    commentTitleLabel.textColor=[UIColor blackColor];
    [commentback addSubview:commentTitleLabel];
    [commentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topLine.mas_bottom).offset(10);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo((kWidth-30));
        make.height.mas_equalTo(20);
    }];
    NSString *comment=_studentAttentModel.comment;
    CGFloat commentHeight = [comment boundingRectWithSize:CGSizeMake(kWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil].size.height;
    UILabel *commentLabel=[[UILabel alloc] init];
    _commentLabel=commentLabel;
    _commentLabel.backgroundColor=[UIColor whiteColor];
    _commentLabel.font=[UIFont systemFontOfSize:14];
    _commentLabel.text =comment;
    _commentLabel.textColor =[UIColor grayColor];
    [_commentLabel setTextAlignment:NSTextAlignmentLeft];
    [_commentLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_commentLabel setNumberOfLines:0];
    [_commentLabel sizeToFit];
    [commentback addSubview:_commentLabel];
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentTitleLabel.mas_bottom).offset(10);
        make.left.equalTo(commentback).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(commentHeight);
    }];
    viewHeight+=commentHeight+25+30;
    
    [commentback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameback.mas_bottom).offset(6);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(kHeight-12-50-kNavBarHeight);
    }];
    
   
}


@end
