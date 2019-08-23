//
//  TalkingCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/23.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkingModel.h"

@interface TalkingCell : UITableViewCell
@property (nonatomic,strong) UIImageView *talkingImage;
@property (nonatomic,strong) UILabel *xs_nameLabel;//学生名
@property (nonatomic,strong) UILabel *talk_timeLabel;//标题
@property (nonatomic,strong) UILabel *c_timeLabel;//发布时间
@property (nonatomic,strong) UILabel *addressLabel;//谈话地点
-(void)initViewWithModel:(TalkingModel *) model;
@end
