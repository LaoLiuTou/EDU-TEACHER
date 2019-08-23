//
//  AddDormSignInView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/31.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddDormSignInDelegate <NSObject>
-(void)clickSelectStu ;
-(void)clickResignin ;

-(void)clickSelectDevice ;
-(void)clickTimeBtn:(UIButton *)btn;
- (void) timesSwitchAction:(UISwitch *)timesSwitch ;
@end

@interface AddDormSignInView : UIView

@property (nonatomic,strong) UITextField *nameText;//标题


@property (nonatomic,strong) UILabel *sign_methodLabel;//签到方式
@property (nonatomic,strong) UILabel *sign_deviceLabel;//签到设备ids

@property (nonatomic,strong) UISwitch *timesSwitch;//仅一次
@property (nonatomic,strong) UIView *timesView;//重复 
@property (nonatomic,strong) UILabel *resigninLabel;//重复时间
@property (nonatomic,strong) UILabel *stoptimeLabel;//自动签到结束时间

@property (nonatomic,strong) UILabel *sign_start_timeLabel;//签到开始时间
@property (nonatomic,strong) UILabel *sign_end_timeLabel;//签到结束时间



@property (nonatomic,strong) UITextView *commentText;//内容
@property (nonatomic,strong) UILabel *studentLabel;//范围


@property (nonatomic,strong) UIScrollView *signScrollView;//
@property (nonatomic,strong) UIImageView *sign_deviceImage;//签到图标
@property (nonatomic,strong) UIScrollView *resigninScrollView; 
@property (nonatomic,strong) UIImageView *resigninImage;//文件
@property (nonatomic,strong) UIImageView *selectImage;//学生
@property (nonatomic,strong) UIScrollView *stuScrollView;//学生


- (int)initView;
@property(nonatomic,strong)id<AddDormSignInDelegate>delegate;


@end


