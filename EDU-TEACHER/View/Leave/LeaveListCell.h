//
//  LeaveListCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/3.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LeaveListCell : UITableViewCell
@property (nonatomic,strong) UILabel *typeLabel;//类型
@property (nonatomic,strong) UILabel *xs_nameLabel;//姓名
//@property (nonatomic,strong) UILabel *submit_timeLabel;//提交、审批时间
@property (nonatomic,strong) UILabel *start_timeLabel;//开始时间
@property (nonatomic,strong) UILabel *end_timeLabel;//结束时间
@property (nonatomic,strong) UILabel *statusLabel;//状态

@end

