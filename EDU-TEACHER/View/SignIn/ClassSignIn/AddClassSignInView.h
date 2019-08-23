//
//  AddClassSignInView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/31.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AddClassSignInDelegate <NSObject>
-(void)clickSelectClassBtn:(UIButton *)btn;
-(void)clickSelectStu ;
-(void)clickSelectDevice ;
-(void)clickAutoSignTimeBtn:(UIButton *)btn;
- (void) timeTableSwitchAction:(UISwitch *)timeTableSwitch ;
-(void)clickTimeBtn:(UIButton *)btn;
@end

@interface AddClassSignInView : UIView

@property (nonatomic,strong) UITextField *nameText;//标题
@property (nonatomic,strong) UILabel *activityLabel;//活动

@property (nonatomic,strong) UITextView *commentText;//内容
@property (nonatomic,strong) UILabel *studentLabel;


@property (nonatomic,strong) UISwitch *timeTableSwitch;//课程签到
@property (nonatomic,strong) UIView *timeTableView;
@property (nonatomic,strong) UIView *timesView;
@property (nonatomic,strong) UILabel *stoptimeLabel;
@property (nonatomic,strong) UILabel *classStartTimeLabel;
@property (nonatomic,strong) UITextField *autoSignTimeText;
@property (nonatomic,strong) UIButton *selectback;
@property (nonatomic,strong) UIButton *switchBack;
@property (nonatomic,strong) UIButton *autoSignTimeBtn;

@property (nonatomic,strong) UILabel *sign_methodLabel;//签到方式
@property (nonatomic,strong) UILabel *sign_deviceLabel;//签到设备ids
@property (nonatomic,strong) UILabel *sign_start_timeLabel;//签到开始时间
@property (nonatomic,strong) UILabel *sign_end_timeLabel;//签到结束时间


@property (nonatomic,strong) UIView *classInfoView;
@property (nonatomic,strong) UILabel *fdLabel;
@property (nonatomic,strong) UILabel *addressLabel;

@property (nonatomic,strong) UIScrollView *signScrollView;//
@property (nonatomic,strong) UIImageView *sign_deviceImage;//签到图标 
@property (nonatomic,strong) UIImageView *selectImage;//学生
@property (nonatomic,strong) UIScrollView *stuScrollView;//学生

@property (nonatomic,strong) UIButton *classStartTimeBack;

- (int)initView;
@property(nonatomic,strong)id<AddClassSignInDelegate>delegate;


@end

