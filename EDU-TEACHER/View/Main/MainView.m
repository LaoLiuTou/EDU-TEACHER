//
//  MainView.m
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/1.
//  Copyright © 2019 Jiubai. All rights reserved.
//
#define  marginWidth    kWidth / 20
#import "MainView.h"
#import "DEFINE.h"

@interface MainView ()


@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UIView *platFormRadiusView;
@property (nonatomic,retain) UIView *statisticView;
@property (nonatomic,retain) UIView *iconView;
@property (nonatomic,retain) UIView *signView;
@property (nonatomic,retain) UIView *leaveView;
@property (nonatomic,retain) UIView *recordView;
@end
@implementation MainView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
        //[self initData:nil];
        
    }
    return self;
}
-(void)initData:(NSDictionary *)mainData{
    _mainData=mainData;
    [self initView];
}
-(void) initView{
    
    //标题
    [self addSubview:self.titleLabel];
    //圆角背景
    [self addSubview:self.platFormRadiusView];
    //统计
    [self addSubview:self.statisticView];
    //图标
    [self addSubview:self.iconView];
    //签到
    [self addSubview:self.signView];
    //请假
    [self addSubview:self.leaveView];
    //日志
    [self addSubview:self.recordView];
    UITapGestureRecognizer *signTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickSign)];
    [_signView addGestureRecognizer:signTap];
    UITapGestureRecognizer *leaveTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickLeave)];
    [_leaveView addGestureRecognizer:leaveTap];
    UITapGestureRecognizer *recordTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickRecord)];
    [_recordView addGestureRecognizer:recordTap];
}


-(UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(20,30, kWidth, 20)];
        //_titleLabel.text=@"吉林大学（财经学院）";
        _titleLabel.text=[_mainData objectForKey:@"title"];
        _titleLabel.font=[UIFont systemFontOfSize:20];
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        _titleLabel.textColor=[UIColor whiteColor];
    }
    return _titleLabel;
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

-(UIView *)statisticView{
    if (!_statisticView) {
        _statisticView=[[UIView alloc] initWithFrame: CGRectMake(marginWidth, headerHeight-20-40, kWidth-marginWidth*2, 80)];
        _statisticView.backgroundColor =[UIColor whiteColor];
        _statisticView.layer.shadowColor = GKColorRGB(220, 230,  250).CGColor;
        _statisticView.layer.shadowOffset = CGSizeMake(0,2);
        _statisticView.layer.shadowOpacity = 1;
        _statisticView.layer.shadowRadius = 4;
        _statisticView.layer.cornerRadius = 4;
        _statisticView.layer.masksToBounds = YES;
        _statisticView.clipsToBounds = NO;
        NSArray *statusArray=@[@"上课中",@"异动中",@"在假中",@"待销假",@"待准假"];
        
        for(int i=0;i<5;i++){
            //线
            if(i!=4){
                UIView * line=[[UIView alloc] init];
                line.backgroundColor=GKColorHEX(0xeeeeee, 1);
                [_statisticView addSubview: line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.statisticView).offset(20);
                    make.left.equalTo(self.statisticView).offset(((kWidth-marginWidth*2)/5) *(i+1));
                    make.width.mas_equalTo(1);
                    make.height.mas_equalTo(40);
                }];
            }
            
            UIButton *statisticBtn = [UIButton new];
            statisticBtn.tag=10000+i;
            [statisticBtn addTarget:self action:@selector(clickStatisticBtn:) forControlEvents:UIControlEventTouchUpInside];
            [_statisticView addSubview: statisticBtn];
            [statisticBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.statisticView).offset(0);
                make.left.equalTo(self.statisticView).offset(((kWidth-marginWidth*2)/5) *(i));
                make.width.mas_equalTo(((kWidth-marginWidth*2)/5));
                make.height.mas_equalTo(80);
            }];
            //状态
            UILabel *statusLabel=[[UILabel alloc] init];
            statusLabel.text=[statusArray objectAtIndex:i];
            statusLabel.font=[UIFont systemFontOfSize:12];
            statusLabel.textColor=[UIColor darkGrayColor];
            statusLabel.textAlignment=NSTextAlignmentCenter;
            [statisticBtn addSubview: statusLabel];
            [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.statisticView).offset(50);
                make.left.equalTo(self.statisticView).offset(((kWidth-marginWidth*2)/5) *i);
                make.width.mas_equalTo((kWidth-marginWidth*2)/5);
                make.height.mas_equalTo(20);
            }];
            //数量
            NSArray *temp=[_mainData objectForKey:@"statistic"];
            UILabel *numberLabel=[[UILabel alloc] init];
            numberLabel.text=[NSString stringWithFormat:@"%@",[temp objectAtIndex:i]];
            numberLabel.font=[UIFont systemFontOfSize:24];
            numberLabel.textColor=[UIColor blackColor];
            numberLabel.textAlignment=NSTextAlignmentCenter;
            [statisticBtn addSubview: numberLabel];
            [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.statisticView).offset(10);
                make.left.equalTo(self.statisticView).offset(((kWidth-marginWidth*2)/5) *i);
                make.width.mas_equalTo((kWidth-marginWidth*2)/5);
                make.height.mas_equalTo(40);
            }];
        }
    }
    return _statisticView;
}
-(UIView *)iconView{
    if (!_iconView) {
        _iconView=[[UIView alloc] initWithFrame: CGRectMake(marginWidth, headerHeight-20-40+90, kWidth-marginWidth*2, 90)];
        _iconView.backgroundColor =[UIColor whiteColor];
        NSArray *iconArray=@[@"icon_tongzhi",@"icon_huodong",@"icon_tanhua",@"icon_banji"];
        NSArray *titleArray=@[@"通知公告",@"活动管理",@"谈心谈话",@"班级管理"];
        for(int i=0;i<4;i++){
            //图标
            UIButton *signBtn=[[UIButton alloc] init];
            signBtn.tag=1000+i;
            [signBtn addTarget:self action:@selector(clickMainBtn:) forControlEvents:UIControlEventTouchUpInside];
            [signBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [signBtn setBackgroundImage: [UIImage imageNamed:[iconArray objectAtIndex:i]] forState:UIControlStateNormal];
            [signBtn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            [signBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            signBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            signBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
            signBtn.imageEdgeInsets = UIEdgeInsetsMake(5,0,0,0);
            signBtn.titleEdgeInsets = UIEdgeInsetsMake(70,0,0,0);
            [_iconView addSubview: signBtn];
            [signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.iconView).offset(5);  make.left.equalTo(self.iconView).offset(((kWidth-marginWidth*2)/4)*i+(((kWidth-marginWidth*2)/4)-66)/2);
                make.width.mas_equalTo(66);
                make.height.mas_equalTo(66);
            }];
        }
    }
    return _iconView;
}
-(UIView *)signView{
    if (!_signView) {
        _signView=[[UIView alloc] initWithFrame: CGRectMake(marginWidth, headerHeight-20-40+200, kWidth-marginWidth*2, 80)];
        _signView.backgroundColor =[UIColor whiteColor];
        _signView.layer.shadowColor = GKColorRGB(220, 230,  250).CGColor;
        _signView.layer.shadowOffset = CGSizeMake(0,2);
        _signView.layer.shadowOpacity = 1;
        _signView.layer.shadowRadius = 4;
        _signView.layer.cornerRadius = 4;
        _signView.layer.masksToBounds = YES;
        _signView.clipsToBounds = NO;
        //图标
        UIImageView  *iconImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qiandao"]];
        [_signView addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.signView).offset(15);
            make.centerY.equalTo(self.signView);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        //标题
        UILabel *title=[[UILabel alloc] init];
        title.font=[UIFont systemFontOfSize:16];
        title.text=@"签到管理";
        [_signView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.signView).offset(10);
            make.left.equalTo(self.signView).offset(55);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(40);
        }];
        //did
        UILabel *didLabel=[[UILabel alloc] init];
        didLabel.font=[UIFont systemFontOfSize:12];
        didLabel.text=[NSString stringWithFormat:@"今日已发起：%@次",[_mainData objectForKey:@"sign_did"]];
        didLabel.textColor=[UIColor darkGrayColor];
        [_signView addSubview:didLabel];
        [didLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.signView).offset(45);
            make.left.equalTo(self.signView).offset(55);
            make.width.mas_equalTo((kWidth-45)/2);
            make.height.mas_equalTo(20);
        }];
        //undo
        UILabel *undoLabel=[[UILabel alloc] init];
        undoLabel.font=[UIFont systemFontOfSize:12];
        undoLabel.text=[NSString stringWithFormat:@"待发起：%@次",[_mainData objectForKey:@"sign_undo"]];
        undoLabel.textAlignment=NSTextAlignmentRight;
        undoLabel.textColor=GKColorRGB(231,  167, 85);
        [_signView addSubview:undoLabel];
        [undoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.signView).offset(45);
            make.right.equalTo(self.signView).offset(-15);
            make.width.mas_equalTo((kWidth-45)/2);
            make.height.mas_equalTo(20);
        }];
    }
    return _signView;
}
-(UIView *)leaveView{
    if (!_leaveView) {
        _leaveView=[[UIView alloc] initWithFrame: CGRectMake(marginWidth, headerHeight-20-40+290, kWidth-marginWidth*2, 80)];
        _leaveView.backgroundColor =[UIColor whiteColor];
        _leaveView.layer.shadowColor = GKColorRGB(220, 230,  250).CGColor;
        _leaveView.layer.shadowOffset = CGSizeMake(0,2);
        _leaveView.layer.shadowOpacity = 1;
        _leaveView.layer.shadowRadius = 4;
        _leaveView.layer.cornerRadius = 4;
        _leaveView.layer.masksToBounds = YES;
        _leaveView.clipsToBounds = NO;
        
        
        //图标
        UIImageView  *iconImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qingjia"]];
        [_leaveView addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leaveView).offset(15);
            make.centerY.equalTo(self.leaveView);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        //标题
        UILabel *title=[[UILabel alloc] init];
        title.font=[UIFont systemFontOfSize:16];
        title.text=@"请假管理";
        [_leaveView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.leaveView).offset(10);
            make.left.equalTo(self.leaveView).offset(55);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(40);
        }];
        //did
        UILabel *didLabel=[[UILabel alloc] init];
        didLabel.font=[UIFont systemFontOfSize:12];
        didLabel.text=[NSString stringWithFormat:@"今日请假：%@人",[_mainData objectForKey:@"leave_did"]];
        didLabel.textColor=[UIColor darkGrayColor];
        [_leaveView addSubview:didLabel];
        [didLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.leaveView).offset(45);
            make.left.equalTo(self.leaveView).offset(55);
            make.width.mas_equalTo((kWidth-45)/2);
            make.height.mas_equalTo(20);
        }];
        //undo
        UILabel *undoLabel=[[UILabel alloc] init];
        undoLabel.font=[UIFont systemFontOfSize:12];
        undoLabel.text=[NSString stringWithFormat:@"待审批：%@条",[_mainData objectForKey:@"leave_undo"]];
        undoLabel.textAlignment=NSTextAlignmentRight;
        undoLabel.textColor=GKColorRGB(231,  167, 85);
        [_leaveView addSubview:undoLabel];
        [undoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.leaveView).offset(45);
            make.right.equalTo(self.leaveView).offset(-15);
            make.width.mas_equalTo((kWidth-45)/2);
            make.height.mas_equalTo(20);
        }];
    }
    return _leaveView;
}
-(UIView *)recordView{
    if (!_recordView) {
        _recordView=[[UIView alloc] initWithFrame: CGRectMake(marginWidth, headerHeight-20-40+380, kWidth-marginWidth*2, 80)];
        _recordView.backgroundColor =[UIColor whiteColor];
        _recordView.layer.shadowColor = GKColorRGB(220, 230,  250).CGColor;
        _recordView.layer.shadowOffset = CGSizeMake(0,2);
        _recordView.layer.shadowOpacity = 1;
        _recordView.layer.shadowRadius = 4;
        _recordView.layer.cornerRadius = 4;
        _recordView.layer.masksToBounds = YES;
        _recordView.clipsToBounds = NO;
        
        
        //图标
        UIImageView  *iconImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rizhi"]];
        [_recordView addSubview:iconImageView];
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.recordView).offset(15);
            make.centerY.equalTo(self.recordView);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(30);
        }];
        //标题
        UILabel *title=[[UILabel alloc] init];
        title.font=[UIFont systemFontOfSize:16];
        title.text=@"日志管理";
        [_recordView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.recordView).offset(10);
            make.left.equalTo(self.recordView).offset(55);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(40);
        }];
       
        //undo
        UILabel *undoLabel=[[UILabel alloc] init];
        undoLabel.font=[UIFont systemFontOfSize:12];
        
        undoLabel.text=[NSString stringWithFormat:@"待办：%@条",[_mainData objectForKey:@"record_undo"]];
        
        undoLabel.textAlignment=NSTextAlignmentRight;
        undoLabel.textColor=GKColorRGB(231,  167, 85);
        [_recordView addSubview:undoLabel];
        [undoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.recordView).offset(45);
            make.right.equalTo(self.recordView).offset(-15);
            make.width.mas_equalTo((kWidth-45)/2);
            make.height.mas_equalTo(20);
        }];
    }
    return _recordView;
}

-(void)clickMainBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickMainBtn:)]){
        [self.delegate clickMainBtn:sender];
    }
}
-(void)clickStatisticBtn:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(clickStatisticBtn:)]){
        [self.delegate clickStatisticBtn:sender];
    }
}

-(void)clickSign{
    if([self.delegate respondsToSelector:@selector(clickSign)]){
        [self.delegate clickSign];
    }
}
-(void)clickLeave{
    if([self.delegate respondsToSelector:@selector(clickLeave)]){
        [self.delegate clickLeave];
    }
}
-(void)clickRecord{
    if([self.delegate respondsToSelector:@selector(clickRecord)]){
        [self.delegate clickRecord];
    }
}
 

@end
