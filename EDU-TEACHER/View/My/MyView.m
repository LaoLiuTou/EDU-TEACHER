//
//  MyView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/25.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import "MyView.h"
#import "DEFINE.h"
#import "UIImageView+WebCache.h"
@interface MyView ()
@property (nonatomic,retain) UIView *platFormRadiusView;
@property (nonatomic,strong) MyModel *myModel;

@end
@implementation MyView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        //[self initView];
    }
    return self;
}
-(int)initViewModel:(MyModel *)myModel{
    self.myModel=myModel;
    [self initView];
    [_header sd_setImageWithURL:[NSURL URLWithString:_myModel.image] placeholderImage:[UIImage imageNamed:@"tx_fd"]];
    _nameLabel.text=_myModel.name;
    _schoolLabel.text=[NSString stringWithFormat:@"(%@ %@)",_myModel.school_name,_myModel.ac_name];
    
    return self.frame.size.height;
}

-(void) initView{
    //圆角背景
    [self addSubview:self.platFormRadiusView];
    [self addMyInfoViews];
    [self addMenu];
    [self addSubview:self.logOutBtn];
    [self.logOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuView.mas_bottom).offset(30);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(kWidth-100);
        make.height.mas_equalTo(44.0f);
    }];
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
-(UIButton *)logOutBtn{
    if (!_logOutBtn) {
        _logOutBtn=[[UIButton alloc] init];
        //loginBtn.titleLabel.font=[UIFont fontWithName:@"STHeitiTC-Light" size:25];
        _logOutBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [_logOutBtn addTarget:self action:@selector(clickLogOutBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_logOutBtn setTitle:@"退 出" forState:UIControlStateNormal];
        _logOutBtn.layer.cornerRadius=16;
        _logOutBtn.layer.masksToBounds=YES;
        _logOutBtn.backgroundColor=GKColorHEX(0x2c92f5,1);
        [_logOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _logOutBtn;
}

-(void)addMyInfoViews{
    //
    //头像
    UIImageView *header=[[UIImageView alloc] init];
    _header=header;
    _header.layer.cornerRadius = 40;
    _header.userInteractionEnabled = YES;
    _header.clipsToBounds = YES;
    _header.layer.borderWidth =2.0f;//设置边框宽度
    _header.layer.borderColor = [UIColor whiteColor].CGColor;//设置边框颜色
    [self addSubview:_header];
    [_header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.right.equalTo(self.mas_right).offset(-40);
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
        make.top.equalTo(self).offset(50);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(kWidth-100);
        make.height.mas_equalTo(20.0f);
    }];
    //学校
    UILabel *schoolLabel=[[UILabel alloc]init];
    _schoolLabel=schoolLabel;
    [_schoolLabel setFont:[UIFont systemFontOfSize:14.0]];
    _schoolLabel.textColor=[UIColor whiteColor];
    [_schoolLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [_schoolLabel setNumberOfLines:0];
    [_schoolLabel sizeToFit];
    [self addSubview:_schoolLabel];
    [_schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self).offset(15);
        make.width.mas_equalTo(kWidth-150);
        //make.height.mas_equalTo(20.0f);
    }];
    UIButton *rightArr=[[UIButton alloc] init];
    [rightArr setBackgroundImage:[UIImage imageNamed:@"youjiantou-bai"] forState:UIControlStateNormal];
    //[rightArr addTarget:self action:@selector(clickMyInfoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightArr];
    [rightArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.header);
        make.left.mas_equalTo(kWidth-35);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *myinfoBtn=[[UIButton alloc] init];
    [myinfoBtn addTarget:self action:@selector(clickMyInfoBtn:) forControlEvents:UIControlEventTouchUpInside];
    myinfoBtn.backgroundColor=[UIColor clearColor];
    [self addSubview:myinfoBtn];
    [myinfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(30);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(80.0f);
    }];
    
}

-(void)addMenu{
    UIView *menuView=[[UIView alloc] init];
    _menuView=menuView;
    [self addSubview:_menuView];
    [_menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.platFormRadiusView).offset(30);
        make.width.mas_equalTo(kWidth);
        make.height.mas_equalTo(60*3);
    }];
    NSArray *iconArray=@[@"biaoqian",@"guanyu",@"shezhi"];
    NSArray *titleArray=@[@"标签管理",@"设置",@"关于在校园"];
    
    for(int i=0;i<titleArray.count;i++){
        UIButton *item=[[UIButton alloc] init];
        item.tag=100+i;
        
        [item addTarget:self action:@selector(clickMenuBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_menuView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.menuView).offset(60*i);
            make.left.equalTo(self.menuView);
            make.width.mas_equalTo(kWidth);
            make.height.mas_equalTo(60);
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
        [menuTitle setFont:[UIFont systemFontOfSize:16.0]];
        menuTitle.textColor=[UIColor blackColor];
        menuTitle.text=titleArray[i];
        [item addSubview:menuTitle];
        [menuTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(item);
            make.left.equalTo(iconImage.mas_right).offset(10);
            make.width.mas_equalTo(kWidth/2);
            make.height.mas_equalTo(60.0f);
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
-(void)clickLogOutBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickLogOutBtn:)]){
        [self.delegate clickLogOutBtn:sender];
    }
    
}
-(void)clickMyInfoBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickMyInfoBtn:)]){
        [self.delegate clickMyInfoBtn:sender];
    }
    
}


@end
