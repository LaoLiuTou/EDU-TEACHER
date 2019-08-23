//
//  AddActivitySignInView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/31.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AddActivitySignInDelegate <NSObject>
-(void)clickSelectActivityBtn:(UIButton *)btn;
-(void)clickSelectStu;
-(void)clickSelectDevice ;
-(void)clickTimeBtn:(UIButton *)btn;
@end

@interface AddActivitySignInView : UIView

@property (nonatomic,strong) UITextField *nameText;//标题
@property (nonatomic,strong) UILabel *activityLabel;//活动
 
@property (nonatomic,strong) UITextView *commentText;//内容
@property (nonatomic,strong) UILabel *studentLabel;

 
@property (nonatomic,strong) UILabel *sign_methodLabel;//签到方式
@property (nonatomic,strong) UILabel *sign_deviceLabel;//签到设备ids
@property (nonatomic,strong) UILabel *sign_start_timeLabel;//签到开始时间
@property (nonatomic,strong) UILabel *sign_end_timeLabel;//签到结束时间


@property (nonatomic,strong) UIScrollView *signScrollView;//
@property (nonatomic,strong) UIImageView *sign_deviceImage;//签到图标

- (int)initView;
@property(nonatomic,strong)id<AddActivitySignInDelegate>delegate;
@end

