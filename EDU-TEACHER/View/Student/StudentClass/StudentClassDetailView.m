//
//  StudentClassDetailView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/8/6.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "StudentClassDetailView.h"
 
#import "TimeTable.h"
@interface StudentClassDetailView()
/**
 *  课程名称
 */
@property (nonatomic, weak) UILabel *classNameLabel;
/**
 *  教师名称
 */
@property (nonatomic, weak) UILabel *teacherLabel;
/**
 *  地址名称
 */
@property (nonatomic, weak) UILabel *addressLabel;
/**
 *  时间名称
 */
@property (nonatomic, weak) UILabel *timelabel;

@end

@implementation StudentClassDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self){
        self = [super initWithFrame:frame];
        self.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.5];
        
        [self initChildView];
    }
    return self;
}

- (void)initChildView{
    
    CGFloat viewWidth = SCREENWIDTH - 24;
    
    UITapGestureRecognizer *backtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackView:)];
    [self addGestureRecognizer:backtap];
    
    //背景
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 8;
    [self addSubview:backView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackView:)];
    [backView addGestureRecognizer:tap];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-JB_TabbarHeight);
        make.width.mas_equalTo(viewWidth);
        make.height.mas_equalTo(120);
    }];
    
    //课程名称
    UILabel *classNameLabel = [[UILabel alloc]init];
    self.classNameLabel = classNameLabel;
    classNameLabel.font = [UIFont boldSystemFontOfSize:16.f];
    classNameLabel.numberOfLines = 0;
    [backView addSubview:classNameLabel];
    [classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(4);
        make.left.mas_equalTo(12);
        make.width.mas_equalTo(viewWidth - 24);
        make.height.mas_equalTo(34);
    }];
    
    //教师
    UIImageView *teacherLogo = [[UIImageView alloc]init];
    teacherLogo.image = [UIImage imageNamed:@"laoshi"];
    [backView addSubview:teacherLogo];
    [teacherLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(classNameLabel.mas_bottom).offset(4);
        make.left.mas_equalTo(12);
        make.width.height.mas_equalTo(18);
    }];
    
    UILabel *teacherLabel = [[UILabel alloc]init];
    self.teacherLabel = teacherLabel;
    teacherLabel.font = [UIFont boldSystemFontOfSize:14.f];
    teacherLabel.textColor = kDarkGrayColor;
    [backView addSubview:teacherLabel];
    [teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(teacherLogo.mas_top);
        make.left.equalTo(teacherLogo.mas_right).offset(8);
        make.width.mas_equalTo(viewWidth - 24 - 26);
        make.height.mas_equalTo(18);
    }];
    
    //地址
    UIImageView *addressLogo = [[UIImageView alloc]init];
    addressLogo.image = [UIImage imageNamed:@"didian"];
    [backView addSubview:addressLogo];
    [addressLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(teacherLogo.mas_bottom).offset(6);
        make.left.mas_equalTo(12);
        make.width.height.mas_equalTo(18);
    }];
    
    UILabel *addressLabel = [[UILabel alloc]init];
    self.addressLabel = addressLabel;
    addressLabel.font = [UIFont boldSystemFontOfSize:14.f];
    addressLabel.textColor = kDarkGrayColor;
    [backView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressLogo.mas_top);
        make.left.equalTo(addressLogo.mas_right).offset(8);
        make.width.mas_equalTo(viewWidth - 24 - 26);
        make.height.mas_equalTo(18);
    }];
    
    //时间
    UIImageView *timeLogo = [[UIImageView alloc]init];
    timeLogo.image = [UIImage imageNamed:@"shijian"];
    [backView addSubview:timeLogo];
    [timeLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressLogo.mas_bottom).offset(6);
        make.left.mas_equalTo(12);
        make.width.height.mas_equalTo(18);
    }];
    
    UILabel *timelabel = [[UILabel alloc]init];
    self.timelabel = timelabel;
    timelabel.font = [UIFont boldSystemFontOfSize:14.f];
    timelabel.textColor = kDarkGrayColor;
    [backView addSubview:timelabel];
    [timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeLogo.mas_top);
        make.left.equalTo(timeLogo.mas_right).offset(8);
        make.width.mas_equalTo(viewWidth - 24 - 26);
        make.height.mas_equalTo(18);
    }];
}

- (void)setModel:(StudentClassModel *)model{
    _model = model;
    
    self.classNameLabel.text = model.courseName;
    
    self.teacherLabel.text = model.teacherName;
    
    self.addressLabel.text = model.classRoom;
    
    self.timelabel.text = [NSString stringWithFormat:@"%@  %@ - %@ (%@ - %@)",model.date,model.startTime,model.endTime,model.start_classTime,model.end_classTime];
}

- (void)tapBackView:(UITapGestureRecognizer *)tap{
    if([self.delegate respondsToSelector:@selector(hide)]){
        [self.delegate hide];
    }
}

@end

