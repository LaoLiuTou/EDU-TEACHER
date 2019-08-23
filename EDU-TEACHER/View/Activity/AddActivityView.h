//
//  AddActivityView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/26.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AddActivityDelegate <NSObject>
-(void)clickSelectAtta;
-(void)clickSelectStu;
-(void)clickSelectDevice;
-(void)clickTimeBtn:(UIButton *)btn;
-(void)changeType:(UISegmentedControl *)typeSegment; 
@end

@interface AddActivityView : UIView

@property (nonatomic,strong) UITextField *nameText;//标题
@property (nonatomic,strong) UISegmentedControl *typeSegment;//类型
@property (nonatomic,strong) UILabel *baomingTimeLabel;//报名截止时间
@property (nonatomic,strong) UILabel *startTimeLabel;//开始时间
@property (nonatomic,strong) UILabel *endTimeLabel;//截止时间
@property (nonatomic,strong) UITextField *numberLabel;//人数限制
@property (nonatomic,strong) UITextView *addressText;//地址
@property (nonatomic,strong) UITextView *commentText;//内容
@property (nonatomic,strong) UIImageView *addImageView;//添加图片
@property (nonatomic,strong) NSString *selectedImage;//添加图片
@property (nonatomic,strong) UIView *addFileView;//添加文件
@property (nonatomic,strong) UIView *selectView;//通知范围
@property (nonatomic,strong) UILabel *studentLabel;
@property (nonatomic,strong) UILabel *filesLabel;//文件


@property (nonatomic,strong) UIView *signView;
@property (nonatomic,strong) UITextField *sign_nameText;//签到名称
@property (nonatomic,strong) UILabel *sign_methodLabel;//签到方式
@property (nonatomic,strong) UILabel *sign_deviceLabel;//签到设备ids
@property (nonatomic,strong) UILabel *sign_start_timeLabel;//签到开始时间
@property (nonatomic,strong) UILabel *sign_end_timeLabel;//签到结束时间

@property (nonatomic,strong) UIScrollView *signScrollView;// 
@property (nonatomic,strong) UIImageView *sign_deviceImage;//签到图标
@property (nonatomic,strong) UIScrollView *filesScrollView;//文件
@property (nonatomic,strong) UIImageView *attaImage;//文件
@property (nonatomic,strong) UIImageView *selectImage;//学生
@property (nonatomic,strong) UIScrollView *stuScrollView;//学生

- (int)initView;
@property(nonatomic,strong)id<AddActivityDelegate>delegate;
@end
