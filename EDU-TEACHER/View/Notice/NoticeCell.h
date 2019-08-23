//
//  NoticeCell.h
//  EDU-TEACHER
//
//  Created by Jiubai on 2019/7/10.
//  Copyright © 2019 Jiubai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeModel.h"
@protocol NoticeCellDelegate <NSObject>
-(void)clickPublishBtn:(UIButton *)btn notice:(NoticeModel *) notice;
@end


@interface NoticeCell : UITableViewCell

@property (nonatomic,strong) UIImageView *noticeImage;//通知标题
@property (nonatomic,strong) UILabel *nameLabel;//通知标题
@property (nonatomic,strong) UIButton *statusBtn;//状态
@property (nonatomic,strong) UILabel *publish_timeLabel;//发布时间
@property (nonatomic,strong) UILabel *readLabel;//未读人数/已读人数

@property (nonatomic,strong) NoticeModel *notice;//通知
@property(nonatomic,strong)id<NoticeCellDelegate>delegate;
@end

