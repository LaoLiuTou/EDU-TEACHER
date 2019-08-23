//
//  StudentView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/19.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "StudentView.h"
#import "DEFINE.h"
#import "UIImageView+WebCache.h"
@interface StudentView ()
@property (nonatomic,retain) UIView *platFormRadiusView;
@property (nonatomic,strong) StudentModel *studentModel;
@property (nonatomic,retain)  UIImageView *header;
@property (nonatomic,retain)  UILabel *nameLabel;
@property (nonatomic,retain) UILabel *numLabel;
@property (nonatomic,retain)  UILabel *statusLabel;
@property (nonatomic,retain) UILabel *phoneValue;
@property (nonatomic,retain) UILabel *xyValue;
@property (nonatomic,retain) UILabel *zyValue;
@property (nonatomic,retain)  UILabel *classValue;
@property (nonatomic,retain)  UIView *grayLine;
@end

@implementation StudentView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight+60);
        //[self initView];
    }
    return self;
}
-(int)initViewModel:(StudentModel *)studentModel{
    self.studentModel=studentModel;
    [self initView];
    [_header sd_setImageWithURL:[NSURL URLWithString:_studentModel.I_UPIMG] placeholderImage:[UIImage imageNamed:@"tx"]];
    _nameLabel.text=_studentModel.NM_T;
    _numLabel.text=[NSString stringWithFormat:@"学号：%@",_studentModel.SN_T];
    
    
    //{                //状态信息：上课中：显示课程签到名称；请假中~~~~：显示请假类型+请假时间；异动中(未签到)：显示未签到课程签到名称；异动中(未销假)：显示请假类型+请假时间；休息中：显示休息中
    //    "id": 1461,
    //    "type": "病假",
    //    "start_time": "2019-06-27 15:03:00",
    //    "end_time": "2019-09-27 15:03:00"
    //}
    NSString *statusStr=@"";
    if([_studentModel.STATUS isEqualToString:@"上课中"]){
        statusStr=[NSString stringWithFormat:@"%@ %@",_studentModel.STATUS,[_studentModel.STATUS_INFO objectForKey:@"type"] ];
    }
    else if([_studentModel.STATUS isEqualToString:@"在假中"]){
        statusStr=[NSString stringWithFormat:@"%@ %@\n%@-%@",_studentModel.STATUS,[_studentModel.STATUS_INFO objectForKey:@"type"],[_studentModel.STATUS_INFO objectForKey:@"start_time"],[_studentModel.STATUS_INFO objectForKey:@"end_time"] ];
    }
    else if([_studentModel.STATUS isEqualToString:@"异动中(未签到)"]){
        statusStr=[NSString stringWithFormat:@"%@ %@",_studentModel.STATUS,[_studentModel.STATUS_INFO objectForKey:@"type"] ];
         
    }
    else if([_studentModel.STATUS isEqualToString:@"异动中(未销假)"]){
        statusStr=[NSString stringWithFormat:@"%@ %@\n%@-%@",_studentModel.STATUS,[_studentModel.STATUS_INFO objectForKey:@"type"],[_studentModel.STATUS_INFO objectForKey:@"start_time"],[_studentModel.STATUS_INFO objectForKey:@"end_time"] ];
    }
    else{
        statusStr=[NSString stringWithFormat:@"%@",_studentModel.STATUS];
    }
    _statusLabel.text=statusStr;
    _phoneValue.text=_studentModel.PH_P;
    _xyValue.text=_studentModel.xueyuan_name;
    _zyValue.text=_studentModel.zhuanye_name;
    _classValue.text=_studentModel.class_name;
    return self.frame.size.height;
}

-(void) initView{
    //圆角背景
    [self addSubview:self.platFormRadiusView];
    [self addStudentInfoViews];
    [self addMenu];
     
}
-(UIView *)platFormRadiusView{
    if (!_platFormRadiusView) {
        _platFormRadiusView = [[UIView alloc] init];
        _platFormRadiusView.backgroundColor = [UIColor whiteColor];
        _platFormRadiusView.frame = CGRectMake(0, headerHeight-20,kWidth , 20);
        //[self.view addSubview:_platFormRadiusView];
        // 左上和右上为圆角
        UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:_platFormRadiusView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerTopLeft cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ] init];
        cornerRadiusLayer.frame = _platFormRadiusView.bounds;
        cornerRadiusLayer.path = cornerRadiusPath.CGPath;
        _platFormRadiusView.layer.mask = cornerRadiusLayer;
    }
    return _platFormRadiusView;
}
-(void)addStudentInfoViews{
    //
    //头像
    UIImageView *header=[[UIImageView alloc] init];
    _header=header;
    _header.layer.cornerRadius = 40;
    _header.userInteractionEnabled = YES;
    _header.clipsToBounds = YES;
    _header.layer.borderWidth =2.0f;//设置边框宽度
    _header.layer.borderColor = [UIColor whiteColor].CGColor;//设置边框颜色
    
    [self addSubview:header];
    [_header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(headerHeight-70);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(80.0f);
    }];
    //姓名
    UILabel *nameLabel=[[UILabel alloc]init];
    _nameLabel=nameLabel;
    [_nameLabel setFont:[UIFont systemFontOfSize:18.0]];
    _nameLabel.textColor=[UIColor whiteColor];
    
    [self addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(headerHeight-60);
        make.left.equalTo(self.header.mas_right).offset(10);
        make.width.mas_equalTo(kWidth-100);
        make.height.mas_equalTo(20.0f);
    }];
    //学号
    UILabel *numLabel=[[UILabel alloc]init];
     _numLabel=numLabel;
    [_numLabel setFont:[UIFont systemFontOfSize:14.0]];
    _numLabel.textColor=[UIColor whiteColor];
   
    [self addSubview:_numLabel];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.left.equalTo(self.header.mas_right).offset(10);
        make.width.mas_equalTo(kWidth-100);
        make.height.mas_equalTo(20.0f);
    }];
    UIButton *rightArr=[[UIButton alloc] init];
    
    [rightArr setBackgroundImage:[UIImage imageNamed:@"youjiantou-bai"] forState:UIControlStateNormal];
    [rightArr addTarget:self action:@selector(clickStudentInfoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightArr];
    [rightArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel).offset(15);
        make.left.mas_equalTo(kWidth-35);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    //状态
    UILabel *statusLabel=[[UILabel alloc]init];
    _statusLabel=statusLabel;
    [_statusLabel setFont:[UIFont systemFontOfSize:12.0]];
    _statusLabel.textColor=[UIColor grayColor];
    [_statusLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_statusLabel setNumberOfLines:0];
    [_statusLabel sizeToFit];
    [self addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numLabel.mas_bottom).offset(5);
        make.left.equalTo(self.header.mas_right).offset(10);
        make.width.mas_equalTo(kWidth-100);
        make.height.mas_equalTo(30.0f);
    }];
    //电话
    UILabel *phoneTitle=[[UILabel alloc]init]; 
    [phoneTitle setFont:[UIFont systemFontOfSize:14.0]];
    phoneTitle.textColor=GKColorHEX(0x2c92f5, 1);
    phoneTitle.text=@"电话";
    [self addSubview:phoneTitle];
    [phoneTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_bottom).offset(20);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(14.0f);
    }];
    UILabel *phoneValue=[[UILabel alloc]init];
    _phoneValue=phoneValue;
    [_phoneValue setFont:[UIFont systemFontOfSize:14.0]];
    _phoneValue.textColor=[UIColor blackColor];
    [self addSubview:_phoneValue];
    [_phoneValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneTitle.mas_bottom).offset(5);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(14.0f);
    }];
    
    //学院
    UILabel *xyTitle=[[UILabel alloc]init];
    [xyTitle setFont:[UIFont systemFontOfSize:14.0]];
    xyTitle.textColor=GKColorHEX(0x2c92f5, 1);
    xyTitle.text=@"学院";
    [self addSubview:xyTitle];
    [xyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneValue.mas_bottom).offset(15);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(14.0f);
    }];
    UILabel *xyValue=[[UILabel alloc]init];
    _xyValue=xyValue;
    [_xyValue setFont:[UIFont systemFontOfSize:14.0]];
    _xyValue.textColor=[UIColor blackColor];
    [self addSubview:_xyValue];
    [_xyValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xyTitle.mas_bottom).offset(5);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(14.0f);
    }];
    
    //专业
    UILabel *zyTitle=[[UILabel alloc]init];
    [zyTitle setFont:[UIFont systemFontOfSize:14.0]];
    zyTitle.textColor=GKColorHEX(0x2c92f5, 1);
    zyTitle.text=@"专业";
    [self addSubview:zyTitle];
    [zyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.xyValue.mas_bottom).offset(15);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(14.0f);
    }];
    UILabel *zyValue=[[UILabel alloc]init];
    _zyValue=zyValue;
    [_zyValue setFont:[UIFont systemFontOfSize:14.0]];
    _zyValue.textColor=[UIColor blackColor];
    [self addSubview:_zyValue];
    [_zyValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(zyTitle.mas_bottom).offset(5);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(14.0f);
    }];
    
    //班级
    UILabel *classTitle=[[UILabel alloc]init];
    [classTitle setFont:[UIFont systemFontOfSize:14.0]];
    classTitle.textColor=GKColorHEX(0x2c92f5, 1);
    classTitle.text=@"专业";
    [self addSubview:classTitle];
    [classTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zyValue.mas_bottom).offset(15);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(14.0f);
    }];
    UILabel *classValue=[[UILabel alloc]init];
    _classValue=classValue;
    [_classValue setFont:[UIFont systemFontOfSize:14.0]];
    _classValue.textColor=[UIColor blackColor];
    [self addSubview:_classValue];
    [_classValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(classTitle.mas_bottom).offset(5);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(kWidth-30);
        make.height.mas_equalTo(14.0f);
    }];
    
    //灰色线
    UIView *grayLine= [[UIView alloc] init];
    grayLine.backgroundColor=GKColorHEX(0xf7f7f7, 1);
    _grayLine=grayLine;
    [self addSubview:_grayLine];
    [_grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classValue.mas_bottom).offset(20);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(6.0f);
    }];
}

-(void)addMenu{
    UIView *menuView=[[UIView alloc] init];
    [self addSubview:menuView];
    [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.grayLine.mas_bottom);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(50*7);
    }];
    NSArray *iconArray=@[@"chengji",@"tanxintanhua",@"xinliguanzhu",@"bangfu",@"rongyu",@"chufen",@"kecheng"];
    NSArray *titleArray=@[@"学生成绩",@"谈心谈话",@"心理关注",@"帮扶资助",@"荣誉奖励",@"学生处分",@"本学期课表"];
    
    for(int i=0;i<titleArray.count;i++){
        UIButton *item=[[UIButton alloc] init];
        item.tag=100+i;
        
        [item addTarget:self action:@selector(clickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(menuView).offset(50*i);
            make.left.equalTo(menuView);
            make.width.mas_equalTo(kWidth);
            make.height.mas_equalTo(50);
        }];
        UILabel *bottomLine=[[UILabel alloc]init];
        bottomLine.backgroundColor=GKColorHEX(0xf7f7f7, 1);
        [item addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(item);
            make.width.mas_equalTo(kWidth);
            make.height.mas_equalTo(1.0f);
        }];
        //图标
        UIImageView *iconImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:iconArray[i]]];
        [item addSubview:iconImage];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(item);
            make.left.equalTo(item).offset(15);
            make.width.mas_equalTo(26);
            make.height.mas_equalTo(26);
        }];
        //标题
        UILabel *menuTitle=[[UILabel alloc]init];
        [menuTitle setFont:[UIFont systemFontOfSize:14.0]];
        menuTitle.textColor=[UIColor blackColor];
        menuTitle.text=titleArray[i];
        [item addSubview:menuTitle];
        [menuTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(item);
            make.left.equalTo(iconImage.mas_right).offset(10);
            make.width.mas_equalTo(kWidth/2);
            make.height.mas_equalTo(50.0f);
        }];
        //右箭头
        UIImageView *arrImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"youjiantou"]];
        [item addSubview:arrImage];
        [arrImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(item);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
        
    }
    
    
}

-(void)clickMenuBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickMenuBtn:)]){
        [self.delegate clickMenuBtn:sender];
    }
    
}
-(void)clickStudentInfoBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickStudentInfoBtn:)]){
        [self.delegate clickStudentInfoBtn:sender];
    }
    
}


@end
