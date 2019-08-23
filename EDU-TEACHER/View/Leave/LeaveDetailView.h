//
//  LeaveDetailView.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/4.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
 


@interface LeaveDetailView : UIView
@property (nonatomic,strong) NSArray *titleArray;//头部字段
@property (nonatomic,strong) NSArray *imageArray;//图片
@property (nonatomic,strong) UIView *albumView;

@property (nonatomic,strong) UILabel *xs_nameLabel;//学生姓名+学号
@property (nonatomic,strong) UILabel *fd_nameLabel;//审核人名称
@property (nonatomic,strong) UILabel *typeLabel;//请假类型
@property (nonatomic,strong) UILabel *is_leaveschoolLabel;//是否离校
@property (nonatomic,strong) UILabel *statusLabel;//审批状态
@property (nonatomic,strong) UILabel *submit_timeLabel;//提交时间
@property (nonatomic,strong) UILabel *approval_timeLabel;//审批时间
@property (nonatomic,strong) UILabel *start_timeLabel;//开始时间
@property (nonatomic,strong) UILabel *end_timeLabel;//结束时间
@property (nonatomic,strong) UILabel *zm_nameLabel;//证明人姓名
@property (nonatomic,strong) UILabel *zm_statusLabel;//证明状态
@property (nonatomic,strong) UILabel *reasonLabel;//请假原因
@property (nonatomic,strong) UILabel *lessonLabel;//请假期间的课程
@property (nonatomic,strong) UILabel *imgLabel;//图片
@property (nonatomic,strong) UILabel *rejectLabel;//驳回原因
@property (nonatomic,strong) UILabel *durationLabel;//请假时长
@property (nonatomic,strong) UILabel *countLabel;//本月请假次数
@property (nonatomic,strong) UILabel *closeStatusLabel;//是否销假
@property (nonatomic,strong) UILabel *contentBottomLine;

@property (nonatomic,strong) UIView *containerView ; 

- (void)initView;
- (void)initReasonView;
- (void)initAlbumView;
- (void)initLessonAndProveView;
- (void)initRejectView;



@end


